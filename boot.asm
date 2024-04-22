bits 16         ; Start in real mode
; Stage 1: Basic bootloader in real mode
org 0x7C00        ; BIOS expects bootloader to load at this address
start:
    cli         ; Disable interrupts 
    mov ax, 0x07C0  ; Set up data segment 
    mov ds, ax

    ; Display a simple message
    mov ah, 0x0E    ; BIOS function to print a character
    mov al, 'L'     ; Character to print 
    int 0x10 
    mov al, 'o'     ; Character to print 
    int 0x10 
    mov al, 'v'     ; Character to print 
    int 0x10 
    mov al, 'e'     ; Character to print 
    int 0x10 
    mov al, 'U'     ; Character to print 
    int 0x10 

    ; Load the protected mode kernel from disk (simplified)
    mov ah, 0x02    ; BIOS read sector function
    mov al, 1       ; Number of sectors to read
    mov bx, 0x8000  ; Load address in memory
    mov ch, 0       ; Cylinder 
    mov cl, 2       ; Sector
    mov dh, 0       ; Head
    mov dl, 0       ; Drive 
    int 0x13        ; Call BIOS interrupt

    ; Check for errors (omitted for brevity)

    jmp 0x0000:pm_start  ; Jump to protected mode code

; Stage 2: Setting up and entering protected mode
bits 32

pm_start:
    ; 1. Set up a Global Descriptor Table (GDT)
    gdt:
        ; Null descriptor 
        dd 0x0, 0x0   

        ; Code descriptor
        dd 0xFFFF, 0x0000, 0x9A, 0xCF 

        ; Data descriptor
        dd 0xFFFF, 0x0000, 0x92, 0xCF  

    gdt_descriptor:
        dw gdt_end - gdt - 1 
        dd gdt               

   ; 2. Load the GDT Register (GDTR)
    lgdt [gdt_descriptor]

   ; 3. Enable protected mode 
    mov eax, cr0
    or eax, 0x1 
    mov cr0, eax 

   ; 4. Jump to protected mode
    jmp 0x8:pm_continue  

pm_continue: 
    ; Move to higher memory for more space, if needed
    mov ax, 0x8000      ; Load kernel segment
    mov ds, ax
    mov es, ax
    ; call print_from_c  








    ; extern main
    ; call main


    ; jmp 0x1111
    jmp c_code_start





    ; Jump to the kernel's entry point (assume at offset 0)
    jmp 0x0000

gdt_end: 


c_code_start:
    incbin "print_from_protected_mode.bin"  

times 510 - ($ - $$) db 0   ; Pad with zeros to reach 510 bytes
dw 0xAA55  