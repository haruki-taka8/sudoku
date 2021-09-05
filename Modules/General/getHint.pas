unit getHint;

interface
uses types;
procedure GetHint (InputGrid : TIntegerGrid; var hint : TStringGrid);
procedure RemoveSolved (InputGrid : TIntegerGrid; var hint : TStringGrid);


implementation
uses auxiliary;

procedure GetHint (InputGrid : TIntegerGrid; var hint : TStringGrid);
var x, y, p, q, ThisY, ThisX, HintPos : integer;
begin
    // Returns a TStringGrid of hints given a TIntegerGrid

    // Defaults
    for y := 0 to 8 do
        for x := 0 to 8 do
            hint[y, x] := '123456789';

    for y := 0 to 8 do
        for x := 0 to 8 do
            if InputGrid[y, x] = 0 then
            begin
                // Elimination: Subgrid
                for p := 0 to 2 do
                    for q := 0 to 2 do
                    begin
                        ThisY := 3 * (y div 3) + p;
                        ThisX := 3 * (x div 3) + q;
                                    
                        if InputGrid[ThisY, ThisX] <> 0 then
                        begin
                            HintPos := pos(SBA_IntToStr(InputGrid[ThisY, ThisX]), hint[y, x]);
                            if HintPos <> 0 then hint[y, x] := SBA_RemoveAt(hint[y, x], HintPos);
                        end;
                    end;
                    
                // Elimination: Column
                for p := 0 to 8 do
                    if InputGrid[p, x] <> 0 then
                    begin
                        HintPos := pos(SBA_IntToStr(InputGrid[p, x]), hint[y, x]);
                        if HintPos <> 0 then hint[y, x] := SBA_RemoveAt(hint[y, x], HintPos);
                    end;
                            
                // Elimination: Row
                for p := 0 to 8 do
                    if InputGrid[y, p] <> 0 then
                    begin
                        HintPos := pos(SBA_IntToStr(InputGrid[y, p]), hint[y, x]);
                        if HintPos <> 0 then hint[y, x] := SBA_RemoveAt(hint[y, x], HintPos);
                    end;
            end
            else
                hint[y, x] := '';
end;


procedure RemoveSolved (InputGrid : TIntegerGrid; var hint : TStringGrid);
var p, q, x, y, ThisX, ThisY : integer;
begin
    for y := 0 to 8 do
        for x := 0 to 8 do
            if InputGrid[y, x] <> 0 then
            begin
                // Set cell empty
                hint[y, x] := '';

                // Remove InputGrid[y, x] from row
                for p := 0 to 8 do
                    if pos(SBA_IntToStr(InputGrid[y, x]), hint[y, p]) <> 0 then
                        hint[y, p] := SBA_RemoveAt(hint[y, p], pos(SBA_IntToStr(InputGrid[y, x]), hint[y, p]));
                    
                // Remove InputGrid[y, x] from column
                for p := 0 to 8 do
                    if pos(SBA_IntToStr(InputGrid[y, x]), hint[p, x]) <> 0 then
                        hint[p, x] := SBA_RemoveAt(hint[p, x], pos(SBA_IntToStr(InputGrid[y, x]), hint[p, x]));

                // Remove InputGrid[y, x] from subgrid/block
                for q := 0 to 2 do
                    for p := 0 to 2 do
                    begin
                        ThisX := 3*(x div 3) + p;
                        ThisY := 3*(y div 3) + q;
                        
                        if pos(SBA_IntToStr(InputGrid[y, x]), hint[ThisY, ThisX]) <> 0 then
                            hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(SBA_IntToStr(InputGrid[y, x]), hint[ThisY, ThisX]));
                    end;
            end;
end;

end.