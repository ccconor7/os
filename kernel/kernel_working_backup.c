void entry() {
}

void main() {
	char *VGA = (char*) 0xB8000;
	*VGA = "XXX";
}
