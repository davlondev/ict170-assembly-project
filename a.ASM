; Student ID: redacted
; Name: David Long
; ICT 170 
; Assignment 2

TITLE PRGM1
.MODEL SMALL
.STACK 100H

.DATA
  ; store the counters
  seconds DW 0
  minutes DW 0
  hours   DW 0

  counts    DW 0 ; when a full day is passed, end the program

.CODE
MAIN PROC

  ; init DS
  MOV AX, @DATA
  MOV DS, AX

  ; receive the input character from user
  ; the character is stored in the AL register
  MOV AH, 1         ; set DOS interrupt to 1 (read char from standard input)
  INT 21H           ; dos interrupt
  SUB AL, '0'       ; convert ascii to digit
  MOV seconds, AL   ; convert seconds to the input digit

  ; main loop
  MyLoop:
    ; reset the time if 11:59:59 is reached
    MOV AX, hours
    MOV BX, 12
    CMP AX, BX      ; compare AX, BX     
    JLE SkipResetTime_
    JGE ShouldResetTime_

  ShouldResetTime_:
    MOV AX, counts    ; compare counts with 2
    MOV BX, 2       
    CMP AX, BX      ; if counts >= 2,
    JGE ShouldExit_   ; end the program

    INC counts
    MOV seconds, 0  ; reset seconds
    MOV minutes, 0  ; reset minutes
    mov hours, 0    ; reset hours
    JMP SkipResetTime_ ; jump to loop

  ShouldExit_:
    MOV AH, 4CH ; 4CH is dos exit
    INT 21H

  SkipResetTime_:
    ; compare seconds with 60
    ; if seconds are greater than 60,
    ; jump to the AddMinute_ label
    MOV AX, seconds
    MOV BX, 60
    CMP AX, BX      ; compare AX > BX
    JGE AddMinute_  ; if AX >= BX, jump to AddMinute_

    ; same for minutes
    MOV AX, minutes
    MOV BX, 60
    CMP AX, BX      ; compare AX > BX
    JGE AddHour_    ; if AX >= BX, jump to AddHour_

    ; print hours (up to 2 digit number)
    ; limitation: when over 99 hours,
    ; it will not print correctly
    MOV AL, hours
    MOV AH, 0
    MOV DL, 10
    DIV DL          ; divide hours by 10 (AL/DL)
    ADD AX, 3030H   ; convert to ascii
    MOV DH, AH      
    MOV DL, AL      ; move first digit to DL
    MOV AH, 2       ; set DOS interrupt 
    INT 21H         ; print first digit
    MOV DL, DH      ; move second digit to DL
    INT 21H         ; print second digit

    ; print ':' between
    MOV AH, 2       ; set DOS interrupt
    MOV DL, ':'     ; set character to ':'
    INT 21H         ; print DL

    ; print minutes
    ; same process as hours
    MOV AL, minutes
    MOV AH, 0
    MOV DL, 10
    DIV DL          ; divide minutes by 10 (AL/DL)
    ADD AX, 3030H   ; convert the result to ascii
    MOV DH, AH
    MOV DL, AL      ; move the first digit to DL (to be printed)
    MOV AH, 2       ; set DOS interrupt
    INT 21H         ; do DOS interrupt
    MOV DL, DH      ; move second digit to DL (to be printed)
    INT 21H         ; print the second digit

    ; print ':' between
    MOV AH, 2       ; set DOS interrupt
    MOV DL, ':'     ; set DL to ':'
    INT 21H         ; print it
    
    ; print seconds
    ; same process as hours and minutes
    MOV AL, seconds
    MOV AH, 0
    MOV DL, 10
    DIV DL          ; divide AL by 10 (seconds/10)
    ADD AX, 3030H   ; convert it to ascii
    MOV DH, AH
    MOV DL, AL      ; move the first digit to DL (to be printed)
    MOV AH, 2       ; set the DOS interrupt
    INT 21H         ; do DOS interrupt
    MOV DL, DH      ; move second digit to DL
    INT 21H         ; print the second digit (DOS interrupt)
    
    ; print new line
    MOV AH, 2       ; set DOS interrupt (print single character)
    MOV DL, 10      ; set character to 10 (newline)
    INT 21H         ; print it (DOS interrupt)

    INC seconds     ; increment seconds (seconds = seconds + 1)
    JMP MyLoop      ; jump to the beginning of the loop

  ; addminute label
  AddMinute_:
    INC minutes     ; increment minutes
    MOV seconds, 0  ; reset seconds (back to zero)
    JMP MyLoop      ; return back to the loop

  ; addhour label
  AddHour_:
    INC hours       ; increment hour
    MOV minutes, 0  ; reset minutes (back to zero)
    MOV seconds, 0  ; reset seconds (back to zero)
    JMP MyLoop      ; return back to the loop

  ; end program
  EndWhile_:
    MOV AH, 4CH ; 4CH is dos exit
    INT 21H

MAIN ENDP ; end
END MAIN
