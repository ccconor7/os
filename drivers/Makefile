CC = i686-elf-gcc
CFLAGS = -ffreestanding -c
#DEPS = screen.h ports.h 
OBJ = screen.o ports.o

%.o: %.c #$(DEPS)
	$(CC) $(CFLAGS) $^ -o $@

screen: $(OBJ)
	$(CC) $(CFLAGS) $^ -o $@

ports: $(OBJ)
	$(CC) $(CFLAGS) $^ -o $@