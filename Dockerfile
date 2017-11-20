FROM fedora:latest
MAINTAINER Krishna Kumar <kks32@cam.ac.uk>

# Update to latest packages, remove vim-minimal & Install Git, GCC, Clang, Autotools and VIM
RUN dnf update -y && \
    dnf remove -y vim-minimal python sqlite && \
    dnf install -y boost boost-devel clang cmake cppcheck eigen3-devel findutils gcc gcc-c++ \
                   git hdf5 hdf5-devel kernel-devel \
                   make sqlite sqlite-devel tar valgrind vim \
                   voro++ voro++-devel vtk vtk-devel wget && \
dnf clean all


# Install Intel Threaded Building blocks
ENV TBB_VERSION 2017_20160916
ENV TBB_DOWNLOAD_URL https://www.threadingbuildingblocks.org/sites/default/files/software_releases/linux/tbb${TBB_VERSION}oss_lin.tgz
ENV TBB_INSTALL_DIR /opt

RUN wget ${TBB_DOWNLOAD_URL} \
	&& tar -C ${TBB_INSTALL_DIR} -xf tbb${TBB_VERSION}oss_lin.tgz \
	&& rm tbb${TBB_VERSION}oss_lin.tgz

RUN sed -i "s%SUBSTITUTE_INSTALL_DIR_HERE%${TBB_INSTALL_DIR}/tbb${TBB_VERSION}oss%" ${TBB_INSTALL_DIR}/tbb${TBB_VERSION}oss/bin/tbbvars.*

# Create a user cbgeo
RUN useradd cbgeo
USER cbgeo

# Configure Intel TBB
RUN echo "source ${TBB_INSTALL_DIR}/tbb${TBB_VERSION}oss/bin/tbbvars.sh intel64" >> ~/.bashrc
RUN echo "PATH=${TBB_INSTALL_DIR}/tbb${TBB_VERSION}oss/:$PATH" >> ~/.bashrc
RUN echo "LD_LIBRARY_PATH=${TBB_INSTALL_DIR}/tbb${TBB_VERSION}oss/lib/:$LD_LIBRARY_PATH" >> ~/.bashrc
RUN echo "TBB_VERSION=0" >> ~/.bashrc
RUN export PATH=${TBB_INSTALL_DIR}/tbb${TBB_VERSION}oss/:$PATH
RUN export LD_LIBRARY_PATH=${TBB_INSTALL_DIR}/tbb${TBB_VERSION}oss/lib/:$LD_LIBRARY_PATH
RUN export TBB_VERSION=0

# Create a research directory and clone git repo of mpm code
RUN mkdir -p /home/cbgeo/research && \
    cd /home/cbgeo/research && \
    git clone https://github.com/cb-geo/mpm.git

# Done
WORKDIR /home/cbgeo/research/mpm

RUN /bin/bash "$@"