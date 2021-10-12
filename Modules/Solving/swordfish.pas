unit Swordfish;

interface
uses triple, types, auxiliary, io;
procedure RemoveHint (var hint : TStringGrid);

implementation
procedure RemoveHint (var hint : TStringGrid);
var y, x, i, j : integer;
    RemoveFrom, ThisBlock, ThisCombo, PossibleIndex : string;
    Possible : array [0..8] of string;
    PossibleCount : integer;
    HasRemoved : boolean;

begin
    // Row -> column
    for i := 1 to 9 do
    begin
        // Get all eligible rows
        HasRemoved := false;
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

            if (length(ThisBlock) >= 2) and (length(ThisBlock) <= 3) then
            begin
                Possible[y] := ThisBlock;
                PossibleIndex := PossibleIndex + SBA_IntToStr(y);
                PossibleCount := PossibleCount + 1;
            end;
        end;

        // Iterate through all possible combinations
        if PossibleCount >= 3 then
            for ThisCombo in GetThreeCombination(PossibleIndex) do
                if ThisCombo = '' then
                    break
                else
                begin
                    RemoveFrom := '';
                    for j := 1 to 3 do
                        RemoveFrom := RemoveFrom + Possible[SBA_StrToInt(ThisCombo[j])];
                    RemoveFrom := MergeHint(RemoveFrom);    
                    

                    if length(RemoveFrom) = 3 then
                    begin
                        // Swordfish detected
                        for y := 0 to 8 do
                            if pos(SBA_IntToStr(y), ThisCombo) = 0 then
                                for x := 0 to 8 do
                                    if pos(SBA_IntToStr(x), RemoveFrom) <> 0 then
                                    begin
                                        if pos(SBA_IntToStr(i), hint[y, x]) <> 0 then HasRemoved := true;
                                        hint[y, x] := SBA_RemoveAt(hint[y, x], pos(SBA_IntToStr(i), hint[y, x]));
                                    end;
                    end;
                end;

        if HasRemoved then
            WriteStepHint(fileHandler, y, x, 'Swordfish', '-['+SBA_IntToStr(i)+'] for col due to rows '+ThisCombo);
    end;


    // Column -> row
    for i := 1 to 9 do
    begin
        // Get all eligible column
        HasRemoved := false;
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

            if (length(ThisBlock) >= 2) and (length(ThisBlock) <= 3) then
            begin
                Possible[x] := ThisBlock;
                PossibleIndex := PossibleIndex + SBA_IntToStr(x);
                PossibleCount := PossibleCount + 1;
            end;
        end;

        // Iterate through all possible combinations
        if PossibleCount >= 3 then
            for ThisCombo in GetThreeCombination(PossibleIndex) do
                if ThisCombo = '' then
                    break
                else
                begin
                    RemoveFrom := '';
                    for j := 1 to 3 do
                        RemoveFrom := RemoveFrom + Possible[SBA_StrToInt(ThisCombo[j])];
                    RemoveFrom := MergeHint(RemoveFrom);    
                    

                    if length(RemoveFrom) = 3 then
                    begin
                        // Swordfish detected
                        for x := 0 to 8 do
                            if pos(SBA_IntToStr(x), ThisCombo) = 0 then
                                for y := 0 to 8 do
                                if pos(SBA_IntToStr(y), RemoveFrom) <> 0 then
                                begin
                                    if pos(SBA_IntToStr(i), hint[y, x]) <> 0 then HasRemoved := true;
                                    hint[y, x] := SBA_RemoveAt(hint[y, x], pos(SBA_IntToStr(i), hint[y, x]));
                                end;
                    end;
                end;

        if HasRemoved then
            WriteStepHint(fileHandler, y, x, 'Swordfish', '-['+SBA_IntToStr(i)+'] for row due to columns '+ThisCombo);
    end;
end;

end.