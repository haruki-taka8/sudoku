unit io;

interface
uses types, auxiliary, sysutils;
procedure ReadConfiguration (var config : TConfiguration);
procedure WriteHint (var fileHandler : text; InputHint : TStringGrid);
procedure WriteStepCell (var fileHandler : text; y, x, Cell : integer; Algorithm, Details : string);
procedure WriteStepHint (var fileHandler : text; y, x : integer; Algorithm, Details : string);
procedure StartTranscript (var fileHandler : Text; InputGrid : TIntegerGrid);

implementation
procedure ReadConfiguration (var config : TConfiguration);
var Defaults : text;
    ThisLine : string;
    DelimiterPos : integer;

begin
    // Defaults
    Config.Interactive := FALSE;
    Config.Verbose     := FALSE;
    Config.Theme       := 'Switch';

    // Read from defaults.ini
    DelimiterPos := 0;
    assign(Defaults, 'defaults.ini');
    reset(Defaults);
    
    while not eof(Defaults) do
    begin
        readln(Defaults, ThisLine);

        DelimiterPos := pos('=', ThisLine);
        if DelimiterPos <> 0 then
        begin
            if copy(ThisLine, 1, 7) = 'verbose' then
                Config.Verbose := pos('TRUE', copy(ThisLine, DelimiterPos+1, 4)) <> 0

            else if copy(ThisLine, 1, 5) = 'theme' then
                Config.Theme := copy(ThisLine, DelimiterPos+1, 6)

            else if copy(ThisLine, 1, 11) = 'interactive' then
                Config.Interactive := pos('TRUE', copy(ThisLine, DelimiterPos+1, 4)) <> 0
        end;
    end;

    close(Defaults);

    // Read from command line arguments
    // sudoku.exe VERBOSE THEME INTERACTIVE SUDOKUGRID
    if ParamCount() = 4 then
    begin
        Config.Verbose     := pos('TRUE', ParamStr(1)) <> 0;
        Config.Theme       := ParamStr(2);
        Config.Interactive := pos('TRUE', ParamStr(3)) <> 0;
    end;
end;

procedure WriteHint (var fileHandler : text; InputHint : TStringGrid);
var x, y : integer;
begin    
    for y := 0 to 8 do
    begin
        for x := 0 to 8 do
        begin
            write(fileHandler, InputHint[y, x]:(x+8));
            if ((x = 2) or (x = 5)) then write(fileHandler, '|');
        end;
        
        if ((y = 2) or (y = 5)) then
        begin
            writeln(fileHandler);
            writeln(fileHandler, '---------------------------+------------------------------------+---------------------------------------------');
        end
        else
            writeln(fileHandler);
    end;
end;

procedure WriteStepCell (var fileHandler : text; y, x, Cell : integer; Algorithm, Details : string);
begin
    if Config.Verbose then
        writeln(fileHandler, '(', y, ',', x, ') = ', Cell, ' | ', Algorithm, '    ', Details);
end;

procedure WriteStepHint (var fileHandler : text; y, x : integer; Algorithm, Details : string);
begin
    if Config.Verbose then
        writeln(fileHandler, '(', y, ',', x, ')     | ', Algorithm, '    ', Details);
end;


procedure StartTranscript (var fileHandler : Text; InputGrid : TIntegerGrid);
var i : integer;
    Filename : string;
begin
    Filename := 'Sudoku_Steps_';
    for i := 0 to 8 do
        Filename := Filename + IntToStr(InputGrid[0, i]);
    Filename := Filename + '.txt';

    assign(fileHandler, Filename);
    rewrite(fileHandler);
end;

end.
