unit NakedTriple;

interface
uses types, auxiliary, io;
procedure RemoveHint (var hint : TStringGrid);

// Much thanks to Justin L. on Stack Overflow for the pseudocode of this algorithm
// https://stackoverflow.com/a/3026236

implementation
type threeCombination = array [0..83] of string;

procedure RemoveHint (var hint : TStringGrid);
var ShouldNotHave, ThisCell : string;
    NakedTripleCells : array [0..8] of boolean;
    y, x, p, q, r, s, SubgridCellID, LeftX, LeftY, NakedTripleCount : integer;
    LockedLeftX, LockedLeftY : integer;
    IsLockedTriple, HasNakedTriple : boolean;
begin
    for y := 0 to 8 do
        for x := 0 to 8 do
            if length(hint[y, x]) = 3 then
            begin
                // Row
                IsLockedTriple := true;
                HasNakedTriple := false;
                NakedTripleCount := 0;

                ShouldNotHave := '123456789';
                for p := 1 to 3 do
                    ShouldNotHave := SBA_RemoveAt(ShouldNotHave, pos(hint[y, x][p], ShouldNotHave));

                // If a cell in a row contains ShouldNotHave, that cell is ineligible for naked triples
                for p := 0 to 8 do
                begin
                    NakedTripleCells[p] := false;
                    ThisCell := hint[y, p];

                    if ThisCell <> '' then
                    begin
                        for q := 1 to 3 do
                            ThisCell := SBA_RemoveAt(ThisCell, pos(hint[y, x][q], ThisCell));

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
                if NakedTripleCount = 3 then
                begin
                    for p := 0 to 8 do
                    begin
                        if (not NakedTripleCells[p]) and (hint[y, p] <> '') then
                        begin
                            HasNakedTriple := true;
                            for q := 1 to 3 do
                                hint[y, p] := SBA_RemoveAt(hint[y, p], pos(hint[y, x][q], hint[y, p]));
                        end;

                        if NakedTripleCells[p] and (3*(p div 3) <> LockedLeftX) then
                            IsLockedTriple := false;
                    end;

                    WriteStepHint(y, x, 'Naked  Triple', '-['+hint[y, x]+'] ∵ row '+SBA_IntToStr(y));
                end;

                // Locked triple
                if IsLockedTriple and HasNakedTriple and (LockedLeftX <> -1) then
                begin
                    for r := LockedLeftX to LockedLeftX+2 do
                        for s := LockedLeftY to LockedLeftY+2 do
                            if (s <> y) and (hint[s, r] <> '') then
                                for q := 1 to 3 do
                                    hint[s, r] := SBA_RemoveAt(hint[s, r], pos(hint[y, x][q], hint[s, r]));
                                    
                    WriteStepHint(y, x, 'Locked Triple', '-['+hint[y, x]+'] ⇒ sub '+SBA_IntToStr((3*(s div 3)+(r div 3)))+' (row)');
                end;


                // Column
                IsLockedTriple := true;
                HasNakedTriple := false;
                NakedTripleCount := 0;
                ShouldNotHave := '123456789';
                for p := 1 to 3 do
                    ShouldNotHave := SBA_RemoveAt(ShouldNotHave, pos(hint[y, x][p], ShouldNotHave));

                // If a cell in a column contains ShouldNotHave, that cell is ineligible for naked triples
                for p := 0 to 8 do
                begin
                    NakedTripleCells[p] := false;
                    ThisCell := hint[p, x];

                    if ThisCell <> '' then
                    begin
                        for q := 1 to 3 do
                            ThisCell := SBA_RemoveAt(ThisCell, pos(hint[y, x][q], ThisCell));

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
                if NakedTripleCount = 3 then
                begin
                    for p := 0 to 8 do
                    begin
                        if (not NakedTripleCells[p]) and (hint[p, x] <> '') then
                        begin
                            HasNakedTriple := true;
                            for q := 1 to 3 do
                                hint[p, x] := SBA_RemoveAt(hint[p, x], pos(hint[y, x][q], hint[p, x]));
                        end;

                        if NakedTripleCells[p] and (3*(p div 3) <> LockedLeftY) then
                            IsLockedTriple := false;
                    end;
                    
                    WriteStepHint(y, x, 'Naked  Triple', '-['+hint[y, x]+'] ∵ col '+SBA_IntToStr(x));
                end;

                // Locked triple
                if IsLockedTriple and HasNakedTriple and (LockedLeftY <> -1) then
                begin
                    for r := LockedLeftX to LockedLeftX+2 do
                        for s := LockedLeftY to LockedLeftY+2 do
                            if (r <> x) and (hint[s, r] <> '') then
                                for q := 1 to 3 do
                                    hint[s, r] := SBA_RemoveAt(hint[s, r], pos(hint[y, x][q], hint[s, r]));

                    WriteStepHint(y, x, 'Locked Triple', '-['+hint[y, x]+'] ⇒ sub '+SBA_IntToStr((3*(s div 3)+(r div 3)))+' (column)');
                end;

                

                // Subgrid
                NakedTripleCount := 0;
                ShouldNotHave := '123456789';
                for p := 1 to 3 do
                    ShouldNotHave := SBA_RemoveAt(ShouldNotHave, pos(hint[y, x][p], ShouldNotHave));

                // If a cell in a subgrid contains ShouldNotHave, that cell is ineligible for naked triples
                // Arrangment for SubgridCellID:
                // 0 1 2 | 0 1 2
                // 3 4 5 | 3 4 5  ...
                // 6 7 8 | 6 7 8 

                SubgridCellID := 0;
                LeftX := 3*(x div 3);
                LeftY := 3*(y div 3);
                for r := LeftX to LeftX+2 do
                    for s := LeftY to LeftY+2 do
                    begin
                        NakedTripleCells[SubgridCellID] := false;
                        ThisCell := hint[s, r];

                        if ThisCell <> '' then
                        begin
                            for q := 1 to 3 do
                                ThisCell := SBA_RemoveAt(ThisCell, pos(hint[y, x][q], ThisCell));

                            if length(ThisCell) = 0 then
                            begin
                                NakedTripleCells[SubgridCellID] := true;
                                NakedTripleCount := NakedTripleCount + 1;
                            end;
                        end;

                        SubgridCellID := SubgridCellID + 1;
                    end;

                // Remove hints in the same subgrid
                SubgridCellID := 0;
                if NakedTripleCount = 3 then
                begin
                    for r := LeftX to LeftX+2 do
                        for s := LeftY to LeftY+2 do
                        begin
                            if (not NakedTripleCells[SubgridCellID]) and (hint[s, r] <> '') then
                                for q := 1 to 3 do
                                    hint[s, r] := SBA_RemoveAt(hint[s, r], pos(hint[y, x][q], hint[s, r]));
                                    
                            SubgridCellID := SubgridCellID + 1;
                        end;
                        WriteStepHint(y, x, 'Naked  Triple', '-['+hint[y, x]+'] ∵ sub '+SBA_IntToStr((3*(s div 3)+(r div 3))));
                end;
            end;
end;

end.
