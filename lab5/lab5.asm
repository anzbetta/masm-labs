.686 ; create 32 bit code
.model flat, stdcall ; 32 bit memory model 
option casemap :none ; case sensitive

include \masm32\include\windows.inc ; always first
include \masm32\macros\macros.asm ; MASM support macros 
include \masm32\include\masm32.inc
include \masm32\include\gdi32.inc 
include \masm32\include\fpu.inc 
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc 
include \masm32\include\msvcrt.inc

includelib \masm32\lib\msvcrt.lib 
includelib \masm32\lib\fpu.lib 
includelib \masm32\lib\masm32.lib 
includelib \masm32\lib\gdi32.lib 
includelib \masm32\lib\user32.lib 
includelib \masm32\lib\kernel32.lib

.data ; директива определения данных 
Buff db 120 dup(?),0
Min dd 0
Base dd 10
Work dd 0
k DWORD 0
n DWORD 0
temp DWORD 0
two DWORD 2.0
three DWORD 3.0
five DWORD 5.0
six DWORD 6.0
zero DWORD 0.0
_title db "Лабораторна робота №5",0 
strbuf dw ?,0
_text db "masm32. Бабіченко Анна ІН-101, ІІТЕ",10,
"Вивід результата через MessageBox:", 10,13
_result dt 0.0
_res dt 0.0
.const 
NULL equ 0
MB_OK equ 0

include \masm32\include\masm32rt.inc 
include \masm32\include\dialogs.inc

dlgproc PROTO :DWORD,:DWORD,:DWORD,:DWORD 
GetTextDialog PROTO :DWORD,:DWORD,:DWORD

.data? 
hInstance dd ?

.code
 
start:
mov hInstance, rv(GetModuleHandle,NULL) 
call main
invoke ExitProcess,eax
 
main proc
LOCAL hIcon :DWORD

invoke InitCommonControls

mov hIcon, rv(LoadIcon,hInstance,10)

mov n, rv(GetTextDialog," Лабораторна робота №5"," Enter N: ",hIcon) ;Введення N 
mov k, rv(GetTextDialog," Лабораторна робота №5"," Enter K: ",hIcon) ;Введення К

.if n != 0 && k != 0 ;Перевірка на пустоту введених даних 
mov eax, sval(k) ;Конвертація зі строки в числа
mov k, eax
mov eax, sval(n) 
mov n, eax

mov eax, n
.if eax > k ;Пошук мінімуму та максимуму, якщо n > k 
mov eax, n ;то змінити їх місцями
mov ebx, k 
mov k, ebx 
mov n, eax
.endif

mov eax, k ;підготовка даних до циклу 
sub eax, n
add eax, 1
mov ecx, eax ;в лічильнику різниця К і N +1 
finit ;інкремент N
fild n 
fld1 
fsub 
fstp n
a: ;початок циклу 
dec ecx
fld n ;результат сумується до _result 
fld1
fadd 
fstp n

fld n
fld two
fcompp
fstsw ax 
sahf
jz a

fld n 
fld three
fcompp 
fstsw ax 
sahf
jz a

fld n       ;n 

fld n 
fmul n 
fld n
fld five
fmul 
fsub
fld six
fadd        ;n^2 - 5n + 6

fdiv        ;n / n^2 - 5n + 6

fld _result 
fadd
fstp _result

dec ecx 
inc ecx 
jnz a

fld _result ;вивід результату
invoke FpuFLtoA, 0, 10, ADDR _result, SRC1_FPU or SRC2_DIMM 
invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION 
ret
ret
.else
fn MessageBox,0,"Error","Title",MB_OK
.endif

; invoke GlobalFree,ptxt

ret

main endp
 
GetTextDialog proc dgltxt:DWORD,grptxt:DWORD,iconID:DWORD 

LOCAL arg1[4]:DWORD
LOCAL parg :DWORD

lea eax, arg1 
mov parg, eax

	 
mov ecx, dgltxt
mov [eax], ecx 
mov ecx, grptxt 
mov [eax+4], ecx 
mov ecx, iconID 
mov [eax+8], ecx

Dialog "Get User Text", \ ;caption 
"Arial",8, \ ;font,pointsize 
WS_OVERLAPPED or \ ;styles for
WS_SYSMENU or DS_CENTER, \ ;dialog window 
5, \ ;number of controls
50,50,292,80, \ ;x y coordinates 
4096 ;memory buffer size

DlgIcon 0,250,12,299
DlgGroup 0,8,4,231,31,300
DlgEdit ES_LEFT or WS_BORDER or WS_TABSTOP,17,16,212,11,301 
DlgButton "OK",WS_TABSTOP,172,42,50,13,IDOK
DlgButton "Cancel",WS_TABSTOP,225,42,50,13,IDCANCEL

CallModalDialog hInstance,0,dlgproc,parg 
ret
GetTextDialog endp

 
dlgproc proc hWin:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD

LOCAL tlen :DWORD
LOCAL hMem :DWORD
LOCAL hIcon :DWORD

switch uMsg
case WM_INITDIALOG
	 
push esi
mov esi, lParam
fn SetWindowText,hWin,[esi] ; title text address
fn SetWindowText,rv(GetDlgItem,hWin,300),[esi+4] ; groupbox text address 
mov eax, [esi+8] ; icon handle
.if eax == 0
mov hIcon, rv(LoadIcon,NULL,IDI_ASTERISK) ;use default system icon
.else
mov hIcon, eax ;load user icon
.endif 
pop esi

fn SendMessage,hWin,WM_SETICON,1,hIcon
invoke SendMessage,rv(GetDlgItem,hWin,299),STM_SETIMAGE,IMAGE_ICON,hIcon 
xor eax, eax
ret

case WM_COMMAND 
switch wParam
case IDOK
mov tlen, rv(GetWindowTextLength,rv(GetDlgItem,hWin,301))
.if tlen == 0
invoke SetFocus,rv(GetDlgItem,hWin,301) 
ret
.endif
add tlen, 1
mov hMem, alloc(tlen)
fn GetWindowText,rv(GetDlgItem,hWin,301),hMem,tlen 
invoke EndDialog,hWin,hMem
case IDCANCEL
invoke EndDialog,hWin,0 
invoke ExitProcess, 0 
endsw
case WM_CLOSE 
invoke EndDialog,hWin,0 
endsw

xor eax, eax 
ret

dlgproc endp 
end start  
