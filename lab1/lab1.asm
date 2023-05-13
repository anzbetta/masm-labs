

.686
.model flat, stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
firstfunc PROTO 
_const1:DWORD,_e:DWORD,_b:DWORD, _const2:DWORD _d:DWORD,_c:DWORD
.data
const1 dd 4
e dd 40
b dd 56
const2 dd 14
d dd 2
c dd 1
_temp1 dd 0
_title db "Laboratorna 1. Arifmetichni operacii",0
strbuf dw ?,0
_text db "masm32. Вивід результата 2a-e/2c через MessageBox:",0ah,"Результат: %d — ціла частина",0ah, 0ah,"СТУДЕНТ КНЕУ  ФІСІТ",0
.code
firstfunc proc _const1:DWORD,_d:DWORD,_const2:DWORD,_e:DWORD, _c:DWORD,_b:DWORD
mov eax, _const1
mul _b
mov ebx, eax
mov eax,_e
div ebx
mov ebx, eax
mov eax,_const2
mul_c
mov eax, ecx
mov eax,_d
div ecx
sub ebx, eax
mov_temp1,ebx
ret
start:
invoke firstfunc, const1,e,b,const2,d,c
invoke wsprintf, ADDR strbuf, ADDR _text, _temp1
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION
invoke ExitProcess, 0
END start


