void dummy_test_entrypoint() {
}

void main() {
	// Create a pointer to a char and point it to the first text cell of 
	//  vid_mem
	char *vid_mem = (char*) 0xB8000;

	// At the address pointed to by the vid_mem pointer, store "X" 
	*vid_mem = "X";
}
