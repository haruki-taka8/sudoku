unit io;

interface
uses types;
procedure ReadGrid (var grid : TIntegerGrid);
procedure WriteGrid (InputGrid : TIntegerGrid);
procedure WriteHint (InputHint : TStringGrid);


implementation

procedure ReadGrid (var grid : TIntegerGrid);
var x, y : integer;
begin
    // Returns Grid (and in the future, Given)
    
    // If pascal has something like $a, $b = 1, 2
    // it will be easier to pass by value rather than ref

    for y := 0 to 8 do
        for x := 0 to 8 do
            read(grid[y, x]);
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
            write(InputHint[y, x]:(x+9));
            if ((x = 2) or (x = 5)) then write('|');
        end;
        
        if ((y = 2) or (y = 5)) then
        begin
            writeln;
            writeln('------------------------------+---------------------------------------+------------------------------------------------');
        end
        else
            writeln;
    end;
end;

end.