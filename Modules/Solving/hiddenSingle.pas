unit hiddenSingle;

interface
uses types, auxiliary, io, sysutils;
function SolveCell (var grid : TIntegerGrid; InputHint : TStringGrid) : boolean;


implementation
function SolveCell (var grid : TIntegerGrid; InputHint : TStringGrid) : boolean;
var x, y, p, q, r, s, ThisX, ThisY : integer;
    ThisHint : string;
    IsHiddenSingle, HasSolved : boolean;
begin
    HasSolved := false;
    for y := 0 to 8 do
        for x := 0 to 8 do
            if grid[y, x] = 0 then
                for p := 1 to length(InputHint[y, x]) do
                begin
                    ThisHint := InputHint[y, x][p];
                    IsHiddenSingle := true;
                
                    // ELIMINATION: Column
                    for q := 0 to 8 do
                        if ((pos(ThisHint, InputHint[q, x]) <> 0) and (q <> y)) then
                        begin
                            IsHiddenSingle := false;
                            break;
                        end;
                        
                    if IsHiddenSingle then
                    begin
                        grid[y, x] := StrToInt(ThisHint);
                        WriteStepCell(fileHandler, y, x, grid[y, x], 'Hidden Single', '(column)');
                        HasSolved := true;
                        break;
                    end;
                    IsHiddenSingle := true;
                        
                    // ELIMINATION: Row
                    for q := 0 to 8 do
                        if ((pos(ThisHint, InputHint[y, q]) <> 0) and (q <> x)) then
                        begin
                            IsHiddenSingle := false;
                            break;
                        end;
                        
                    if IsHiddenSingle then
                    begin
                        grid[y, x] := StrToInt(ThisHint);
                        WriteStepCell(fileHandler, y, x, grid[y, x], 'Hidden Single', '(row)');
                        HasSolved := true;
                        break;
                    end;
                    IsHiddenSingle := true;
                        
                    // ELIMINATION: Subgrid
                    for r := 0 to 2 do
                        for s := 0 to 2 do
                        begin
                            ThisY := 3 * (y div 3) + r;
                            ThisX := 3 * (x div 3) + s;
                            
                            if ((pos(ThisHint, InputHint[ThisY, ThisX]) <> 0) and ((ThisY <> y) or (ThisX <> x))) then
                            begin
                                IsHiddenSingle := false;
                                break;
                            end;
                        end;
                    
                    if IsHiddenSingle then
                    begin
                        grid[y, x] := StrToInt(ThisHint);
                        WriteStepCell(fileHandler, y, x, grid[y, x], 'Hidden Single', '(subgrid)');
                        HasSolved := true;
                        break;
                    end;
                end;

    SolveCell := HasSolved;
end;

end.