#include "screen.h"
#include "ports.h"

// --------------------------
// -- Private kernel decl. --
// --------------------------

int getCursorOffset();
void setCursorOffset(int offset);

int getOffset(int col, int row) { return 2 * (row * MAX_COLS + col); }
int getRowOffset(int offset) { return offset / (2 * MAX_COLS); }
int getColOffset(int offset) { return (offset - (getRowOffset(offset) * 2 * MAX_COLS)) / 2; }

int printChar(char c, int col, int row, char *attr);


// ------------------------
// -- Private kernel API --
// ------------------------

// printChar : print character at col, row, or cursor position
int printChar(char c, int col, int row, char *attr) {
	unsigned char *vid_mem = (unsigned char*) VID_ADDRESS;

	// If no colour, use white text on black
	if (!attr) attr = WHITE_ON_BLACK;

	// If co-ords are OOB, print a red "E" for ERROR at bottom left
	if (col >= MAX_COLS || row >= MAX_ROWS) {
		vid_mem[2 * (MAX_COLS) * (MAX_ROWS) - 2] = 'E';
		vid_mem[2 * (MAX_COLS) * (MAX_ROWS) - 1] = RED_ON_WHITE;

		return getOffset(col, row);
	}

	int offset;
	if (col >= 0 && row >= 0) offset = getOffset(col, row);
	else offset = getCursorOffset();

	if (c == '\n') {
		row = getRowOffset(offset);
		offset = getOffset(0, row+1);
	} else {
		vid_mem[offset] = c;
		vid_mem[offset] = attr;
		offset += 2;
	}

	setCursorOffset(offset);
	return offset;
}

int getCursorOffset() {
	write_port_b(REG_SCREEN_CTRL, 14);
	int offset = read_port_b(REG_SCREEN_DATA) << 8;

	write_port_b(REG_SCREEN_CTRL, 15);
	offset += read_port_b(REG_SCREEN_DATA);

	return offset * 2;
}

void setCursorOffset(int offset) {
	offset /= 2;
	write_port_b(REG_SCREEN_CTRL, 14);
	write_port_b(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
	write_port_b(REG_SCREEN_CTRL, 15);
	write_port_b(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

void clearScreen() {
	int screen_size = MAX_COLS * MAX_ROWS;
	int i;
	char *screen = VID_ADDRESS;

	for (i = 0; i < screen_size; i++) {
		screen[i*2] = ' ';
		screen[i*2+1] = WHITE_ON_BLACK;
	}
	setCursorOffset(getOffset(0, 0));
}


// -----------------------
// -- Public kernel API --
// -----------------------

void kprint_at(char *msg, int col, int row) {
	int offset;
	if (col >= 0 && row >= 0) offset = getOffset(col, row); 
	else { 
		offset = getCursorOffset();
		row = getRowOffset(offset);
		col = getColOffset(offset);	
	}

	int i = 0;
	while (msg[i] != 0) {
		offset = printChar(msg[i++], col, row, WHITE_ON_BLACK);
		row = getRowOffset(offset);
		col = getColOffset(offset);
	}
}

void kprint(char *msg) {
	kprint_at(msg, -1, -1);
}