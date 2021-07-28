unit removePointingPair;

interface
uses types, auxiliary;
procedure RemovePointingPair (var hint : TStringGrid);


implementation

procedure RemovePointingPair (var hint : TStringGrid);
var x, y, p, q, Number, NumberCount, ThisCellX, ThisCellY, LastX, LastY : integer;
begin
    for y := 0 to 8 do
        for x := 0 to 8 do
        begin
            for Number := 1 to 9 do
            begin
                NumberCount := 0;
                
                // Elimination: Column
                for p := 0 to 2 do
                    for q := 0 to 2 do
                    begin
                        ThisCellY := 3 * (y div 3) + p;
                        ThisCellX := 3 * (x div 3) + q;
                        
                        if (pos(SBA_IntToStr(Number), hint[ThisCellY, ThisCellX]) <> 0) and (pos(SBA_IntToStr(Number), hint[y, x]) <> 0) then
                        begin
                            LastX := ThisCellX;
                            LastY := ThisCellY;
                            NumberCount := NumberCount + 1;
                        end;
                    end;
                
                if (NumberCount = 2) and (LastX = x) and (LastY <> y) then
                begin
                    for p := 0 to 8 do
                    begin
                        if ((p div 3) <> (LastY div 3)) and (pos(SBA_IntToStr(Number), hint[p, x]) <> 0) then
                        begin
                            hint[p, x] := SBA_RemoveAt(hint[p, x], pos(SBA_IntToStr(Number), hint[p, x]));
                            
                            if VERBOSE then
                                writeln('Remove ', Number, ' from (', p, ',', x, ') by pointing pair of (',y,',',x,') and (',LastY,',',LastX,'), col');  
                        end;
                    end;
                end;
                
                // Elimination: Row
                for p := 0 to 2 do
                    for q := 0 to 2 do
                    begin
                        ThisCellY := 3 * (y div 3) + p;
                        ThisCellX := 3 * (x div 3) + q;
                        
                        if (pos(SBA_IntToStr(Number), hint[ThisCellY, ThisCellX]) <> 0) and (pos(SBA_IntToStr(Number), hint[y, x]) <> 0) then
                        begin
                            LastX := ThisCellX;
                            LastY := ThisCellY;
                            NumberCount := NumberCount + 1;
                        end;
                    end;
                
                if (NumberCount = 2) and (LastX <> x) and (LastY = y) then
                begin
                    for p := 0 to 8 do
                    begin
                        if ((p div 3) <> (LastX div 3)) and (pos(SBA_IntToStr(Number), hint[y, p]) <> 0) then
                        begin
                            hint[y, p] := SBA_RemoveAt(hint[y, p], pos(SBA_IntToStr(Number), hint[y, p]));
                            
                            if VERBOSE then
                                writeln('Remove ', Number, ' from (', y, ',', p, ') by pointing pair of (',y,',',x,') and (',LastY,',',LastX,'), row');  
                        end;
                    end;
                end;
            end;
        end;
end;

end.