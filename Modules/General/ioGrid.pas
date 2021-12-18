unit ioGrid;

interface
uses types, auxiliary, crt, sysutils;
procedure ReadGrid (var grid : TIntegerGrid; var given : TBooleanGrid);
procedure WriteResult (InputGrid : TIntegerGrid; InputGiven : TBooleanGrid; Theme : string; ToFile : boolean);
procedure WriteGrid (InputGrid : TIntegerGrid; InputGiven : TBooleanGrid; YOffset, XOffset : integer; ToFile : boolean);

implementation
procedure ReadGrid (var grid : TIntegerGrid; var given : TBooleanGrid);
var x, y, i : integer;
    ThisLine, ThisInput : string;
    HasPrinted : boolean;

begin
    // Returns Grid and Given
    ClrScr;
    TextColor(White);
    writeln('Input unsolved sudoku board, -1 to exit');

    // Read input
    HasPrinted := false;
    ThisInput := '';

    if ParamCount() = 4 then
        ThisInput := trim(ParamStr(4));

    while length(ThisInput) <> 81 do
    begin
        // Remove space
        ThisInput := StringReplace(ThisInput, ' ', '', [rfReplaceAll]);
        if length(ThisInput) = 81 then break;

        // Read extra input if needed
        if (not HasPrinted) and (ParamCount() = 4) then
        begin
            write(ParamStr(4));
            HasPrinted := true;
        end;

        readln(ThisLine);
        if ThisLine = '-1' then halt(2);
        ThisInput := ThisInput + ThisLine;
    end;

    // Convert to TIntegerGrid
    ClrScr;
    y := 0;
    x := 0;
    for i := 1 to 81 do
    begin            
        grid[y, x] := StrToIntDef(ThisInput[i], 0);
        given[y, x] := grid[y, x] <> 0;

        x := x + 1;
        if x >= 9 then
        begin
            x := 0;
            y := y + 1;
        end;
    end;
end;

procedure WriteResult (InputGrid : TIntegerGrid; InputGiven : TBooleanGrid; Theme : string; ToFile : boolean);
begin
    if Theme = 'plain' then WriteGrid(InputGrid, InputGiven, 1, 1, ToFile);
    GotoXY(1,17);
    TextColor(White);
end;

procedure WriteGrid (InputGrid : TIntegerGrid; InputGiven : TBooleanGrid; YOffset, XOffset : integer; ToFile : boolean);
var x, y : integer;

begin
    // Prints the grid to STDIN and file if VERBOSE
    if Config.Verbose and ToFile then writeln(fileHandler);

    TextColor(White);
    for y := 0 to 8 do
    begin
        GotoXY(XOffset, YOffset);
        for x := 0 to 8 do
        begin
            if InputGrid[y, x] = 0 then
            begin
                write('. ');

                if Config.Verbose and ToFile then write(fileHandler, '. ');
            end
            else
            begin
                if InputGiven[y, x] then
                    write(InputGrid[y, x], ' ')
                else
                begin
                    TextColor(Yellow);
                    write(InputGrid[y, x], ' ');
                    TextColor(White);
                end;

                if Config.Verbose and ToFile then write(fileHandler, InputGrid[y, x], ' ');
            end;
            if ((x = 2) or (x = 5)) then
            begin
                write('| ');

                if Config.Verbose and ToFile then write(fileHandler, '| ');
            end;
        end;
        YOffset := YOffset + 1;
     
        if ((y = 2) or (y = 5)) then
        begin
            writeln;
            GotoXY(XOffset, YOffset);
            writeln('------+-------+------');
            if Config.Verbose and ToFile then
            begin
                writeln(fileHandler);
                writeln(fileHandler, '------+-------+------');
            end;

            YOffset := YOffset + 1;
        end
        else
        begin
            writeln;
            if Config.Verbose and ToFile then writeln(fileHandler);
        end;
    end;

    // Write resultant board in without \s
    if Config.Verbose and ToFile then
    begin
        writeln(fileHandler);
        for y := 0 to 8 do
            for x := 0 to 8 do
                write(fileHandler, grid[y, x]);

        writeln(fileHandler);
    end;
end;

end.
