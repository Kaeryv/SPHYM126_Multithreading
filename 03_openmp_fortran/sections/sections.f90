program main
    !$use omp_lib
    implicit none
    
    !$omp parallel
    !$omp sections
    !$omp section
    call sleep(1)
    write(*,*) "Doing something ploppy."
    !$omp section
    call sleep(1)
    write(*,*) "Doing something funky."
    !$omp section
    call sleep(1)
    write(*,*) "Doing something kinky."
    !$omp section
    call sleep(1)
    write(*,*) "Doing something fuzzy."
    !$omp section
    call sleep(1)
    write(*,*) "Doing something crazy."
    !$omp end sections
    !$omp end parallel
end program