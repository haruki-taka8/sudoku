unit removeNakedPair;

interface
uses types, auxiliary;
procedure RemoveNakedPair (var hint : TStringGrid);


implementation

procedure RemoveNakedPair (var hint : TStringGrid);
var x, y, p, r, s, u, PairX, PairY, SubX, SubY, PairSubX, PairSubY : integer;
    ThisX, ThisY : integer;
begin
    for y := 0 to 8 do
        for x := 0 to 8 do
            if length(hint[y, x]) = 2 then
            begin
                // Elimination: Row (Horizontal matches)
                PairX := 0;
                PairY := 0;
                SubX := 0;
                SubY := 0;
                PairSubX := 0;
                PairSubY := 0;
                
                for p := 0 to 8 do
                    if (hint[y, x] = hint[y, p]) and (x <> p) then
                    begin
                        PairX := p;
                        PairY := y;
                        break;
                    end;
                
                if PairX <> 0 then
                begin
                    // Remove others from row
                    for p := 0 to 8 do
                        if (p <> x) and (p <> PairX) then
                        begin
                            if pos(hint[y, x][1], hint[y, p]) <> 0 then
                            begin
                                hint[y, p] := SBA_RemoveAt(hint[y, p], pos(hint[y, x][1], hint[y, p]));
                                
                                if VERBOSE then
                                    writeln('Remove ', hint[y, x][1], ' from (', y, ',', p, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), row-row, 0');
                            end;
                            if pos(hint[y, x][2], hint[y, p]) <> 0 then
                            begin
                                hint[y, p] := SBA_RemoveAt(hint[y, p], pos(hint[y, x][2], hint[y, p]));
                                
                                if VERBOSE then
                                    writeln('Remove ', hint[y, x][2], ' from (', y, ',', p, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), row-row, 1');
                            end;
                        end;
                        
                    // Remove others from subgrid
                    SubX := x div 3;
                    SubY := y div 3;
                    PairSubX := PairX div 3;
                    PairSubY := PairY div 3;
                    
                    if (SubX = PairSubX) and (SubY = PairSubY) then
                    begin
                        // The matched naked pair is within the same subgrid
                        // eliminate others from the same subgrid
                        for r := 0 to 2 do
                            for s := 0 to 2 do
                            begin
                                ThisX := 3 * SubX + s;
                                ThisY := 3 * SubY + r;
                                
                                if ((ThisX <> x) or (ThisY <> y)) and ((ThisX <> PairX) or (ThisY <> PairY)) then
                                begin
                                    if pos(hint[y, x][1], hint[ThisY, ThisX]) <> 0 then
                                    begin
                                        hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][1], hint[ThisY, ThisX]));
                                        
                                        if VERBOSE then
                                            writeln('Remove ', hint[y, x][1], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), row-sub, 0');
                                    end;
                                    if pos(hint[y, x][2], hint[ThisY, ThisX]) <> 0 then
                                    begin
                                        hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][2], hint[ThisY, ThisX]));
                                        
                                        if VERBOSE then
                                            writeln('Remove ', hint[y, x][2], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), row-sub, 1');
                                    end;
                                end;
                            end;
                    end;
                    
                end;
                    
                // Elimination: Column (Vertical matches)
                PairX := 0;
                PairY := 0;
                SubX := 0;
                SubY := 0;
                PairSubX := 0;
                PairSubY := 0;
                
                for p := 0 to 8 do
                    if (hint[y, x] = hint[p, x]) and (y <> p) then
                    begin
                        PairX := x;
                        PairY := p;
                        break;
                    end;
                
                if PairY <> 0 then
                begin
                    // Remove others from column
                    for p := 0 to 8 do
                        if (p <> y) and (p <> PairY) then
                        begin
                        
                            if pos(hint[y, x][1], hint[p, x]) <> 0 then
                            begin
                                hint[p, x] := SBA_RemoveAt(hint[p, x], pos(hint[y, x][1], hint[p, x]));
                                
                                if VERBOSE then
                                    writeln('Remove ', hint[y, x][1], ' from (', p, ',', x, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), col-col, 0');
                            end;
                            if pos(hint[y, x][2], hint[p, x]) <> 0 then
                            begin
                                hint[p, x] := SBA_RemoveAt(hint[p, x], pos(hint[y, x][2], hint[p, x]));
                                
                                if VERBOSE then
                                    writeln('Remove ', hint[y, x][2], ' from (', p, ',', x, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), col-col, 1');
                            end;
                        end;
                        
                    // Remove others from subgrid
                    SubX := x div 3;
                    SubY := y div 3;
                    PairSubX := PairX div 3;
                    PairSubY := PairY div 3;
                    
                    if (SubX = PairSubX) and (SubY = PairSubY) then
                    begin
                        // The matched naked pair is within the same subgrid
                        // eliminate others from the same subgrid
                        for r := 0 to 2 do
                            for s := 0 to 2 do
                            begin
                                ThisX := 3 * SubX + s;
                                ThisY := 3 * SubY + r;
                                
                                if ((ThisX <> x) or (ThisY <> y)) and ((ThisX <> PairX) or (ThisY <> PairY)) then
                                begin
                                    if pos(hint[y, x][1], hint[ThisY, ThisX]) <> 0 then
                                    begin
                                        hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][1], hint[ThisY, ThisX]));
                                        
                                        if VERBOSE then
                                            writeln('Remove ', hint[y, x][1], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), col-sub, 0');
                                    end;
                                    if pos(hint[y, x][2], hint[ThisY, ThisX]) <> 0 then
                                    begin
                                        hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][2], hint[ThisY, ThisX]));
                                        
                                        if VERBOSE then
                                            writeln('Remove ', hint[y, x][2], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), col-sub, 1');
                                    end;
                                end;
                            end;
                    end;
                end;
                
                // Elimination: Subgrid
                PairX := 0;
                PairY := 0;
                SubX := x div 3;
                SubY := y div 3;
                PairSubX := 0;
                PairSubY := 0;
                
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
                    
                if PairX <> 0 then
                begin
                    for r := 0 to 2 do
                        for u := 0 to 2 do
                        begin
                            ThisX := 3 * SubX + s;
                            ThisY := 3 * SubY + r;
                            
                            if ((ThisX <> x) or (ThisY <> y)) and ((ThisX <> PairX) or (ThisY <> PairY)) then
                            begin
                                if pos(hint[y, x][1], hint[ThisY, ThisX]) <> 0 then
                                begin
                                    hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][1], hint[ThisY, ThisX]));
                                    
                                    if VERBOSE then
                                        writeln('Remove ', hint[y, x][1], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), sub-sub, 0');
                                end;
                                if pos(hint[y, x][2], hint[ThisY, ThisX]) <> 0 then
                                begin
                                    hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][2], hint[ThisY, ThisX]));
                                    
                                    if VERBOSE then
                                        writeln('Remove ', hint[y, x][2], ' from (', ThisY, ',', ThisX, ') by naked pair of (',y,',',x,') and (',PairY,',',PairX,'), sub-sub, 1');
                                end;
                            end;
                        end;
                end;
            end;
end;

end.