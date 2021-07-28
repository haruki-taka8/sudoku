PROGRAM Solve_Sudoku_2;
CONST VERBOSE = TRUE;    // Set TRUE to display actions done on each step
      THEME   = 'Plain'; // Plain, Switch, E257
TYPE
    // Types because Pascal doesn't accept
    // directly writing types onto function headers
    TIntegerGrid = array [0..8, 0..8] of integer;
    TStringGrid  = array [0..8, 0..8] of string;

VAR
    // Global variables, use with caution
    grid    : TIntegerGrid;
    oldGrid : TIntegerGrid;
    hint    : TStringGrid;


// Auxiliary functions because Pascal has poor type support
// If done in a .NET-compatible language, these functions are not required
//      SBA_RemoveAt => '0123456'.Remove(at, 1)
//      SBA_StrToInt => [Convert]::ToInt16('str')  or  [Int] 'str'
//      SBA_IntToStr => [String] int               or  "int"
FUNCTION SBA_RemoveAt (Input : string; Position : integer) : string;
BEGIN
    SBA_RemoveAt := copy(Input, 1, Position-1) + copy(Input, Position+1, 8);
END;

FUNCTION SBA_StrToInt (Input : string) : integer;
VAR temp, code : integer;
BEGIN
    Val(Input, temp, code);
    code := code; // To suppress compiler warning
    SBA_StrToInt := temp;
END;

FUNCTION SBA_IntToStr (Input : integer) : string;
VAR temp : string;
BEGIN
    Str(Input, temp);
    SBA_IntToStr := temp;
END;



PROCEDURE ReadGrid (var grid: TIntegerGrid);
VAR x, y : integer;
BEGIN
    // Returns Grid (and in the future, Given)
    
    // If pascal has something like $a, $b = 1, 2
    // it will be easier to pass by value rather than ref

    for y := 0 to 8 do
        for x := 0 to 8 do
            read(grid[y, x]);
END;

PROCEDURE WriteGrid (InputGrid : TIntegerGrid);
VAR x, y : integer;
BEGIN
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
END;



FUNCTION IsSolved (InputGrid : TIntegerGrid) : boolean;
VAR x, y : integer;
    result : boolean;
BEGIN
    // Returns a boolean indicating whether the board is solved

    result := true;
    for y := 0 to 8 do
        for x := 0 to 8 do
            if InputGrid[y, x] = 0 then
            begin
                result := false;
                break;
            end;
    IsSolved := result;
END;

FUNCTION IsRepeated (InputGrid, InputOldGrid: TIntegerGrid) : boolean;
VAR x, y : integer;
    result : boolean;
BEGIN
    // Returns a boolean indicating whether the two grids are identical
    
    result := true;
    for y := 0 to 8 do
        for x := 0 to 8 do
            if InputGrid[y, x] <> InputOldGrid[y, x] then
            begin
                result := false;
                break;
            end;
    IsRepeated := result;
END;



PROCEDURE GetHint (InputGrid : TIntegerGrid; var hint : TStringGrid);
VAR x, y, p, q, thisCellY, thisCellX, HintPos : integer;
BEGIN
    // Returns a TStringGrid of hints given a TIntegerGrid

    // Defaults
    for y := 0 to 8 do
        for x := 0 to 8 do
            hint[y, x] := '123456789';

    for y := 0 to 8 do
        for x := 0 to 8 do
            if InputGrid[y, x] = 0 then
            begin
                // Elimination: Subgrid
                for p := 0 to 2 do
                    for q := 0 to 2 do
                    begin
                        thisCellY := 3 * (y div 3) + p;
                        thisCellX := 3 * (x div 3) + q;
                                    
                        if InputGrid[thisCellY, thisCellX] <> 0 then
                        begin
                            HintPos := pos(SBA_IntToStr(InputGrid[thisCellY, thisCellX]), hint[y, x]);
                            if HintPos <> 0 then hint[y, x] := SBA_RemoveAt(hint[y, x], HintPos);
                        end;
                    end;
                    
                // Elimination: Column
                for p := 0 to 8 do
                    if InputGrid[p, x] <> 0 then
                    begin
                        HintPos := pos(SBA_IntToStr(InputGrid[p, x]), hint[y, x]);
                        if HintPos <> 0 then hint[y, x] := SBA_RemoveAt(hint[y, x], HintPos);
                    end;
                            
                // Elimination: Row
                for p := 0 to 8 do
                    if InputGrid[y, p] <> 0 then
                    begin
                        HintPos := pos(SBA_IntToStr(InputGrid[y, p]), hint[y, x]);
                        if HintPos <> 0 then hint[y, x] := SBA_RemoveAt(hint[y, x], HintPos);
                    end;
            end
            else
                hint[y, x] := '';
