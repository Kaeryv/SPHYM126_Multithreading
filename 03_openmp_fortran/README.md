# Fortran and OpenMP

OpenMP consists of a collection of preprocessor directives enabling programmer to
parallelize code with little to no modifications and great portability.
One could call this approach meta-parallelization as opposed to implemented paralellization.

## How do directives work ?

Any line of code like
```bash
!$ My line of code
```
will be compiled only if the `-fopenmp` flag was passed to enable **OpenMp** (use -qopenmp for **ifort**). 
Hence this little program will only **write** one time without `-fopenmp`:

```fortran
program main
    !$use omp_lib
    implicit none

    !$omp parallel
    write(*,*) "A thread is reporting"
    !$omp end parallel
end program
```

This example leads us to define the first **OpenMP** directives.

## Core directives

Directives are hints to further help the compiler to understand what we want to do. Mostly, directives for compilers are **restrictives**, which means they enable **assumptions** by the compiler because we respected **constraints** while coding. 
Those are numerous and serve different purposes for vectorizing or threading:
- No pointer aliasing 
- Alignment of memory
- No concurrent acces to *resouces*
- Order of operations does not matter

To summarize, directives for vectorization, automatic parallelism are preservatives and only **decorate** the code.

### OpenMP is particular

The case of OpenMP is quite special because OpenMp contains strong directives that not only guide the compiler but deeply modifies the code. This last sentence is in contradiction with the statement above about 'drop in' parallelization. That's right, we need to be careful with OpenMP as it still
requires thorough code integration.
Moreover, OpenMP contains imperative, restrictive and permissive instructions !

## Instructions overview

### Declare parallel zone or threads group

```fortran

Main thread sequential 

! Starting parallel zone
!$omp parallel

...
Instructions here are executed on each thread concurrently
...

!$omp end parallel
! End of the parallel zone, threads "join"
Main thread sequential 
```

The first question we may ask is, well, how many threads were created ?
The answer is implementation-defined, openmp uses all allowed threads,
the responsability falls and should fall on your OS.
The second point I want to insist on is the term concurrently which is chosen carefully. These operations are nor sequential nor simultaneous.
There is no guarantee on the timing of each thread, they will start as
the resources are provided by the OS, threads can be virtual (not related to a physical core) but in practice we want to target only physical (or hyperthreaded, which are physical from our software perspective) cores.

### do ... while

In order to do some meaningful threading, we need our threads to perform different tasks. Typically, we use the parallel do:

```fortran
!$omp do
do i = 1, 3
    do j = 1, 4-i
        call sleep(1)
    end do
    write(*,*) "thread: ", i
end do
!$omp end do
!$omp end parallel
```

The work is splitted among all available threads in the current context using a scheduling procedure, more on that later.


### Sections

Sections are constructs used to do different tasks on different threads of a context. The concurrency is maximized, if the are more sections than threads,
the additional sections are sequentially appended to each thread execution stack.

```fortran
!$omp parallel
!$omp sections
    !$omp section
        write(*,*) "Doing something funny."
    !$omp section
        write(*,*) "Doing something fuzzy."
    !$omp section
        write(*,*) "Doing something crazy."
!$omp end sections
!$omp end parallel
```


### Workshare

La directive workshare est destinée aux functions élémentaires et structures de contrôle || intégrées à fortran:
- Assignations vectorielles
- where
- forall
- user-defined elementals
- minval, maxval
- matmul, reshape

```

```

The above directive is one of the most lean and usefull ones. One can simply enable parallelism on well-defined function, user-implemented or not.
Array expressions are also easyly managed this way, enabling clear
mathematical expressions with increased speed of execution.



### Critical

### Single

### Barrier

### Atomic

## Data attributes

### Reduction

Application à un calcul de pi:
```c++
double calc_pi_gregory(const long max_iter_times)
{
    register double cur_pi = 0;
    #pragma omp parallel for reduction(+:cur_pi)
    for(register int idx=1; idx<=max_iter_times; idx+=2)
    {
        cur_pi += (idx>>1 & 1) ? -4./idx : 4./idx;
    }
    return cur_pi;
}
```
## Sheduling attributes

### Static schedule

```fortran
!$omp do schedule(static, 64)
do i = 1, 1027
    ...
end do
!$omp end do
```

Work is divided in `16` *blocks* of `64` iterations + `1` block of `3` iterations.