unit auxiliary;

interface
function SBA_RemoveAt (Input : string; Position : integer) : string;
function SBA_StrToInt (Input : string) : integer;
function SBA_IntToStr (Input : integer) : string;
function MergeHint (HintsInHouse : string) : string;

implementation
function SBA_RemoveAt (Input : string; Position : integer) : string;
var Result : string;
begin
    if Position = 0 then
        Result := Input
    else
        Result := copy(Input, 1, Position-1) + copy(Input, Position+1, 8);

    SBA_RemoveAt := Result;
end;

function SBA_StrToInt (Input : string) : integer;
var Temp, Code : integer;
begin
    Val(Input, Temp, Code);
    Code := Code; // Sorry, I have to suppress compiler warning
    SBA_StrToInt := Temp;
end;

function SBA_IntToStr (Input : integer) : string;
var Temp : string;
begin
    Str(Input, Temp);
    SBA_IntToStr := Temp;
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