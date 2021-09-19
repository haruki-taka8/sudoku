## Ideologies
**Treble**
* Inspired by Google's [Project Treble](https://source.android.com/devices/architecture), this program is broken into numerous submodules each containing procedures or functions.
It is possible to add/edit/remove code without having to change a large amount of underlying code.
<br>

**Verb-Noun**
* In align with [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands?view=powershell-7.1),
  most procedures and functions follow a `Verb-Noun` name convention.
<br>

**Casing-Scope**
* The casing of a variable denote the its scope
  * `UPPERCASE`: global constant (none in use)
  * `camelCase`: global variable
  * `PascalCase`: local variable
  * Metavariables such as `i`, `j`, `k` are always in lowercase.
<br>

## Each Submodule
For each module that attempts to solve the sudoku board, its interface exposes either or both procedures:

    procedure RemoveHint (var hint : TStringGrid);
    procedure SolveCell (var grid : TIntegerGrid; InputHint : TStringGrid);

The actual implementation (private) may include auxiliary function(s) that the main program needs not to know.

Other modules, depending on their needs, may list differently-named subroutines.
