OBJECTS = loader.o kmain.o

CC = gcc
CFLAGS = -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
         -nostartfiles -nodefaultlibs -Wall -Wextra -Werror -c

AS = nasm
ASFLAGS = -f elf32



default: os.iso

clean:
	rm -rf *.o *.debug.s kernel.elf os.iso iso/
	# don't remove stage2_eltorito...


%.o: %.c
	$(CC) $(CFLAGS) $< -o $@
%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

%.debug.s: %.c
	$(CC) $(CFLAGS) -S -masm=intel $< -o $@



kernel.elf: link.ld $(OBJECTS)
	ld  -T link.ld -melf_i386 $(OBJECTS) -o kernel.elf

stage2_eltorito:
	wget http://littleosbook.github.com/files/stage2_eltorito

os.iso: kernel.elf stage2_eltorito
	mkdir -p iso/boot/grub
	cp stage2_eltorito iso/boot/grub/
	cp kernel.elf iso/boot/

	echo 'default=0' > iso/boot/grub/menu.lst
	echo 'timeout=0' >> iso/boot/grub/menu.lst
	echo 'title os' >>  iso/boot/grub/menu.lst
	echo 'kernel /boot/kernel.elf' >>  iso/boot/grub/menu.lst

	genisoimage -R                              \
	            -b boot/grub/stage2_eltorito    \
	            -no-emul-boot                   \
	            -boot-load-size 4               \
	            -A os                           \
	            -input-charset utf8             \
	            -quiet                          \
	            -boot-info-table                \
	            -o os.iso                       \
	            iso
