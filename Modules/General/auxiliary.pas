unit auxiliary;

interface
function SBA_RemoveAt (Input : string; Position : integer) : string;
function SBA_StrToInt (Input : string) : integer;
function SBA_IntToStr (Input : integer) : string;
// function SBA_Contains (Input, Key : string) : boolean;
// function SBA_ContainsInt (Input : string; Key : integer) : boolean;

// Auxiliary functions because Pascal has poor type support
// If done in a .NET-compatible language, these functions are not required
//      SBA_RemoveAt => '0123456'.Remove(at, 1)
//      SBA_StrToInt => [Convert]::ToInt16('str')  or  [Int] 'str'
//      SBA_IntToStr => [String] int               or  "int"
// //     SBA_Contains(Int) => '0123456'.IndexOf('2') -ne 0

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

// function SBA_Contains (Input : string, Key : string) : boolean;
// begin
//     return (pos(Key, Input) <> 0);
// end;

// function SBA_ContainsInt (Input : string, Key : Integer) : boolean;
// begin
//     return (pos(SBA_IntToStr(Key), Input) <> 0);
// end;

end.