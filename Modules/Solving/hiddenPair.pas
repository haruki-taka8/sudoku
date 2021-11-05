unit HiddenPair;

interface
uses combination, io, types, auxiliary, sysutils;
function RemoveHint (var hint : TStringGrid) : boolean;


implementation
function RemoveHint (var hint : TStringGrid) : boolean;
var x, y, p, q, PairX, PairY, LeftX, LeftY, ExactTotal, Total : integer;
    ThisCombo : string;
    HasRemoved : boolean;

begin
    HasRemoved := false;
    for y := 0 to 8 do
        for x := 0 to 8 do
            if length(hint[y, x]) > 2 then
            begin
                for ThisCombo in GetCombination(hint[y, x], 2) do
                    if ThisCombo = '' then
                        break
                    else
                    begin
                        if length(hint[y, x]) > 2 then
                        begin
                            // Row
                            ExactTotal := 0;
                            Total      := 0;
                            PairX   := -1;
                            PairY   := -1;

                            // First pass: exact matches
                            for q := 0 to 8 do
                                if (pos(ThisCombo[1], hint[y, q]) <> 0) and (pos(ThisCombo[2], hint[y, q]) <> 0) then
                                begin
                                    ExactTotal := ExactTotal + 1;
                                    PairX := q;
                                    PairY := y;
                                end;

                            // Second pass: any digit matches
                            for q := 0 to 8 do
                                if (pos(ThisCombo[1], hint[y, q]) <> 0) or (pos(ThisCombo[2], hint[y, q]) <> 0) then
                                    Total := Total + 1;

                            // (Matches-2) because second pass counts the cells counted in first pass
                            if (ExactTotal = 2) and (Total = 2) and (x <> PairX) and (PairX <> -1) and (PairY <> -1) then
                            begin
                                // Remove other candidates from (y, x) and (PairY, PairX)
                                hint[y, x] := ThisCombo;
                                hint[PairY, PairX] := ThisCombo;
                                HasRemoved := true;

                                WriteStepHint(fileHandler, y, x, 'Hidden Pair', '=['+ThisCombo+'] due to ('+IntToStr(y)+','+IntToStr(x)+')+('+IntToStr(PairY)+','+IntToStr(PairX)+') (row)');
                            end;
                        end;


                        // Column
                        if length(hint[y, x]) > 2 then
                        begin
                            ExactTotal := 0;
                            Total := 0;
                            PairX   := -1;
                            PairY   := -1;

                            // First pass: exact matches
                            for q := 0 to 8 do
                                if (pos(ThisCombo[1], hint[q, x]) <> 0) and (pos(ThisCombo[2], hint[q, x]) <> 0) then
                                begin
                                    ExactTotal := ExactTotal + 1;
                                    PairX := x;
                                    PairY := q;
                                end;

                            // Second pass: any digit matches
                            for q := 0 to 8 do
                                if (pos(ThisCombo[1], hint[q, x]) <> 0) or (pos(ThisCombo[2], hint[q, x]) <> 0) then
                                    Total := Total + 1;

                            if (ExactTotal = 2) and (Total = 2) and (y <> PairY) and (PairX <> -1) and (PairY <> -1) then
                            begin
                                // Remove other candidates from (y, x) and (PairY, PairX)
                                hint[y, x] := ThisCombo;
                                hint[PairY, PairX] := ThisCombo;
                                HasRemoved := true;

                                WriteStepHint(fileHandler, y, x, 'Hidden Pair', '=['+ThisCombo+'] due to ('+IntToStr(y)+','+IntToStr(x)+')+('+IntToStr(PairY)+','+IntToStr(PairX)+') (column)');
                            end;
                        end;

                        if length(hint[y, x]) > 2 then
                        begin
                            // Subgrid
                            ExactTotal := 0;
                            Total      := 0;
                            LeftX   := 3*(x div 3);
                            LeftY   := 3*(y div 3);
                            PairX   := -1;
                            PairY   := -1;

                            // First pass: exact matches
                            for q := LeftY to LeftY+2 do
                                for p := LeftX to LeftX+2 do
                                    if (pos(ThisCombo[1], hint[q, p]) <> 0) and (pos(ThisCombo[2], hint[q, p]) <> 0) then
                                    begin
                                        ExactTotal := ExactTotal + 1;
                                        PairX := p;
                                        PairY := q;
                                    end;

                            // Second pass: any digit matches
                            for q := LeftY to LeftY+2 do
                                for p := LeftX to LeftX+2 do
                                    if (pos(ThisCombo[1], hint[q, p]) <> 0) or (pos(ThisCombo[2], hint[q, p]) <> 0) then
                                        Total := Total + 1;

                            if (ExactTotal = 2) and (Total = 2) and ((x <> PairX) or (y <> PairY)) and (PairX <> -1) and (PairY <> -1) then
                                // Two IF statments because Pascal does NOT support short-circuit evaluation NOR out-of-bound indexing
                                // https://en.wikipedia.org/wiki/Short-circuit_evaluation
                                // Combining the IFs may result in a overflow (runtime error 216).

                                if length(hint[PairY, PairX]) > 2 then
                                begin
                                    // Remove other candidates from (y, x) and (PairY, PairX)
                                    hint[y, x] := ThisCombo;
                                    hint[PairY, PairX] := ThisCombo;
                                    HasRemoved := true;

                                    WriteStepHint(fileHandler, y, x, 'Hidden Pair', '=['+ThisCombo+'] due to ('+IntToStr(y)+','+IntToStr(x)+')+('+IntToStr(PairY)+','+IntToStr(PairX)+') (subgrid)');
                                end;
                        end;
                    end;
            end;

    RemoveHint := HasRemoved;
end;

end.