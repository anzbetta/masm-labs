.486                                        ;��������� ���������� ���� �������������
.model flat, stdcall                        ;���������� ����� ����� �����
option casemap :none                        ;��������� ��������� �� �������� �������

include \masm32\include\windows.inc         ;���������� ����������� ����� windows.inc
include \masm32\macros\macros.asm           ;MASM support macros
include \masm32\include\masm32.inc          ;���������� ����������� ����� masm.inc
include \masm32\include\gdi32.inc           ;���������� ����������� ����� gdi32.inc
include \masm32\include\fpu.inc             ;���������� ����������� ����� fpu.inc
include \masm32\include\user32.inc          ;���������� ����������� ����� user32.inc
include \masm32\include\kernel32.inc        ;���������� ����������� ����� kernel32.inc
include \masm32\include\msvcrt.inc          ;���������� ����������� ����� msvcrt.inc 
includelib \masm32\lib\msvcrt.lib           ;���������� �������� msvcrt.lib
includelib \masm32\lib\fpu.lib              ;���������� �������� fpu.lib
includelib \masm32\lib\masm32.lib           ;���������� �������� masm32.lib
includelib \masm32\lib\gdi32.lib            ;���������� �������� gdi32.lib
includelib \masm32\lib\user32.lib           ;���������� �������� user32.lib
includelib \masm32\lib\kernel32.lib         ;���������� �������� kernel32.lib

.data                                       ;��������� ���������� ������
_power DWORD 63.0
_root DWORD 100.0
_r DWORD 0.0                                ;���������� ����� r
_const1 DWORD 0.63                          ;���������� ���������
borderLeft DWORD -1.0                       ;���������� ����� borderLeft
borderRight DWORD 1.0                       ;���������� ����� borderRight

_title db "����������� ������ �4",0         ;����� ���� �����������
strbuf dw ?,0
_text db "�������� ���� ��-101 ����",10,
"y = 0.63^2 + z               z < -1 ", 10,
"y = tg(z)              -1 <= z <= 1", 10,
"y = (z + sqrt(z))^0.63 1  <  z", 10,
"���������: "
_res db 10 DUP(0),10,13

MsgBoxCaption db "��������� ���������",0 
MsgBoxText_1 db "z < -1",0 
MsgBoxText_2 db "-1 <= z <= 1", 0
MsgBoxText_3 db " z > 1", 0                 ;��������� �� ����� ����������� ����������� ��� ���������

.const 
NULL equ 0 
MB_OK equ 0 

.code                                       ;��������� ������� �������� ������
_start:                                     ;���� ������� �������� � ������ _start
main proc                                   ;��������� proc
LOCAL _z: DWORD                             ;���������� ����� z
mov _z, sval(input("Enter z: "))            ;��������� z ��� ������ �����������

finit                                       ;����������� ������������ 
fild _z                                     ;������������ z � �������� �����
fstp _z                                     ;���������� z � �������������� � �����
fld borderLeft                              ;������������ ����� � �������� �����
fld _z                                      ;������������ z � �������� �����, ������� ����� � st(1)
fcompp                                      ;��������� ������� ����� � ���������
fstsw ax                                    ;������ �������� ����� ����� fpu � ������
sahf                                        ;����� ����� ������� � ������ ������� ��������� 
jbe first                                   ;����� 

fld borderRight                             ;�������� ����� � �������� �����
fld _z                                      ;�������� ����� z � �������� �����, ��������� ����� � st(1)
fcompp                                      ;��������� ������� ����� � ���������
fstsw ax                                    ;������ �������� ����� ����� fpu � ������
sahf                                        ;����� ����� ������� � ������ ������� ���������
jbe second                                  ;�����

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
jmp lexit                                   ;���������� �� ���� exit (GOTO exit)


first:                                      ;����
fld _const1
fmul _const1
fadd _z

INVOKE MessageBoxA, NULL, ADDR MsgBoxText_1, ADDR MsgBoxCaption, MB_OK 
invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM
invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
invoke ExitProcess, 0

jmp lexit

second:
fld _z                                      ;��������� ����� � �������� �����
fld1
fptan                                       ;����������� ��������
fxch st(1)

INVOKE MessageBoxA, NULL, ADDR MsgBoxText_2, ADDR MsgBoxCaption, MB_OK 
invoke FpuFLtoA, 0, 10, ADDR _res, SRC1_FPU or SRC2_DIMM
invoke MessageBox, 0, offset _text, offset _title, MB_ICONINFORMATION
invoke ExitProcess, 0

lexit:
ret
main endp
ret                                         ;���������� ��������� ��
end _start                                  ;���������� �������� � ���� _start
