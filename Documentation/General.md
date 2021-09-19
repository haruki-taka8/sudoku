## About This Program
This program solves unfinished Sudoku boards using a number of mostly simple methods. It accepts input in different formats and can optionally output the results in a themed fashion.

It is only tested on Windows 10, although it should work fine on other operating systems as well.
<br><br>

## Repository Structure

    ├───.vscode                  IDE/FPC-related settings
    │
    ├───Modules
    │   ├───General              Uncategorized code
    │   └───Solving              Code that modifies the Sudoku board
    │
    └───Tests                    Simple & intermediate unfilled Sudoku boards
 <br>
 
## Development & Building
For original development, Visual Studio Code and Free Pascal on Windows 10 are used. Building with other compilers and/or on other systems may also work, but not guaranteed.
The command for compiling is:

    fpc.exe sudoku.pas
    

A complimentary `cleanup.ps1` Powershell script is provided to remove any `.ppu` and `.o` files within the working directory. There is a plan to add a `cleanup.sh` bash script for Linux users.
