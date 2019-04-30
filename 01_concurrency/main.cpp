#include <iostream>
#include <thread>


#define MAX_GREETINGS 5

void loop(int id)
{
  for(int i = 0; i < MAX_GREETINGS; i++) 
  {
    printf("Thread nr. %d reporting for duty %d !\n", id, i); 
    printf("L'id physique de ce thread est: %d\n", std::this_thread::get_id()); 
  }
}

int main()
{
  unsigned int n = std::thread::hardware_concurrency();
  std::cout << n << " concurrent threads are supported.\n";

  // Creation de trois threads en ||, les threads sont detaches a la creation.
  // Les variables representent les threads. 
  std::thread t1(&loop, 1);
  std::thread t2(&loop, 2);
  std::thread t3(&loop, 3);

  // Code sequentiel present sur le thread du main, permet de joindre les
  // differentes executions || afin de terminer correctement le programme.
  t1.join();
  t2.join();
  t3.join();
  return 0;
}