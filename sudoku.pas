program sudoku;

uses
    crt,
    sysutils,
    auxiliary          in 'Modules\General\auxiliary.pas',
    combination        in 'Modules\General\combination.pas',
    endgame            in 'Modules\General\endgame.pas',
    GetHint            in 'Modules\General\getHint.pas',
    io                 in 'Modules\General\io.pas',
    ioGrid             in 'Modules\General\ioGrid.pas',
    types              in 'Modules\General\types.pas',
     
    NakedSingle        in 'Modules\Solving\nakedSingle.pas',
    HiddenSingle       in 'Modules\Solving\hiddenSingle.pas',
    Visual             in 'Modules\Solving\visual.pas',

    NakedPair          in 'Modules\Solving\nakedPair.pas',
    HiddenPair         in 'Modules\Solving\hiddenPair.pas',
    ClaimingPair       in 'Modules\Solving\claimingPair.pas',
    PointingPairTriple in 'Modules\Solving\pointingPairTriple.pas',
    NakedTriple        in 'Modules\Solving\nakedTriple.pas',
    HiddenTriple       in 'Modules\Solving\hiddenTriple.pas',
    NakedQuad          in 'Modules\Solving\nakedQuad.pas',
    HiddenQuad         in 'Modules\Solving\hiddenQuad.pas',
    Wing               in 'Modules\Solving\wing.pas',
    XYWing             in 'Modules\Solving\xyWing.pas',
    XYZWing            in 'Modules\Solving\xyzWing.pas';

begin
    ReadConfiguration(config);
    ReadGrid(grid, given);

    oldGrid := grid;
    GetHint.GetHint(grid, hint);

    if config.Verbose then StartTranscript(fileHandler, grid);
    
    // Solving loop
    while (true) do
    begin
        if config.Interactive and (not IsRepeated(oldGrid, Grid)) then
        begin
            WriteResult(grid, given, Config.Theme, FALSE);
            writeln;
            write('Press ENTER to go to next step.');
            readln;
        end;

        oldGrid := Grid;
        GetHint.RemoveSolved(grid, hint);
        
        if NakedSingle.SolveCell(grid, hint)   then continue;
        if HiddenSingle.SolveCell(grid, hint)  then continue;
        if Visual.SolveCell(grid, hint)        then continue;

        if NakedPair.RemoveHint(hint)          then continue;
        if HiddenPair.RemoveHint(hint)         then continue;
        if ClaimingPair.RemoveHint(hint)       then continue;
        if PointingPairTriple.RemoveHint(hint) then continue;
        if NakedTriple.RemoveHint(hint)        then continue;
        if HiddenTriple.RemoveHint(hint)       then continue;
        if NakedQuad.RemoveHint(hint)          then continue;
        if HiddenQuad.RemoveHint(hint)         then continue;
        if Wing.RemoveHint(hint, 2)            then continue; // X-Wing
        if Wing.RemoveHint(hint, 3)            then continue; // Swordfish
        if Wing.RemoveHint(hint, 4)            then continue; // Jellyfish
        if XYWing.RemoveHint(hint)             then continue;
        if XYZWing.RemoveHint(hint)            then continue;
        break;
    end;

    WriteResult(grid, given, Config.Theme, TRUE);

    if Config.Verbose then
    begin
        writeln(fileHandler);
        if IsSolved(grid) then
            writeln(fileHandler, 'Board is solved.')
        else
        begin
            writeln('Unable to solve the board. Hints shown in log file.');
            writeln(fileHandler, 'Unable to solve the board. Hints shown below.');
            writeln(fileHandler);
            WriteHint(fileHandler, hint);
        end;
        
        writeln(fileHandler);
        close(fileHandler);
    end;
        
    if ParamCount <> 4 then
    begin
        write('Press ENTER to exit.');
        readln();
    end;
end.
