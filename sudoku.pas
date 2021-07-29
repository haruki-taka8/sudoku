program sudoku;

uses 
    types                in 'Modules\types.pas',
    auxiliary            in 'Modules\auxiliary.pas',
    io                   in 'Modules\io.pas',
    endgame              in 'Modules\endgame.pas',      
    getHint              in 'Modules\getHint.pas',     
    removeNakedPair      in 'Modules\removeNakedPair.pas',   
    removePointingPair   in 'Modules\removePointingPair.pas',
    removeNakedSingle    in 'Modules\removeNakedSingle.pas',
    removeHiddenSingle   in 'Modules\removeHiddenSingle.pas',
    removeRemainingOfInt in 'Modules\removeRemainingOfInt.pas';

var
    // Global variables, use with caution
    grid    : TIntegerGrid;
    oldGrid : TIntegerGrid;
    hint    : TStringGrid;

begin
    ReadGrid(grid);
    
    // Solving loop
    while not IsSolved(grid) do
    begin
        oldGrid := grid;
        
        // Solve
        // Took me an hour to realize the Unit.Interface convention
        // ALL ONLINE DOCUMENTATIONS ARE COMPLETELY WRONG!
        GetHint.GetHint(grid, hint);
        RemoveNakedPair.RemoveNakedPair(hint);
        RemovePointingPair.RemovePointingPair(hint);
        
        RemoveNakedSingle.RemoveNakedSingle(grid, hint);
        RemoveHiddenSingle.RemoveHiddenSingle(grid, hint);
        RemoveRemainingOfInt.RemoveRemainingOfInt(grid, hint);
        
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