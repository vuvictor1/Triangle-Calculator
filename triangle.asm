;********************************************************************************************
; Author Information:                                                                       *
; Name:         Victor V. Vu                                                                *
; Email:        vuvictor@csu.fullerton.edu                                                  * 
; Section:      Cpsc 240-07                                                                 *  
;                                                                                           *
; Program Information:                                                                      *
; Program Name: Triangle Calculator                                                         *
; Files: driver.cpp and triangle.asm                                                        *
; This File: triangle.asm                                                                   *
; Description: Called by driver to calculate missing side, perimeter and area.              *
;********************************************************************************************
; Copyright (C) 2022 Victor V. Vu                                                           *
; This program is free software: you can redistribute it and/or modify it under the terms   * 
; of the GNU General Public License version 3 as published by the Free Software Foundation. * 
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY  *
; without even the implied Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. * 
; See the GNU General Public License for more details. A copy of the GNU General Public     *
; License v3 is available here:  <https://www.gnu.org/licenses/>.                           *                                                                                          
;********************************************************************************************
; Programmed in Ubuntu-based Linux Platform.                                                *
; To run program, type in terminal: "sh r.sh"                                               *
*********************************************************************************************

extern printf ; Required, includes printf
extern scanf ; Required, includes scanf
extern sin ; Includes sin
extern cos ; Includes cos

global triangle ; Giving the function global scope so C++ can use

segment .data ; Indicates initialized data

welcome db "We take care of all your Triangles.", 10, 10, 0 ; 0 is the null terminator \0, 10 means newline \n

prompt db "Please enter your name: ", 0 ; prompt output

string_format db "%s", 0 ; format_specifier for strings, creates an array of characters

name_output db 10, "Good morning %s, please enter the length of side 1, length of side 2, and size(degrees) of the included angle between them as real float nuumbers. Separate the numbers by white"
            db " space, and be sure to press <enter> after the last inputted number.", 10, 10, 0 ; text output

three_float_format db "%lf %lf %lf", 0 ; format for 64 bit float

float_output db 10, "Thank you %s. You entered %lf %lf %lf", 10, 10, 0

ap_out db "The area of your triangle is %lf square units", 10, 10,
       db "The perimeter is %.3lf linear units.", 10, 10, 0

return db "The area will now be sent to the driver function.", 10, 10, 0

error db "Unfortunately, one of your inputs is invalid. Please run this program again.", 10, 10, 0

pi: dq 0x400921FB54442D18 ; stores value of pi 3.14

segment .bss ;Indicates values that require user input

user_name: resb 64 ; resserving bytes for user_name
perimeter: resq 1 ; reserves 1 qword for perimeter
area: resq 1 ; same as perimter but for area

segment .text ; stores executable code

triangle: ; essentially the same as int main() {} <--- enters program

; Required 15 pushes and pops for assembly program to run
push       rbp             ;Save a copy of the stack base pointer
mov        rbp, rsp        ;Needed to ensure compatibility with C and C++.
push       rbx             ;Back up rbx
push       rcx             ;Back up rcx
push       rdx             ;Back up rdx
push       rsi             ;Back up rsi
push       rdi             ;Back up rdi
push       r8              ;Back up r8
push       r9              ;Back up r9
push       r10             ;Back up r10
push       r11             ;Back up r11
push       r12             ;Back up r12
push       r13             ;Back up r13
push       r14             ;Back up r14
push       r15             ;Back up r15
pushf                      ;Back up rflags
;--------------------------------------------

; Printf block for welcome message
mov rax, 0 ; tells not to print float
mov rdi, welcome ; passes intro
call printf ; call function to print

mov rax, 0
mov rdi, prompt ; print prompt
call printf

; Scanf block to take input
mov rax, 0
mov rdi, string_format ; passes format specifiier
mov rsi, user_name ; stores input
call scanf ; scan for user input

mov rax, 0
mov rdi, name_output ; passes output message
mov rsi, user_name ; uses data from username
call printf ; prints out output

; Section to take 3 float inputs and print
; setting up the input for a 64 bit float
mov rdi, three_float_format ; move float format into first parameter register // rdi = "%lf %lf %lf"
mov rsi, rsp ; <- second arg register now points to top of stack
mov rdx, rsp
add rdx, qword 8 ; rdx points to second qword
mov rcx, rsp
add rcx, qword 16 ; rcx points to third qword
call scanf ; scanf("%lf %lf %lf", rsp, rsp + 8, rsp + 16);

