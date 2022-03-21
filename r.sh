#!/bin/bash

#Line above is required for every bash file
#Other lines starting with # are comments

#Author: Victor V. Vu 
#Section: Cpsc 240-07                                                                
#Descrption: BASH compilation file

#Removes old files when we create a new compilation
rm *.o
rm *.out

#Echo works the same way Cout does
echo "Compiling files..."

#Compiles the assembly code
nasm -f elf64 -o triangle.o triangle.asm

#Compiles the C++ code
g++ -c -m64 -std=c++17 -fno-pie -no-pie -o driver.o driver.cpp

#Link the 'O' files together
g++ -m64 -std=c++17 -fno-pie -no-pie -o object_file_compiled.out triangle.o driver.o

#Another echo that couts
echo "Compilation successful! Running Program"

#Runs the file object_file_compiled.out
./object_file_compiled.out
