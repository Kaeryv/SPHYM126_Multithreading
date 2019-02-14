CXX=gfortran
CFLAGS=-fopenmp
SOURCES=hello.f90
BINARY=main.x

all:
	$(CXX) $(CFLAGS) $(SOURCES) -o $(BINARY)

run:
	./$(BINARY)

clean:
	rm *.x
