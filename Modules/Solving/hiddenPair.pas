unit HiddenPair;

interface
uses io, types, auxiliary;
procedure RemoveHint (var hint : TStringGrid);


implementation
type twoCombination = array [0..35] of string;

function GetTwoCombination (Input : string) : twoCombination;
var
    Output : twoCombination;
    y, x, i : integer;

begin
    // I know this is ridiculous, but hear me out!
    // Without the following lines, Pascal causes a memory corruption!
    // https://www.cvedetails.com/vulnerability-list/opmemc-1/memory-corruption.html
    Output[0] := '';
    Output[1] := '';
    Output[2] := '';
    Output[3] := '';
    Output[4] := '';
    Output[5] := '';
    Output[6] := '';
    Output[7] := '';
    Output[8] := '';
    Output[9] := '';
    Output[10] := '';
    Output[11] := '';
    Output[12] := '';
    Output[13] := '';
    Output[14] := '';
    Output[15] := '';
    Output[16] := '';
    Output[17] := '';
    Output[18] := '';
    Output[19] := '';
    Output[20] := '';
    Output[21] := '';
    Output[22] := '';
    Output[23] := '';
    Output[24] := '';
    Output[25] := '';
    Output[26] := '';
    Output[27] := '';
    Output[28] := '';
    Output[29] := '';
    Output[30] := '';
    Output[31] := '';
    Output[32] := '';
    Output[33] := '';
    Output[34] := '';
    Output[35] := '';

    i := 0;
    for y := 1 to length(Input)-1 do
        for x := y+1 to length(Input) do
        begin
            Output[i] := Input[y] + Input[x];
            i := i + 1;
        end;

    GetTwoCombination := Output;
end;


procedure RemoveHint (var hint : TStringGrid);
var x, y, p, q, i, PairX, PairY, LeftX, LeftY, ExactTotal, Total : integer;
    ThisCombo : twoCombination;
    // Combination : string;

begin
    for y := 0 to 8 do
        for x := 0 to 8 do
            if length(hint[y, x]) > 2 then
            begin
                ThisCombo := GetTwoCombination(hint[y, x]);
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

                                if VERBOSE then
                                    writeln('Hint (', y, ',', x, ') and (', PairY, ',', PairX, ') as ', ThisCombo[i][1], ThisCombo[i][2], ' by hidden pair, row');
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

                                if VERBOSE then
                                    writeln('Hint (', y, ',', x, ') and (', PairY, ',', PairX, ') as ', ThisCombo[i], ' by hidden pair, column');
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

                                    if VERBOSE then
                                        writeln('Hint (', y, ',', x, ') and (', PairY, ',', PairX, ') as ', ThisCombo[i], ' by hidden pair, subgrid');
                                end;
                        end;
                    end;
            end;
end;

end.