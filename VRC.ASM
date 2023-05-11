PRINTS MACRO SMSG
MOV AH, 09H
LEA DX, SMSG
INT 21H
ENDM

READS MACRO SBUFF
MOV AH, 0AH
LEA DX, SBUFF
INT 21H
ENDM
                               
DATA SEGMENT
print_msg DB "Enter bits: $"
newline DB 0DH, 0AH, '$'
print_even DB "Even Parity: $"
print_odd DB "Odd Parity: $"
bitse DB 50, 0, 50 DUP('$')
bitso DB 50, 0, 50 DUP('$')
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA
START:
        MOV AX, DATA
        MOV DS, AX

        PRINTS print_msg
        READS bitse

        MOV BL, 00H
        MOV CL, 07H
        LEA SI, bitse+2
        LEA DI, bitso+2
        ITERATE:
                MOV AL, [SI]
                MOV [DI], AL
                CMP AL, '1'
                JE INC_ONE
                JMP NEXT
                INC_ONE:
                        INC BL
                NEXT:
                        INC SI
                        INC DI
                        DEC CL
                        JNZ ITERATE

        MOV AX, 0000H
        MOV AL, BL
        MOV DL, 02H
        DIV DL

        CMP AH, 00H
        JE ZERO
        MOV AL, '1'
        MOV BL, '0'
        MOV [SI], AL
        MOV [DI], BL
        JMP FINAL_OUT

        ZERO:
                MOV AL, '0'
                MOV BL, '1'
                MOV [SI], AL
                MOV [DI], BL

        FINAL_OUT:
                PRINTS newline
                PRINTS print_even
		PRINTS newline
                PRINTS bitse+2
                PRINTS newline
                PRINTS print_odd
                PRINTS newline
                PRINTS bitso+2
        MOV AH, 4CH
        INT 21H
CODE ENDS
END START
                        

                        
                
