.486                                    ; create 32 bit code
    .model flat, stdcall                    ; 32 bit memory model
    option casemap :none                    ; case sensitive
    include \masm32\include\windows.inc     ; always first
    include \masm32\macros\macros.asm       ; MASM support macros
  ; -----------------------------------------------------------------
  ; include files that have MASM format prototypes for function calls
  ; -----------------------------------------------------------------
    include \masm32\include\masm32.inc
    include \masm32\include\gdi32.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc
include c:\masm32\include\msvcrt.inc
includelib c:\masm32\lib\msvcrt.lib
  ; ------------------------------------------------
  ; Library files that have definitions for function
  ; exports and tested reliable prebuilt code.
  ; ------------------------------------------------
    includelib \masm32\lib\masm32.lib
    includelib \masm32\lib\gdi32.lib
    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib

.data	; ��������� ����������� ������
_temp1 dd ?,0
_temp2 dd ?,0
_const1 dd 2
_const2 dd 2
_title db "����������� ������ �2. �������� ����������",0
strbuf dw ?,0
_text db "masm32.  ���� ���������� ����� MessageBox:",0ah,
"y=2a-e/2c c>a",0ah,
"y=b/a+c/a c<=a",0ah,
"���������: %d � ���� �������",0ah, 0ah,
"������� ����  ���� �������� ���� ��-101",0
MsgBoxCaption  db "������ ���� ���������",0 
MsgBoxText_1     db "����������  _c >_a",0 
MsgBoxText_2     db "����������  _c<=_a",0 

.const 
   NULL        equ  0 
   MB_OK       equ  0 

.code	; ��������� ������ �������� ������
_start:	; ����� ������ ��������� � ������ _start
 
main proc
LOCAL _a: DWORD 
LOCAL _b: DWORD 
LOCAL _c: DWORD
LOCAL _e: DWORD 

mov _a, sval(input("enter a = "))
mov _b, sval(input("enter b = "))
mov _c, sval(input("enter c = "))
mov _e, sval(input("enter e = "))
 
mov ebx, _c 
mov eax, _a ;����� �� �������� ����� _c � ������� eax.
sub ebx, eax   ; ���������  _c<=_a
   
	jle zero

; zero ;������������ ������� �� ����� zero,
;���� ���� ZF ����������.
;����  �� , �� ���������� ����������� ������
;y=2a-e/2c c>a 



mov eax, _const1      ; ����������� �������� _const1 � ������ eax
mul _a                ; ������� eax �� �������� _a � ��������� �������� � eax
mov ecx, eax          ; �������� �������� �������� � ecx
mov eax, _const2      ; ����������� �������� _const2 � eax
mul _c                ; ������� eax �� �������� _c � ��������� �������� � eax
mov ebx, eax          ; �������� �������� �������� � ebx
mov eax, _e           ; ����������� �������� _e � eax
div ebx               ; ĳ���� eax �� ebx � ��������� �������� � eax
sub ecx, eax          ; ³������ ��������� ������ � eax �� ��������, �� ���������� � ecx
mov _temp1, ecx       ; �������� ��������� � _temp1





INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_1, ADDR MsgBoxCaption, MB_OK 
invoke wsprintf, ADDR strbuf, ADDR _text, _temp1
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION
invoke ExitProcess, 0

jmp lexit ;��������� �� ����� exit (GOTO exit)

 zero:
;y=b/a+c/a c<=a


mov eax, _b
cdq ; ���������� ����� �� edx ��� ������
idiv _a ; �������� b/a, ��������� ������ �������� � eax, ������ � edx
mov ecx, eax ; �������� ��������� b/a � ecx
mov eax, _c
cdq ; ���������� ����� �� edx ��� ������
idiv _a ; �������� c/a, ��������� ������ �������� � eax, ������ � edx
add eax, ecx ; ������ ���������� b/a � c/a
mov _temp2, eax ; �������� ��������� � ����� _temp2



INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_2, ADDR MsgBoxCaption, MB_OK 
invoke wsprintf, ADDR strbuf, ADDR _text, _temp2
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION
invoke ExitProcess, 0

 lexit:
 ret
main endp
 ret                     ; ������� ���������� ��
end _start          ; ���������� ��������� � ������ _start
