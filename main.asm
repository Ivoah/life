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

    ld bc, 60 ; ceil(30/8)*15
    pcall(malloc)
    kld((board), ix)

    ld bc, 60 ; ceil(30/8)*15
    pcall(malloc)
    kld((next_board), ix)

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
    push hl \ push de
    ld b, l \ ld c, e
    kcall(getBoard)
    pop de \ pop hl
    kcall(c, .drawCell)
    pop bc
    djnz .cols
    pop bc
    inc l \ inc l \ inc l
    djnz .rows

    ret

.drawCell:
    ld bc, 0x0303
    pcall(rectOR)
    inc l
    ld a, e
    inc a
    pcall(resetPixel)
    dec l
    inc e \ inc e \ inc e

    ret

;; getBoard
;; Gets specific location from board array
;; Inputs:
;;  B, C: row, column of location
;; Outputs:
;;  Flag C: Set if location is alive, reset if dead

getBoard:
    push bc
    srl b \ srl b \ srl b
    ld h, 0
    ld l, b
    add hl, hl \ add hl, hl
    kld(de, (board))
    add hl, de
    ex de, hl

    ld h, 0
    ld l, c
    add hl, de
    ld a, (hl)
    pop bc
    inc b \ rra \ djnz $-1

    ret

;; setBoard
;; Sets specific location to board array
;; Inputs:
;;  B, C: row, column of location
;;  A: value to put on board

setBoard:



board:
    .dw 0x0000

next_board:
    .dw 0x0000

rules:
    .db 3
    .db 0xFF
    .db 2
    .db 3
    .db 0xFF
