unit NakedTriple;

interface
uses types, auxiliary, io;
procedure RemoveHint (var hint : TStringGrid);

// Much thanks to Justin L. on Stack Overflow for the pseudocode of this algorithm
// https://stackoverflow.com/a/3026236

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

procedure RemoveHint (var hint: TStringGrid);
var y, x, p, q, r, s : integer;
    Hints, ThisCombo, ThisCell : string;
    NakedTripleCells : array [0..8] of boolean;
    NakedTripleCount : integer;
    LockedLeftX, LockedLeftY, SubgridCellID : integer;
    IsLockedTriple, HasNakedTriple, IsOnceLockedTriple : boolean;

begin
    IsOnceLockedTriple := false;

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
                // If a cell contains anything other than the combination, it is ineligible for naked triples
                NakedTripleCount := 0;
                for p := 0 to 8 do
                begin
                    NakedTripleCells[p] := false;
                    ThisCell := hint[y, p];

                    if ThisCell <> '' then
                    begin
                        for q := 1 to 3 do
                            ThisCell := SBA_RemoveAt(ThisCell, pos(ThisCombo[q], ThisCell));

                        if length(ThisCell) = 0 then
                        begin
                            NakedTripleCells[p] := true;
                            NakedTripleCount := NakedTripleCount + 1;
                            LockedLeftX := 3*(p div 3);
                            LockedLeftY := 3*(y div 3);
                        end;
                    end;
                end;

                // Remove hints in the same row
                IsLockedTriple := true;
                HasNakedTriple := false;
                if NakedTripleCount = 3 then
                begin
                    HasNakedTriple := true;
                    for p := 0 to 8 do
                    begin
                        if (not NakedTripleCells[p]) and (hint[y, p] <> '') then
                            for q := 1 to 3 do
                                hint[y, p] := SBA_RemoveAt(hint[y, p], pos(ThisCombo[q], hint[y, p]));

                        if NakedTripleCells[p] and (3*(p div 3) <> LockedLeftX) then
                            IsLockedTriple := false;
                    end;

                    WriteStepHint(y, x, 'Naked  Triple', '-['+ThisCombo+'] due to row '+SBA_IntToStr(y));
                end;

                // Locked?
                if IsLockedTriple and HasNakedTriple and (LockedLeftX <> -1) then
                begin
                    for r := LockedLeftY to LockedLeftY+2 do
                        for s := LockedLeftX to LockedLeftX+2 do
                            if (r <> y) and (hint[r, s] <> '') then
                                for q := 1 to 3 do
                                    hint[r, s] := SBA_RemoveAt(hint[r, s], pos(ThisCombo[q], hint[r, s]));

                    IsOnceLockedTriple := true; 
                    WriteStepHint(y, x, 'Locked Triple', '-['+ThisCombo+'] for sub '+SBA_IntToStr((3*(r div 3)+(s div 3)))+' (row)');
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
                // If a cell contains anything other than the combination, it is ineligible for naked triples
                NakedTripleCount := 0;
                for p := 0 to 8 do
                begin
                    NakedTripleCells[p] := false;
                    ThisCell := hint[p, x];

                    if ThisCell <> '' then
                    begin
                        for q := 1 to 3 do
                            ThisCell := SBA_RemoveAt(ThisCell, pos(ThisCombo[q], ThisCell));

                        if length(ThisCell) = 0 then
                        begin
                            NakedTripleCells[p] := true;
                            NakedTripleCount := NakedTripleCount + 1;
                            LockedLeftX := 3*(x div 3);
                            LockedLeftY := 3*(p div 3);
                        end;
                    end;
                end;

                // Remove hints in the same column
                IsLockedTriple := true;
                HasNakedTriple := false;
                if NakedTripleCount = 3 then
                begin
                    HasNakedTriple := true;
                    for p := 0 to 8 do
                    begin
                        if (not NakedTripleCells[p]) and (hint[p, x] <> '') then
                            for q := 1 to 3 do
                                hint[p, x] := SBA_RemoveAt(hint[p, x], pos(ThisCombo[q], hint[p, x]));

                        if NakedTripleCells[p] and (3*(p div 3) <> LockedLeftY) then
                            IsLockedTriple := false;
                    end;

                    WriteStepHint(y, x, 'Naked  Triple', '-['+ThisCombo+'] due to col '+SBA_IntToStr(x));
                end;

                // Locked?
                if IsLockedTriple and HasNakedTriple and (LockedLeftY <> -1) then
                begin
                    for r := LockedLeftY to LockedLeftY+2 do
                        for s := LockedLeftX to LockedLeftX+2 do
                            if (s <> x) and (hint[r, s] <> '') then
                                for q := 1 to 3 do
                                    hint[r, s] := SBA_RemoveAt(hint[r, s], pos(ThisCombo[q], hint[r, s]));

                    IsOnceLockedTriple := true;             
                    WriteStepHint(y, x, 'Locked Triple', '-['+ThisCombo+'] for sub '+SBA_IntToStr((3*(r div 3)+(s div 3)))+' (col)');
                end;
            end;
    end;


    // Subgrid
    if not IsOnceLockedTriple then
    begin
        y := 0;
        x := 0;

        // Iterate through top left of each subgrid
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
                        // If a cell contains anything other than the combination, it is ineligible for naked triples
                        NakedTripleCount := 0;
                        SubgridCellID := 0;
                        for r := y to y+2 do
                            for s := x to x+2 do
                            begin
                                NakedTripleCells[SubgridCellID] := false;
                                ThisCell := hint[r, s];

                                if ThisCell <> '' then
                                begin
                                    for q := 1 to 3 do
                                        ThisCell := SBA_RemoveAt(ThisCell, pos(ThisCombo[q], ThisCell));

                                    if length(ThisCell) = 0 then
                                    begin
                                        NakedTripleCells[SubgridCellID] := true;
                                        NakedTripleCount := NakedTripleCount + 1;
                                    end;
                                end;
                                SubgridCellID := SubgridCellID + 1;
                            end;

                            // Remove hints in the same subgrid
                            if NakedTripleCount = 3 then
                            begin
                                SubgridCellID := 0;
                                for r := y to y+2 do
                                    for s := x to x+2 do
                                    begin
                                        if (not NakedTripleCells[SubgridCellID]) and (hint[r, s] <> '') then
                                            for q := 1 to 3 do
                                                hint[r, s] := SBA_RemoveAt(hint[r, s], pos(ThisCombo[q], hint[r, s]));

                                        SubgridCellID := SubgridCellID + 1;
                                    end;

                                WriteStepHint(y, x, 'Naked  Triple', '-['+ThisCombo+'] due to sub '+SBA_IntToStr((3*(r div 3)+(s div 3))));
                                // WriteHint(hint);
                            end;
                    end;

                x := x + 3;
            end;
            y := y + 3;
            x := 0;
        end;

    end;

end;

end.
