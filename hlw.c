#include <stdint.h>

void main() { // No return needed in this context
    const char* message = "Hello World!";
    volatile uint16_t* vga = (uint16_t*) 0xB8000;

    for (int i = 0; message[i] != '\0'; ++i) {
        vga[i] = (uint16_t)message[i] | (uint16_t)0x0F00;
    }
}
