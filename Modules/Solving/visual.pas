unit visual;

interface
uses types, auxiliary, io;
function SolveCell (var grid : TIntegerGrid; InputHint : TStringGrid) : boolean;

// Remove visual, aka Visual Elimination or The Brady Bunch Technique.
// An upgrade of RemainingOfInt

implementation
function SolveCell (var grid: TIntegerGrid; InputHint : TStringGrid) : boolean;
var i, x, y, p, r, s, ThisX, ThisY, CandidateCount : integer;
    Candidates : TIntegerGrid;
    HasSolved : boolean;

begin
    HasSolved := false;
    for i := 1 to 9 do
    begin
        Candidates := Grid;
        for y := 0 to 8 do
            for x := 0 to 8 do
                if grid[y, x] = i then
                begin
                    // Remove from same row
                    for p := 0 to 8 do
                        if p <> x then
                            Candidates[y, p] := 999; // Set cell as incompatible with i

                    // Remove from same column
                    for p := 0 to 8 do
                        if p <> y then
                            Candidates[p, x] := 999;

                    // Remove from same subgrid
                    for r := 0 to 2 do
                        for s := 0 to 2 do
                        begin
                            ThisX := 3 * (x div 3) + s;
                            ThisY := 3 * (y div 3) + r;

                            if (ThisX <> x) or (ThisY <> y) then
                                Candidates[ThisY, ThisX] := 999;
                        end;
                end;

        // All possibilities are ({grid[y, x] = 0})
        for y := 0 to 8 do
            for x := 0 to 8 do
                if Candidates[y, x] = 0 then
                begin
                    // Check if only one possible cell for Number in subgrid
                    CandidateCount := 0;
                    for r := 0 to 2 do
                        for s := 0 to 2 do
                        begin
                            ThisX := 3 * (x div 3) + s;
                            ThisY := 3 * (y div 3) + r;

                            if grid[ThisY, ThisX] = 0 then
                                CandidateCount := CandidateCount + 1;
                        end;

                    if CandidateCount = 1 then
                    begin
                        grid[y, x] := i;
                        WriteStepCell(fileHandler, y, x, grid[y, x], 'Visual Elimination', '');
                        HasSolved := true;
                    end;
                end;
    end;

    SolveCell := HasSolved;
end;

end.
