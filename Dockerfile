FROM dealii/dealii:v8.5.0-gcc-mpi-fulldepscandi-debugrelease 
LABEL maintainer <kks32@cam.ac.uk> 

# Build mpm
RUN git clone https://github.com/cb-geo/mpm.git ./mpm

WORKDIR /home/dealii/mpm