END;

PROCEDURE WriteHint (InputHint : TStringGrid);
VAR x, y : integer;
BEGIN
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
END;

PROCEDURE RemoveNakedPairs (var hint : TStringGrid);
VAR x, y, p, r, s, u, PairX, PairY, SubX, SubY, PairSubX, PairSubY : integer;
    ThisX, ThisY : integer;
BEGIN
    for y := 0 to 8 do
        for x := 0 to 8 do
            if length(hint[y, x]) = 2 then
            begin
                // Elimination: Row (Horizontal matches)
                PairX := 0;
                PairY := 0;
                SubX := 0;
                SubY := 0;
                PairSubX := 0;
                PairSubY := 0;
                
                for p := 0 to 8 do
                    if (hint[y, x] = hint[y, p]) and (x <> p) then
                    begin
                        PairX := p;
                        PairY := y;
                        break;
                    end;
                
                if PairX <> 0 then
                begin
                    // Remove others from row
                    for p := 0 to 8 do
                        if (p <> x) and (p <> PairX) then
                        begin
                            if pos(hint[y, x][1], hint[y, p]) <> 0 then
                            begin
                                hint[y, p] := SBA_RemoveAt(hint[y, p], pos(hint[y, x][1], hint[y, p]));
                                
                                if VERBOSE then
                                    writeln('Remove ', hint[y, x][1], ' from (', y, ',', p, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), row-row, 0');
                            end;
                            if pos(hint[y, x][2], hint[y, p]) <> 0 then
                            begin
                                hint[y, p] := SBA_RemoveAt(hint[y, p], pos(hint[y, x][2], hint[y, p]));
                                
                                if VERBOSE then
                                    writeln('Remove ', hint[y, x][2], ' from (', y, ',', p, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), row-row, 1');
                            end;
                        end;
                        
                    // Remove others from subgrid
                    SubX := x div 3;
                    SubY := y div 3;
                    PairSubX := PairX div 3;
                    PairSubY := PairY div 3;
                    
                    if (SubX = PairSubX) and (SubY = PairSubY) then
                    begin
                        // The matched naked pair is within the same subgrid
                        // eliminate others from the same subgrid
                        for r := 0 to 2 do
                            for s := 0 to 2 do
                            begin
                                ThisX := 3 * SubX + s;
                                ThisY := 3 * SubY + r;
                                
                                if ((ThisX <> x) or (ThisY <> y)) and ((ThisX <> PairX) or (ThisY <> PairY)) then
                                begin
                                    if pos(hint[y, x][1], hint[ThisY, ThisX]) <> 0 then
                                    begin
                                        hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][1], hint[ThisY, ThisX]));
                                        
                                        if VERBOSE then
                                            writeln('Remove ', hint[y, x][1], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), row-sub, 0');
                                    end;
                                    if pos(hint[y, x][2], hint[ThisY, ThisX]) <> 0 then
                                    begin
                                        hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][2], hint[ThisY, ThisX]));
                                        
                                        if VERBOSE then
                                            writeln('Remove ', hint[y, x][2], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), row-sub, 1');
                                    end;
                                end;
                            end;
                    end;
                    
                end;
                    
                // Elimination: Column (Vertical matches)
                PairX := 0;
                PairY := 0;
                SubX := 0;
                SubY := 0;
                PairSubX := 0;
                PairSubY := 0;
                
                for p := 0 to 8 do
                    if (hint[y, x] = hint[p, x]) and (y <> p) then
                    begin
                        PairX := x;
                        PairY := p;
                        break;
                    end;
                
                if PairY <> 0 then
                begin
                    // Remove others from column
                    for p := 0 to 8 do
                        if (p <> y) and (p <> PairY) then
                        begin
                        
                            if pos(hint[y, x][1], hint[p, x]) <> 0 then
                            begin
                                hint[p, x] := SBA_RemoveAt(hint[p, x], pos(hint[y, x][1], hint[p, x]));
                                
                                if VERBOSE then
                                    writeln('Remove ', hint[y, x][1], ' from (', p, ',', x, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), col-col, 0');
                            end;
                            if pos(hint[y, x][2], hint[p, x]) <> 0 then
                            begin
                                hint[p, x] := SBA_RemoveAt(hint[p, x], pos(hint[y, x][2], hint[p, x]));
                                
                                if VERBOSE then
                                    writeln('Remove ', hint[y, x][2], ' from (', p, ',', x, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), col-col, 1');
                            end;
                        end;
                        
                    // Remove others from subgrid
                    SubX := x div 3;
                    SubY := y div 3;
                    PairSubX := PairX div 3;
                    PairSubY := PairY div 3;
                    
                    if (SubX = PairSubX) and (SubY = PairSubY) then
                    begin
                        // The matched naked pair is within the same subgrid
                        // eliminate others from the same subgrid
                        for r := 0 to 2 do
                            for s := 0 to 2 do
                            begin
                                ThisX := 3 * SubX + s;
                                ThisY := 3 * SubY + r;
                                
                                if ((ThisX <> x) or (ThisY <> y)) and ((ThisX <> PairX) or (ThisY <> PairY)) then
                                begin
                                    if pos(hint[y, x][1], hint[ThisY, ThisX]) <> 0 then
                                    begin
                                        hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][1], hint[ThisY, ThisX]));
                                        
                                        if VERBOSE then
                                            writeln('Remove ', hint[y, x][1], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), col-sub, 0');
                                    end;
                                    if pos(hint[y, x][2], hint[ThisY, ThisX]) <> 0 then
                                    begin
                                        hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][2], hint[ThisY, ThisX]));
                                        
                                        if VERBOSE then
                                            writeln('Remove ', hint[y, x][2], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), col-sub, 1');
                                    end;
                                end;
                            end;
                    end;
                end;
                
                // Elimination: Subgrid
                PairX := 0;
                PairY := 0;
                SubX := x div 3;
                SubY := y div 3;
                PairSubX := 0;
                PairSubY := 0;
                
                for r := 0 to 2 do
                    for s := 0 to 2 do
                    begin
                        ThisX := 3 * SubX + s;
                        ThisY := 3 * SubY + r;
                        
                        if (length(hint[ThisY, ThisX]) = 2) and (hint[ThisY, ThisX] = hint[y, x]) and ((ThisX <> x) or (ThisY <> y)) then
                        begin
                            PairX := ThisX;
                            PairY := ThisY;
                            break;
                        end;
                    end;
                    
                if PairX <> 0 then
                begin
                    for r := 0 to 2 do
                        for u := 0 to 2 do
                        begin
                            ThisX := 3 * SubX + s;
                            ThisY := 3 * SubY + r;
                            
                            if ((ThisX <> x) or (ThisY <> y)) and ((ThisX <> PairX) or (ThisY <> PairY)) then
                            begin
                                if pos(hint[y, x][1], hint[ThisY, ThisX]) <> 0 then
                                begin
                                    hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][1], hint[ThisY, ThisX]));
                                    
                                    if VERBOSE then
                                        writeln('Remove ', hint[y, x][1], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), sub-sub, 0');
                                end;
                                if pos(hint[y, x][2], hint[ThisY, ThisX]) <> 0 then
                                begin
                                    hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][2], hint[ThisY, ThisX]));
                                    
                                    if VERBOSE then
                                        writeln('Remove ', hint[y, x][2], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), sub-sub, 1');
                                end;
                            end;
                        end;
                end;
            end;
