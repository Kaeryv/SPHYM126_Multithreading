#include "config.h"
program main
!$ use omp_lib
  use iso_fortran_env
  implicit none

  integer, parameter :: r = 4
  integer :: iu, k
  real(r), dimension(:,:), allocatable :: V, V_old, EPS
  real(r), dimension(_ITERATIONS) :: conv_criterion

  real(r) :: Lx, dx, dV, Vm
  integer :: nx, i, j

  character(32) :: output_format


  real(4) :: t1, t2  

  Lx = _LENGTH
  Vm = 10._r

  dx = _DELTA_X
  

  nx = nint((Lx/dx))

  dV = Vm/nx

  allocate(V(0:nx, 0:nx), V_old(0:nx, 0:nx), EPS(0:nx, 0:nx))

  V = 0._r
  EPS = 1._r

  V(:, 0) = Vm
  V(0, :) = ([((nx-i)*dV, i = 0, nx)])
  V(nx, :) = V(0, :)
  V_old = V
  
  do i = 0, nx
    do j = 0, nx
      if((abs(i*dx-0.05)*4.0 < j*dx-0.06)) EPS(i, j) = -10e+6
    end do
  end do 

  call cpu_time(t1)

  !$omp parallel
  do k = 1, _ITERATIONS
    !$omp workshare
    V(1:nx-1,1:nx-1) = (EPS(2:nx,1:nx-1)/(dx**2)*V_old(2:nx,1:nx-1)+EPS(0:nx-2,1:nx-1)/(dx**2)*V_old(0:nx-2,1:nx-1)&
    + EPS(1:nx-1,2:nx)/(dx**2)*V_old(1:nx-1,2:nx)+EPS(1:nx-1,0:nx-2)/(dx**2)*V_old(1:nx-1,0:nx-2))&
    / ((EPS(2:nx,1:nx-1) + EPS(0:nx-2,1:nx-1))/(dx**2) + (EPS(1:nx-1,2:nx)+EPS(1:nx-1,0:nx-2))/(dx**2))
    !$omp end workshare
    

    conv_criterion(k) = maxval(abs(V(1:nx-1,1:nx-1)-V_old(1:nx-1,1:nx-1)))
    
    V_old(1:nx-1,1:nx-1) = V(1:nx-1,1:nx-1)
  end do
  !$omp end parallel

  call cpu_time(t2)

  print *, "Computations lasted: ", t2 - t1, " seconds"
  
  
  open(newunit=iu, file='eps.bin',access="stream",action="write")
  write(iu) EPS
  close(iu)
  open(newunit=iu,file="map.bin",access="stream",action="write")
  write(iu) V
  close(iu) 
  open(newunit=iu, file='conv.bin',access="stream",action="write")
  write(iu) conv_criterion
  close(iu)
end program
