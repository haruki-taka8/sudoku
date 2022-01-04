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
    
    for i := 0 to 125 do
    begin
        Output[i] := '';
        Output[i] := ''; // Reset twice, or Pascal won't clear the memory
    end;

    i := 0;

    if Width = 2 then
        for w := 1 to length(Input)-1 do
            for v := w+1 to length(Input) do
            begin
                Output[i] := Input[w]+Input[v];
                i := i+1;
            end

    else if Width = 3 then
        for x := 1 to length(Input)-2 do
            for w := x+1 to length(Input)-1 do
                for v := w+1 to length(Input) do
                begin
                    Output[i] := Input[x]+Input[w]+Input[v];
                    i := i+1;
                end

    else if Width = 4 then
        for y := 1 to length(Input)-3 do
            for x := y+1 to length(Input)-2 do
                for w := x+1 to length(Input)-1 do
                    for v := w+1 to length(Input) do
                    begin
                        Output[i] := Input[y]+Input[x]+Input[w]+Input[v];
                        i := i+1;
                    end;

    GetCombination := Output;
end;

end.
