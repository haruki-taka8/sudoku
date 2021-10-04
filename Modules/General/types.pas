unit types;

interface
type
    TIntegerGrid  = array [0..8, 0..8] of integer;
    TBooleanGrid  = array [0..8, 0..8] of boolean;
    TStringGrid   = array [0..8, 0..8] of string[9];

var
    verbose : boolean;
    theme, input, inputFile : string;
    fileHandler : Text;

implementation
end.