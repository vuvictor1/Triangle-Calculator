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
*/
#include <cstdio> // Required header
#include <iostream>
#include <iomanip>

extern "C" double triangle(); //includes triangle as an external function

int main() {
  printf("\nWelcome to Amazing Triangles programmed by Victor V. Vu on January 29, 2022.\n\n");

  double area_returned = triangle(); //Data is being returned from the assembly file

  std::cout << "The driver received this number, " << std::fixed << std::setprecision(9) << area_returned << " and will simply keep it. " << std::endl;

  std::cout << std::endl;

  std::cout << "An integer zero will now be sent to the operating system. Have a good day. Bye" << std::endl;

  return 0;
}
