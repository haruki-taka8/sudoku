unit ioGrid;

interface
uses types, auxiliary, crt;
procedure ReadGrid (var grid : TIntegerGrid; var given : TBooleanGrid; InputMode, InputFile : string);
procedure WriteResult (InputGrid : TIntegerGrid; InputGiven : TBooleanGrid; Theme : string);
procedure WriteGrid (InputGrid : TIntegerGrid; InputGiven : TBooleanGrid; YOffset, XOffset : integer);

implementation
procedure ReadGrid (var grid : TIntegerGrid; var given : TBooleanGrid; InputMode, InputFile : string);
var x, y, i : integer;
    ThisLine : string;
    InputHandler : Text;

begin
    // Returns Grid and Given
    
    // If pascal has something like $a, $b = 1, 2
    // it will be easier to pass by value rather than ref
    if InputFile <> 'stdin' then
    begin
        assign(InputHandler, InputFile);
        reset(InputHandler);
    end;

    for y := 0 to 8 do
        for x := 0 to 8 do
            grid[y, x] := 0;

    if InputFile = 'stdin' then
        writeln('Input unsolved sudoku board (', InputMode, ' mode)');

    if InputMode = 'Space' then
        for y := 0 to 8 do
            for x := 0 to 8 do
            begin
                if InputFile = 'stdin' then
                    read(grid[y, x])
                else
                    read(InputHandler, grid[y, x]);
                given[y, x] := grid[y, x] <> 0;
            end
                
    else if InputMode = 'Continuous' then
    begin
        if InputFile = 'stdin' then
            read(ThisLine)
        else
            read(InputHandler, ThisLine);

        // Sanitize input ([ .] -> 0)
        for i := 1 to length(ThisLine) do
            if (ThisLine[i] = ' ') or (ThisLine[i] = '.') then
                ThisLine[i] := '0';

        y := 0;
        x := 0;
        for i := 1 to length(ThisLine) do
        begin
            grid[y, x] := SBA_StrToInt(ThisLine[i]);
            given[y, x] := grid[y, x] <> 0;

            x := x + 1;
            if x >= 9 then
            begin
                x := 0;
                y := y + 1;
            end;
        end;
    end;

    if InputFile <> 'stdin' then
        close(InputHandler);
end;

procedure WriteResult (InputGrid : TIntegerGrid; InputGiven : TBooleanGrid; Theme : string);
begin
    ClrScr;
    if Theme = 'Plain' then
        WriteGrid(InputGrid, InputGiven, 1, 1)

    else if Theme = 'Switch' then
    begin
        textColor(Red);
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
        WriteGrid(InputGrid, InputGiven, 2, 28);

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
    else if Theme = 'E257' then
    begin    
        TextColor(DarkGray);
        TextColor(DarkGray);
    GotoXY(1,1);
    writeln('E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMI');
    writeln('T                         E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRES');
    writeln('S  6 4 1 | 3 8 5 | 2 7 9  TEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO');
    writeln('&  9 5 2 | 1 7 6 | 4 3 8  S#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E');
    writeln('2  7 3 8 | 2 9 4 | 5 6 1  &SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMIT');
    writeln('E  ------+-------+------  257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS');
    writeln('#  1 2 6 | 4 5 7 | 9 8 3  EDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&');
    writeln('S  8 7 5 | 9 2 3 | 1 4 6  #ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E2');
    writeln('5  3 9 4 | 8 6 1 | 7 2 5  SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITE');
    writeln('D  ------+-------+------  57#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#');
    writeln('O  4 1 7 | 6 3 9 | 8 5 2  DEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&S');
    writeln('H  5 8 3 | 7 1 2 | 6 9 4  ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E25');
    writeln('7  2 6 9 | 5 4 8 | 3 1 7  HONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITED');
    writeln('E                         7#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#O');
    writeln('DORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SH');
    
    TextColor(Blue);
    GotoXY(27,4);
    write('S#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E');
    GotoXY(27,5);
    write('&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMIT');
    GotoXY(27,6);
    write('257#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS');
    GotoXY(27,7);
    write('E+-------------------------------------------------+&');
    GotoXY(27,8);
    write('#|                                                 |2');
    GotoXY(29,8);
    TextColor(White);
    write('   E257-2000  Limited Express Odoriko & Shonan');
    TextColor(Blue);
    GotoXY(27,9);
    write('S+-------------------------------------------------+E');
    GotoXY(27,10);
    write('57#LIMITEDEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#');
    GotoXY(27,11);
    write('DEXPRESS#ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&S');
    GotoXY(27,12);
    write('ODORIKO&SHONAN#E257#LIMITEDEXPRESS#ODORIKO&SHONAN#E25');
    GotoXY(1,4);
    write('&');
    GotoXY(1,5);
    write('2');
    GotoXY(1,7);
    write('#');
    GotoXY(1,8);
    write('S');
    GotoXY(1,9);
    write('5');
    GotoXY(1,11);
    write('O');
    GotoXY(1,12);
    write('H');

    WriteGrid(InputGrid, InputGiven, 3, 4);
    
    TextColor(Blue);
    GotoXY(1,6);
    write('E  ------+-------+------');
    GotoXY(1,10);
    write('D  ------+-------+------');

        
    end;
    GotoXY(1,17);
end;

procedure WriteGrid (InputGrid : TIntegerGrid; InputGiven : TBooleanGrid; YOffset, XOffset : integer);
var x, y : integer;

begin
    // Prints the grid   
    TextColor(White);
    for y := 0 to 8 do
    begin
        GotoXY(XOffset, YOffset);
        for x := 0 to 8 do
        begin
            if InputGrid[y, x] = 0 then
                write('. ')
            else
                if InputGiven[y, x] then
                    write(InputGrid[y, x], ' ')
                else
                begin
                    TextColor(Yellow);
                    write(InputGrid[y, x], ' ');
                    TextColor(White);
                end;

            if ((x = 2) or (x = 5)) then write('| ');
        end;
        YOffset := YOffset + 1;
     
        if ((y = 2) or (y = 5)) then
        begin
            writeln;
            GotoXY(XOffset, YOffset);
            writeln('------+-------+------');
            YOffset := YOffset + 1;
        end
        else
            writeln;
    end;
end;

end.
