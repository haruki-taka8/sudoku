## About auxiliary.pas.md
**auxiliary.pas** hosts three functions oftenly used and inconveniently long to repeat every few lines.
It can be considered a subset of the `sysUtils` module. As a result, the entire program takes up less space.

## Details
It exposes the following functions:

    function SBA_RemoveAt (Input : string; Position : integer) : string;
    function SBA_StrToInt (Input : string) : integer;
    function SBA_IntToStr (Input : integer) : string;
    
**`SBA_RemoveAt`**
* Removes one character from the provided string
* The position parameter is 1-based.
