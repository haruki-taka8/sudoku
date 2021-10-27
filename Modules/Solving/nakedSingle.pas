unit nakedSingle;

interface
uses types, auxiliary, io;
function SolveCell (var grid : TIntegerGrid; InputHint : TStringGrid) : boolean;

// Naked single = cell with only one hint

implementation

function SolveCell (var grid : TIntegerGrid; InputHint : TStringGrid) : boolean;
var x, y : integer;
    HasSolved : boolean;
begin
    HasSolved := false;
    for y := 0 to 8 do
        for x := 0 to 8 do
            if length(InputHint[y, x]) = 1 then
            begin
                grid[y, x] := SBA_StrToInt(InputHint[y, x]);
                WriteStepCell(fileHandler, y, x, grid[y, x], 'Naked  Single', '');
                HasSolved := true;
            end;

    SolveCell := HasSolved;
end;

end.