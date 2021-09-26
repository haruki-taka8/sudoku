unit getHint;

interface
uses types;
procedure GetHint (InputGrid : TIntegerGrid; var hint : TStringGrid);
procedure RemoveSolved (InputGrid : TIntegerGrid; var hint : TStringGrid);


implementation
uses auxiliary;

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
                        hint[y, x] := SBA_RemoveAt(hint[y, x], pos(SBA_IntToStr(InputGrid[p, q]), hint[y, x]));
                    
                // Elimination: column & row
                for p := 0 to 8 do
                begin
                    hint[y, x] := SBA_RemoveAt(hint[y, x], pos(SBA_IntToStr(InputGrid[p, x]), hint[y, x]));
                    hint[y, x] := SBA_RemoveAt(hint[y, x], pos(SBA_IntToStr(InputGrid[y, p]), hint[y, x]));
                end;
            end
            else
                hint[y, x] := '';
end;


procedure RemoveSolved (InputGrid : TIntegerGrid; var hint : TStringGrid);
var p, q, x, y, LeftX, LeftY : integer;
begin
    for y := 0 to 8 do
        for x := 0 to 8 do
            if InputGrid[y, x] <> 0 then
            begin
                // Set cell empty
                hint[y, x] := '';

                // Remove InputGrid[y, x] from column & row
                for p := 0 to 8 do
                begin
                    hint[y, p] := SBA_RemoveAt(hint[y, p], pos(SBA_IntToStr(InputGrid[y, x]), hint[y, p]));
                    hint[p, x] := SBA_RemoveAt(hint[p, x], pos(SBA_IntToStr(InputGrid[y, x]), hint[p, x]));
                end;

                // Remove InputGrid[y, x] from subgrid/block
                LeftY := 3*(y div 3);
                LeftX := 3*(x div 3);
                for q := LeftY to LeftY+2 do
                    for p := LeftX to LeftX+2 do
                        hint[q, p] := SBA_RemoveAt(hint[q, p], pos(SBA_IntToStr(InputGrid[y, x]), hint[q, p]));
            end;
end;

end.