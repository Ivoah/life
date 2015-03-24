_x .equ 3
_y .equ 9
_w .equ 30
_h .equ 15

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
    .db "Conway's Game of Life", 0 ;' <- fix syntax highlighting
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

    ld a, 0b00000100
    kld(hl, name)
    corelib(drawWindow)

    kcall(drawBoard)

    corelib(appGetKey)

    cp kMODE
    jr nz, .loop

    ; Exit when the user presses "MODE"
    ret

drawBoard:
    ld l, _y
    ld b, _h
.rows:
    push bc
    ld e, _x
    ld b, _w
.cols:
    push bc
    ld bc, 0x0303
    pcall(rectOR)
    inc l
    ld a, e
    inc a
    pcall(resetPixel)
    dec l
    inc e \ inc e \ inc e
    pop bc
    djnz .cols
    pop bc
    inc l \ inc l \ inc l
    djnz .rows

    ret

board:
    ;.fill
