unit nakedPair;

interface
uses types, auxiliary, io;
function RemoveHint (var hint : TStringGrid) : boolean;


implementation
function RemoveHint (var hint : TStringGrid) : boolean;
var x, y, p, r, s, i, PairX, PairY, SubX, SubY, PairSubX, PairSubY : integer;
    ThisX, ThisY : integer;
    IsLockedPair : boolean;
    HasRemoved, HasEverRemoved : boolean;
    OldHint : string;

begin
    HasEverRemoved := false;
    for y := 0 to 8 do
        for x := 0 to 8 do
            if length(hint[y, x]) = 2 then
            begin
                IsLockedPair := false;

                // Elimination: Row (Horizontal matches)
                OldHint := '';
                HasRemoved := false;
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
                            OldHint := hint[y, p];
                            for i := 1 to 2 do
                                hint[y, p] := SBA_RemoveAt(hint[y, p], pos(hint[y, x][i], hint[y, p]));

                            if hint[y, p] <> OldHint then
                            begin
                                HasRemoved := true;
                                HasEverRemoved := true;
                            end;
                        end;

                    if HasRemoved then
                        WriteStepHint(fileHandler, y, x, 'Naked  Pair', '-['+hint[y, x]+'] due to ('+SBA_IntToStr(y)+','+SBA_IntToStr(x)+')+('+SBA_IntToStr(y)+','+SBA_IntToStr(PairX)+') (row)');
                    
                        
                    // Remove others from subgrid
                    SubX := x div 3;
                    SubY := y div 3;
                    PairSubX := PairX div 3;
                    OldHint := '';
                    HasRemoved := false;
                    
                    if SubX = PairSubX then
                    begin
                        // The matched naked pair is within the same subgrid
                        // eliminate others from the same subgrid
                        for r := 0 to 2 do
                            for s := 0 to 2 do
                            begin
                                ThisX := 3 * SubX + s;
                                ThisY := 3 * SubY + r;
                                
                                if not (((ThisX = x) and (ThisY = y)) or ((ThisX = PairX) and (ThisY = PairY))) then
                                begin
                                    OldHint := hint[ThisY, ThisX];
                                    for i := 1 to 2 do
                                        hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][i], hint[ThisY, ThisX]));

                                    if hint[ThisY, ThisX] <> OldHint then
                                    begin
                                        HasRemoved := true;
                                        HasEverRemoved := true;
                                    end;
                                end;
                            end;
                        
                        IsLockedPair := true;
                        if HasRemoved then
                            WriteStepHint(fileHandler, y, x, 'Locked Pair', '-['+hint[y, x]+'] due to ('+SBA_IntToStr(y)+','+SBA_IntToStr(x)+')+('+SBA_IntToStr(PairY)+','+SBA_IntToStr(PairX)+') (row)');
                    end;
                end;
                    
                // Elimination: Column (Vertical matches)
                PairY := -1;
                OldHint := '';
                HasRemoved := false;
                
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
                            OldHint := hint[p, x];
                            for i := 1 to 2 do
                                hint[p, x] := SBA_RemoveAt(hint[p, x], pos(hint[y, x][i], hint[p, x]));

                            if hint[p, x] <> OldHint then
                            begin
                                HasRemoved := true;
                                HasEverRemoved := true;
                            end;
                        end;

                    if HasRemoved then
                        WriteStepHint(fileHandler, y, x, 'Naked  Pair', '-['+hint[y, x]+'] due to ('+SBA_IntToStr(y)+','+SBA_IntToStr(x)+')+('+SBA_IntToStr(PairY)+','+SBA_IntToStr(x)+') (column)');
                    
                    // Remove others from subgrid
                    SubX := x div 3;
                    SubY := y div 3;
                    PairSubX := PairX div 3;
                    PairSubY := PairY div 3;
                    OldHint := '';
                    HasRemoved := false;
                    
                    if SubY = PairSubY then
                    begin
                        // The matched naked pair is within the same subgrid
                        // eliminate others from the same subgrid
                        for r := 0 to 2 do
                            for s := 0 to 2 do
                            begin
                                ThisX := 3 * SubX + s;
                                ThisY := 3 * SubY + r;
                                
                                if not (((ThisX = x) and (ThisY = y)) or ((ThisX = PairX) and (ThisY = PairY))) then
                                begin
                                    OldHint := hint[ThisY, ThisX];
                                    for i := 1 to 2 do
                                        hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][i], hint[ThisY, ThisX]));
                                    if hint[ThisY, ThisX] <> OldHint then
                                    begin
                                        HasRemoved := true;
                                        HasEverRemoved := true;
                                    end;
                                end;
                            end;
                        
                        
                        IsLockedPair := true;
                        if HasRemoved then
                            WriteStepHint(fileHandler, y, x, 'Locked Pair', '-['+hint[y, x]+'] due to ('+SBA_IntToStr(y)+','+SBA_IntToStr(x)+')+('+SBA_IntToStr(PairY)+','+SBA_IntToStr(PairX)+') (column)');
                    end;
                end;
                
                // Elimination: Subgrid
                if not IsLockedPair then
                begin
                    PairX := -1;
                    PairY := -1;
                    SubX := x div 3;
                    SubY := y div 3;
                    OldHint := '';
                    HasRemoved := false;

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
                    begin
                        for r := 0 to 2 do
                            for s := 0 to 2 do
                            begin
                                ThisX := 3 * SubX + s;
                                ThisY := 3 * SubY + r;

                                if not (((ThisX = x) and (ThisY = y)) or ((ThisX = PairX) and (ThisY = PairY))) then
                                begin
                                    OldHint := hint[ThisY, ThisX];
                                    for i := 1 to 2 do
                                        hint[ThisY, ThisX] := SBA_RemoveAt(hint[ThisY, ThisX], pos(hint[y, x][i], hint[ThisY, ThisX]));
                                    if hint[ThisY, ThisX] <> OldHint then
                                    begin
                                        HasRemoved := true;
                                        HasEverRemoved := true;
                                    end;
                                end;
                            end;

                        if HasRemoved then
                            WriteStepHint(fileHandler, y, x, 'Naked  Pair', '-['+hint[y, x]+'] due to ('+SBA_IntToStr(y)+','+SBA_IntToStr(x)+')+('+SBA_IntToStr(PairY)+','+SBA_IntToStr(PairX)+') (subgrid)');
                    end;
                end;
            end;

    RemoveHint := HasEverRemoved;
end;

end.