#include <iostream>
#include <thread>
#include <mutex>
#define MAX_GREETINGS 3

// Verrou pour la resource 'ecriture'
std::mutex verrou_ecriture;

void loop(int id)
{
  for (int i = 0; i < MAX_GREETINGS; i++)
  {
    // Nous souhaitons que ces deux lignes soient cohérentes
    // Le verrou est donc employe pour bloquer les autres threads.

    verrou_ecriture.lock();
    printf("\e\[31m:: Mutex locked \e\[00m\n");
    if(id==1)
    {
      std::cout << "Thread nr. " << id  << " waiting for user interaction." << std::endl;
      std::cin.get();
    }
    printf(" ::  Numéro du thread: %d, appel nr. %d. \n", id, i);
    printf(" ::  Identifiant physique du thread: 0x%08x \n", std::this_thread::get_id());

    // Nous liberons le verrou
    printf("\e\[32m:: Unlocking mutex \e\[00m\n");
    verrou_ecriture.unlock();
  }
}

int main()
{
  unsigned int n = std::thread::hardware_concurrency();
  std::cout << n << " concurrent threads are supported.\n";

  // Creation séquentielle de trois threads en ||.
  // L'execution quitte ce thread maitre
  // Les variables representent les threads.
  std::thread t1(&loop, 1);
  std::thread t2(&loop, 2);
  std::thread t3(&loop, 3);

  verrou_ecriture.lock();
  printf(" ::  Identifiant physique du maitre: 0x%08x \n", std::this_thread::get_id());
  verrou_ecriture.unlock();
  // Code sequentiel present sur le thread du main, permet de joindre les
  // differentes executions || afin de terminer correctement le programme.
  t1.join();
  t2.join();
  t3.join();
  return 0;
}