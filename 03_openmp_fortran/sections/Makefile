CXX=gfortran
CFLAGS=-fopenmp
SOURCES=sections.f90
BINARY=main.x

all:
	$(CXX) $(CFLAGS) $(SOURCES) -o $(BINARY)

run2:
	taskset -c 0-1 ./$(BINARY)

run4:
	taskset -c 0-3 ./$(BINARY)

run5:
	taskset -c 0-4 ./$(BINARY)

clean:
	rm *.x