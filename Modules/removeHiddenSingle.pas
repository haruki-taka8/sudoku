unit removeHiddenSingle;

interface
uses types, auxiliary;
procedure RemoveHiddenSingle (var grid : TIntegerGrid; InputHint : TStringGrid);


implementation

procedure RemoveHiddenSingle (var grid : TIntegerGrid; InputHint : TStringGrid);
var x, y, p, q, r, s, ThisCellX, ThisCellY : integer;
    ThisHint : string;
    IsHiddenSingle : boolean;
begin
    for y := 0 to 8 do
    begin
        for x := 0 to 8 do
        begin
            if grid[y, x] = 0 then
            begin
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
                    grid[y, x] := SBA_StrToInt(ThisHint);
                    if VERBOSE then
                        writeln('Set (', y, ',', x, ') to ', ThisHint, ' by hidden single, column');
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
                    grid[y, x] := SBA_StrToInt(ThisHint);
                    if VERBOSE then
                        writeln('Set (', y, ',', x, ') to ', ThisHint, ' by hidden single, row');
                    break;
                    end;
                    IsHiddenSingle := true;
                        
                    // ELIMINATION: Subgrid
                    for r := 0 to 2 do
                    begin
                        for s := 0 to 2 do
                        begin
                            ThisCellY := 3 * (y div 3) + r;
                            ThisCellX := 3 * (x div 3) + s;
                            
                            if ((pos(ThisHint, InputHint[ThisCellY, ThisCellX]) <> 0) and ((ThisCellY <> y) or (ThisCellX <> x))) then
                            begin
                                IsHiddenSingle := false;
                                break;
                            end;
                        end;
                    end;
                    
                    if IsHiddenSingle then
                    begin
                        grid[y, x] := SBA_StrToInt(ThisHint);
                        if VERBOSE then
                            writeln('Set (', y, ',', x, ') to ', ThisHint, ' by hidden single, subgrid');
                        break;
                    end;
                end;
            end;
        end;
    end;
end;

end.