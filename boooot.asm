bits 16         ; Start in 16-bit real mode
org 0x7C00      ; Standard bootloader origin

; --- Bootloader Setup ---
section .text
global _start
_start:
    cli         ; Disable interrupts
    xor ax, ax  ; Clear registers for segment setup
    mov ds, ax
    mov es, ax  

    ; ... (Code to load your C code into memory. See variations below)

; --- Switch to Protected Mode ---
    call enable_protected_mode  ; Jump to the protected mode setup routine

; --- Call C Code ---    
    call c_code_start           ; Call the C code to print "Hello World!"

; --- Back to Real Mode (Optional) ---
    cli
    mov eax, cr0
    and eax, 0x7FFFFFFF         ; Clear protected mode bit
    mov cr0, eax
    jmp 0:reset_vector          ; Far jump to reset CPU

; --- Protected Mode Setup ---
enable_protected_mode:
    lgdt [gdt_table]            ; Load GDT
    mov eax, cr0                ; Set protected mode bit in CR0
    or eax, 0x1
    mov cr0, eax
    jmp 0x8:protected_mode_entry  ; Jump to protected mode segment

; --- GDT (Very Basic) ---
gdt_table:
    dw 0xFFFF, 0x0, 0x0, 0x0       ; Null descriptor
    dw 0xFFFF, 0x0, 0x9A, 0xCF     ; 32-bit code segment (4GB)
    dw 0xFFFF, 0x0, 0x92, 0xCF     ; 32-bit data segment (4GB)
gdt_table_end:
gdt_pointer:
    dw gdt_table_end - gdt_table - 1  ; GDT limit
    dd gdt_table                        ; GDT base address

; --- Protected Mode Entry ---
protected_mode_entry:
    mov ax, 0x10                    ; Data segment selector
    mov ds, ax
    mov es, ax
    mov ss, ax 
    ; Set up initial stack (adjust if needed)
    mov esp, 0x7000 
    ret ; Return to caller (bootloader)

; --- Placeholder for Compiled C Code ---
c_code_start:
    ; ... Your compiled C code (`hello.bin`) will be placed here using 'incbin'
    incbin "hello.bin"

; --- Reset Vector ---
reset_vector:
    times 510-($-$$) db 0       ; Fill up to 510 bytes
    dw 0xAA55                   ; Bootloader signature
