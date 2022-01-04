unit pointingPairTriple;

interface
uses types, auxiliary, io, sysutils;
function RemoveHint (var hint : TStringGrid) : boolean;

implementation
function RemoveHint (var hint : TStringGrid) : boolean;
var x, y, p, r, s, LeftX, LeftY : integer;
    CountInAlign, CountInSubgrid : integer;
    HasRemoved, HasEverRemoved : boolean;
    RemoveMode : string;

begin
    HasEverRemoved := false;
    for y := 0 to 8 do
        for x := 0 to 8 do
            for p := 1 to 9 do
            begin
                // Columns
                CountInAlign := 0;
                CountInSubgrid := 0;
                HasRemoved := false;
                LeftX := 3*(x div 3);
                LeftY := 3*(y div 3);

                // For top to bottom of subgrid
                for r := LeftY to LeftY+2 do
                    if pos(IntToStr(p), hint[r, x]) <> 0 then
                        CountInAlign := CountInAlign + 1;
                
                // Total count of P, CountInSubgrid in subgrid (must be equal to CountInAlign)
                for r := LeftY to LeftY+2 do
                    for s := LeftX to LeftX+2 do
                        if pos(IntToStr(p), hint[r, s]) <> 0 then
                            CountInSubgrid := CountInSubgrid + 1;

                if (CountInAlign = CountInSubgrid) and ((CountInAlign = 2) or (CountInAlign = 3)) then
                begin
                    // Remove from the same column except within the subgrid
                    // Pointing
                    for r := 0 to 8 do
                        if ((y div 3) <> (r div 3)) and (pos(IntToStr(p), hint[r, x]) <> 0) then
                        begin
                            hint[r, x] := RemoveAt(hint[r, x], pos(IntToStr(p), hint[r, x]));
                            HasRemoved := true;
                            HasEverRemoved := true;
                        end;

                        if CountInAlign = 2 then
                            RemoveMode := 'Pair'
                        else
                            RemoveMode := 'Triple';

                        if HasRemoved then
                            WriteStepHint(fileHandler, y, x, 'Pointing '+RemoveMode, '-['+IntToStr(p)+'] for col '+IntToStr(y)+' due to sub '+IntToStr(3*(y div 3)+(x div 3)));
                end;

                // Rows
                CountInAlign := 0;
                CountInSubgrid := 0;
                HasRemoved := false;
                LeftX := 3*(x div 3);
                LeftY := 3*(y div 3);

                // For left end to right end of subgrid
                for r := LeftX to LeftX+2 do
                    if pos(IntToStr(p), hint[y, r]) <> 0 then
                        CountInAlign := CountInAlign + 1;

                // Total count of P, CountInSubgrid in subgrid (must be equal to CountInAlign)
                for r := LeftY to LeftY+2 do
                    for s := LeftX to LeftX+2 do
                        if pos(IntToStr(p), hint[r, s]) <> 0 then
                            CountInSubgrid := CountInSubgrid + 1;

                if (CountInAlign = CountInSubgrid) and ((CountInAlign = 2) or (CountInAlign = 3)) then
                begin
                    // Remove from the same row except within the subgrid
                    // Pointing
                    for r := 0 to 8 do
                        if ((x div 3) <> (r div 3)) and (pos(IntToStr(p), hint[y, r]) <> 0) then
                        begin
                            hint[y, r] := RemoveAt(hint[y, r], pos(IntToStr(p), hint[y, r]));
                            HasRemoved := true;
                            HasEverRemoved := true;
                        end;
                    
                    if CountInAlign = 2 then
                        RemoveMode := 'Pair'
                    else
                        RemoveMode := 'Triple';

                    if HasRemoved then
                        WriteStepHint(fileHandler, y, x, 'Pointing '+RemoveMode, '-['+IntToStr(p)+'] for row '+IntToStr(x)+' due to sub '+IntToStr(3*(y div 3)+(x div 3)));
                end;

            end;

    RemoveHint := HasEverRemoved;
end;

end.
