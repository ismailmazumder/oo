gcc -ffreestanding -c -m32 hlw.c -o hello.o
objcopy -O binary hello.o hello.bin
nasm -f elf32 boooot.asm -o bootloader.o

ld -m elf_i386 -Ttext 0x7C00 -o bootloader.elf bootloader.o hello.o
dd if=/dev/zero of=bootdisk.img bs=512 count=2880
dd if=bootloader.elf of=bootdisk.img conv=notrunc

qemu-system-i386 -fda bootdisk.img



gcc -ffreestanding -c -m32 hlw.c -o hello.o
objcopy -O binary hello.o hello.bin
nasm -f bin boooot.asm -o bootloader.bin

ld -m elf_i386 -Ttext 0x7C00 -o bootloader.elf bootloader.o hello.o
dd if=/dev/zero of=bootdisk.img bs=512 count=2880
dd if=bootloader.elf of=bootdisk.img conv=notrunc

qemu-system-i386 -fda bootdisk.img