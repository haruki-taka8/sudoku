unit removePointingPair;

interface
uses types, auxiliary;
procedure RemovePointingPair (var hint : TStringGrid);


implementation

procedure RemovePointingPair (var hint : TStringGrid);
var x, y, p, q, Number, NumberCount, ThisX, ThisY, PairX, PairY : integer;
begin
    for y := 0 to 8 do
        for x := 0 to 8 do
            for Number := 1 to 9 do
            begin                
                // Elimination: Column
                NumberCount := 0;
                for p := 0 to 2 do
                    for q := 0 to 2 do
                    begin
                        ThisY := 3 * (y div 3) + p;
                        ThisX := 3 * (x div 3) + q;
                        
                        if (pos(SBA_IntToStr(Number), hint[ThisY, ThisX]) <> 0) and (pos(SBA_IntToStr(Number), hint[y, x]) <> 0) then
                        begin
                            PairX := ThisX;
                            PairY := ThisY;
                            NumberCount := NumberCount + 1;
                        end;
                    end;
                
                if (NumberCount = 2) and (PairX = x) and (PairY <> y) then
                begin
                    for p := 0 to 8 do
                    begin
                        if ((p div 3) <> (PairY div 3)) and (pos(SBA_IntToStr(Number), hint[p, x]) <> 0) then
                        begin
                            hint[p, x] := SBA_RemoveAt(hint[p, x], pos(SBA_IntToStr(Number), hint[p, x]));
                            
                            if VERBOSE then
                                writeln('Remove ', Number, ' from (', p, ',', x, ') by pointing pair of (',y,',',x,') and (',PairY,',',PairX,'), col-col');  
                        end;
                    end;
                end;
                
                // Elimination: Row
                NumberCount := 0;
                for p := 0 to 2 do
                    for q := 0 to 2 do
                    begin
                        ThisY := 3 * (y div 3) + p;
                        ThisX := 3 * (x div 3) + q;
                        
                        if (pos(SBA_IntToStr(Number), hint[ThisY, ThisX]) <> 0) and (pos(SBA_IntToStr(Number), hint[y, x]) <> 0) then
                        begin
                            PairX := ThisX;
                            PairY := ThisY;
                            NumberCount := NumberCount + 1;
                        end;
                    end;
                
                if (NumberCount = 2) and (PairX <> x) and (PairY = y) then
                begin
                    for p := 0 to 8 do
                    begin
                        if ((p div 3) <> (PairX div 3)) and (pos(SBA_IntToStr(Number), hint[y, p]) <> 0) then
                        begin
                            hint[y, p] := SBA_RemoveAt(hint[y, p], pos(SBA_IntToStr(Number), hint[y, p]));
                            
                            if VERBOSE then
                                writeln('Remove ', Number, ' from (', y, ',', p, ') by pointing pair of (',y,',',x,') and (',PairY,',',PairX,'), row-row');  
                        end;
                    end;
                end;
            end;
end;

end.