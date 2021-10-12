program sudoku;

uses
    crt,
    auxiliary          in 'Modules\General\auxiliary.pas',
    endgame            in 'Modules\General\endgame.pas',
    GetHint            in 'Modules\General\getHint.pas',
    io                 in 'Modules\General\io.pas',
    ioGrid             in 'Modules\General\ioGrid.pas',
    triple             in 'Modules\General\triple.pas',
    types              in 'Modules\General\types.pas',
     
    NakedPair          in 'Modules\Solving\nakedPair.pas',
    HiddenPair         in 'Modules\Solving\hiddenPair.pas',
    NakedTriple        in 'Modules\Solving\nakedTriple.pas',
    HiddenTriple       in 'Modules\Solving\hiddenTriple.pas',
    PointingPairTriple in 'Modules\Solving\pointingPairTriple.pas',
    ClaimingPair       in 'Modules\Solving\claimingPair.pas',
    XWing              in 'Modules\Solving\xWing.pas',
    XYWing             in 'Modules\Solving\xyWing.pas',
    XYZWing            in 'Modules\Solving\xyzWing.pas',
    Swordfish          in 'Modules\Solving\swordfish.pas',

    NakedSingle        in 'Modules\Solving\nakedSingle.pas',
    HiddenSingle       in 'Modules\Solving\hiddenSingle.pas',
    Visual             in 'Modules\Solving\visual.pas';

begin
    ReadConfiguration(config);
    ReadGrid(grid, given, config.Input, config.InputFile);
    GetHint.GetHint(grid, hint);

    if Config.Verbose then StartTranscript(fileHandler, grid);
    // Solving loop
    for i := 1 to 16 do
    begin
        // Solve
        // Took me an hour to realize the Unit.Implementation convention
        // ALL ONLINE DOCUMENTATIONS ARE COMPLETELY WRONG!
        GetHint.RemoveSolved(grid, hint);
        
        NakedPair.RemoveHint(hint);
        HiddenPair.RemoveHint(hint);
        NakedTriple.RemoveHint(hint);
        HiddenTriple.RemoveHint(hint);
        PointingPairTriple.RemoveHint(hint);
        ClaimingPair.RemoveHint(hint);
        XWing.RemoveHint(hint);
        XYWing.RemoveHint(hint);
        XYZWing.RemoveHint(hint);
        Swordfish.RemoveHint(hint);
        
        NakedSingle.SolveCell(grid, hint);
        HiddenSingle.SolveCell(grid, hint);
        Visual.SolveCell(grid, hint);

        if IsSolved(grid) then break;
    end;

    WriteResult(grid, given, Config.Theme);

    if Config.Verbose then
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
        
        writeln(fileHandler);
        StopTranscript(fileHandler);
    end;
        
    writeln('Press ENTER to exit.');
    readln();
    readln(); // No clue why, but two readln; are required
end.
