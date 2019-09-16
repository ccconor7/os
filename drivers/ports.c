#include "ports.h"

// Read a single byte from the port
unsigned char read_port_b (unsigned short port) {
	unsigned char result;

	// "=a" (result):
	// Assign value in AL register to result variable

	// "d" (port):
	// EDX = port

	__asm__("in %%dx, %%al" : "=a" (result) : "d" (port));

	return result;
}

// Write a single byte to the port
void write_port_b (unsigned short port, unsigned char data) {

	// "a" (data):
	// EAX = data

	// "d" (port):
	// EDX = port
	__asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

unsigned short read_port_w (unsigned short port) {
	unsigned short result;
	
	__asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));

	return result;
}

void write_port_w (unsigned short port, unsigned short data) {
	__asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}
