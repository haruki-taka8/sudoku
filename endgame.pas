unit endgame;

interface
uses types;
function IsSolved (InputGrid : TIntegerGrid) : boolean;
function IsRepeated (InputGrid, InputOldGrid: TIntegerGrid) : boolean;


implementation

function IsSolved (InputGrid : TIntegerGrid) : boolean;
var x, y : integer;
    result : boolean;
begin
    // Returns a boolean indicating whether the board is solved

    result := true;
    for y := 0 to 8 do
        for x := 0 to 8 do
            if InputGrid[y, x] = 0 then
            begin
                result := false;
                break;
            end;
    IsSolved := result;
end;

function IsRepeated (InputGrid, InputOldGrid: TIntegerGrid) : boolean;
var x, y : integer;
    result : boolean;
begin
    // Returns a boolean indicating whether the two grids are identical
    
    result := true;
    for y := 0 to 8 do
        for x := 0 to 8 do
            if InputGrid[y, x] <> InputOldGrid[y, x] then
            begin
                result := false;
                break;
            end;
    IsRepeated := result;
end;

end.