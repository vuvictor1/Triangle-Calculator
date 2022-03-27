/*
;********************************************************************************************
; Author Information:                                                                       *
; Name:         Victor V. Vu                                                                *
; Email:        vuvictor@csu.fullerton.edu                                                  *
; Section:      Cpsc 240-07                                                                 *  
;                                                                                           *
; Program Information:                                                                      *
; Program Name: Triangle Calculator                                                         *
; Files: driver.cpp and triangle.asm                                                        *
; This File: driver.cpp                                                                     *
; Description: Main file that outputs text, calls triangle function for math computations.  *
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
*/
#include <cstdio> // Required header
#include <iostream> // header for cout function
#include <iomanip> // header to set decimal precision

extern "C" double triangle(); //includes triangle as an external function

int main() {
  printf("\nWelcome to Amazing Triangles programmed by Victor V. Vu on January 29, 2022.\n\n");

  double area_returned = triangle(); //Data is being returned from the assembly file

  std::cout << "The driver received this number, " << std::fixed << std::setprecision(9) << area_returned << " and will simply keep it. " << std::endl;

  std::cout << std::endl;

  std::cout << "An integer zero will now be sent to the operating system. Have a good day. Bye" << std::endl;

  return 0;
}
