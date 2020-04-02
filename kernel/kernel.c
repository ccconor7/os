#include "../drivers/ports.h"
#include "../drivers/screen.h"


void main() {
	clear_screen();
	//kprint("line \n break");
	//kprint("aa");
	//kprint_at("There is a line\nbreak", 0, 20);

	for(int row = 0; row < MAX_ROWS; row++) {
		for(int col = 0; col < MAX_COLS; col++) {
			kprint("a");
		}
	}
}
