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
    if Theme = 'plain' then
        WriteGrid(InputGrid, InputGiven, 1, 1, ToFile)

    else if Theme = 'switch' then
    begin
        textColor(Red);
        gotoXY(1,1);
        writeln('                                                              +-----------+');
        writeln('                                                              | +         |');
        writeln('                                                              |     X     |');
        writeln('                                                              |   Y   A   |');
        writeln('                                                              |     B     |');
        writeln('                                                              |           |');
        writeln('                                                              |           |');
        writeln('                                                              |     O     |');
        writeln('                                                              |           |');
        writeln('                                                              |  #        |');
        writeln('                                                              |           |');
        writeln('                                                              |           |');
        writeln('                                                              +-----------+');
    
        textColor(DarkGray);
        gotoXY(1,1);
        writeln('           ------------- SBA Sudoku - Switch Theme -----------');
        writeln('                           N E V | E R 0 | 0 0 0              ');                                                                                                                                                                                                                                   
        writeln('                           0 G O | N N A | 0 0 0              ');                                                                                                                                                                                                                                   
        writeln('                           0 0 G | I V E | 0 0 0              ');                                                                                                                                                                                                                                   
        writeln('                           ------+-------+------              ');                                                                                                                                                                                                                                   
        writeln('                           0 0 0 | Y O U | 0 0 0              ');                                                                                                                                                                                                                                   
        writeln('                           0 0 0 | 0 U P | 0 0 0              ');                                                                                                                                                                                                                                   
        writeln('                           0 0 0 | 0 0 0 | 0 0 0              ');                                                                                                                                                                                                                                   
        writeln('                           ------+-------+------              ');                                                                                                                                                                                                                                   
        writeln('                           0 0 0 | 0 0 0 | 0 0 0              ');                                                                                                                                                                                                                                   
        writeln('                           0 0 0 | 0 0 0 | 0 0 0              ');                                                                                                                                                                                                                                   
        writeln('                           0 0 0 | 0 0 0 | 0 0 0              ');
        writeln('           ---------------------------------------------------');
        WriteGrid(InputGrid, InputGiven, 2, 28, ToFile);

        textColor(Cyan);
        gotoXY(1,1);
        writeln('+-----------+');
        writeln('|         - |');
        writeln('|           |');
        writeln('|     O     |');
        writeln('|           |');
        writeln('|     ^     |');
        writeln('|   <   >   |');
        writeln('|     v     |');
        writeln('|           |');
        writeln('|        #  |');
        writeln('|           |');
        writeln('|           |');
        writeln('+-----------+');
        TextColor(LightGray); 
    end
    else if Theme = 'e257' then
    begin    
        TextColor(DarkGray);
        GotoXY(1,1);
        writeln('E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMI');
        writeln('T                         E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRES');
        writeln('S                         TEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO');
        GotoXY(1,13);
        writeln('7                         HONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITED');
        writeln('E                         7#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#O');
        writeln('DORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SH');

        TextColor(Blue);
        GotoXY(1,4);
        writeln('&                         S#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E');
        writeln('2                         &SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMIT');
        writeln('E                         257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS');
        writeln('#                         E+-------------------------------------------------+&');

        write('S                         #|                                                 |2');
        GotoXY(29,8);
        TextColor(White);
        write('   E257-2000  Limited Express Odoriko & Shonan');
        TextColor(Blue);

        GotoXY(1,9);
        writeln('5                         S+-------------------------------------------------+E');
        writeln('D                         57#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#');
        writeln('O                         DEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&S');
        writeln('H                         ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E25');

        WriteGrid(InputGrid, InputGiven, 3, 4, ToFile);

        TextColor(Blue);
        GotoXY(4,6);
        write('------+-------+------');
        GotoXY(4,10);
        write('------+-------+------');        
    end;
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
