#!/usr/bin/env bash

i686-elf-as boot.s -o boot.o
i686-elf-gcc -c kernel.c -o kernel.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions
i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

qemu-system-i386 -kernel myos.bin

