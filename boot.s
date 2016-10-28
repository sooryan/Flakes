# Declare constants for the multiboot header.
.set ALIGN,    1<<0             # align loaded modules on page boundaries
.set MEMINFO,  1<<1             # provide memory map
.set FLAGS,    ALIGN | MEMINFO  # this is the Multiboot 'flag' field
.set MAGIC,    0x1BADB002       # 'magic number' lets bootloader find the header
.set CHECKSUM, -(MAGIC + FLAGS) # checksum of above, to prove we are multiboot

# Declare a multiboot header that marks the program as a kernel. These are magic
# values that are documented in the multiboot standard.
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

# This allocates room for a small stack by creating a symbol at the bottom of
# it, then allocating 16384 bytes for it, and finally creating a symbol at the
# top. The stack grows downwards on x86.
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

.section .text
.global _start
.type _start, @function
_start:
    mov $stack_top, %esp

    # Enter the high-level kernel
    call kernel_main

    # If the system has nothing more to do, put the computer into an
    # infinite loop
    cli
1:  hlt
    jmp 1b
