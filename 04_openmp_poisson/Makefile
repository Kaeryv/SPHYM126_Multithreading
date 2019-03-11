FC=gfortran
#FC=ifort
FFLAGS=-O2 -cpp -lpthread -fopenmp # -march=native -ftree-vectorize -mavx

all:
	$(FC) $(FFLAGS) main.openmp.f90 -o openmp.x
	$(FC) $(FFLAGS) main.f90 -o sequential.x

runs:
	./sequential.x
runo:
	./openmp.x
