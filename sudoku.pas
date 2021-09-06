program sudoku;

uses 
    types          in 'Modules\General\types.pas',
    auxiliary      in 'Modules\General\auxiliary.pas',
    io             in 'Modules\General\io.pas',
    endgame        in 'Modules\General\endgame.pas',      
    GetHint        in 'Modules\General\getHint.pas',     
    NakedPair      in 'Modules\Solving\nakedPair.pas',
    PointingPair   in 'Modules\Solving\pointingPair.pas',
    NakedSingle    in 'Modules\Solving\nakedSingle.pas',
    HiddenSingle   in 'Modules\Solving\hiddenSingle.pas',
    Visual         in 'Modules\Solving\visual.pas',
    HiddenPair     in 'Modules\Solving\HiddenPair.pas';

var
    // Global variables, use with caution
    grid    : TIntegerGrid;
    oldGrid : TIntegerGrid;
    hint    : TStringGrid;

begin
    ReadGrid(grid);
    GetHint.GetHint(grid, hint);
    
    // Solving loop
    while not IsSolved(grid) do
    begin
        oldGrid := grid;
        
        // Solve
        // Took me an hour to realize the Unit.Interface convention
        // ALL ONLINE DOCUMENTATIONS ARE COMPLETELY WRONG!
        GetHint.RemoveSolved(grid, hint);
        HiddenPair.RemoveHint(hint);
        NakedPair.RemoveHint(hint);
        PointingPair.RemoveHint(hint);
        
        NakedSingle.SolveCell(grid, hint);
        HiddenSingle.SolveCell(grid, hint);
        Visual.SolveCell(grid, hint);
        
        // Repeatition Detection
        if VERBOSE then writeln;
        
        if IsRepeated(grid, oldGrid) then
        begin
            WriteHint(hint);
            writeln;
            writeln('REPETITION DETECTED; BAILING!');
            break;
        end;
            
    end;
    
    WriteGrid(grid);
    if IsSolved(grid) then writeln('SOLVED!');
end.