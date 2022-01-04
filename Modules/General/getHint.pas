unit getHint;

interface
uses types, auxiliary, sysutils;
procedure GetHint (InputGrid : TIntegerGrid; var hint : TStringGrid);
function RemoveSolved (InputGrid : TIntegerGrid; var hint : TStringGrid) : boolean;

implementation
procedure GetHint (InputGrid : TIntegerGrid; var hint : TStringGrid);
var x, y, p, q, LeftX, LeftY : integer;
begin
    // Returns a TStringGrid of hints given a TIntegerGrid
    for y := 0 to 8 do
        for x := 0 to 8 do
            if InputGrid[y, x] = 0 then
            begin
                hint[y, x] := '123456789';

                // Elimination: Subgrid
                LeftY := 3*(y div 3);
                LeftX := 3*(x div 3);
                for p := LeftY to LeftY+2 do
                    for q := LeftX to LeftX+2 do                
                        hint[y, x] := RemoveAt(hint[y, x], pos(IntToStr(InputGrid[p, q]), hint[y, x]));
                    
                // Elimination: column & row
                for p := 0 to 8 do
                begin
                    hint[y, x] := RemoveAt(hint[y, x], pos(IntToStr(InputGrid[p, x]), hint[y, x]));
                    hint[y, x] := RemoveAt(hint[y, x], pos(IntToStr(InputGrid[y, p]), hint[y, x]));
                end;
            end
            else
                hint[y, x] := '';
end;

function RemoveSolved (InputGrid : TIntegerGrid; var hint : TStringGrid) : boolean;
var p, q, x, y, LeftX, LeftY : integer;
    Old1, Old2 : string[9];
    HasRemoved : boolean;
begin
    HasRemoved := false;
    for y := 0 to 8 do
        for x := 0 to 8 do
            if InputGrid[y, x] <> 0 then
            begin
                // Set cell empty
                hint[y, x] := '';

                // Remove InputGrid[y, x] from column & row
                for p := 0 to 8 do
                begin
                    Old1 := hint[y, p];
                    Old2 := hint[p, x];

                    hint[y, p] := RemoveAt(hint[y, p], pos(IntToStr(InputGrid[y, x]), hint[y, p]));
                    hint[p, x] := RemoveAt(hint[p, x], pos(IntToStr(InputGrid[y, x]), hint[p, x]));

                    if (hint[y, p] <> Old1) or (hint[p, x] <> Old2) then
                        HasRemoved := true;
                end;

                // Remove InputGrid[y, x] from subgrid/block
                LeftY := 3*(y div 3);
                LeftX := 3*(x div 3);
                for q := LeftY to LeftY+2 do
                    for p := LeftX to LeftX+2 do
                    begin
                        Old1 := hint[q, p];
                        hint[q, p] := RemoveAt(hint[q, p], pos(IntToStr(InputGrid[y, x]), hint[q, p]));

                        if (hint[q, p] <> Old1) then
                            HasRemoved := true;
                    end;
            end;

    RemoveSolved := HasRemoved;
end;

end.
