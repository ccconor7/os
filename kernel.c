#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

static const size_t VGA_COLS = 80;
static const size_t VGA_ROWS = 25;

enum vga_color {
	VGA_COLOR_BLACK = 0,
	VGA_COLOR_BLUE = 1,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_CYAN = 3,
	VGA_COLOR_RED = 4,
	VGA_COLOR_MAGENTA = 5,
	VGA_COLOR_BROWN = 6,
	VGA_COLOR_LIGHT_GREY = 7,
	VGA_COLOR_DARK_GREY = 8,
	VGA_COLOR_LIGHT_BLUE = 9,
	VGA_COLOR_LIGHT_GREEN = 10,
	VGA_COLOR_LIGHT_CYAN = 11,
	VGA_COLOR_LIGHT_RED = 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN = 14,
	VGA_COLOR_WHITE = 15,
};

/* Static: static storage duration and internal linkage
    - Duration: storage duration is entire execution of the program
    - Linkage: identifier can be referred to from all scopes in current translation unit

    Inline: replaces a call of the function with its body, eliminating the need for a 
    function call */
static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg) {
    return fg | bg << 4;
}

static inline uint16_t vga_entry(unsigned char uc, uint8_t color) {
    return (uint16_t)uc | (uint16_t)color << 8;
}

size_t strlen(const char* str) {
    size_t len = 0;
    while(str[len])
        len++;
    return len;
}

size_t    term_row;
size_t    term_col;
uint8_t   term_color;
uint16_t* term_buffer;

void term_init(void){
    term_row = 0;
    term_col = 0;
    term_color = vga_entry_color(VGA_COLOR_RED, VGA_COLOR_BLACK);
    term_buffer = (uint16_t*) 0xB8000;

    // Clear the terminal
    for(size_t y = 0; y < VGA_ROWS; y++) {
        for(size_t x = 0; x < VGA_COLS; x++) {
            const size_t index = y * VGA_COLS + x;
            term_buffer[index] = vga_entry(' ', term_color);
        }
    }
}

void term_set_color(uint8_t color) {
    term_color = color;
}

void term_put_char_at(char c, uint8_t color, size_t x, size_t y) {
    const size_t index = y * VGA_COLS + x;
    term_buffer[index] = vga_entry(c, color);
}

void term_put_char(char c) {
    term_put_char_at(c, term_color, term_col, term_row);

    // Handle newlines
    if(c == '\n') {
        term_row++;
        term_col = -1;
    }

    // If reached edge of screen
    if(++term_col == VGA_COLS) {
        term_col = 0;
        if(++term_row == VGA_ROWS) {
            term_row = 0;
        }
    }
}

void term_write(const char* data, size_t size) {
    for(size_t i = 0; i < size; i++) {
        term_put_char(data[i]);
    }
}

void term_write_string(const char* data) {
    term_write(data, strlen(data));
}

void kernel_main(void) {
    term_init();
    term_write_string("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaa");
    term_write_string("test1\ntest2\ntest3\n");
}