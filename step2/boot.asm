; boot.asm
   ; mov ds, 0x07c0 ; Can't do this b/c invalid combination of opcodes and operands
                    ; ds is a segment register -> look into segments

   ; The code in the boot sector of the disk is loaded by the BIOS at 0000:7c00
   ; (segment: offset). The segment seems to basically be the start of the
   ; memory and the offset is added to the segment x 16/0x10

   ; 64k x 16 = 1024k or 1MB
   ; Multiplying a hex number by 16 effectively shifts it over 4 bits so instead
   ; of a 16 digit number, you now have a 20 digit number with four zeros at the
   ; end. The equivalent action in decimal is multiplying a number by 10 to add
   ; a zero to the end. Then you can add the offset to get the exact address.

   mov ax, 0x07c0 ; First load segment into ax
   mov ds, ax     ; ds stands for data segment register and stores the segment
                  ; part. It can only load the segment value from a general
                  ; purpose register, not from memory. See link for the bullshit no
                  ; reasons - could be edge case, not wanting to do paths, etc
                  ; http://stackoverflow.com/questions/19074666/8086-why-cant-we-move-an-immediate-data-into-segment-register

   mov ah, 0x0 ; Sets ah register to clear the screen
   mov al, 0x3 ; Sets screen to 80x25
   int 0x10    ; Calls the video service interrupt
 
   mov si, msg ; move the location of msg into si

   mov ah, 0x0E ; Set ah to be teletype?? for writing characters
                ; which takes ascii byte from al and prints it to screen

putchar_loop:
   lodsb     ; Loads a byte from where si points to into al

   or al, al ; Compares the two operands and if either of the bits are one the
             ; first operand's bit turns to 1, for each bit separately
             ; Side note about zero flag: If any operation returns zero this
             ; flag is set

   jz hang   ; Jumps if the zero flag is set

   int 0x10  ; Otherwise calls the video service interrupt

   jmp putchar_loop ; Repeat
 
msg:
   db 'Hello World yoyoyo', 13, 10, 0
   ; 13 is carriage return \n
   ; 10 is new line \r
   ; Historically a \n was used to move the carriage down, while the \r was used to move the carriage back to the left side of the page.

hang:
   ;hlt ; Don't do just this b/c after an interrupt happens, the computer
        ; executes the command after hlt. Either add a jmp or just keep the
        ; infinite loop.
   jmp hang

   times 510-($-$$) db 0
   db 0x55
   db 0xAA
