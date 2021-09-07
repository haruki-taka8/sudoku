unit ClaimingPair;

interface
uses io, types, auxiliary;
procedure RemoveHint (var hint : TStringGrid);


implementation

procedure RemoveHint (var hint : TStringGrid);
var y, x, p, q, r, s, LeftX, LeftY : integer;
    SubgridTotal, Total : integer;

begin
    for y := 0 to 8 do
        for x := 0 to 8 do
            for p := 1 to 9 do
                if pos(SBA_IntToStr(p), hint[y, x]) <> 0 then
                begin
                    // Row
                    SubgridTotal := 0;
                    Total := 0;
                    LeftX := 3*(x div 3);
                    LeftY := 3*(y div 3);

                    for q := LeftX to LeftX+2 do
                        if pos(SBA_IntToStr(p), hint[y, q]) <> 0 then
                            SubgridTotal := SubgridTotal + 1;
                    
                    for q := 0 to 8 do
                        if pos(SBA_IntToStr(p), hint[y, q]) <> 0 then
                            Total := Total + 1;

                    // IF there are no number P outside of subgrid and in row X
                    // Remove from subgrid
                    if (Total = 2) and (SubgridTotal = 2) then
                        for s := LeftY to LeftY+2 do
                            for r := LeftX to LeftX+2 do
                                if (s <> y) and (pos(SBA_IntToStr(p), hint[s, r]) <> 0) then
                                begin
                                    hint[s, r] := SBA_RemoveAt(hint[s, r], pos(SBA_IntToStr(p), hint[s, r]));

                                    if VERBOSE then
                                        writeln('Remove ', p, ' from (', s, ',', r, ') based on row ', y ,' by locked candidates, row-sub claiming');
                                end;

                    // Column
                    SubgridTotal := 0;
                    Total := 0;
                    LeftX := 3*(x div 3);
                    LeftY := 3*(y div 3);

                    for q := LeftY to LeftY+2 do
                        if pos(SBA_IntToStr(p), hint[q, x]) <> 0 then
                            SubgridTotal := SubgridTotal + 1;
                    
                    for q := 0 to 8 do
                        if pos(SBA_IntToStr(p), hint[q, x]) <> 0 then
                            Total := Total + 1;

                    // IF there are no number P outside of subgrid and in row X
                    // Remove from subgrid
                    if (Total = 2) and (SubgridTotal = 2) then
                        for s := LeftY to LeftY+2 do
                            for r := LeftX to LeftX+2 do
                                if (r <> x) and (pos(SBA_IntToStr(p), hint[s, r]) <> 0) then
                                begin
                                    hint[s, r] := SBA_RemoveAt(hint[s, r], pos(SBA_IntToStr(p), hint[s, r]));

                                    if VERBOSE then
                                        writeln('Remove ', p, ' from (', s, ',', r, ') based on col ', x ,' by locked candidates, col-sub claiming');
                                end;
                end;
end;

end.