END;

PROCEDURE RemovePointingPair (var hint : TStringGrid);
VAR x, y, p, q, Number, NumberCount, ThisCellX, ThisCellY, LastX, LastY : integer;
BEGIN
    for y := 0 to 8 do
        for x := 0 to 8 do
        begin
            for Number := 1 to 9 do
            begin
                NumberCount := 0;
                
                // Elimination: Column
                for p := 0 to 2 do
                    for q := 0 to 2 do
                    begin
                        ThisCellY := 3 * (y div 3) + p;
                        ThisCellX := 3 * (x div 3) + q;
                        
                        if (pos(SBA_IntToStr(Number), hint[ThisCellY, ThisCellX]) <> 0) and (pos(SBA_IntToStr(Number), hint[y, x]) <> 0) then
                        begin
                            LastX := ThisCellX;
                            LastY := ThisCellY;
                            NumberCount := NumberCount + 1;
                        end;
                    end;
                
                if (NumberCount = 2) and (LastX = x) and (LastY <> y) then
                begin
                    for p := 0 to 8 do
                    begin
                        if ((p div 3) <> (LastY div 3)) and (pos(SBA_IntToStr(Number), hint[p, x]) <> 0) then
                        begin
                            hint[p, x] := SBA_RemoveAt(hint[p, x], pos(SBA_IntToStr(Number), hint[p, x]));
                            
                            if VERBOSE then
                                writeln('Remove ', Number, ' from (', p, ',', x, ') by pointing pair of (',y,',',x,') and (',LastY,',',LastX,'), col');  
                        end;
                    end;
                end;
                
                // Elimination: Row
                for p := 0 to 2 do
                    for q := 0 to 2 do
                    begin
                        ThisCellY := 3 * (y div 3) + p;
                        ThisCellX := 3 * (x div 3) + q;
                        
                        if (pos(SBA_IntToStr(Number), hint[ThisCellY, ThisCellX]) <> 0) and (pos(SBA_IntToStr(Number), hint[y, x]) <> 0) then
                        begin
                            LastX := ThisCellX;
                            LastY := ThisCellY;
                            NumberCount := NumberCount + 1;
                        end;
                    end;
                
                if (NumberCount = 2) and (LastX <> x) and (LastY = y) then
                begin
                    for p := 0 to 8 do
                    begin
                        if ((p div 3) <> (LastX div 3)) and (pos(SBA_IntToStr(Number), hint[y, p]) <> 0) then
                        begin
                            hint[y, p] := SBA_RemoveAt(hint[y, p], pos(SBA_IntToStr(Number), hint[y, p]));
                            
                            if VERBOSE then
                                writeln('Remove ', Number, ' from (', y, ',', p, ') by pointing pair of (',y,',',x,') and (',LastY,',',LastX,'), row');  
                        end;
                    end;
                end;
            end;
        end;
