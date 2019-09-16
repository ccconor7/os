#include "../drivers/ports.h"
#include "../drivers/screen.h"


void main() {
	clearScreen();
	kprint("line \n break");
	//kprint_at("This text spans multiple lines", 75, 10);
	//kprint_at("There is a line\nbreak", 0, 20);
}
