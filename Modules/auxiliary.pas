unit auxiliary;

interface
function SBA_RemoveAt (Input : string; Position : integer) : string;
function SBA_StrToInt (Input : string) : integer;
function SBA_IntToStr (Input : integer) : string;

// Auxiliary functions because Pascal has poor type support
// If done in a .NET-compatible language, these functions are not required
//      SBA_RemoveAt => '0123456'.Remove(at, 1)
//      SBA_StrToInt => [Convert]::ToInt16('str')  or  [Int] 'str'
//      SBA_IntToStr => [String] int               or  "int"


implementation

function SBA_RemoveAt (Input : string; Position : integer) : string;
begin
    SBA_RemoveAt := copy(Input, 1, Position-1) + copy(Input, Position+1, 8);
end;

function SBA_StrToInt (Input : string) : integer;
var Temp, Code : integer;
begin
    Val(Input, Temp, Code);
    Code := Code; // To suppress compiler warning
    SBA_StrToInt := Temp;
end;

function SBA_IntToStr (Input : integer) : string;
var Temp : string;
begin
    Str(Input, Temp);
    SBA_IntToStr := Temp;
end;

end.