END;



// The following procedures with prefix Remove:
//   - Accepts two parameters:
//       var grid      : TIntegerGrid
//           InputHint : TStringGrid
//
//   - Returns a grid with action completed specified in
//     the procedure name

PROCEDURE RemoveNakedSingle (var grid : TIntegerGrid; InputHint : TStringGrid);
VAR x, y : integer;
BEGIN
    for y := 0 to 8 do
        for x := 0 to 8 do
            if (grid[y, x] = 0) and (length(InputHint[y, x]) = 1) then
            begin
                grid[y, x] := SBA_StrToInt(InputHint[y, x]);
                
                if VERBOSE then
                    writeln('Set (', y, ',', x, ') to ', hint[y, x], ' by naked single');
            end;
END;

PROCEDURE RemoveHiddenSingle (var grid : TIntegerGrid; InputHint : TStringGrid);
VAR x, y, p, q, r, s, ThisCellX, ThisCellY : integer;
    ThisHint : string;
    IsHiddenSingle : boolean;
BEGIN
    for y := 0 to 8 do
    begin
        for x := 0 to 8 do
        begin
            if grid[y, x] = 0 then
            begin
                for p := 1 to length(InputHint[y, x]) do
                begin
                    ThisHint := InputHint[y, x][p];
                    IsHiddenSingle := true;
                
                    // ELIMINATION: Column
                    for q := 0 to 8 do
                    if ((pos(ThisHint, InputHint[q, x]) <> 0) and (q <> y)) then
                    begin
                        IsHiddenSingle := false;
                        break;
                    end;
                        
                    if IsHiddenSingle then
                    begin
                    grid[y, x] := SBA_StrToInt(ThisHint);
                    if VERBOSE then
                        writeln('Set (', y, ',', x, ') to ', ThisHint, ' by hidden single, column');
                    break;
                    end;
                    IsHiddenSingle := true;
                        
                    // ELIMINATION: Row
                    for q := 0 to 8 do
                    if ((pos(ThisHint, InputHint[y, q]) <> 0) and (q <> x)) then
                    begin
                        IsHiddenSingle := false;
                        break;
                    end;
                        
                    if IsHiddenSingle then
                    begin
                    grid[y, x] := SBA_StrToInt(ThisHint);
                    if VERBOSE then
                        writeln('Set (', y, ',', x, ') to ', ThisHint, ' by hidden single, row');
                    break;
                    end;
                    IsHiddenSingle := true;
                        
                    // ELIMINATION: Subgrid
                    for r := 0 to 2 do
                    begin
                        for s := 0 to 2 do
                        begin
                            ThisCellY := 3 * (y div 3) + r;
                            ThisCellX := 3 * (x div 3) + s;
                            
                            if ((pos(ThisHint, hint[ThisCellY, ThisCellX]) <> 0) and ((ThisCellY <> y) or (ThisCellX <> x))) then
                            begin
                                IsHiddenSingle := false;
                                break;
                            end;
                        end;
                    end;
                    
                    if IsHiddenSingle then
                    begin
                        grid[y, x] := SBA_StrToInt(ThisHint);
                        if VERBOSE then
                            writeln('Set (', y, ',', x, ') to ', ThisHint, ' by hidden single, subgrid');
                        break;
                    end;
                end;
            end;
        end;
    end;
