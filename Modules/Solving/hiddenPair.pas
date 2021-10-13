unit HiddenPair;

interface
uses combination, io, types, auxiliary;
procedure RemoveHint (var hint : TStringGrid);


implementation
procedure RemoveHint (var hint : TStringGrid);
var x, y, p, q, i, PairX, PairY, LeftX, LeftY, ExactTotal, Total : integer;
    ThisCombo : TCombination;

begin
    for y := 0 to 8 do
        for x := 0 to 8 do
            if length(hint[y, x]) > 2 then
            begin
                ThisCombo := GetCombination(hint[y, x], 2);
                for i := 0 to 35 do
                    if ThisCombo[i] <> '' then
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
                                if (pos(ThisCombo[i][1], hint[y, q]) <> 0) and (pos(ThisCombo[i][2], hint[y, q]) <> 0) then
                                begin
                                    ExactTotal := ExactTotal + 1;
                                    PairX := q;
                                    PairY := y;
                                end;

                            // Second pass: any digit matches
                            for q := 0 to 8 do
                                if (pos(ThisCombo[i][1], hint[y, q]) <> 0) or (pos(ThisCombo[i][2], hint[y, q]) <> 0) then
                                    Total := Total + 1;

                            // (Matches-2) because second pass counts the cells counted in first pass
                            if (ExactTotal = 2) and (Total = 2) and (x <> PairX) and (PairX <> -1) and (PairY <> -1) then
                            begin
                                // Remove other candidates from (y, x) and (PairY, PairX)
                                hint[y, x] := ThisCombo[i];
                                hint[PairY, PairX] := ThisCombo[i];

                                WriteStepHint(fileHandler, y, x, 'Hidden Pair', '=['+ThisCombo[i]+'] due to ('+SBA_IntToStr(y)+','+SBA_IntToStr(x)+')+('+SBA_IntToStr(PairY)+','+SBA_IntToStr(PairX)+') (row)');
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
                                if (pos(ThisCombo[i][1], hint[q, x]) <> 0) and (pos(ThisCombo[i][2], hint[q, x]) <> 0) then
                                begin
                                    ExactTotal := ExactTotal + 1;
                                    PairX := x;
                                    PairY := q;
                                end;

                            // Second pass: any digit matches
                            for q := 0 to 8 do
                                if (pos(ThisCombo[i][1], hint[q, x]) <> 0) or (pos(ThisCombo[i][2], hint[q, x]) <> 0) then
                                    Total := Total + 1;

                            if (ExactTotal = 2) and (Total = 2) and (y <> PairY) and (PairX <> -1) and (PairY <> -1) then
                            begin
                                // Remove other candidates from (y, x) and (PairY, PairX)
                                hint[y, x] := ThisCombo[i];
                                hint[PairY, PairX] := ThisCombo[i];

                                WriteStepHint(fileHandler, y, x, 'Hidden Pair', '=['+ThisCombo[i]+'] due to ('+SBA_IntToStr(y)+','+SBA_IntToStr(x)+')+('+SBA_IntToStr(PairY)+','+SBA_IntToStr(PairX)+') (column)');
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
                                    if (pos(ThisCombo[i][1], hint[q, p]) <> 0) and (pos(ThisCombo[i][2], hint[q, p]) <> 0) then
                                    begin
                                        ExactTotal := ExactTotal + 1;
                                        PairX := p;
                                        PairY := q;
                                    end;

                            // Second pass: any digit matches
                            for q := LeftY to LeftY+2 do
                                for p := LeftX to LeftX+2 do
                                    if (pos(ThisCombo[i][1], hint[q, p]) <> 0) or (pos(ThisCombo[i][2], hint[q, p]) <> 0) then
                                        Total := Total + 1;

                            if (ExactTotal = 2) and (Total = 2) and ((x <> PairX) or (y <> PairY)) and (PairX <> -1) and (PairY <> -1) then
                                // Two IF statments because Pascal does NOT support short-circuit evaluation NOR out-of-bound indexing
                                // https://en.wikipedia.org/wiki/Short-circuit_evaluation
                                // Combining the IFs may result in a overflow (runtime error 216).

                                if length(hint[PairY, PairX]) > 2 then
                                begin
                                    // Remove other candidates from (y, x) and (PairY, PairX)
                                    hint[y, x] := ThisCombo[i];
                                    hint[PairY, PairX] := ThisCombo[i];

                                    WriteStepHint(fileHandler, y, x, 'Hidden Pair', '=['+ThisCombo[i]+'] due to ('+SBA_IntToStr(y)+','+SBA_IntToStr(x)+')+('+SBA_IntToStr(PairY)+','+SBA_IntToStr(PairX)+') (subgrid)');
                                end;
                        end;
                    end;
            end;
end;

end.