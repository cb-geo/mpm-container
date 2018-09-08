BootStrap:docker
From:fedora:latest

%post
dnf update -y && \
dnf remove -y vim-minimal python sqlite && \
dnf install -y boost boost-devel clang clang-tools-extra cmake cppcheck eigen3-devel \
                   findutils gcc gcc-c++ git hdf5 hdf5-devel kernel-devel lcov \
                   make openmpi openmpi-devel tar tbb tbb-devel \
                   valgrind vim vtk vtk-devel wget && \
dnf clean all

mkdir -p /research && cd /research 
git clone https://github.com/cb-geo/mpm.git

%runscript
/bin/bash "$@"
