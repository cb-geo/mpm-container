FROM fedora:28
MAINTAINER Krishna Kumar <kks32@cam.ac.uk>

# Update to latest packages, remove vim-minimal & Install Git, GCC, Clang, Autotools and VIM
RUN dnf update -y && \
    dnf remove -y vim-minimal python sqlite && \
    dnf install -y boost boost-devel clang clang-analyzer clang-tools-extra cmake cppcheck eigen3-devel \
                   findutils gcc gcc-c++ git hdf5 hdf5-devel kernel-devel lcov \
                   make openmpi openmpi-devel tar tbb tbb-devel \
                   valgrind vim vtk vtk-devel wget && \
dnf clean all

# Install GMSH
RUN git clone https://gitlab.onelab.info/gmsh/gmsh.git --depth 1
RUN cd gmsh && mkdir build && cd build && cmake -DENABLE_BUILD_DYNAMIC=1 .. && make && make install && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib64/

# Load OpenMPI module
RUN source /etc/profile.d/modules.sh && export MODULEPATH=$MODULEPATH:/usr/share/modulefiles && module load mpi/openmpi-x86_64

# Create a user cbgeo
RUN useradd cbgeo
USER cbgeo

# Create a research directory and clone git repo of mpm code
RUN mkdir -p /home/cbgeo/research && \
    cd /home/cbgeo/research && \
    git clone https://github.com/cb-geo/mpm.git

# Done
WORKDIR /home/cbgeo/research/mpm

RUN /bin/bash "$@"