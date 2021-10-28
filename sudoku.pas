program sudoku;

uses
    crt,
    auxiliary          in 'Modules\General\auxiliary.pas',
    combination        in 'Modules\General\combination.pas',
    endgame            in 'Modules\General\endgame.pas',
    GetHint            in 'Modules\General\getHint.pas',
    io                 in 'Modules\General\io.pas',
    ioGrid             in 'Modules\General\ioGrid.pas',
    types              in 'Modules\General\types.pas',
     
    NakedPair          in 'Modules\Solving\nakedPair.pas',
    HiddenPair         in 'Modules\Solving\hiddenPair.pas',
    NakedTriple        in 'Modules\Solving\nakedTriple.pas',
    HiddenTriple       in 'Modules\Solving\hiddenTriple.pas',
    PointingPairTriple in 'Modules\Solving\pointingPairTriple.pas',
    ClaimingPair       in 'Modules\Solving\claimingPair.pas',
    Wing               in 'Modules\Solving\wing.pas',
    XYWing             in 'Modules\Solving\xyWing.pas',
    XYZWing            in 'Modules\Solving\xyzWing.pas',

    NakedSingle        in 'Modules\Solving\nakedSingle.pas',
    HiddenSingle       in 'Modules\Solving\hiddenSingle.pas',
    Visual             in 'Modules\Solving\visual.pas';

begin
    ReadConfiguration(config);
    ReadGrid(grid, given, config.Input, config.InputFile);
    GetHint.GetHint(grid, hint);

    if Config.Verbose then StartTranscript(fileHandler, grid);
    // Solving loop
    while (true) do
    begin
        GetHint.RemoveSolved(grid, hint);
        
        if NakedSingle.SolveCell(grid, hint)   then continue;
        if HiddenSingle.SolveCell(grid, hint)  then continue;
        if Visual.SolveCell(grid, hint)        then continue;

        if NakedPair.RemoveHint(hint)          then continue;
        if HiddenPair.RemoveHint(hint)         then continue;
        if ClaimingPair.RemoveHint(hint)       then continue;
        if NakedTriple.RemoveHint(hint)        then continue;
        if HiddenTriple.RemoveHint(hint)       then continue;
        if PointingPairTriple.RemoveHint(hint) then continue;
        if Wing.RemoveHint(hint, 2)            then continue; // X-Wing
        if Wing.RemoveHint(hint, 3)            then continue; // Swordfish
        if Wing.RemoveHint(hint, 4)            then continue; // Jellyfish
        if XYWing.RemoveHint(hint)             then continue;
        if XYZWing.RemoveHint(hint)            then continue;
        break;
    end;

    WriteResult(grid, given, Config.Theme);

    if Config.Verbose then
    begin
        writeln(fileHandler);
        if IsSolved(grid) then
            writeln(fileHandler, 'Board is solved.')
        else
        begin
            writeln('Unable to solve board. Hints shown in log file.');
            writeln(fileHandler, 'Unable to solve board. Hints shown below.');
            writeln(fileHandler);
            WriteHint(fileHandler, hint);
        end;
        
        writeln(fileHandler);
        StopTranscript(fileHandler);
    end;
        
    write('Press ENTER to exit.');
    readln();
    readln(); // No clue why, but two readln; are required
end.