movsd xmm15, [rsp+0] ; dereference the data at the top of stack, store in xmm15
movsd xmm14, [rsp+8]
movsd xmm13, [rsp+16] ; dereference the data at the bottom of stack store in xmm13

mov rax, 3 ; move 3 into rax, code expects 3 floats
mov rdi, float_output ;output float
mov rsi, user_name ; output username
movsd xmm0, xmm15 ; copy the value in xmm15 to xmm0
movsd xmm1, xmm14 ; copy xxmm14 to xmm1
movsd xmm2, xmm13 ; copy degrees to xmm2
call printf

; Moves rax into xmm12
mov rax, 0
cvtsi2sd xmm12, rax ; Make xmm12 0

ucomisd xmm15, xmm12 ; Compare A to zero
jb on_error ; If A is less than 0 jump

ucomisd xmm14, xmm12
jb on_error

ucomisd xmm13, xmm12
jb on_error

; Math Portion
; convert xmm13 into radians
movsd xmm12, [pi] ; copy pi into xmm12
mov rax, 180 ; targets number 180
cvtsi2sd xmm11, rax ; convert 180 to float
divsd xmm12, xmm11 ; xmm12 = pi/180
mulsd xmm13, xmm12 ; mutilply degrees with xmm12

; Perimiter calculations
; Find the missing side (C) = sqrt(A^2 + B^2 - 2AB*cos(x))
; xmm15 = A, xmm14 = B, and xmm13 = angle (rad)
mov rax, 2 ; move 2 into rax, expect 2 float
cvtsi2sd xmm12, rax ; converts int 2 to floats
mulsd xmm12, xmm15 ; mutiplies side 1 to pi
mulsd xmm12, xmm14 ; mutiplies side 1 and 2 to pi

movsd xmm11, xmm15 ; copy side 1 to xmm11
mulsd xmm11, xmm11 ; multiply xmm11 to itself = (side1)^2

movsd xmm10, xmm14 ; copy side 2 to xmm10
mulsd xmm10, xmm10 ; xmm10 = B^2

; call cos(x)
movsd xmm0, xmm13
call cos ; xmm0 = cos(x)

mov rax, 1
cvtsi2sd xmm9, rax ; convert int xmm9 to float
mulsd xmm9, xmm12 ; xmm9 = -2AB
mulsd xmm9, xmm0 ; xmm9 = -2AB*cos(x)
addsd xmm9, xmm10
addsd xmm9, xmm11 ; xmm9 = A^2 + B^2 - 2AB*cos(x)
sqrtsd xmm9, xmm9 ; xmm9 = missing side (C)

; add all sides to complete permiter
addsd xmm9, xmm15 ; C + A
addsd xmm9, xmm14 ; C + A + B

movsd [perimeter], xmm9 ; store value of perimeter

; Area calculation = = [A*B*sin(x)]/2
; xmm15 = A, xmm14 = B, and xmm13 = angle (rad)

; calling sin function
movsd xmm0, xmm13
call sin ; xmm0 = sin(x)

; Complete area formula
movsd xmm12, xmm0 ; store sin in xmm12
mulsd xmm12, xmm15 ; multiply by A
mulsd xmm12, xmm14 ; mutliply b B
mov rax, 2
cvtsi2sd xmm11, rax ; convert int to float
divsd xmm12, xmm11 ; Divide by PI
movsd [area], xmm12 ; Store area

; Output answer
mov rax, 2
movsd xmm0, [area]
movsd xmm1, [perimeter]
mov rdi, ap_out
call printf

jmp if_code_good ; If code is good move on

on_error:
mov rax, 0
mov rdi, error
call printf
movsd xmm0, xmm12 ; return 0
jmp end_of_code ; If code is bad jump to end

if_code_good: ;Code is good continue
movsd xmm0, [area] ; return area to driver

end_of_code: ; After jumping program reaches end

; Backs up 15 pushes and pop, required for assembly program
popf         ;Restore rflags
pop rbx      ;Restore rbx
pop r15      ;Restore r15
pop r14      ;Restore r14
pop r13      ;Restore r13
pop r12      ;Restore r12
pop r11       ;Restore r11
pop r10      ;Restore r10
pop r9       ;Restore r9
pop r8       ;Restore r8
pop rcx      ;Restore rcx
pop rdx      ;Restore rdx
pop rsi      ;Restore rsi
pop rdi      ;Restore rdi
pop rbp      ;Restore rbp

ret ; return statemnt
