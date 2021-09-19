unit nakedSingle;

interface
uses types, auxiliary, io;
procedure SolveCell (var grid : TIntegerGrid; InputHint : TStringGrid);

// Naked single = cell with only one hint

implementation

procedure SolveCell (var grid : TIntegerGrid; InputHint : TStringGrid);
var x, y : integer;
begin
    for y := 0 to 8 do
        for x := 0 to 8 do
            if length(InputHint[y, x]) = 1 then
            begin
                grid[y, x] := SBA_StrToInt(InputHint[y, x]);
                WriteStepCell(fileHandler, y, x, grid[y, x], 'Naked  Single', '');
            end;
end;

end.