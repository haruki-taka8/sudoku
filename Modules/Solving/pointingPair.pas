unit pointingPair;

interface
uses types, auxiliary, io;
procedure RemoveHint (var hint : TStringGrid);

implementation
procedure RemoveHint (var hint: TStringGrid);
var x, y, p, r, s, LeftX, LeftY : integer;
    CountInAlign, CountInSubgrid : integer;
begin
    for y := 0 to 8 do
        for x := 0 to 8 do
            for p := 1 to 9 do
            begin
                // Columns
                CountInAlign := 0;
                CountInSubgrid := 0;
                LeftX := 3*(x div 3);
                LeftY := 3*(y div 3);

                // For top to bottom of subgrid
                for r := LeftY to LeftY+2 do
                    if pos(SBA_IntToStr(p), hint[r, x]) <> 0 then
                        CountInAlign := CountInAlign + 1;
                
                // Total count of P, CountInSubgrid in subgrid (must be equal to CountInAlign)
                for r := LeftY to LeftY+2 do
                    for s := LeftX to LeftX+2 do
                        if pos(SBA_IntToStr(p), hint[r, s]) <> 0 then
                            CountInSubgrid := CountInSubgrid + 1;

                if (CountInAlign = CountInSubgrid) and ((CountInAlign = 2) or (CountInAlign = 3)) then
                begin
                    // Remove from the same column except within the subgrid
                    // Pointing
                    for r := 0 to 8 do
                        if ((y div 3) <> (r div 3)) and (pos(SBA_IntToStr(p), hint[r, x]) <> 0) then
                            hint[r, x] := SBA_RemoveAt(hint[r, x], pos(SBA_IntToStr(p), hint[r, x]));

                        WriteStepHint(y, x, 'Pointing Pair', '-['+SBA_IntToStr(p)+'] for row '+SBA_IntToStr(y)+' due to sub '+SBA_IntToStr(3*(y div 3)+(x div 3)));
                end;

                // Rows
                CountInAlign := 0;
                CountInSubgrid := 0;
                LeftX := 3*(x div 3);
                LeftY := 3*(y div 3);

                // For left end to right end of subgrid
                for r := LeftX to LeftX+2 do
                    if pos(SBA_IntToStr(p), hint[y, r]) <> 0 then
                        CountInAlign := CountInAlign + 1;

                // Total count of P, CountInSubgrid in subgrid (must be equal to CountInAlign)
                for r := LeftY to LeftY+2 do
                    for s := LeftX to LeftX+2 do
                        if pos(SBA_IntToStr(p), hint[r, s]) <> 0 then
                            CountInSubgrid := CountInSubgrid + 1;

                if (CountInAlign = CountInSubgrid) and ((CountInAlign = 2) or (CountInAlign = 3)) then
                begin
                    // Remove from the same row except within the subgrid
                    // Pointing
                    for r := 0 to 8 do
                        if ((x div 3) <> (r div 3)) and (pos(SBA_IntToStr(p), hint[y, r]) <> 0) then
                            hint[y, r] := SBA_RemoveAt(hint[y, r], pos(SBA_IntToStr(p), hint[y, r]));
                    
                    WriteStepHint(y, x, 'Pointing Pair', '-['+SBA_IntToStr(p)+'] for col '+SBA_IntToStr(x)+' due to sub '+SBA_IntToStr(3*(y div 3)+(x div 3)));
                end;

            end;
end;

end.