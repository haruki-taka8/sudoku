unit NakedTriple;

interface
uses triple, types, auxiliary, io;
procedure RemoveHint (var hint : TStringGrid);


// Much thanks to Justin L. on Stack Overflow for the pseudocode of this algorithm
// https://stackoverflow.com/a/3026236

implementation
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

                    WriteStepHint(fileHandler, y, x, 'Naked  Triple', '-['+ThisCombo+'] due to row '+SBA_IntToStr(y));
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
                    WriteStepHint(fileHandler, y, x, 'Locked Triple', '-['+ThisCombo+'] for sub '+SBA_IntToStr((3*(r div 3)+(s div 3)))+' (row)');
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

                    WriteStepHint(fileHandler, y, x, 'Naked  Triple', '-['+ThisCombo+'] due to col '+SBA_IntToStr(x));
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
                    WriteStepHint(fileHandler, y, x, 'Locked Triple', '-['+ThisCombo+'] for sub '+SBA_IntToStr((3*(r div 3)+(s div 3)))+' (col)');
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

                                WriteStepHint(fileHandler, y, x, 'Naked  Triple', '-['+ThisCombo+'] due to sub '+SBA_IntToStr((3*(r div 3)+(s div 3))));
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
