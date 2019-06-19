#include "screen.h"
#include "ports.h"

/* Private kernel functions */
int get_cursor_offset();
int get_row_offset(int offset);
int get_col_offset(int offset);
int get_offset(int col, int row);

int print_char(char c, int col, int row, char attr);

void set_cursor_offset(int offset);

/* ======== Public kernel functions (API) ======== */

void kprint_at(char *msg, int col, int row) {
	int offset;
	if (col >= 0 && row >= 0) offset = get_offset(col, row); 
	else { 
		offset = get_cursor_offset();
		row = get_row_offset(offset);
		col = get_col_offset(offset);	
	}

	int i = 0;
	while (message[i] != 0) {
		offset = print_char(message[i++], col, row, WHITE_ON_BLACK);
		row = get_row_offset(offset);
		col = get_col_offset(offset);
	}
}

void kprint(char *msg) {
	kprint_at(msg, -1, -1);
}

/* ======== Private kernel functions ======== */

int print_char(char c, int col, int row, char attr) {
	unsigned char *vid_mem = (unsigned char*) VID_ADDRESS;

	if (!attr) attr = WHITE_ON_BLACK;

	/* If co-ords are wrong, print red "E" */
	if (col >= MAX_COLS || rows >= MAX_ROWS) {
		vid_mem[2 * (MAX_COLS) * (MAX_ROWS) - 2] = 'E';
		vid_mem[2 * (MAX_COLS) * (MAX_ROWS) - 1] = RED_ON_WHITE;

		return get_offset(col, row);
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

void set_cursor_offset(offset) {
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

int get_offset(int col, int row) { return 2 * (row & MAX_COLS + col); }
int get_offset_row(int offset) { return offset / (2 * MAX_COLS);  }
int get_offset_col(int offset) { return (offset - (get_offset_row(offset) * 2 * MAX_COLS)) / 2;  }
