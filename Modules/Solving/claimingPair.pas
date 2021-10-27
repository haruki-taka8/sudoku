unit ClaimingPair;

interface
uses io, types, auxiliary;
function RemoveHint (var hint : TStringGrid) : boolean;


implementation

function RemoveHint (var hint : TStringGrid) : boolean;
var y, x, p, q, r, s, LeftX, LeftY : integer;
    SubgridTotal, Total : integer;
    HasRemoved, HasEverRemoved : boolean;

begin
    HasEverRemoved := false;
    for y := 0 to 8 do
        for x := 0 to 8 do
            for p := 1 to 9 do
                if pos(SBA_IntToStr(p), hint[y, x]) <> 0 then
                begin
                    // Row
                    HasRemoved := false;
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
                    begin
                        for s := LeftY to LeftY+2 do
                            for r := LeftX to LeftX+2 do
                                if (s <> y) and (pos(SBA_IntToStr(p), hint[s, r]) <> 0) then
                                begin
                                    hint[s, r] := SBA_RemoveAt(hint[s, r], pos(SBA_IntToStr(p), hint[s, r]));
                                    HasRemoved := true;
                                    HasEverRemoved := true;
                                    
                                end;

                        if HasRemoved then
                            WriteStepHint(fileHandler, y, x, 'Claiming Pair', '-['+SBA_IntToStr(p)+'] for sub '+SBA_IntToStr(3*(y div 3)+(x div 3))+' due to row '+SBA_IntToStr(y));
                    end;

                    // Column
                    HasRemoved := false;
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
                    begin
                        for s := LeftY to LeftY+2 do
                            for r := LeftX to LeftX+2 do
                                if (r <> x) and (pos(SBA_IntToStr(p), hint[s, r]) <> 0) then
                                begin
                                    hint[s, r] := SBA_RemoveAt(hint[s, r], pos(SBA_IntToStr(p), hint[s, r]));
                                    HasRemoved := true;
                                    HasEverRemoved := true;
                                end;

                        if HasRemoved then
                            WriteStepHint(fileHandler, y, x, 'Claiming Pair', '-['+SBA_IntToStr(p)+'] for sub '+SBA_IntToStr(3*(y div 3)+(x div 3))+' due to col '+SBA_IntToStr(x));
                    end;
                end;

    RemoveHint := HasEverRemoved;
end;

end.