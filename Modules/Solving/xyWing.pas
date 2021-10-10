unit xyWing;

interface
uses types, auxiliary, io;
procedure RemoveHint (var hint : TStringGrid);

implementation

type
    TCoordinates = record
        x, y : integer;
        Hint : string[2];
        UniqueFromPivot : string[1];

    end;

procedure RemoveHint (var hint : TStringGrid);
var x, y, p, q, r, s, i, j, u, v, LeftX, LeftY : integer;
    Pivot, Empty : TCoordinates;
    Wings : array [0..20] of TCoordinates;
    QCandidates, PCandidates : array [0..26] of TCoordinates;

begin
    Empty.x := -1;
    Empty.y := -1;
    Empty.Hint := '';
    Empty.UniqueFromPivot := '';

    for y := 0 to 8 do
        for x := 0 to 8 do
        begin
            // Reset pivot and wing variables
            for i := 0 to 20 do Wings[i] := Empty;
            Pivot := Empty;

            if length(hint[y, x]) = 2 then
            begin
                Pivot.x := x;
                Pivot.y := y;
                Pivot.Hint := hint[y, x];

                // Scan for wings
                i := 0;

                // Row & column
                for p := 0 to 8 do
                begin
                    if (length(hint[y, p]) = 2) and (Pivot.Hint <> hint[y, p]) and ((pos(Pivot.Hint[1], hint[y, p]) <> 0) or (pos(Pivot.Hint[2], hint[y, p]) <> 0)) then
                    begin
                        Wings[i].x := p;
                        Wings[i].y := y;
                        Wings[i].Hint := hint[y, p];

                        if (pos(hint[y, p][1], Pivot.Hint) = 0) then
                            Wings[i].UniqueFromPivot := hint[y, p][1]
                        else
                            Wings[i].UniqueFromPivot := hint[y, p][2];

                        i := i + 1;
                    end;

                    if (length(hint[p, x]) = 2) and (Pivot.Hint <> hint[p, x]) and ((pos(Pivot.Hint[1], hint[p, x]) <> 0) or (pos(Pivot.Hint[2], hint[p, x]) <> 0)) then
                    begin
                        Wings[i].x := x;
                        Wings[i].y := p;
                        Wings[i].Hint := hint[p, x];

                        if (pos(hint[p, x][1], Pivot.Hint) = 0) then
                            Wings[i].UniqueFromPivot := hint[p, x][1]
                        else
                            Wings[i].UniqueFromPivot := hint[p, x][2];

                        i := i + 1;
                    end;
                end;

                // Subgrid
                LeftX := 3*(x div 3);
                LeftY := 3*(y div 3);

                for q := LeftY to LeftY+2 do
                    for p := LeftX to LeftX+2 do
                        if not ((q = y) or (p = x)) then // Do not check same row & column
                            if (length(hint[q, p]) = 2) and (Pivot.Hint <> hint[q, p]) and ((pos(Pivot.Hint[1], hint[q, p]) <> 0) or (pos(Pivot.Hint[2], hint[q, p]) <> 0)) then
                            begin
                                Wings[i].y := q;
                                Wings[i].x := p;
                                Wings[i].Hint := hint[q, p];

                                if (pos(hint[q, p][1], Pivot.Hint) = 0) then
                                    Wings[i].UniqueFromPivot := hint[q, p][1]
                                else
                                    Wings[i].UniqueFromPivot := hint[q, p][2];

                                i := i + 1;
                            end;

                // Foreach wing: check if candidate is possible
                if i >= 2 then
                    for q := 0 to i-2 do
                        for p := q+1 to i-1 do
                            if Wings[q].UniqueFromPivot = Wings[p].UniqueFromPivot then
                                if (Wings[q].y <> Wings[p].y) and (Wings[q].x <> Wings[p].x) then
                                    if (Wings[q].Hint <> Wings[p].Hint) then
                                    begin
                                        // writeln('YWing ', y, ',', x, ' ~ ', hint[y, x], '  ~  ', Wings[q].y, ',', Wings[q].x, ' ~ ', Wings[q].Hint, '  =  ', Wings[p].y, ',', Wings[p].x, ' ~ ', Wings[p].Hint);
                                        // These are possible XY-Wing candidates, but they may not necessarily intersect each other
                                        // The following code checks what Wings[q] and Wings[p] intersect
                                        for j := 0 to 26 do
                                        begin
                                            QCandidates[j] := Empty;
                                            PCandidates[j] := Empty;
                                        end;

                                        u := 0;
                                        v := 0;

                                        // Row
                                        for r := 0 to 8 do
                                        begin
                                            if Wings[q].y <> r then
                                            begin
                                                QCandidates[u].y := r;
                                                QCandidates[u].x := Wings[q].x;
                                                u := u + 1;
                                            end;
                                            if Wings[p].y <> r then
                                            begin
                                                PCandidates[v].y := r;
                                                PCandidates[v].x := Wings[p].x;
                                                v := v + 1;
                                            end;
                                        end;

                                        // Column
                                        for r := 0 to 8 do
                                        begin
                                            if Wings[q].x <> r then
                                            begin
                                                QCandidates[u].x := r;
                                                QCandidates[u].y := Wings[q].y;
                                                u := u + 1;
                                            end;
                                            if Wings[p].x <> r then
                                            begin
                                                PCandidates[v].x := r;
                                                PCandidates[v].y := Wings[p].y;
                                                v := v + 1;
                                            end;
                                        end;

                                        // Subgrid
                                        for s := 0 to 2 do
                                            for r := 0 to 2 do
                                            begin
                                                LeftX := 3*(Wings[q].x div 3);
                                                LeftY := 3*(Wings[q].y div 3);
                                                if (Wings[q].y <> LeftY+s) and (Wings[q].x <> LeftX+r) then
                                                begin
                                                    QCandidates[u].y := LeftY+s;
                                                    QCandidates[u].x := LeftX+r;
                                                    u := u + 1;
                                                end;

                                                LeftX := 3*(Wings[p].x div 3);
                                                LeftY := 3*(Wings[p].y div 3);
                                                if (Wings[p].y <> LeftY+s) and (Wings[p].x <> LeftX+r) then
                                                begin
                                                    PCandidates[v].y := LeftY+s;
                                                    PCandidates[v].x := LeftX+r;
                                                    v := v + 1;
                                                end;
                                            end;

                                        for s := 0 to 26 do
                                            for r := 0 to 26 do
                                                if (QCandidates[s].x = PCandidates[r].x) and (QCandidates[s].y = PCandidates[r].y) then
                                                    if (QCandidates[s].y <> -1) or (PCandidates[r].y <> -1) then
                                                    begin
                                                        if pos(Wings[q].UniqueFromPivot, hint[QCandidates[s].y, QCandidates[s].x]) <> 0 then
                                                            WriteStepHint(fileHandler, QCandidates[s].y, QCandidates[s].x, 'XY-Wing', '-['+Wings[q].UniqueFromPivot+'] due to ('+SBA_IntToStr(Wings[q].y)+','+SBA_IntToStr(Wings[q].x)+')+('+SBA_IntToStr(Pivot.y)+','+SBA_IntToStr(Pivot.x)+')+('+SBA_IntToStr(Wings[p].y)+','+SBA_IntToStr(Wings[p].x)+')');
                                                        hint[QCandidates[s].y, QCandidates[s].x] := SBA_RemoveAt(hint[QCandidates[s].y, QCandidates[s].x], pos(Wings[q].UniqueFromPivot, hint[QCandidates[s].y, QCandidates[s].x]));
                                                    end;

                                    end;
                                        
            end;
        end;

end;

end.