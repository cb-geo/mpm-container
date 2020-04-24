FROM fedora:31
MAINTAINER Krishna Kumar <krishnak@utexas.edu>

# Update to latest packages, remove vim-minimal & Install Git, GCC, Clang, Autotools and VIM
RUN dnf update -y && \
    dnf remove -y vim-minimal sqlite && \
    dnf install -y boost boost-devel clang clang-analyzer clang-tools-extra cmake cppcheck dnf-plugins-core \
                   eigen3-devel findutils freeglut freeglut-devel gcc gcc-c++ git hdf5 hdf5-devel \
                   kernel-devel lcov libnsl make ninja-build openblas openblas-devel openblas-openmp \
                   openmpi openmpi-devel python tar tbb tbb-devel valgrind vim vtk vtk-devel wget && \
dnf clean all

# Install GMSH
# RUN git clone https://gitlab.onelab.info/gmsh/gmsh.git --depth 1
# RUN cd gmsh && mkdir build && cd build && cmake -DENABLE_BUILD_DYNAMIC=1 .. && make && make install && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib64/

# Load OpenMPI module
# RUN source /etc/profile.d/modules.sh && export MODULEPATH=$MODULEPATH:/usr/share/modulefiles && module load mpi/openmpi-x86_64
ENV PATH="/usr/lib64/openmpi/bin/:${PATH}"

# Install MKL
RUN dnf config-manager --add-repo https://yum.repos.intel.com/mkl/setup/intel-mkl.repo && \
    rpm --import https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
    dnf install -y intel-mkl

# Create a user cbgeo
RUN useradd cbgeo
USER cbgeo

# Configure MKL
RUN echo "source /opt/intel/bin/compilervars.sh -arch intel64 -platform linux" >> ~/.bashrc
RUN echo "source /opt/intel/mkl/bin/mklvars.sh intel64" >> ~/.bashrc

# PETSc
RUN cd /home/cbgeo/ && git clone -b maint https://gitlab.com/petsc/petsc.git petsc && \
    cd petsc && ./configure PETSC_DIR=/home/cbgeo/petsc/ --with-debugging=0 COPTFLAGS='-O3 -march=arch-linux2-c-opt -mtune=native' CXXOPTFLAGS='-O3 -march=arch-linux2-c-opt -mtune=native' && make PETSC_DIR=/home/cbgeo/petsc PETSC_ARCH=arch-linux-c-opt all -j2 && \
    make PETSC_DIR=/home/cbgeo/petsc PETSC_ARCH=arch-linux-c-opt check
ENV PETSC_ARCH=arch-linux-c-opt
ENV PETSC_DIR=/home/cbgeo/petsc/

# KaHIP
RUN cd /home/cbgeo/ && git clone https://github.com/schulzchristian/KaHIP.git && \
    cd KaHIP && sh ./compile_withcmake.sh

# Partio
RUN cd /home/cbgeo/ && git clone https://github.com/wdas/partio.git && \
    cd partio && cmake . && make

# Create a research directory and clone git repo of mpm code
RUN mkdir -p /home/cbgeo/research && \
    cd /home/cbgeo/research && \
    git clone https://github.com/cb-geo/mpm.git

# Done
WORKDIR /home/cbgeo/research/mpm

RUN /bin/bash "$@"
