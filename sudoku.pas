program sudoku;

uses 
    types        in 'Modules\General\types.pas',
    auxiliary    in 'Modules\General\auxiliary.pas',
    io           in 'Modules\General\io.pas',
    endgame      in 'Modules\General\endgame.pas',      
    GetHint      in 'Modules\General\getHint.pas',
    HiddenTriple in 'Modules\Solving\hiddenTriple.pas',
    NakedSingle  in 'Modules\Solving\nakedSingle.pas',
    NakedPair    in 'Modules\Solving\nakedPair.pas',
    HiddenSingle in 'Modules\Solving\hiddenSingle.pas',
    HiddenPair   in 'Modules\Solving\hiddenPair.pas',
    PointingPair in 'Modules\Solving\pointingPair.pas',
    ClaimingPair in 'Modules\Solving\claimingPair.pas',
    NakedTriple  in 'Modules\Solving\nakedTriple.pas',
    Visual       in 'Modules\Solving\visual.pas';

var
    // Global variables, use with caution
    grid    : TIntegerGrid;
    // oldGrid : TIntegerGrid;
    hint    : TStringGrid;
    i : integer;

begin
    ReadGrid(grid);
    GetHint.GetHint(grid, hint);
    WriteHint(hint);

    // Solving loop
    // while not IsSolved(grid) do
    i := 0;
    while i < 16 do
    begin
        // oldGrid := grid;

        // Solve
        // Took me an hour to realize the Unit.Implementation convention
        // ALL ONLINE DOCUMENTATIONS ARE COMPLETELY WRONG!
        GetHint.RemoveSolved(grid, hint);
        
        HiddenPair.RemoveHint(hint);
        NakedPair.RemoveHint(hint);
        NakedTriple.RemoveHint(hint);
        HiddenTriple.RemoveHint(hint);
        ClaimingPair.RemoveHint(hint);
        PointingPair.RemoveHint(hint);
        
        NakedSingle.SolveCell(grid, hint);
        HiddenSingle.SolveCell(grid, hint);
        Visual.SolveCell(grid, hint);
        
        // Repeatition Detection
        if VERBOSE then writeln;
        
        // if IsRepeated(grid, oldGrid) then
        // begin
        //     WriteHint(hint);
        //     writeln;
        //     writeln('REPETITION DETECTED; BAILING!');
        //     break;
        // end;
        if IsSolved(grid) then break;

        i := i + 1;
    end;
    
    WriteGrid(grid);
    if IsSolved(grid) then
        writeln('SOLVED! - ', i, ' steps used!')
    else
        WriteHint(hint);
end.