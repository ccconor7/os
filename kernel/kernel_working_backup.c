#include "../drivers/screen.h"
#include "../drivers/ports.h"

void entry() {
}

void main() {
	char *VGA = (char*) 0xB8000;
	*VGA = 's';
	*(VGA+2) = 'h';
	*(VGA+4) = 'e';
	*(VGA+6) = 'd';

	clearScreen();
}
