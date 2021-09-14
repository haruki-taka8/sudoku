unit io;

interface
uses types, auxiliary;
procedure ReadConfiguration (var verbose : boolean; var theme, input : string);
procedure ReadGrid (var grid : TIntegerGrid; InputMode : string);
procedure WriteGrid (InputGrid : TIntegerGrid);
procedure WriteHint (InputHint : TStringGrid);
procedure WriteStepCell (y, x, Cell : integer; Algorithm, Details : string);
procedure WriteStepHint (y, x : integer; Algorithm, Details : string);


implementation

procedure ReadConfiguration (var verbose : boolean; var theme, input : string);
var Defaults : text;
    ThisLine : string;
    DelimiterPos : integer;

begin
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
            begin
                ThisLine := copy(ThisLine, DelimiterPos+1, 8);
                if ThisLine = 'TRUE' then
                    verbose := TRUE
                else
                    verbose := FALSE;
            end
            else if copy(ThisLine, 1, 5) = 'theme' then
                theme := copy(ThisLine, DelimiterPos+1, 6)

            else if copy(ThisLine, 1, 5) = 'input' then
                input := copy(ThisLine, DelimiterPos+1, 10);
        end;
    end;

    close(Defaults);
end;


procedure ReadGrid (var grid : TIntegerGrid; InputMode : string);
var x, y, i : integer;
    ThisLine : string;
begin
    // Returns Grid (and in the future, Given)
    
    // If pascal has something like $a, $b = 1, 2
    // it will be easier to pass by value rather than ref
    writeln('Input unsolved sudoku board (', InputMode, ' mode)');

    if InputMode = 'Space' then
    begin
        for y := 0 to 8 do
            for x := 0 to 8 do
                read(grid[y, x]);
        writeln('asdsadasdas');
    end
    else if InputMode = 'Continuous' then
    begin
        readln(ThisLine);

        // Sanitize input ([ .] -> 0)
        for i := 1 to length(ThisLine) do
            if (ThisLine[i] = ' ') or (ThisLine[i] = '.') then
                ThisLine[i] := '0';

        y := 0;
        x := 0;
        for i := 1 to length(ThisLine) do
        begin
            grid[y, x] := SBA_StrToInt(ThisLine[i]);

            x := x + 1;
            if x >= 9 then
            begin
                x := 0;
                y := y + 1;
            end;
        end;
    end;
end;

procedure WriteGrid (InputGrid : TIntegerGrid);
var x, y : integer;
begin
    // Prints the grid
    
    for y := 0 to 8 do
    begin
        for x := 0 to 8 do
        begin
            if InputGrid[y, x] = 0 then
                write('. ')
            else
                write(InputGrid[y, x], ' ');
            if ((x = 2) or (x = 5)) then write('| ');
        end;
        
        if ((y = 2) or (y = 5)) then
        begin
            writeln;
            writeln('------+-------+------');
        end
        else
            writeln;
    end;

    writeln;
    writeln;
end;

procedure WriteHint (InputHint : TStringGrid);
var x, y : integer;
begin
    // Debug function; not for production use
    
    writeln;
    for y := 0 to 8 do
    begin
        for x := 0 to 8 do
        begin
            write(InputHint[y, x]:(x+8));
            // write(InputHint[y, x],',');
            if ((x = 2) or (x = 5)) then write('|');
        end;
        
        if ((y = 2) or (y = 5)) then
        begin
            writeln;
            writeln('---------------------------+------------------------------------+---------------------------------------------');
        end
        else
            writeln;
    end;
end;


procedure WriteStepCell (y, x, Cell : integer; Algorithm, Details : string);
begin
    if verbose then
        writeln('(', y, ',', x, ') = ', Cell, ' | ', Algorithm, '    ', Details);
end;

procedure WriteStepHint (y, x : integer; Algorithm, Details : string);
begin
    if verbose then
        writeln('(', y, ',', x, ')     | ', Algorithm, '    ', Details);
end;

end.
