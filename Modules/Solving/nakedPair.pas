unit nakedPair;

interface
uses types, auxiliary;
procedure RemoveHint (var hint : TStringGrid);


implementation

procedure RemoveHint (var hint : TStringGrid);
var x, y, p, r, s, i, PairX, PairY, SubX, SubY, PairSubX, PairSubY : integer;
    ThisX, ThisY : integer;
begin
    for y := 0 to 8 do
        for x := 0 to 8 do
            if length(hint[y, x]) = 2 then
            begin
                // Elimination: Row (Horizontal matches)
                PairX := -1;
                
                for p := 0 to 8 do
                    if (hint[y, x] = hint[y, p]) and (x <> p) then
                    begin
                        PairX := p;
                        PairY := y;
                        break;
                    end;
                
                if PairX <> -1 then
                begin
                    // Remove others from row
                    for p := 0 to 8 do
                        if (p <> x) and (p <> PairX) then
                        begin
                            for i := 1 to 2 do
                                hint[y, p] := SBA_RemoveAt(hint[y, p], pos(hint[y, x][i], hint[y, p]));

                            if VERBOSE then
                                writeln('Remove ', hint[y, x], ' from (', y, ',', p, ') by naked pair of (',y,',',x,') and (',y,',',PairX,'), row-row');
                        end;
                        
                    // Remove others from subgrid
                    SubX := x div 3;
                    SubY := y div 3;
                    PairSubX := PairX div 3;
                    
                    if SubX = PairSubX then
                        // The matched naked pair is within the same subgrid
                        // eliminate others from the same subgrid
                        for r := 0 to 2 do
                            for s := 0 to 2 do
                            begin
                                ThisX := 3 * SubX + s;
                                ThisY := 3 * SubY + r;
                                
                                if not (((ThisX = x) and (ThisY = y)) or ((ThisX = PairX) and (ThisY = PairY))) then
                                begin
                                    for i := 1 to 2 do
                                        hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][i], hint[ThisY, ThisX]));

                                    if VERBOSE then
                                        writeln('Remove ', hint[y, x], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), row-sub');
                                end;
                            end;
                end;
                    
                // Elimination: Column (Vertical matches)
                PairY := -1;
                
                for p := 0 to 8 do
                    if (hint[y, x] = hint[p, x]) and (y <> p) then
                    begin
                        PairX := x;
                        PairY := p;
                        break;
                    end;
                
                if PairY <> -1 then
                begin
                    // Remove others from column
                    for p := 0 to 8 do
                        if (p <> y) and (p <> PairY) then
                        begin
                            for i := 1 to 2 do
                                hint[p, x] := SBA_RemoveAt(hint[p, x], pos(hint[y, x][i], hint[p, x]));

                            if VERBOSE then
                                writeln('Remove ', hint[y, x], ' from (', p, ',', x, ') by naked pair of (',y,',',x,') and (',PairY,',',x,'), col-col');
                        end;
                        
                    // Remove others from subgrid
                    SubX := x div 3;
                    SubY := y div 3;
                    PairSubX := PairX div 3;
                    PairSubY := PairY div 3;
                    
                    if SubY = PairSubY then
                        // The matched naked pair is within the same subgrid
                        // eliminate others from the same subgrid
                        for r := 0 to 2 do
                            for s := 0 to 2 do
                            begin
                                ThisX := 3 * SubX + s;
                                ThisY := 3 * SubY + r;
                                
                                if not (((ThisX = x) and (ThisY = y)) or ((ThisX = PairX) and (ThisY = PairY))) then
                                begin
                                    for i := 1 to 2 do
                                        hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][i], hint[ThisY, ThisX]));

                                    if VERBOSE then
                                        writeln('Remove ', hint[y, x], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), col-sub');
                                end;
                            end;
                end;
                
                // Elimination: Subgrid
                PairX := -1;
                PairY := -1;
                SubX := x div 3;
                SubY := y div 3;
                
                for r := 0 to 2 do
                    for s := 0 to 2 do
                    begin
                        ThisX := 3 * SubX + s;
                        ThisY := 3 * SubY + r;
                        
                        if (length(hint[ThisY, ThisX]) = 2) and (hint[ThisY, ThisX] = hint[y, x]) and ((ThisX <> x) or (ThisY <> y)) then
                        begin
                            PairX := ThisX;
                            PairY := ThisY;
                            break;
                        end;
                    end;
                    
                if PairX <> -1 then
                    for r := 0 to 2 do
                        for s := 0 to 2 do
                        begin
                            ThisX := 3 * SubX + s;
                            ThisY := 3 * SubY + r;
                            
                            if not (((ThisX = x) and (ThisY = y)) or ((ThisX = PairX) and (ThisY = PairY))) then
                            begin
                                for i := 1 to 2 do
                                    hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][i], hint[ThisY, ThisX]));

                                if VERBOSE then
                                    writeln('Remove ', hint[y, x], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), row-row');
                            end;
                        end;
            end;
end;

end.