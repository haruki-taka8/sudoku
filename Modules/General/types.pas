unit types;

interface
type
    TIntegerGrid  = array [0..8, 0..8] of integer;
    TBooleanGrid  = array [0..8, 0..8] of boolean;
    TStringGrid   = array [0..8, 0..8] of string[9];
    TConfiguration = record
        Verbose : boolean;
        Theme, Input, InputFile : string[16];
    end;

var
    // Global variables, use with caution
    i : integer;
    grid   : TIntegerGrid;
    given  : TBooleanGrid;
    hint   : TStringGrid;
    config : TConfiguration;
    fileHandler : Text;

implementation
end.