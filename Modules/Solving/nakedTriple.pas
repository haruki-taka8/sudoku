unit NakedTriple;

interface
uses io, types, auxiliary;
procedure RemoveHint (var hint : TStringGrid);

// Much thanks to Justin L. on Stack Overflow for the pseudocode of this algorithm
// https://stackoverflow.com/a/3026236

implementation
type threeCombination = array [0..83] of string;

procedure RemoveHint (var hint : TStringGrid);
var ShouldNotHave, ThisCell : string;
    NakedTripleCells : array [0..8] of boolean;
    y, x, p, q, r, s, SubgridCellID, LeftX, LeftY, NakedTripleCount : integer;
begin
    for y := 0 to 8 do
        for x := 0 to 8 do
            if length(hint[y, x]) = 3 then
            begin
                // Row
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
                        end;
                    end;
                end;

                // Remove hints in the same row
                if NakedTripleCount = 3 then
                    for p := 0 to 8 do
                        if (not NakedTripleCells[p]) and (hint[y, p] <> '') then
                        begin
                            for q := 1 to 3 do
                                hint[y, p] := SBA_RemoveAt(hint[y, p], pos(hint[y, x][q], hint[y, p]));

                            if VERBOSE then
                                writeln('Remove ', hint[y, x], ' from (', y, ',', p, ') based on row ', y, ' by naked triples, row-row');
                        end;


                // Column
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
                        end;
                    end;
                end;

                // Remove hints in the same column
                if NakedTripleCount = 3 then
                    for p := 0 to 8 do
                        if (not NakedTripleCells[p]) and (hint[p, x] <> '') then
                        begin
                            for q := 1 to 3 do
                                hint[p, x] := SBA_RemoveAt(hint[p, x], pos(hint[y, x][q], hint[p, x]));

                            if VERBOSE then
                                writeln('Remove ', hint[y, x], ' from (', p, ',', x, ') based on col ', x, ' by naked triples, col-col');
                            
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
                // for p := 0 to 8 do
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
                    for r := LeftX to LeftX+2 do
                        for s := LeftY to LeftY+2 do
                        begin
                            if (not NakedTripleCells[SubgridCellID]) and (hint[s, r] <> '') then
                            begin
                                for q := 1 to 3 do
                                    hint[s, r] := SBA_RemoveAt(hint[s, r], pos(hint[y, x][q], hint[s, r]));

                                if VERBOSE then
                                    writeln('Remove ', hint[y, x], ' from (', s, ',', r, ') based on sub ', (3*(s div 3)+(r div 3)) ,' by naked triples, sub-sub');

                            end;
                            SubgridCellID := SubgridCellID + 1;
                        end;
            end;
end;

end.
