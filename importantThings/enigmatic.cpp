#include <iostream>
#include <string>
#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */
#include <chrono>
#include <thread>

#include "windowSize.cpp"

const int DEFAULT_ITER = 20;
// const double DEFAULT_BPS = 0.6667;

class Random { 
public:
  	Random (int max);
	int getRandom ();
private:
	int max;
};

Random::Random(int max) {
	this->max = max;
	srand(time(NULL));
}

int Random::getRandom() {
	int r = rand() % this->max - 3;
	return r;
}

void iteration(Random* r) {
	int rnd = r->getRandom();
	for (int i = 0; i < rnd; i++) {
		std::cout << " ";
	}
	std::cout << "):~" << std::endl;
}

int main(int n_args, char* argv[]) {
	using namespace std::chrono; // ns, us, ms, s, h, etc.
	using namespace std::this_thread;     // sleep_for, sleep_until

	int iterations = DEFAULT_ITER;
	nanoseconds bps = 666000000ns;
	bool infinite = false;
	if (n_args >= 2) {
		iterations = atoi(argv[1]);
		if (iterations == -1) {
			infinite = true;						
		}
	}
	if (n_args == 3) {
		bps = nanoseconds(60000000000/atoi(argv[2]))/4;
	}
	WindowSize ws = getWindowSize();
	Random* r = new Random(ws.cols);
	for (int i = 0; i < iterations || infinite; i++) {
		iteration(r);
		sleep_for(bps);
	}
	return 0;
}