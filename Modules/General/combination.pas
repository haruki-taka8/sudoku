unit Combination;

interface
type TCombination = array [0..125] of string[4];

function GetCombination (Input : string; Width : integer) : TCombination;

implementation
function GetCombination (Input : string; Width : integer) : TCombination;
var y, x, w, v, i : integer;
    Output : TCombination;
begin
    // "Unassigned chars can have any content, depending on what was just in memory when the memory for the array was made available."
    // - https://wiki.freepascal.org/Character_and_string_types
    // This indicates a memory leak, so reset the Output array  :)
    // A FOR loop won't work :)
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
    Output[121] := '';
    Output[122] := '';
    Output[123] := '';
    Output[124] := '';
    Output[125] := '';

    i := 0;

    if Width = 2 then
    begin
        for w := 1 to length(Input)-1 do
            for v := w+1 to length(Input) do
            begin
                Output[i] := Input[w]+Input[v];
                i := i+1;
            end;
    end

    else if Width = 3 then
    begin
        for x := 1 to length(Input)-2 do
            for w := x+1 to length(Input)-1 do
                for v := w+1 to length(Input) do
                begin
                    Output[i] := Input[x]+Input[w]+Input[v];
                    i := i+1;
                end;
    end

    else if Width = 4 then
    begin
        for y := 1 to length(Input)-3 do
            for x := y+1 to length(Input)-2 do
                for w := x+1 to length(Input)-1 do
                    for v := w+1 to length(Input) do
                    begin
                        Output[i] := Input[y]+Input[x]+Input[w]+Input[v];
                        i := i+1;
                    end;
    end;

    GetCombination := Output;
end;

end.