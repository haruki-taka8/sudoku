program sudoku;

uses
    types        in 'Modules\General\types.pas',
    auxiliary    in 'Modules\General\auxiliary.pas',
    io           in 'Modules\General\io.pas',
    endgame      in 'Modules\General\endgame.pas',      
    triple       in 'Modules\General\triple.pas',      
    GetHint      in 'Modules\General\getHint.pas',
    XWing        in 'Modules\Solving\xWing.pas',
    HiddenTriple in 'Modules\Solving\hiddenTriple.pas',
    NakedSingle  in 'Modules\Solving\nakedSingle.pas',
    NakedPair    in 'Modules\Solving\nakedPair.pas',
    HiddenSingle in 'Modules\Solving\hiddenSingle.pas',
    HiddenPair   in 'Modules\Solving\hiddenPair.pas',
    ClaimingPair in 'Modules\Solving\claimingPair.pas',
    NakedTriple  in 'Modules\Solving\nakedTriple.pas',
    Visual       in 'Modules\Solving\visual.pas',
    PointingPairTriple in 'Modules\Solving\pointingPairTriple.pas';

var
    // Global variables, use with caution
    grid    : TIntegerGrid;
    // oldGrid : TIntegerGrid;
    hint    : TStringGrid;
    i : integer;

begin
    verbose := FALSE;
    theme   := 'Switch';
    input   := 'Space';
    ReadConfiguration(verbose, theme, input);

    ReadGrid(grid, input);
    GetHint.GetHint(grid, hint);
    writeln;

    // Solving loop
    for i := 1 to 16 do
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
        PointingPairTriple.RemoveHint(hint);
        XWing.RemoveHint(hint);
        
        NakedSingle.SolveCell(grid, hint);
        HiddenSingle.SolveCell(grid, hint);
        Visual.SolveCell(grid, hint);
        
        if verbose then writeln;
        if IsSolved(grid) then break;
    end;
    
    WriteGrid(grid);
    if IsSolved(grid) then
        writeln('SOLVED! - ', i, ' steps used!')
    else
        WriteHint(hint);
end.