#include "kernel.inc"
#include "corelib.inc"
    .db "KEXC"
    .db KEXC_ENTRY_POINT
    .dw start
    .db KEXC_STACK_SIZE
    .dw 20
    .db KEXC_NAME
    .dw name
    .db KEXC_HEADER_END
name:
    .db "life", 0
corelib_path:
    .db "/lib/core"
start:
    ; This is an example program, replace it with your own!
    
    kld(de, corelib_path)
    pcall(loadLibrary)

    ; Get a lock on the devices we intend to use
    pcall(getLcdLock)
    pcall(getKeypadLock)

    ; Allocate and clear a buffer to store the contents of the screen
    pcall(allocScreenBuffer)
    pcall(clearBuffer)

.loop:
    ; Copy the display buffer to the actual LCD
    pcall(fastCopy)

    ld a, %00000100
    kld(hl, window_title)
    corelib(drawWindow)

    corelib(appGetKey)

    cp kMODE
    jr nz, .loop

    ; Exit when the user presses "MODE"
    ret

window_title:
    .db "Conway's Game of Life", 0
