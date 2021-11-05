unit NakedQuad;

interface
uses combination, types, auxiliary, io, sysutils;
function RemoveHint (var hint : TStringGrid) : boolean;


implementation
function RemoveHint (var hint: TStringGrid) : boolean;
var y, x, p, q, r, s : integer;
    Hints, ThisCombo, ThisCell, OldHint : string;
    NakedQuadCells : array [0..8] of boolean;
    NakedQuadCount : integer;
    SubgridCellID : integer;
    HasRemoved, HasEverRemoved : boolean;

begin
    HasEverRemoved := false;

    // Row
    y := 0;
    x := 0;
    OldHint := '';
    HasRemoved := false;
    for y := 0 to 8 do
    begin
        Hints := '';

        // Generate possible quad combination
        for p := 0 to 8 do Hints := Hints + hint[y, p];
        Hints := MergeHint(Hints);

        for ThisCombo in GetCombination(Hints, 4) do
            if ThisCombo = '' then
                break
            else
            begin
                // If a cell contains anything other than the combination, it is ineligible for naked quads
                NakedQuadCount := 0;
                for p := 0 to 8 do
                begin
                    NakedQuadCells[p] := false;
                    ThisCell := hint[y, p];

                    if ThisCell <> '' then
                    begin
                        for q := 1 to 4 do
                            ThisCell := SBA_RemoveAt(ThisCell, pos(ThisCombo[q], ThisCell));

                        if length(ThisCell) = 0 then
                        begin
                            NakedQuadCells[p] := true;
                            NakedQuadCount := NakedQuadCount + 1;
                        end;
                    end;
                end;

                // Remove hints in the same row
                if NakedQuadCount = 4 then
                begin
                    for p := 0 to 8 do
                    begin
                        if (not NakedQuadCells[p]) and (hint[y, p] <> '') then
                        begin
                            OldHint := hint[y, p];
                            for q := 1 to 4 do
                                hint[y, p] := SBA_RemoveAt(hint[y, p], pos(ThisCombo[q], hint[y, p]));

                            if hint[y, p] <> OldHint then 
                            begin
                                HasRemoved := true;
                                HasEverRemoved := true;
                            end;
                        end;
                    end;

                    if HasRemoved then
                        WriteStepHint(fileHandler, y, x, 'Naked  Quad', '-['+ThisCombo+'] due to row '+IntToStr(y));
                end;
            end;
    end;



    // Column
    y := 0;
    x := 0;
    OldHint := '';
    HasRemoved := false;
    for x := 0 to 8 do
    begin
        Hints := '';

        // Generate possible Quad combination
        for p := 0 to 8 do Hints := Hints + hint[p, x];
        Hints := MergeHint(Hints);

        for ThisCombo in GetCombination(Hints, 4) do
            if ThisCombo = '' then
                break
            else
            begin
                // If a cell contains anything other than the combination, it is ineligible for naked Quads
                NakedQuadCount := 0;
                for p := 0 to 8 do
                begin
                    NakedQuadCells[p] := false;
                    ThisCell := hint[p, x];

                    if ThisCell <> '' then
                    begin
                        for q := 1 to 4 do
                            ThisCell := SBA_RemoveAt(ThisCell, pos(ThisCombo[q], ThisCell));

                        if length(ThisCell) = 0 then
                        begin
                            NakedQuadCells[p] := true;
                            NakedQuadCount := NakedQuadCount + 1;
                        end;
                    end;
                end;

                // Remove hints in the same column
                if NakedQuadCount = 4 then
                begin
                    for p := 0 to 8 do
                    begin
                        if (not NakedQuadCells[p]) and (hint[p, x] <> '') then
                        begin
                            OldHint := hint[p, x];
                            for q := 1 to 4 do
                                hint[p, x] := SBA_RemoveAt(hint[p, x], pos(ThisCombo[q], hint[p, x]));

                            if hint[p, x] <> OldHint then
                            begin
                                HasRemoved := true;
                                HasEverRemoved := true;
                            end;
                        end;
                    end;

                    if HasRemoved then
                        WriteStepHint(fileHandler, y, x, 'Naked  Quad', '-['+ThisCombo+'] due to col '+IntToStr(x));
                end;
            end;
    end;


    // Subgrid
    y := 0;
    x := 0;
    OldHint := '';
    HasRemoved := false;

    // Iterate through top left of each subgrid
    while y < 8 do
    begin
        while x < 8 do
        begin
            Hints := '';
            // Generate possible Quad combination
            for r := y to y+2 do
                for s := x to x+2 do
                    Hints := Hints + hint[r, s];
            Hints := MergeHint(Hints);


            for ThisCombo in GetCombination(Hints, 4) do
                if ThisCombo = '' then
                    break
                else
                begin
                    // If a cell contains anything other than the combination, it is ineligible for naked Quads
                    NakedQuadCount := 0;
                    SubgridCellID := 0;
                    for r := y to y+2 do
                        for s := x to x+2 do
                        begin
                            NakedQuadCells[SubgridCellID] := false;
                            ThisCell := hint[r, s];

                            if ThisCell <> '' then
                            begin
                                for q := 1 to 4 do
                                    ThisCell := SBA_RemoveAt(ThisCell, pos(ThisCombo[q], ThisCell));

                                if length(ThisCell) = 0 then
                                begin
                                    NakedQuadCells[SubgridCellID] := true;
                                    NakedQuadCount := NakedQuadCount + 1;
                                end;
                            end;
                            SubgridCellID := SubgridCellID + 1;
                        end;

                        // Remove hints in the same subgrid
                        if NakedQuadCount = 4 then
                        begin
                            SubgridCellID := 0;
                            for r := y to y+2 do
                                for s := x to x+2 do
                                begin
                                    if (not NakedQuadCells[SubgridCellID]) and (hint[r, s] <> '') then
                                    begin
                                        OldHint := hint[r, s];
                                        for q := 1 to 4 do
                                            hint[r, s] := SBA_RemoveAt(hint[r, s], pos(ThisCombo[q], hint[r, s]));

                                        if hint[r, s] <> OldHint then
                                        begin
                                            HasRemoved := true;
                                            HasEverRemoved := true;
                                        end;
                                    end;

                                    SubgridCellID := SubgridCellID + 1;
                                end;

                            if HasRemoved then
                                WriteStepHint(fileHandler, y, x, 'Naked  Quad', '-['+ThisCombo+'] due to sub '+IntToStr((3*(r div 3)+(s div 3))));
                        end;
                end;

            x := x + 3;
        end;
        y := y + 3;
        x := 0;
    end;  

    RemoveHint := HasEverRemoved;
end;

end.
