unit visual;

interface
uses types, auxiliary;
procedure SolveCell (var grid : TIntegerGrid; InputHint : TStringGrid);

// Remove visual, aka Visual Elimination or The Brady Bunch Technique.
// An upgrade of RemainingOfInt


implementation

procedure SolveCell (var grid: TIntegerGrid; InputHint : TStringGrid);
var i, x, y, p, r, s, ThisX, ThisY, CanindateCount : integer;
    Canindates : TIntegerGrid;
begin
    for i := 1 to 9 do
    begin
        Canindates := Grid;
        for y := 0 to 8 do
            for x := 0 to 8 do
                if grid[y, x] = i then
                begin
                    // Remove from same row
                    for p := 0 to 8 do
                        if p <> x then
                            Canindates[y, p] := 999; // Set cell as incompatible with i

                    // Remove from same column
                    for p := 0 to 8 do
                        if p <> y then
                            Canindates[p, x] := 999;

                    // Remove from same subgrid
                    for r := 0 to 2 do
                        for s := 0 to 2 do
                        begin
                            ThisX := 3 * (x div 3) + s;
                            ThisY := 3 * (y div 3) + r;

                            if (ThisX <> x) or (ThisY <> y) then
                                Canindates[ThisY, ThisX] := 999;
                        end;
                end;

        // All possibilities are ({grid[y, x] = 0})
        for y := 0 to 8 do
            for x := 0 to 8 do
                if Canindates[y, x] = 0 then
                begin
                    // Check if only one possible cell for Number in subgrid
                    CanindateCount := 0;
                    for r := 0 to 2 do
                        for s := 0 to 2 do
                        begin
                            ThisX := 3 * (x div 3) + s;
                            ThisY := 3 * (y div 3) + r;

                            if grid[ThisY, ThisX] = 0 then
                                CanindateCount := CanindateCount + 1;
                        end;

                    if CanindateCount = 1 then
                    begin
                        grid[y, x] := i;

                        if VERBOSE then
                            writeln('Set (', y, ',', x, ') as ', i, ' by visual elimination');
                    end;
                end;
    end;
end;
end.
// foreach Number
//     set non-zero as possible
//     remove in same row
//     remove in same column
//     remove in same subgrid
//     if only one remaining in block
//         set that as Number

// require data type TBooleanGrid/ or just use TIntegerGrid