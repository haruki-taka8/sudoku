unit HiddenQuad;

interface
uses combination, types, auxiliary, io, sysutils;
function RemoveHint (var hint : TStringGrid) : boolean;

implementation
function RemoveHint (var hint : TStringGrid) : boolean;
var y, x, p, r, s, HiddenQuadCount, SubgridCellID : integer;
    Hints, ThisCombo, ThisCell, ThisLetter : string;
    IsHiddenQuad : array [0..8] of boolean;
    HasRemoved, HasEverRemoved : boolean;
begin
    HasEverRemoved := false;

    // Row
    y := 0;
    x := 0;
    HasRemoved := false;
    for y := 0 to 8 do
    begin
        Hints := '';

        // Generate possible Quad combination
        for p := 0 to 8 do Hints := Hints + hint[y, p];
        Hints := MergeHint(Hints);

        for ThisCombo in GetCombination(Hints, 4) do
            if ThisCombo = '' then
                break
            else
            begin
                HiddenQuadCount := 0;

                // If a cell in a house contains ThisCombo, the cell is eligible for hidden Quads
                for p := 0 to 8 do
                begin
                    IsHiddenQuad[p] := false;
                    if (pos(ThisCombo[1], hint[y, p]) <> 0) or
                       (pos(ThisCombo[2], hint[y, p]) <> 0) or
                       (pos(ThisCombo[3], hint[y, p]) <> 0) or
                       (pos(ThisCombo[4], hint[y, p]) <> 0) then
                    begin
                        HiddenQuadCount := HiddenQuadCount + 1;
                        IsHiddenQuad[p] := true;
                    end;
                end;

                // Remove other hints in cells where IsHiddenQuad[p] are TRUE
                if HiddenQuadCount = 4 then
                begin
                    for p := 0 to 8 do
                        if IsHiddenQuad[p] then
                        begin
                            ThisCell := '';
                            for ThisLetter in ThisCombo do
                                if pos(ThisLetter, hint[y, p]) <> 0 then ThisCell := ThisCell + ThisLetter;

                            if hint[y, p] <> ThisCell then
                            begin
                                HasRemoved := true;
                                HasEverRemoved := true;
                                hint[y, p] := ThisCell;
                            end;
                        end;

                    if HasRemoved then
                        WriteStepHint(fileHandler, y, x, 'Hidden Quad', '-[^'+ThisCombo+'] for row '+IntToStr(y));
                end;
            end;
    end;

    // Column
    y := 0;
    x := 0;
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
                HiddenQuadCount := 0;

                // If a cell in a house contains ThisCombo, the cell is eligible for hidden Quads
                for p := 0 to 8 do
                begin
                    IsHiddenQuad[p] := false;
                    if (pos(ThisCombo[1], hint[p, x]) <> 0) or
                       (pos(ThisCombo[2], hint[p, x]) <> 0) or
                       (pos(ThisCombo[3], hint[p, x]) <> 0) or
                       (pos(ThisCombo[4], hint[p, x]) <> 0) then
                    begin
                        HiddenQuadCount := HiddenQuadCount + 1;
                        IsHiddenQuad[p] := true;
                    end;
                end;

                // Remove other hints in cells where IsHiddenQuad[p] are TRUE
                if HiddenQuadCount = 4 then
                begin
                    for p := 0 to 8 do
                        if IsHiddenQuad[p] then
                        begin
                            ThisCell := '';
                            for ThisLetter in ThisCombo do
                                if pos(ThisLetter, hint[p, x]) <> 0 then ThisCell := ThisCell + ThisLetter;
                            
                            if hint[p, x] <> ThisCell then
                            begin
                                HasRemoved := true;
                                HasEverRemoved := true;
                                hint[p, x] := ThisCell;    
                            end;                    
                        end;

                    if HasRemoved then
                        WriteStepHint(fileHandler, y, x, 'Hidden Quad', '-[^'+ThisCombo+'] for col '+IntToStr(x));
                end;
            end;
    end;


    // Subgrid
    y := 0;
    x := 0;
    HasRemoved := false;
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
                    HiddenQuadCount := 0;
                    SubgridCellID := 0;

                    // If a cell in a house contains ThisCombo, the cell is eligible for hidden Quads
                    for r := y to y+2 do
                        for s := x to x+2 do
                        begin
                            IsHiddenQuad[SubgridCellID] := false;
                            if (pos(ThisCombo[1], hint[r, s]) <> 0) or
                               (pos(ThisCombo[2], hint[r, s]) <> 0) or
                               (pos(ThisCombo[3], hint[r, s]) <> 0) or
                               (pos(ThisCombo[4], hint[r, s]) <> 0) then
                            begin
                                HiddenQuadCount := HiddenQuadCount + 1;
                                IsHiddenQuad[SubgridCellID] := true;
                            end;
                            SubgridCellID := SubgridCellID + 1;
                        end;

                    // Remove other hints in cells where IsHiddenQuad[p] are TRUE
                    if HiddenQuadCount = 4 then
                    begin
                        SubgridCellID := 0;
                        for r := y to y+2 do
                            for s := x to x+2 do
                            begin
                                if IsHiddenQuad[SubgridCellID] then
                                begin
                                    ThisCell := '';
                                    for ThisLetter in ThisCombo do
                                        if pos(ThisLetter, hint[r, s]) <> 0 then ThisCell := ThisCell + ThisLetter;

                                    if hint[r, s] <> ThisCell then
                                    begin
                                        HasRemoved := true;
                                        HasEverRemoved := true;
                                        hint[r, s] := ThisCell;    
                                    end;                    
                                end;
                                SubgridCellID := SubgridCellID + 1;
                            end;

                        if HasRemoved then
                            WriteStepHint(fileHandler, y, x, 'Hidden Quad', '-[^'+ThisCombo+'] for sub '+IntToStr((3*(r div 3)+(s div 3))));
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
