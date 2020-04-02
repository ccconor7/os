#include "../drivers/screen.h"
#include "../drivers/ports.h"

void entry() {
}

void main() {
	clear_screen();
	char *VGA = (char*) 0xB8000;
	*VGA = 's';
	*(VGA+2) = 'h';
	*(VGA+4) = 'e';
	*(VGA+6) = 'd';
}
