unit HiddenTriple;

interface
uses types, auxiliary, io;
procedure RemoveHint (var hint : TStringGrid);


implementation
type threeCombination = array [0..83] of string;

function MergeHint (HintsInHouse : string) : string;
var i, j : integer;
    Temp : char;
    Result : string;
begin
    // = UNIQUE(SORT(HintsInHouse))
    // Concatenate hints
    
    // Sort (bubble, per char)
    for i := 1 to length(HintsInHouse)-1 do
        for j := 1 to length(HintsInHouse)-i do
            if HintsInHouse[j] > HintsInHouse[j+1] then
            begin
                Temp := HintsInHouse[j+1];
                HintsInHouse[j+1] := HintsInHouse[j];
                HintsInHouse[j] := Temp;
            end;
        
    // Remove duplicates
    Result := '';
    for Temp in HintsInHouse do
        if pos(Temp, Result) = 0 then
            Result := Result + Temp;
    MergeHint := Result;
end;

function GetThreeCombination (Input : string) : threeCombination;
var y, x, w, i : integer;
    Output : threeCombination;
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
    Output[36] := '';
    Output[37] := '';
    Output[38] := '';
    Output[39] := '';
    Output[40] := '';
    Output[41] := '';
    Output[42] := '';
    Output[43] := '';
    Output[44] := '';
    Output[45] := '';
    Output[46] := '';
    Output[47] := '';
    Output[48] := '';
    Output[49] := '';
    Output[50] := '';
    Output[51] := '';
    Output[52] := '';
    Output[53] := '';
    Output[54] := '';
    Output[55] := '';
    Output[56] := '';
    Output[57] := '';
    Output[58] := '';
    Output[59] := '';
    Output[60] := '';
    Output[61] := '';
    Output[62] := '';
    Output[63] := '';
    Output[64] := '';
    Output[65] := '';
    Output[66] := '';
    Output[67] := '';
    Output[68] := '';
    Output[69] := '';
    Output[70] := '';
    Output[71] := '';
    Output[72] := '';
    Output[73] := '';
    Output[74] := '';
    Output[75] := '';
    Output[76] := '';
    Output[77] := '';
    Output[78] := '';
    Output[79] := '';
    Output[80] := '';
    Output[81] := '';
    Output[82] := '';
    Output[83] := '';

    i := 0;
    for y := 1 to length(Input)-2 do
        for x := y+1 to length(Input)-1 do
            for w := x+1 to length(Input) do
            begin
                Output[i] := Input[y]+Input[x]+Input[w];
                i := i+1
            end;
    GetThreeCombination := Output;
end;

procedure RemoveHint (var hint : TStringGrid);
var y, x, p, r, s, HiddenTripleCount, SubgridCellID : integer;
    Hints, ThisCombo, ThisCell, ThisLetter : string;
    IsHiddenTriple : array [0..8] of boolean;