END;

PROCEDURE RemovedRemainingOfInt (var grid : TIntegerGrid; InputHint : TStringGrid);
VAR x, y, p, ThisPosX, ThisPosY : integer;
    PossibleX, PossibleY : string;
BEGIN
    for p := 1 to 9 do
    begin
        PossibleX := '012345678';
        PossibleY := '012345678';
        
        // Elminate impossible X and Y coordinates for digit p
        for y := 0 to 8 do
            for x := 0 to 8 do
                if grid[y, x] = p then
                begin
                    ThisPosY := pos(SBA_IntToStr(y), PossibleY);
                    ThisPosX := pos(SBA_IntToStr(x), PossibleX);
                    
                    if (ThisPosY <> 0) and (ThisPosX <> 0) then
                    begin
                        possibleY := SBA_RemoveAt(PossibleY, ThisPosY)
                    end;
                end;
        
        // If only one count of digit missing, locate the missing cell
        if ((length(PossibleY) = 1) and (length(PossibleX) = 1)) then
            begin
                grid[SBA_StrToInt(PossibleY), SBA_StrToInt(PossibleX)] := p;
                if VERBOSE then
                    writeln('Set (', PossibleY, ',', PossibleX, ') to ', p, ' by remaining 1 digit');
            end;
    end;
END;



BEGIN // Main
    ReadGrid(grid);
    
    
    // Solving loop
    while not IsSolved(grid) do
    begin
        oldGrid := grid;
        
        // Solve
        GetHint(grid, hint);
        RemoveNakedPairs(hint);
        RemovePointingPair(hint);
        
        
        RemoveNakedSingle(grid, hint);
        RemoveHiddenSingle(grid, hint);
        RemovedRemainingOfInt(grid, hint);
        
        
        // Repeatition Detection
        if VERBOSE then
            writeln;
        
        if IsRepeated(grid, oldGrid) then
        begin
            writeln;
            writeln('REPETITION DETECTED; BAILING!');
            break;
        end;
            
    end;
    
    WriteGrid(grid);
    if IsSolved(grid) then
        writeln('Solved!');
END.