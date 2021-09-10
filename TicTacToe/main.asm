.model	flat,c

extern	puts:proc,getchar:proc,system:proc

.const
MK      db      '・○×'
DRAW    db      'draw',0
CLS     db      'cls',0
CND     dd      15h,540h,15000h,1041h,4104h,10410h,1110h,10101h
MSK     dd      55555555h,33333333h,0f0f0f0fh,00ff00ffh,0000ffffh

.data
TURN    dd      1
BDVAL   dd      0
BDMK    db      '・・・',0dh,0ah,'・・・',0dh,0ah,'・・・',0ah,0
MSG     db      '・',27h,'s turn [0-8] > ',0
WIN     db      '・ wins!',0

.code
main    proc
        push    ebx
HEAD:   mov     eax,TURN
        mov     ax,word ptr [offset MK+eax*2]
        mov     [offset MSG],ax                         ;set mk of input msg

        push    offset BDMK
        call    puts                                    ;show board
        push    offset MSG
        call    puts                                    ;show input msg
        add     esp,8

POS:    call    getchar
        sub     eax,'0'
        cmp     eax,8
        ja      POS                                     ;if eax is not in 0-8

        lea     ecx,[eax*2]
        mov     edx,3
        shl     edx,cl
        test    edx,BDVAL
        jnz     POS                                     ;if not 0 at eax pos

        mov     edx,TURN
        shl     edx,cl
        or      BDVAL,edx                               ;put val

        mov     edx,3
        div     dl
        mov     dl,ah
        shl     al,2
        add     dl,al
        shl     edx,1
        add     edx,offset BDMK
        mov     eax,TURN
        mov     ax,word ptr [offset MK+eax*2]
        mov     word ptr [edx],ax                       ;put mk

        mov     ecx,8
        mov     edx,offset CND

JDG:    mov     eax,BDVAL
        test	TURN,2
        jz      NOUGHT                                  ;if NOUGHT turn
        shr     eax,1
NOUGHT: and     eax,[edx]
        xor     eax,[edx]
        jz      FND                                     ;if 3 in a row
        add     edx,4
        loop    JDG

        mov     eax,BDVAL
        mov     ebx,offset MSK
        mov     cl,1

CNT:    mov     edx,eax
        and     eax,[ebx]
        shr     edx,cl
        and     edx,[ebx]
        add     eax,edx
        add     ebx,4
        shl     cl,1
        test    cl,32
        jz      CNT

        xor     eax,9
        jz      DRW                                     ;if board is filled

        xor     TURN,3                                  ;switch turn

        push    offset CLS
        call    system                                  ;clear screen
        add     esp,4

        jmp     HEAD

DRW:    push    offset DRAW                             ;set result msg
        jmp     FIN

FND:    mov     eax,TURN
        mov     ax,word ptr [offset MK+eax*2]
        mov     [offset WIN],ax
        push    offset WIN                              ;set result msg

FIN:    push    offset CLS
        call    system                                  ;clear screen
        push    offset BDMK
        call    puts                                    ;show board
        add     esp,8
        call    puts                                    ;show result msg
        add     esp,4

        pop     ebx
        mov     eax,0
        ret
main    endp
        end
