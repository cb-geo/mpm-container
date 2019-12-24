FROM fedora:30
MAINTAINER Krishna Kumar <kks32@cam.ac.uk>

# Update to latest packages, remove vim-minimal & Install Git, GCC, Clang, Autotools and VIM
RUN dnf update -y && \
    dnf remove -y vim-minimal python sqlite && \
    dnf install -y boost boost-devel clang clang-analyzer clang-tools-extra cmake cppcheck eigen3-devel \
                   findutils gcc gcc-c++ git hdf5 hdf5-devel kernel-devel lcov \
                   make ninja-build openmpi openmpi-devel tar tbb tbb-devel \
                   valgrind vim vtk vtk-devel wget && \
dnf clean all

# Install GMSH
RUN git clone https://gitlab.onelab.info/gmsh/gmsh.git --depth 1
RUN cd gmsh && mkdir build && cd build && cmake -DENABLE_BUILD_DYNAMIC=1 .. && make && make install && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib64/

# Load OpenMPI module
# RUN source /etc/profile.d/modules.sh && export MODULEPATH=$MODULEPATH:/usr/share/modulefiles && module load mpi/openmpi-x86_64
ENV PATH="/usr/lib64/openmpi/bin/:${PATH}"

# METIS and PARMETIS
RUN wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.3.tar.gz && \
    tar -xf parmetis-4.0.3.tar.gz && \
    cd parmetis-4.0.3/ && \
    make config shared=1 cc=mpicc cxx=mpic++ && \
    make install && cd .. && rm -rf parmetis*

RUN wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz && \
    tar -xf metis-5.1.0.tar.gz && \
    cd metis-5.1.0/ && \
    make config shared=1 cc=mpicc cxx=mpic++ && \
    make install && cd .. && rm -rf metis*

# Create a user cbgeo
RUN useradd cbgeo
USER cbgeo

# KaHIP

RUN cd /home/cbgeo/ && git clone https://github.com/schulzchristian/KaHIP.git && \
    cd KaHIP && sh ./compile_withcmake.sh

# Create a research directory and clone git repo of mpm code
RUN mkdir -p /home/cbgeo/research && \
    cd /home/cbgeo/research && \
    git clone https://github.com/cb-geo/mpm.git

# Done
WORKDIR /home/cbgeo/research/mpm

RUN /bin/bash "$@"
