unit getHint;

interface
uses types;
procedure GetHint (InputGrid : TIntegerGrid; var hint : TStringGrid);


implementation
uses auxiliary;

procedure GetHint (InputGrid : TIntegerGrid; var hint : TStringGrid);
var x, y, p, q, thisCellY, thisCellX, HintPos : integer;
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
                        thisCellY := 3 * (y div 3) + p;
                        thisCellX := 3 * (x div 3) + q;
                                    
                        if InputGrid[thisCellY, thisCellX] <> 0 then
                        begin
                            HintPos := pos(SBA_IntToStr(InputGrid[thisCellY, thisCellX]), hint[y, x]);
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

end.