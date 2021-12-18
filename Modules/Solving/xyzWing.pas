unit xyzWing;

interface
uses types, auxiliary, io, sysutils;
function RemoveHint (var hint : TStringGrid) : boolean;

implementation

type
    TCoordinates = record
        x, y : integer;
        Hint : string[3];

    end;

function RemoveHint (var hint : TStringGrid) : boolean;
var x, y, p, q, r, s, i, j, u, v, LeftX, LeftY : integer;
    Pivot, Empty : TCoordinates;
    Wings : array [0..20] of TCoordinates;
    QCandidates, PCandidates : array [0..26] of TCoordinates;
    CommonWithPivot : string;
    HasEverRemoved : boolean;

begin
    HasEverRemoved := false;
    Empty.x := -1;
    Empty.y := -1;
    Empty.Hint := '';

    for y := 0 to 8 do
        for x := 0 to 8 do
        begin
            // Reset pivot and wing variables
            for i := 0 to 20 do Wings[i] := Empty;
            Pivot := Empty;

            if length(hint[y, x]) = 3 then
            begin
                Pivot.x := x;
                Pivot.y := y;
                Pivot.Hint := hint[y, x];

                // Scan for wings
                i := 0;

                // Row & column
                for p := 0 to 8 do
                begin
                    if (length(hint[y, p]) = 2) and (pos(hint[y, p][1], Pivot.Hint) <> 0) and (pos(hint[y, p][2], Pivot.Hint) <> 0) then
                    begin
                        Wings[i].x := p;
                        Wings[i].y := y;
                        Wings[i].Hint := hint[y, p];
                        i := i + 1;
                    end;

                    if (length(hint[p, x]) = 2) and (pos(hint[p, x][1], Pivot.Hint) <> 0) and (pos(hint[p, x][2], Pivot.Hint) <> 0) then
                    begin
                        Wings[i].x := x;
                        Wings[i].y := p;
                        Wings[i].Hint := hint[p, x];
                        i := i + 1;
                    end;
                end;

                // Subgrid
                LeftX := 3*(x div 3);
                LeftY := 3*(y div 3);

                for q := LeftY to LeftY+2 do
                    for p := LeftX to LeftX+2 do
                        if not ((q = y) or (p = x)) then // Do not check same row & column
                            if (length(hint[q, p]) = 2) and (pos(hint[q, p][1], Pivot.Hint) <> 0) and (pos(hint[q, p][2], Pivot.Hint) <> 0) then
                            begin
                                Wings[i].y := q;
                                Wings[i].x := p;
                                Wings[i].Hint := hint[q, p];
                                i := i + 1;
                            end;

                // Foreach wing: check if candidate is possible
                if i >= 2 then
                    for q := 0 to i-2 do
                        for p := q+1 to i-1 do
                            if (Wings[q].Hint[1] = Wings[p].Hint[1]) or
                               (Wings[q].Hint[1] = Wings[p].Hint[2]) or
                               (Wings[q].Hint[2] = Wings[p].Hint[1]) or
                               (Wings[q].Hint[2] = Wings[p].Hint[2]) then
                                if (Wings[q].y <> Wings[p].y) and (Wings[q].x <> Wings[p].x) then
                                    if (Wings[q].Hint <> Wings[p].Hint) then
                                    begin
                                        // writeln('XYZWing ', y, ',', x, ' ~ ', hint[y, x], '  ~  ', Wings[q].y, ',', Wings[q].x, ' ~ ', Wings[q].Hint, '  =  ', Wings[p].y, ',', Wings[p].x, ' ~ ', Wings[p].Hint);
                                        // Determine common hint with pivot
                                        if (Wings[q].Hint[1] = Wings[p].Hint[1]) or (Wings[q].Hint[1] = Wings[p].Hint[2]) then
                                            CommonWithPivot := Wings[q].Hint[1]
                                        else
                                            CommonWithPivot := Wings[q].Hint[2];

                                        // These are possible XYZ-Wing candidates, but they may not necessarily intersect each other
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
                                            if (Wings[q].y <> r) and (Pivot.y <> r) then
                                            begin
                                                QCandidates[u].y := r;
                                                QCandidates[u].x := Wings[q].x;
                                                u := u + 1;
                                            end;
                                            if (Wings[p].y <> r) and (Pivot.y <> r) then
                                            begin
                                                PCandidates[v].y := r;
                                                PCandidates[v].x := Wings[p].x;
                                                v := v + 1;
                                            end;
                                        end;

                                        // Column
                                        for r := 0 to 8 do
                                        begin
                                            if (Wings[q].x <> r) and (Pivot.x <> r) then
                                            begin
                                                QCandidates[u].x := r;
                                                QCandidates[u].y := Wings[q].y;
                                                u := u + 1;
                                            end;
                                            if (Wings[p].x <> r) and (Pivot.x <> r) then
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
                                                if (Wings[q].y <> LeftY+s) and (Wings[q].x <> LeftX+r) and ((Pivot.y <> LeftY+s) or (Pivot.x <> LeftX+r)) then
                                                begin
                                                    QCandidates[u].y := LeftY+s;
                                                    QCandidates[u].x := LeftX+r;
                                                    u := u + 1;
                                                end;

                                                LeftX := 3*(Wings[p].x div 3);
                                                LeftY := 3*(Wings[p].y div 3);
                                                if (Wings[p].y <> LeftY+s) and (Wings[p].x <> LeftX+r) and ((Pivot.y <> LeftY+s) or (Pivot.x <> LeftX+r)) then
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
                                                        if (QCandidates[s].y div 3 = Pivot.y div 3) and (QCandidates[s].x div 3 = Pivot.x div 3) then
                                                        begin
                                                            if pos(CommonWithPivot, hint[QCandidates[s].y, QCandidates[s].x]) <> 0 then
                                                            begin
                                                                WriteStepHint(fileHandler, QCandidates[s].y, QCandidates[s].x, 'XYZ-Wing', '-['+CommonWithPivot+'] due to ('+IntToStr(Wings[q].y)+','+IntToStr(Wings[q].x)+')+('+IntToStr(Pivot.y)+','+IntToStr(Pivot.x)+')+('+IntToStr(Wings[p].y)+','+IntToStr(Wings[p].x)+')');
                                                                HasEverRemoved := true;
                                                            end;
                                                            hint[QCandidates[s].y, QCandidates[s].x] := RemoveAt(hint[QCandidates[s].y, QCandidates[s].x], pos(CommonWithPivot, hint[QCandidates[s].y, QCandidates[s].x]));
                                                        end;

                                    end;
                                        
            end;
        end;

    RemoveHint := HasEverRemoved;
end;

end.