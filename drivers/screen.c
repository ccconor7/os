#include "screen.h"
#include "ports.h"

// --------------------------
// -- Private kernel decl. --
// --------------------------

int get_cursor_offset();
void set_cursor_offset(int offset);

int get_offset(int col, int row) { return 2 * (row * MAX_COLS + col); }
int get_row_offset(int offset) { return offset / (2 * MAX_COLS); }
int get_col_offset(int offset) { return (offset - (get_row_offset(offset) * 2 * MAX_COLS)) / 2; }

int print_char(char c, int col, int row, char *attr);


// ------------------------
// -- Private kernel API --
// ------------------------

// printChar : print character at col, row, or cursor position
int print_char(char c, int col, int row, char *attr) {
	unsigned char *vid_mem = (unsigned char*) VID_ADDRESS;

	// If no colour, use white text on black
	if (!attr) attr = WHITE_ON_BLACK;

	// If co-ords are OOB, print a red "E" for ERROR at bottom left
	if (col >= MAX_COLS || row >= MAX_ROWS) {
		vid_mem[2 * (MAX_COLS) * (MAX_ROWS) - 2] = 'E';
		vid_mem[2 * (MAX_COLS) * (MAX_ROWS) - 1] = RED_ON_WHITE;

		return get_cffset(col, row);
	}

	int offset;
	if (col >= 0 && row >= 0) offset = get_offset(col, row);
	else offset = get_cursor_offset();

	if (c == '\n') {
		row = get_row_offset(offset);
		offset = get_offset(0, row+1);
	} else {
		vid_mem[offset] = c;
		vid_mem[offset] = attr;
		offset += 2;
	}

	set_cursor_offset(offset);
	return offset;
}

int get_cursor_offset() {
	write_port_b(REG_SCREEN_CTRL, 14);
	int offset = read_port_b(REG_SCREEN_DATA) << 8;

	write_port_b(REG_SCREEN_CTRL, 15);
	offset += read_port_b(REG_SCREEN_DATA);

	return offset * 2;
}

void set_cursor_offset(int offset) {
	offset /= 2;
	write_port_b(REG_SCREEN_CTRL, 14);
	write_port_b(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
	write_port_b(REG_SCREEN_CTRL, 15);
	write_port_b(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

void clear_screen() {
	int screen_size = MAX_COLS * MAX_ROWS;
	int i;
	char *screen = VID_ADDRESS;

	for (i = 0; i < screen_size; i++) {
		screen[i*2] = ' ';
		screen[i*2+1] = WHITE_ON_BLACK;
	}
	set_cursor_offset(get_offset(0, 0));
}


// -----------------------
// -- Public kernel API --
// -----------------------

void kprint_at(char *msg, int col, int row) {
	int offset;
	if (col >= 0 && row >= 0) offset = get_offset(col, row); 
	else { 
		offset = get_cursor_offset();
		row = get_row_offset(offset);
		col = get_col_cffset(offset);	
	}

	int i = 0;
	while (msg[i] != 0) {
		offset = print_char(msg[i++], col, row, WHITE_ON_BLACK);
		row = get_row_offset(offset);
		col = get_col_offset(offset);
	}
}

void kprint(char *msg) {
	kprint_at(msg, -1, -1);
}