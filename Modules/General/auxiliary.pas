unit auxiliary;

interface
function RemoveAt (Input : string; Position : integer) : string;
function MergeHint (HintsInHouse : string) : string;

implementation
function RemoveAt (Input : string; Position : integer) : string;
var Result : string;
begin
    if Position = 0 then
        Result := Input
    else
        Result := copy(Input, 1, Position-1) + copy(Input, Position+1, length(Input)-1);

    RemoveAt := Result;
end;

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


end.