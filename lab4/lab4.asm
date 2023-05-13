.486                                        ;директива визначення типу мікропроцесора
.model flat, stdcall                        ;визначення лінійної моделі пам’яті
option casemap :none                        ;розділення верхнього та нижнього регістрів

include \masm32\include\windows.inc         ;підключення програмного файлу windows.inc
include \masm32\macros\macros.asm           ;MASM support macros
include \masm32\include\masm32.inc          ;підключення програмного файлу masm.inc
include \masm32\include\gdi32.inc           ;підключення програмного файлу gdi32.inc
include \masm32\include\fpu.inc             ;підключення програмного файлу fpu.inc
include \masm32\include\user32.inc          ;підключення програмного файлу user32.inc
include \masm32\include\kernel32.inc        ;підключення програмного файлу kernel32.inc
include \masm32\include\msvcrt.inc          ;підключення програмного файлу msvcrt.inc 
includelib \masm32\lib\msvcrt.lib           ;підключення бібліотеки msvcrt.lib
includelib \masm32\lib\fpu.lib              ;підключення бібліотеки fpu.lib
includelib \masm32\lib\masm32.lib           ;підключення бібліотеки masm32.lib
includelib \masm32\lib\gdi32.lib            ;підключення бібліотеки gdi32.lib
includelib \masm32\lib\user32.lib           ;підключення бібліотеки user32.lib
includelib \masm32\lib\kernel32.lib         ;підключення бібліотеки kernel32.lib

.data                                       ;директива визначення данних
_power DWORD 63.0
_root DWORD 100.0
_r DWORD 0.0                                ;оголошення змінної r
_const1 DWORD 0.63                          ;оголошення константи
borderLeft DWORD -1.0                       ;оголошення змінної borderLeft
borderRight DWORD 1.0                       ;оголошення змінної borderRight

_title db "Лабораторна робота №4",0         ;назва вікна повідомлення
strbuf dw ?,0
_text db "Бабіченко Анна ІН-101 ІІТЕ",10,
"y = 0.63^2 + z               z < -1 ", 10,
"y = tg(z)              -1 <= z <= 1", 10,
"y = (z + sqrt(z))^0.63 1  <  z", 10,
"Результат: "
_res db 10 DUP(0),10,13

MsgBoxCaption db "Результат порівняння",0 
MsgBoxText_1 db "z < -1",0 
MsgBoxText_2 db "-1 <= z <= 1", 0
MsgBoxText_3 db " z > 1", 0                 ;виведення на екран користувачу повідомлення про результат

.const 
NULL equ 0 
MB_OK equ 0 

.code                                       ;директива початку сегменту команд
_start:                                     ;мітка початку програми з іменем _start
main proc                                   ;директива proc
LOCAL _z: DWORD                             ;оголошення змінної z
mov _z, sval(input("Enter z: "))            ;виведення z для вибору користувача

finit                                       ;ініціалізація співпроцесора 
fild _z                                     ;завантаження z у верхівку стеку
fstp _z                                     ;збереження z з виштовхуванням з стеку
fld borderLeft                              ;завантаження змінної у верхівку стеку
fld _z                                      ;завантаження z у верхівку стеку, зміщення змінної у st(1)
fcompp                                      ;порівняння вершини стека з операндом
fstsw ax                                    ;записує значення слова стану fpu в регістр
sahf                                        ;запис вмісту регістра в регістр прапорів процесора 
jbe first                                   ;джамп 

fld borderRight                             ;записуємо змінну у верхівку стеку
fld _z                                      ;записуємо змінну z у верхівку стеку, попередня змінна в st(1)
fcompp                                      ;порівняння вершини стека з операндом
fstsw ax                                    ;записує значення слова стану fpu в регістр
sahf                                        ;запис вмісту регістра в регістр прапорів процесора
jbe second                                  ;джамп

fld _const1                                 ;st = 0.63
fld _z                                      ;st = z, st(1) = 0.63
fsqrt                                       ;st = sqrt(z)
fadd _z                                     ;st = sqrt(z) + z
fyl2x                                       ;st(1) *= log2(st)  st(1) = log2(sqrt(z) + z) * 0.63
fxtract                                     ;st = 1.11608, st(1) = log2(int)
fsub borderRight                            
f2xm1
fadd borderRight
fstp _r                                     ;_r = 2^0.011608 
fld borderRight
f2xm1
fadd borderRight
fmul _r

INVOKE MessageBoxA, NULL, ADDR MsgBoxText_3, ADDR MsgBoxCaption, MB_OK 
invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM
invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
invoke ExitProcess, 0
jmp lexit                                   ;переходимо на мітку exit (GOTO exit)


first:                                      ;мітка
fld _const1
fmul _const1
fadd _z

INVOKE MessageBoxA, NULL, ADDR MsgBoxText_1, ADDR MsgBoxCaption, MB_OK 
invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM
invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
invoke ExitProcess, 0

jmp lexit

second:
fld _z                                      ;занесення змінної у верхівці стеку
fld1
fptan                                       ;знаходження тангенсу
fxch st(1)

INVOKE MessageBoxA, NULL, ADDR MsgBoxText_2, ADDR MsgBoxCaption, MB_OK 
invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM
invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
invoke ExitProcess, 0

lexit:
ret
main endp
ret                                         ;повернення управління ОС
end _start                                  ;завершення програми з ім’ям _start
