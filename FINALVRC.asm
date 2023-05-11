PRINT MACRO MESSAGE
    MOV AH, 09H
    LEA DX, MESSAGE
    INT 21H
ENDM

DATA SEGMENT
    STARTMSG DB 'VERTICAL REDUNDANCY CALCULATOR', 13, 10, '$'
    ED DB 'ENTER 8-BIT DATA: $'
    EP DB "DATA WITH EVEN PARITY: $"
    OP DB 13,10,"DATA WITH ODD PARITY: $"
    ONENO DB '1$'
    ZERONO DB '0$'
    NUM DB ?       ; ORIGINAL NUMBER
    EVNUM DB ?     ; EVEN PARITY
    ODNUM DB ?     ; ODD PARITY
    BUFF DB 1 DUP(0)
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA
    START:
        MOV AX, DATA
        MOV DS, AX

        PRINT STARTMSG
        PRINT ED

        ; Scan data
        LEA AX, BUFF
        MOV AH, 0AH
        INT 21H
        
        MOV SI, OFFSET BUFF+2   ; Start at the input buffer offset
        MOV CL, 8         ; Loop counter for 8 bits
        MOV AL, 00H       ; Clear AL to store the binary result

        CONVERT_LOOP:
            MOV BL, [SI]  ; Load the current character
            CMP BL, '0'   ; Compare the current character to '0'
            JNE SET_BIT   ; Jump if not equal (character is '1')

            JMP NEXT_BIT  ; Jump to process the next bit

        SET_BIT:
            OR AL, 1      ; Set the least significant bit of AL to 1

        NEXT_BIT:
            INC SI        ; Move to the next character
            DEC CL        ; Decrement the loop counter
            JNZ CONVERT_LOOP ; Jump if the loop counter is not zero

            ;End Scan
        MOV BL, 00H   
        MOV CX, 08H   

        CALCULATE_PARITY:
            ROL AL, 01   
            JC INCREMENT_ONES   
            JMP CONTINUE_LOOP

        INCREMENT_ONES:
            INC BL   

        CONTINUE_LOOP:
            LOOP CALCULATE_PARITY   

        
        PRINT EP

        MOV CX, 8   
        PRINT_ORIG_EVEN:
            ROL DL, 1   
            JC PRINT_ONE
            PRINT ZERONO
            JMP CONTINUE_PRINT

        PRINT_ONE:
            PRINT ONENO

        CONTINUE_PRINT:
            LOOP PRINT_ORIG_EVEN   

        
        MOV AL, [BUFF+2] ;DOS interrupt 0Ah stores the length of the input string in the first byte of the buffer, and the actual input starts from the third byte.   
        MOV BL, 00H   

        CALCULATE_ODD_PARITY:
            ROL AL, 01   
            JC INCREMENT_ODD_ONES   
            JMP CONTINUE_ODD_LOOP

        INCREMENT_ODD_ONES:
            INC BL  

        CONTINUE_ODD_LOOP:
            LOOP CALCULATE_ODD_PARITY   

        
        PRINT OP

        MOV CX, 8   
        PRINT_ORIG_ODD:
            ROL DL, 1   
            JC PRINT_ODD_ONE
            PRINT ZERONO
            JMP CONTINUE_ODD_PRINT

        PRINT_ODD_ONE:
            PRINT ONENO

        CONTINUE_ODD_PRINT:
            LOOP PRINT_ORIG_ODD   

        EXIT:
            MOV AH, 4CH
            INT 21H

CODE ENDS
END START
