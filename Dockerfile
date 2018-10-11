FROM fedora:28
MAINTAINER Krishna Kumar <kks32@cam.ac.uk>

# Update to latest packages, remove vim-minimal & Install Git, GCC, Clang, Autotools and VIM
RUN dnf update -y && \
    dnf remove -y vim-minimal python sqlite && \
    dnf install -y boost boost-devel clang clang-tools-extra cmake cppcheck eigen3-devel \
                   findutils gcc gcc-c++ git hdf5 hdf5-devel kernel-devel lcov \
                   make tar tbb tbb-devel \
                   valgrind vim vtk vtk-devel wget && \
dnf clean all


# Load OpenMPI module
RUN sudo dnf -y module install openmpi openmpi-devel 
RUN source /etc/profile.d/modules.sh && module load mpi/openmpi-x86_64

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