; step1.asm

hang:
    jmp hang

    times 510-($-$$) db 0
    ; Without the following lines, qemu doesn't boot the floppy disk
    db 0x55
    db 0xAA
