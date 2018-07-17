
loader.o: loader.s
	nasm -f elf32 loader.s

kernel.elf: link.ld loader.o
	ld -T link.ld -melf_i386 loader.o -o kernel.elf

stage2_eltorito:
	wget http://littleosbook.github.com/files/stage2_eltorito
