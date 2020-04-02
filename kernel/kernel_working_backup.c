#include "../drivers/screen.h"
#include "../drivers/ports.h"

void entry() {
}

//void set_cursor_offset(int offset);

void main() {
	clear_screen();
	unsigned char *vid_mem = (unsigned char*) VID_ADDRESS;
	*vid_mem= 's';
	*(vid_mem+2) = 'h';
	*(vid_mem+4) = 'e';
	*(vid_mem+6) = 'd';

	set_cursor_offset(100);
}
