unit wing;

interface
uses combination, types, auxiliary, io;
procedure RemoveHint (var hint : TStringGrid; IntersectionCount : integer);

implementation
procedure RemoveHint (var hint : TStringGrid; IntersectionCount : integer);
var y, x, i, j : integer;
    RemoveFrom, ThisBlock, ThisCombo, PossibleIndex, Algorithm : string;
    Possible : array [0..8] of string;
    PossibleCount : integer;
    HasRemoved : boolean;

begin
    case IntersectionCount of
        2 : Algorithm := 'X-Wing';
        3 : Algorithm := 'Swordfish';
        4 : Algorithm := 'Jellyfish';
    end;

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
                if pos(SBA_IntToStr(i), hint[y, x]) <> 0 then
                    ThisBlock := ThisBlock + SBA_IntToStr(x);

            if (length(ThisBlock) >= 2) and (length(ThisBlock) <= IntersectionCount) then
            begin
                Possible[y] := ThisBlock;
                PossibleIndex := PossibleIndex + SBA_IntToStr(y);
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
                    RemoveFrom := Possible[SBA_StrToInt(ThisCombo[1])];
                    for j := 2 to IntersectionCount do
                        RemoveFrom := RemoveFrom + Possible[SBA_StrToInt(ThisCombo[j])];
                    RemoveFrom := MergeHint(RemoveFrom);    
                    
                    if length(RemoveFrom) = IntersectionCount then
                    begin
                        // X-Wing/Swordfish/Jellyfish detected
                        for y := 0 to 8 do
                            if pos(SBA_IntToStr(y), ThisCombo) = 0 then
                                for x := 0 to 8 do
                                    if pos(SBA_IntToStr(x), RemoveFrom) <> 0 then
                                    begin
                                        if pos(SBA_IntToStr(i), hint[y, x]) <> 0 then HasRemoved := true;
                                        hint[y, x] := SBA_RemoveAt(hint[y, x], pos(SBA_IntToStr(i), hint[y, x]));
                                    end;
                    end;

                    if HasRemoved then
                        WriteStepHint(fileHandler, y, x, Algorithm, '-['+SBA_IntToStr(i)+'] for col ['+RemoveFrom+'] due to row ['+ThisCombo+']');
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
                if pos(SBA_IntToStr(i), hint[y, x]) <> 0 then
                    ThisBlock := ThisBlock + SBA_IntToStr(y);

            if (length(ThisBlock) = 2) and (length(ThisBlock) <= IntersectionCount) then
            begin
                Possible[x] := ThisBlock;
                PossibleIndex := PossibleIndex + SBA_IntToStr(x);
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
                    RemoveFrom := Possible[SBA_StrToInt(ThisCombo[1])];
                    for j := 2 to IntersectionCount do
                        RemoveFrom := RemoveFrom + Possible[SBA_StrToInt(ThisCombo[j])];
                    RemoveFrom := MergeHint(RemoveFrom);    
                    
                    if length(RemoveFrom) = IntersectionCount then
                    begin
                        // X-Wing/Swordfish/Jellyfish detected
                        for x := 0 to 8 do
                            if pos(SBA_IntToStr(x), ThisCombo) = 0 then
                                for y := 0 to 8 do
                                    if pos(SBA_IntToStr(y), RemoveFrom) <> 0 then
                                    begin
                                        if pos(SBA_IntToStr(i), hint[y, x]) <> 0 then HasRemoved := true;
                                        hint[y, x] := SBA_RemoveAt(hint[y, x], pos(SBA_IntToStr(i), hint[y, x]));
                                    end;
                    end;

                    if HasRemoved then
                        WriteStepHint(fileHandler, y, x, Algorithm, '-['+SBA_IntToStr(i)+'] for row ['+RemoveFrom+'] due to col ['+ThisCombo+']');
                end;
    end;
end;

end.