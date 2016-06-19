boot.bin:
	nasm -f bin boot.asm -o boot.bin

qemu: boot.bin
	qemu-system-x86_64 -fda boot.bin

clean:
	rm *.bin
