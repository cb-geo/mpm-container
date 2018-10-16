BootStrap:docker
From:fedora:latest

%post
dnf update -y && \
dnf remove -y vim-minimal python sqlite && \
dnf install -y boost boost-devel clang clang-analyzer clang-tools-extra cmake cppcheck eigen3-devel \
                   findutils gcc gcc-c++ git hdf5 hdf5-devel kernel-devel lcov \
                   make openmpi openmpi-devel tar tbb tbb-devel \
                   valgrind vim vtk vtk-devel wget && \
dnf clean all

git clone https://gitlab.onelab.info/gmsh/gmsh.git --depth 1
cd gmsh && mkdir build && cd build && cmake -DENABLE_BUILD_DYNAMIC=1 .. && make && make install

source /etc/profile.d/modules.sh && export MODULEPATH=$MODULEPATH:/usr/share/modulefiles && module load mpi/openmpi-x86_64

mkdir -p /research && cd /research 
git clone https://github.com/cb-geo/mpm.git

%runscript
/bin/bash "$@"
