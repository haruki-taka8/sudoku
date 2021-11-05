unit wing;

interface
uses combination, types, auxiliary, io, sysutils;
function RemoveHint (var hint : TStringGrid; IntersectionCount : integer) : boolean;

implementation
function RemoveHint (var hint : TStringGrid; IntersectionCount : integer) : boolean;
var y, x, i, j : integer;
    RemoveFrom, ThisBlock, ThisCombo, PossibleIndex, Algorithm : string;
    Possible : array [0..8] of string;
    PossibleCount : integer;
    HasRemoved, HasEverRemoved : boolean;

begin
    case IntersectionCount of
        2 : Algorithm := 'X-Wing';
        3 : Algorithm := 'Swordfish';
        4 : Algorithm := 'Jellyfish';
    end;
    HasEverRemoved := false;

    // Row -> column
    for i := 1 to 9 do
    begin
        // Get all eligible rows
        PossibleCount := 0;
        PossibleIndex := '';
        for y := 0 to 8 do
            Possible[y] := '';

        for y := 0 to 8 do
        begin
            ThisBlock := '';
            for x := 0 to 8 do
                if pos(IntToStr(i), hint[y, x]) <> 0 then
                    ThisBlock := ThisBlock + IntToStr(x);

            if (length(ThisBlock) >= 2) and (length(ThisBlock) <= IntersectionCount) then
            begin
                Possible[y] := ThisBlock;
                PossibleIndex := PossibleIndex + IntToStr(y);
                PossibleCount := PossibleCount + 1;
            end;
        end;

        // Iterate through all possible combinations
        if PossibleCount >= IntersectionCount then
            for ThisCombo in GetCombination(PossibleIndex, IntersectionCount) do
                if ThisCombo = '' then
                    break
                else
                begin
                    HasRemoved := false;
                    RemoveFrom := Possible[StrToInt(ThisCombo[1])];
                    for j := 2 to IntersectionCount do
                        RemoveFrom := RemoveFrom + Possible[StrToInt(ThisCombo[j])];
                    RemoveFrom := MergeHint(RemoveFrom);    
                    
                    if length(RemoveFrom) = IntersectionCount then
                    begin
                        // X-Wing/Swordfish/Jellyfish detected
                        for y := 0 to 8 do
                            if pos(IntToStr(y), ThisCombo) = 0 then
                                for x := 0 to 8 do
                                    if pos(IntToStr(x), RemoveFrom) <> 0 then
                                    begin
                                        if pos(IntToStr(i), hint[y, x]) <> 0 then
                                        begin
                                            HasRemoved := true;
                                            HasEverRemoved := true;
                                        end;
                                        hint[y, x] := SBA_RemoveAt(hint[y, x], pos(IntToStr(i), hint[y, x]));
                                    end;
                    end;

                    if HasRemoved then
                        WriteStepHint(fileHandler, y, x, Algorithm, '-['+IntToStr(i)+'] for col ['+RemoveFrom+'] due to row ['+ThisCombo+']');
                end;
    end;


    // Column -> row
    for i := 1 to 9 do
    begin
        // Get all eligible column
        HasRemoved    := false;
        PossibleCount := 0;
        PossibleIndex := '';
        for x := 0 to 8 do
            Possible[x] := '';

        for x := 0 to 8 do
        begin
            ThisBlock := '';
            for y := 0 to 8 do
                if pos(IntToStr(i), hint[y, x]) <> 0 then
                    ThisBlock := ThisBlock + IntToStr(y);

            if (length(ThisBlock) = 2) and (length(ThisBlock) <= IntersectionCount) then
            begin
                Possible[x] := ThisBlock;
                PossibleIndex := PossibleIndex + IntToStr(x);
                PossibleCount := PossibleCount + 1;
            end;
        end;

        // Iterate through all possible combinations
        if PossibleCount >= IntersectionCount then
            for ThisCombo in GetCombination(PossibleIndex, IntersectionCount) do
                if ThisCombo = '' then
                    break
                else
                begin
                    HasRemoved := false;
                    RemoveFrom := Possible[StrToInt(ThisCombo[1])];
                    for j := 2 to IntersectionCount do
                        RemoveFrom := RemoveFrom + Possible[StrToInt(ThisCombo[j])];
                    RemoveFrom := MergeHint(RemoveFrom);    
                    
                    if length(RemoveFrom) = IntersectionCount then
                    begin
                        // X-Wing/Swordfish/Jellyfish detected
                        for x := 0 to 8 do
                            if pos(IntToStr(x), ThisCombo) = 0 then
                                for y := 0 to 8 do
                                    if pos(IntToStr(y), RemoveFrom) <> 0 then
                                    begin
                                        if pos(IntToStr(i), hint[y, x]) <> 0 then
                                        begin
                                            HasRemoved := true;
                                            HasEverRemoved := true;
                                        end;
                                        hint[y, x] := SBA_RemoveAt(hint[y, x], pos(IntToStr(i), hint[y, x]));
                                    end;
                    end;

                    if HasRemoved then
                        WriteStepHint(fileHandler, y, x, Algorithm, '-['+IntToStr(i)+'] for row ['+RemoveFrom+'] due to col ['+ThisCombo+']');
                end;
    end;

    RemoveHint := HasEverRemoved;
end;

end.