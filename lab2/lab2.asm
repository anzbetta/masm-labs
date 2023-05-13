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

.data	; директива определения данных
_temp1 dd ?,0
_temp2 dd ?,0
_const1 dd 2
_const2 dd 2
_title db "Лабораторна робота №2. операції порівнняння",0
strbuf dw ?,0
_text db "masm32.  Вивід результата через MessageBox:",0ah,
"y=2a-e/2c c>a",0ah,
"y=b/a+c/a c<=a",0ah,
"Результат: %d — ціла частина",0ah, 0ah,
"СТУДЕНТ КНЕУ  ІІТЕ Бабіченко Анна ІН-101",0
MsgBoxCaption  db "Пример окна сообщения",0 
MsgBoxText_1     db "порівнняння  _c >_a",0 
MsgBoxText_2     db "порівнняння  _c<=_a",0 

.const 
   NULL        equ  0 
   MB_OK       equ  0 

.code	; директива начала сегмента команд
_start:	; метка начала программы с именем _start
 
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
mov eax, _a ;здесь мы записали число _c в регистр eax.
sub ebx, eax   ; порівняння  _c<=_a
   
	jle zero

; zero ;осуществляем переход на метку zero,
;если флаг ZF установлен.
;Если  не , то выполнение продолжится дальше
;y=2a-e/2c c>a 



mov eax, _const1      ; Завантажуємо значення _const1 в регістр eax
mul _a                ; Множимо eax на значення _a і результат зберігаємо в eax
mov ecx, eax          ; Зберігаємо отримане значення в ecx
mov eax, _const2      ; Завантажуємо значення _const2 в eax
mul _c                ; Множимо eax на значення _c і результат зберігаємо в eax
mov ebx, eax          ; Зберігаємо отримане значення в ebx
mov eax, _e           ; Завантажуємо значення _e в eax
div ebx               ; Ділимо eax на ebx і результат зберігаємо в eax
sub ecx, eax          ; Віднімаємо результат ділення з eax від значення, що зберігається в ecx
mov _temp1, ecx       ; Зберігаємо результат в _temp1





INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_1, ADDR MsgBoxCaption, MB_OK 
invoke wsprintf, ADDR strbuf, ADDR _text, _temp1
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION
invoke ExitProcess, 0

jmp lexit ;переходим на метку exit (GOTO exit)

 zero:
;y=b/a+c/a c<=a


mov eax, _b
cdq ; розширення знаку до edx для ділення
idiv _a ; отримуємо b/a, результат ділення зберігаємо в eax, остачу в edx
mov ecx, eax ; зберігаємо результат b/a в ecx
mov eax, _c
cdq ; розширення знаку до edx для ділення
idiv _a ; отримуємо c/a, результат ділення зберігаємо в eax, остачу в edx
add eax, ecx ; додаємо результати b/a і c/a
mov _temp2, eax ; зберігаємо результат у змінну _temp2



INVOKE    MessageBoxA, NULL, ADDR MsgBoxText_2, ADDR MsgBoxCaption, MB_OK 
invoke wsprintf, ADDR strbuf, ADDR _text, _temp2
invoke MessageBox, NULL, addr strbuf, addr _title, MB_ICONINFORMATION
invoke ExitProcess, 0

 lexit:
 ret
main endp
 ret                     ; возврат управления ОС
end _start          ; завершение программы с именем _start
