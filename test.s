; Our first 6502 program.
; Follow the instructions in README.md.

.segment "BSS"
i:      .res 1          ; a byte of memory for i
j:      .res 1          ; a byte of memory for j
k:      .res 1          ; a byte of memory for k
result: .res 1          ; a byte of memory for the result

.segment "CODE"
.export _main

_main:
    lda #$16
    sta $FFCB


    lda #10             ; Load constant 10 into register A
    sta i               ; Store register A in memory at i

    ; TODO: Initialize j with 7 and k with 4.

    lda #0              ; A is now zero, but i is still 10
    lda i               ; Read i back from memory
    rts                 ; Return A to sim65

    ; Later, replace the final three instructions with
    ; the unfinished calculation shown in README.md.
