unit Jellyfish;

interface
uses triple, types, auxiliary, io;
procedure RemoveHint (var hint : TStringGrid);

implementation
type TFourCombination = array [0..125] of string;

function GetFourCombination (Input : string) : TFourCombination;
var y, x, w, v, i : integer;
    Output : TFourCombination;
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
    Output[84] := '';
    Output[85] := '';
    Output[86] := '';
    Output[87] := '';
    Output[88] := '';
    Output[89] := '';
    Output[90] := '';
    Output[91] := '';
    Output[92] := '';
    Output[93] := '';
    Output[94] := '';
    Output[95] := '';
    Output[96] := '';
    Output[97] := '';
    Output[98] := '';
    Output[99] := '';
    Output[100] := '';
    Output[101] := '';
    Output[102] := '';
    Output[103] := '';
    Output[104] := '';
    Output[105] := '';
    Output[106] := '';
    Output[107] := '';
    Output[108] := '';
    Output[109] := '';
    Output[110] := '';
    Output[111] := '';
    Output[112] := '';
    Output[113] := '';
    Output[114] := '';
    Output[115] := '';
    Output[116] := '';
    Output[117] := '';
    Output[118] := '';
    Output[119] := '';
    Output[120] := '';
    Output[120] := '';
    Output[121] := '';
    Output[122] := '';
    Output[123] := '';
    Output[124] := '';

    i := 0;
    for y := 1 to length(Input)-3 do
        for x := y+1 to length(Input)-2 do
            for w := x+1 to length(Input)-1 do
                for v := w+1 to length(Input) do
                begin
                    Output[i] := Input[y]+Input[x]+Input[w]+Input[v];
                    i := i+1
                end;
    GetFourCombination := Output;
end;

procedure RemoveHint (var hint : TStringGrid);
var y, x, i, j : integer;
    RemoveFrom, ThisBlock, ThisCombo, PossibleIndex, RemovedBlock : string;
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
        RemovedBlock := '';
        PossibleIndex := '';
        for y := 0 to 8 do
            Possible[y] := '';

        for y := 0 to 8 do
        begin
            ThisBlock := '';
            for x := 0 to 8 do
                if pos(SBA_IntToStr(i), hint[y, x]) <> 0 then
                    ThisBlock := ThisBlock + SBA_IntToStr(x);

            if (length(ThisBlock) >= 2) and (length(ThisBlock) <= 4) then
            begin
                Possible[y] := ThisBlock;
                PossibleIndex := PossibleIndex + SBA_IntToStr(y);
                PossibleCount := PossibleCount + 1;
            end;
        end;

        // Iterate through all possible combinations
        if PossibleCount >= 4 then
            for ThisCombo in GetFourCombination(PossibleIndex) do
                if ThisCombo = '' then
                    break
                else
                begin
                    RemoveFrom := '';
                    for j := 1 to 4 do
                        RemoveFrom := RemoveFrom + Possible[SBA_StrToInt(ThisCombo[j])];
                    RemoveFrom := MergeHint(RemoveFrom);    
                    
                    if length(RemoveFrom) = 4 then
                    begin
                        // Jellyfish detected
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
                        RemovedBlock := RemovedBlock + RemoveFrom;
                end;
        
        if HasRemoved then
            WriteStepHint(fileHandler, y, x, 'Jellyfish', '-['+SBA_IntToStr(i)+'] for col '+MergeHint(RemovedBlock)+' due to row '+ThisCombo);
    end;

    // Column -> row
    for i := 1 to 9 do
    begin
        // Get all eligible column
        HasRemoved := false;
        PossibleCount := 0;
        RemovedBlock := '';
        PossibleIndex := '';
        for x := 0 to 8 do
            Possible[x] := '';

        for x := 0 to 8 do
        begin
            ThisBlock := '';
            for y := 0 to 8 do
                if pos(SBA_IntToStr(i), hint[y, x]) <> 0 then
                    ThisBlock := ThisBlock + SBA_IntToStr(y);

            if (length(ThisBlock) >= 2) and (length(ThisBlock) <= 4) then
            begin
                Possible[x] := ThisBlock;
                PossibleIndex := PossibleIndex + SBA_IntToStr(x);
                PossibleCount := PossibleCount + 1;
            end;
        end;

        // Iterate through all possible combinations
        if PossibleCount >= 4 then
            for ThisCombo in GetFourCombination(PossibleIndex) do
                if ThisCombo = '' then
                    break
                else
                begin
                    RemoveFrom := '';
                    for j := 1 to 4 do
                        RemoveFrom := RemoveFrom + Possible[SBA_StrToInt(ThisCombo[j])];
                    RemoveFrom := MergeHint(RemoveFrom);    
                    

                    if length(RemoveFrom) = 4 then
                    begin
                        // Jellyfish detected
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
                        RemovedBlock := RemovedBlock + RemoveFrom;
                end;

        if HasRemoved then
            WriteStepHint(fileHandler, y, x, 'Jellyfish', '-['+SBA_IntToStr(i)+'] for row '+MergeHint(RemovedBlock)+' due to col '+ThisCombo);
    end;
end;

end.