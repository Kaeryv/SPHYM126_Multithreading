program main
    !$use omp_lib
    implicit none
    
    integer :: i, j

    !$omp parallel
    write(*,*) "A thread is reporting"
    !$omp end parallel


    !$omp parallel
    !$omp do
    do i = 1, 3
        do j = 1, 4-i
            call sleep(1)
        end do
        write(*,*) "thread: ", i
    end do
    !$omp end do
    !$omp end parallel

end program