begin
    // Row
    y := 0;
    x := 0;
    for y := 0 to 8 do
    begin
        Hints := '';

        // Generate possible triple combination
        for p := 0 to 8 do Hints := Hints + hint[y, p];
        Hints := MergeHint(Hints);

        for ThisCombo in GetThreeCombination(Hints) do
            if ThisCombo <> '' then
            begin
                HiddenTripleCount := 0;

                // If a cell in a house contains ThisCombo, the cell is eligible for hidden triples
                for p := 0 to 8 do
                begin
                    IsHiddenTriple[p] := false;
                    if (pos(ThisCombo[1], hint[y, p]) <> 0) or
                       (pos(ThisCombo[2], hint[y, p]) <> 0) or
                       (pos(ThisCombo[3], hint[y, p]) <> 0) then
                    begin
                        HiddenTripleCount := HiddenTripleCount + 1;
                        IsHiddenTriple[p] := true;
                    end;
                end;

                // Remove other hints in cells where IsHiddenTriple[p] are TRUE
                if HiddenTripleCount = 3 then
                begin
                    for p := 0 to 8 do
                        if IsHiddenTriple[p] then
                        begin
                            ThisCell := '';
                            for ThisLetter in ThisCombo do
                                if pos(ThisLetter, hint[y, p]) <> 0 then ThisCell := ThisCell + ThisLetter;
                            hint[y, p] := ThisCell;                        
                        end;

                    WriteStepHint(y, x, 'Hidden Triple', '-[^'+ThisCombo+'] for row '+SBA_IntToStr(y));
                end;
            end;
    end;

    // Column
    y := 0;
    x := 0;
    for x := 0 to 8 do
    begin
        Hints := '';

        // Generate possible triple combination
        for p := 0 to 8 do Hints := Hints + hint[p, x];
        Hints := MergeHint(Hints);

        for ThisCombo in GetThreeCombination(Hints) do
            if ThisCombo <> '' then
            begin
                HiddenTripleCount := 0;

                // If a cell in a house contains ThisCombo, the cell is eligible for hidden triples
                for p := 0 to 8 do
                begin
                    IsHiddenTriple[p] := false;
                    if (pos(ThisCombo[1], hint[p, x]) <> 0) or
                       (pos(ThisCombo[2], hint[p, x]) <> 0) or
                       (pos(ThisCombo[3], hint[p, x]) <> 0) then
                    begin
                        HiddenTripleCount := HiddenTripleCount + 1;
                        IsHiddenTriple[p] := true;
                    end;
                end;

                // Remove other hints in cells where IsHiddenTriple[p] are TRUE
                if HiddenTripleCount = 3 then
                begin
                    for p := 0 to 8 do
                        if IsHiddenTriple[p] then
                        begin
                            ThisCell := '';
                            for ThisLetter in ThisCombo do
                                if pos(ThisLetter, hint[p, x]) <> 0 then ThisCell := ThisCell + ThisLetter;
                            hint[p, x] := ThisCell;                        
                        end;

                    WriteStepHint(y, x, 'Hidden Triple', '-[^'+ThisCombo+'] for col '+SBA_IntToStr(x));
                end;
            end;
    end;


    // Subgrid
    y := 0;
    x := 0;
    while y < 8 do
    begin
        while x < 8 do
        begin
            Hints := '';

            // Generate possible triple combination
            for r := y to y+2 do
                for s := x to x+2 do
                    Hints := Hints + hint[r, s];
            Hints := MergeHint(Hints);

            for ThisCombo in GetThreeCombination(Hints) do
                if ThisCombo <> '' then
                begin
                    HiddenTripleCount := 0;
                    SubgridCellID := 0;

                    // If a cell in a house contains ThisCombo, the cell is eligible for hidden triples
                    for r := y to y+2 do
                        for s := x to x+2 do
                        begin
                            IsHiddenTriple[SubgridCellID] := false;
                            if (pos(ThisCombo[1], hint[r, s]) <> 0) or
                               (pos(ThisCombo[2], hint[r, s]) <> 0) or
                               (pos(ThisCombo[3], hint[r, s]) <> 0) then
                            begin
                                HiddenTripleCount := HiddenTripleCount + 1;
                                IsHiddenTriple[SubgridCellID] := true;
                            end;
                            SubgridCellID := SubgridCellID + 1;
                        end;

                    // Remove other hints in cells where IsHiddenTriple[p] are TRUE
                    if HiddenTripleCount = 3 then
                    begin
                        SubgridCellID := 0;
                        for r := y to y+2 do
                            for s := x to x+2 do
                            begin
                                if IsHiddenTriple[SubgridCellID] then
                                begin
                                    ThisCell := '';
                                    for ThisLetter in ThisCombo do
                                        if pos(ThisLetter, hint[r, s]) <> 0 then ThisCell := ThisCell + ThisLetter;
                                    hint[r, s] := ThisCell;                        
                                end;
                                SubgridCellID := SubgridCellID + 1;
                            end;

                        WriteStepHint(y, x, 'Hidden Triple', '-[^'+ThisCombo+'] for sub '+SBA_IntToStr((3*(r div 3)+(s div 3))));
                    end;
                end; 
            x := x + 3;
        end;
        y := y + 3;
        x := 0;
    end;
end;


// procedure RemoveHint (var hint : TStringGrid);
// var ThisCombo : string;
//     IsHiddenTriple : array [0..8] of boolean;
//     y, x, p, q, r, s, SubgridCellID, LeftX, LeftY, HiddenTripleCount : integer;
// begin
//     for y := 0 to 8 do
//         for x := 0 to 8 do
//             if length(hint[y, x]) >= 4 then
//                 for ThisCombo in GetThreeCombination(hint[y, x]) do
//                     if ThisCombo <> '' then
//                     begin
//                         // Row
//                         HiddenTripleCount := 0;

//                         // If a cell in a row contains ThisCombo, that cell is eligible for naked triples
//                         for p := 0 to 8 do
//                         begin
//                             IsHiddenTriple[p] := false;

