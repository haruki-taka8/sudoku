## 📍 About
Sudoku solver in Pascal. The program will attempt to solve a user-provided sudoku board. It can also log all actions and the resultant board to an external file.

Sorry, the code is horrifying, I know. The design principal was to get the algroithms working, rather than to make them clean and sustainable. Attempting to improve the code may only lead to more frustration than you have now.
<br>

## 🧪 Algorithms
<table>
  <tr>
    <td><b>Naked</b></td>
    <td><b>Hidden</b></td>
    <td><b>Intersections</b></td>
    <td><b>Wings</b></td>
    <td><b>Fish</b></td>
  </tr>
  <tr>
    <td>Naked single</td>
    <td>Hidden single</td>
    <td>Pointing pair</td>
    <td>XY-Wing</td>
    <td>X-Wing</td>
  </tr>
  <tr>
    <td>Naked pair</td>
    <td>Hidden pair</td>
    <td>Pointing triple</td>
    <td>XYZ-Wing</td>
    <td>Swordfish</td>
  </tr>
  <tr>
    <td>Naked triple</td>
    <td>Hidden triple</td>
    <td>Claiming pair</td>
    <td></td>
    <td>Jellyfish</td>
  </tr>
  <tr>
    <td>Naked quad</td>
    <td>Hidden quad</td>
    <td>Visual elimination</td>
    <td></td>
    <td></td>
  </tr>
</table>
<br>

## 💡 Execution Instructions
Command-line:
* Run `launcher.ps1`; or
* Run `sudoku.exe` in a terminal; or
* provide arguments: `sudoku.exe VERBOSE THEME INTERACTIVE SUDOKUGRID`
<br>

GUI Demo (Windows-only):
* Run `GUI\GUI_launcher.ps1`
<br>

## 🖊️ Build Instructions
Compile `sudoku.pas` with a compiler of your choice. The official Windows binary is built with [FPC](https://www.freepascal.org/). Tested on Windows 7, 10 and 11.

The GUI demo is made with Powershell and WPF. It is Windows-only. Tested on Windows 7, 10 and 11.
