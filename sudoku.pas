program sudoku;

uses
    crt,
    types        in 'Modules\General\types.pas',
    auxiliary    in 'Modules\General\auxiliary.pas',
    io           in 'Modules\General\io.pas',
    ioGrid       in 'Modules\General\ioGrid.pas',
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
    grid  : TIntegerGrid;
    given : TBooleanGrid;
    hint  : TStringGrid;
    i : integer;

begin
    verbose := FALSE;
    theme   := 'Switch';
    input   := 'Space';
    ReadConfiguration(verbose, theme, input);

    ClrScr;
    TextColor(White);
    ReadGrid(grid, given, input);
    GetHint.GetHint(grid, hint);
    writeln;

    if verbose then StartTranscript(fileHandler, grid);
    // Solving loop
    for i := 1 to 16 do
    begin
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

        if IsSolved(grid) then break;
    end;
    
    if verbose then
    begin
        writeln(fileHandler);
        if IsSolved(grid) then
            writeln(fileHandler, 'Solved in ', i, ' steps.')
        else
        begin
            writeln(fileHandler, 'Unable to solve board. Hints shown below.');
            writeln(fileHandler);
            WriteHint(fileHandler, hint);
        end;

        StopTranscript(fileHandler);
    end;
    
    WriteResult(grid, given, theme);
    
    if not IsSolved(grid) then
        writeln('Grid not solved, see log file for details.');
        
    writeln('Press ENTER to exit.');
    readln();
end.
