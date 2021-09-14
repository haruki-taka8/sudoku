unit Triple;

interface
type threeCombination = array [0..83] of string;

function MergeHint (HintsInHouse : string) : string;
function GetThreeCombination (Input : string) : threeCombination;

implementation
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

end.