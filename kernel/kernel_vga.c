#include "../drivers/ports.h"

void main() {
	write_port_b(0x3d4, 14);

	int position = read_port_b(0x3d5);
	position = position << 8;

	write_port_b(0x3d4, 15);
	position += read_port_b(0x3d5);

	int offset = position * 2;

	// Create a pointer to a char and point it to the first text cell of 
	//  vid_mem
	char *VGA = 0xB8000;

	// At the address pointed to by the vid_mem pointer, store "X" 
	VGA[offset] = 'q';
	VGA[offset] = 0x0f;
}
