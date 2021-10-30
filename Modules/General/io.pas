unit io;

interface
uses types, auxiliary;
procedure ReadConfiguration (var config : TConfiguration);
procedure WriteHint (var fileHandler : text; InputHint : TStringGrid);
procedure WriteStepCell (var fileHandler : text; y, x, Cell : integer; Algorithm, Details : string);
procedure WriteStepHint (var fileHandler : text; y, x : integer; Algorithm, Details : string);
procedure StartTranscript (var fileHandler : Text; InputGrid : TIntegerGrid);
procedure StopTranscript (var fileHandler : Text);


implementation
procedure ReadConfiguration (var config : TConfiguration);
var Defaults : text;
    ThisLine : string;
    DelimiterPos : integer;

begin
    Config.Interactive := FALSE;
    Config.Verbose     := FALSE;
    Config.Theme       := 'Switch';
    Config.Input       := 'Space';
    Config.InputFile   := 'stdin';

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
                Config.Verbose := pos('TRUE', ThisLine) <> 0

            else if copy(ThisLine, 1, 5) = 'theme' then
                Config.Theme := copy(ThisLine, DelimiterPos+1, 6)

            else if copy(ThisLine, 1, 11) = 'interactive' then
                Config.Interactive := pos('TRUE', ThisLine) <> 0

            else if copy(ThisLine, 1, 9) = 'inputFile' then
                Config.InputFile := copy(ThisLine, DelimiterPos+1, 10)

            else if copy(ThisLine, 1, 5) = 'input' then
                Config.Input := copy(ThisLine, DelimiterPos+1, 10);
        end;
    end;

    close(Defaults);
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
        Filename := Filename + SBA_IntToStr(InputGrid[0, i]);
    Filename := Filename + '.txt';

    assign(fileHandler, Filename);
    rewrite(fileHandler);
end;

procedure StopTranscript (var fileHandler : Text);
begin
    close(fileHandler);
end;

end.