//                             if (pos(ThisCombo[1], hint[y, p]) <> 0) or
//                                (pos(ThisCombo[2], hint[y, p]) <> 0) or
//                                (pos(ThisCombo[3], hint[y, p]) <> 0) then
//                             begin
//                                 HiddenTripleCount := HiddenTripleCount + 1;
//                                 IsHiddenTriple[p] := true;
//                             end;
//                         end;

//                         // Remove other hints in cells where IsHiddenTriple[p] are TRUE
//                         if HiddenTripleCount = 3 then
//                         begin
//                             for p := 0 to 8 do
//                                 if IsHiddenTriple[p] then
//                                     for q := 1 to length(hint[y, p]) do
//                                         if not ((hint[y, p][q] = ThisCombo[1]) or
//                                            (hint[y, p][q] = ThisCombo[2]) or
//                                            (hint[y, p][q] = ThisCombo[3])) then
//                                             hint[y, p] := SBA_RemoveAt(hint[y, p], q);

//                             WriteStepHint(y, x, 'Hidden Triple', '-[^'+ThisCombo+'] due to row '+SBA_IntToStr(y));
//                         end;


//                         // Column
//                         HiddenTripleCount := 0;

//                         // If a cell in a column contains ThisCombo, that cell is eligible for naked triples
//                         for p := 0 to 8 do
//                         begin
//                             IsHiddenTriple[p] := false;

//                             if (pos(ThisCombo[1], hint[p, x]) <> 0) or
//                                (pos(ThisCombo[2], hint[p, x]) <> 0) or
//                                (pos(ThisCombo[3], hint[p, x]) <> 0) then
//                             begin
//                                 HiddenTripleCount := HiddenTripleCount + 1;
//                                 IsHiddenTriple[p] := true;
//                             end;
//                         end;

//                         // Remove other hints in cells where IsHiddenTriple[p] are TRUE
//                         if HiddenTripleCount = 3 then
//                         begin
//                             for p := 0 to 8 do
//                                 if IsHiddenTriple[p] then
//                                     for q := 1 to length(hint[p, x]) do
//                                         if not ((hint[p, x][q] = ThisCombo[1]) or
//                                            (hint[p, x][q] = ThisCombo[2]) or
//                                            (hint[p, x][q] = ThisCombo[3])) then
//                                             hint[p, x] := SBA_RemoveAt(hint[p, x], q);

//                             WriteStepHint(y, x, 'Hidden Triple', '-[^'+ThisCombo+'] due to col '+SBA_IntToStr(x));
//                         end;


//                         // Subgrid
//                         HiddenTripleCount := 0;
//                         LeftX := 3*(x div 3);
//                         LeftY := 3*(y div 3);
//                         SubgridCellID := 0;

//                         // If a cell in a subgrid contains ThisCombo, that cell is eligible for naked triples
//                         for s := LeftY to LeftY+2 do
//                             for r := LeftX to LeftX+2 do
//                             begin
//                                 IsHiddenTriple[SubgridCellID] := false;
    
//                                 if (pos(ThisCombo[1], hint[p, x]) <> 0) or
//                                    (pos(ThisCombo[2], hint[p, x]) <> 0) or
//                                    (pos(ThisCombo[3], hint[p, x]) <> 0) then
//                                 begin
//                                     HiddenTripleCount := HiddenTripleCount + 1;
//                                     IsHiddenTriple[SubgridCellID] := true;
//                                 end;
//                                 SubgridCellID := SubgridCellID + 1;
//                             end;

//                         // Remove other hints in cells where IsHiddenTriple[p] are TRUE
//                         if HiddenTripleCount = 3 then
//                         begin
//                             SubgridCellID := 0;
//                             for s := LeftY to LeftY+2 do
//                                 for r := LeftX to LeftX+2 do
//                                 begin
//                                     if IsHiddenTriple[SubgridCellID] then
//                                         for q := 1 to length(hint[s, r]) do
//                                             if not ((hint[s, r][q] = ThisCombo[1]) or
//                                                (hint[s, r][q] = ThisCombo[2]) or
//                                                (hint[s, r][q] = ThisCombo[3])) then
//                                                 hint[s, r] := SBA_RemoveAt(hint[s, r], q);

//                                     SubgridCellID := SubgridCellID + 1;
//                                 end;
//                             // for p := 0 to 8 do

//                             WriteStepHint(y, x, 'Hidden Triple', '-[^'+ThisCombo+'] due to sub '+SBA_IntToStr(3*(s div 3)+(r div 3)));
//                         end;


//                     end;
// end;

end.
