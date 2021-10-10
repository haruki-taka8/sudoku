unit xWing;

interface
uses types, auxiliary, io;
procedure RemoveHint (var hint : TStringGrid);

implementation
type
    coordinates = record
        y : integer;
        x : integer;
    end;
    CoordCombination = array [0..2015] of coordinates;


function GetCoordCombination (Count : integer) : CoordCombination;
var y, x, i : integer;
    Result : CoordCombination;
begin
    i := 0;
    for y := 0 to Count-2 do
        for x := y+1 to Count-1 do
        begin
            Result[i].y := y;
            Result[i].x := x;
            i := i + 1;
        end;
        
    for x := i to 2015 do
    begin
        Result[x].y := -1;
        Result[x].x := -1;
    end;
        
    GetCoordCombination := Result;
end;

procedure RemoveHint (var hint : TStringGrid);
var i, y, x, p : integer;
    LT, RT, LB, RB, j : coordinates;
    Count, CountA, CountB : integer;
    Possible : array [0..80] of coordinates;
    HasRemoved : boolean;
begin
    for i := 1 to 9 do
    begin
        for p := 0 to 80 do
        begin
            Possible[p].y := -1;
            Possible[p].x := -1;
        end;
        Count := 0;

        for y := 0 to 8 do
            for x := 0 to 8 do
                if pos(SBA_IntToStr(i), hint[y, x]) <> 0 then
                begin
                    Possible[Count].y := y;
                    Possible[Count].x := x;
                    Count := Count + 1;
                end;

        for j in GetCoordCombination(Count) do
            if ((j.y <> -1) and (j.x <> -1)) then
            begin
                LT.y := possible[j.y].y;
                LT.x := possible[j.y].x;
                RB.y := possible[j.x].y;
                RB.x := possible[j.x].x;
                RT.y := possible[j.y].y;
                RT.x := possible[j.x].x;
                LB.y := possible[j.x].y;
                LB.x := possible[j.y].x;

                if (LT.y <> LB.y) and (LT.x <> RT.x) and
                   (pos(SBA_IntToStr(i), hint[LT.y, LT.x]) <> 0) and
                   (pos(SBA_IntToStr(i), hint[RT.y, RT.x]) <> 0) and
                   (pos(SBA_IntToStr(i), hint[LB.y, LB.x]) <> 0) and
                   (pos(SBA_IntToStr(i), hint[RB.y, RB.x]) <> 0)
                then
                begin                    
                    // Column (column match, remove from row)
                    CountA := 0;
                    CountB := 0;
                    for p := 0 to 8 do
                    begin
                        if pos(SBA_IntToStr(i), hint[p, LT.x]) <> 0 then
                            CountA := CountA + 1;

                        if pos(SBA_IntToStr(i), hint[p, RT.x]) <> 0 then
                            CountB := CountB + 1;
                    end;

                    if (CountA = 2) and (CountB = 2) then
                    begin
                        // Remove others from rows (except in LT, RT, LB, RB)
                        HasRemoved := false;
                        for p := 0 to 8 do
                        begin
                            if (pos(SBA_IntToStr(i), hint[LT.y, p]) <> 0) and (p <> LT.x) and (p <> RT.x) then
                            begin
                                hint[LT.y, p] := SBA_RemoveAt(hint[LT.y, p], pos(SBA_IntToStr(i), hint[LT.y, p]));
                                HasRemoved := true;
                            end;

                            if (pos(SBA_IntToStr(i), hint[LT.y, p]) <> 0) and (p <> LT.x) and (p <> RT.x) then
                            begin
                                hint[LT.y, p] := SBA_RemoveAt(hint[LT.y, p], pos(SBA_IntToStr(i), hint[LT.y, p]));
                                HasRemoved := true;
                            end;
                        end;

                        if HasRemoved then
                            WriteStepHint(fileHandler, LT.y, LT.x, 'X-Wing', '-['+SBA_IntToStr(i)+'] due to ('+SBA_IntToStr(LT.y)+','+SBA_IntToStr(LT.x)+')+('+SBA_IntToStr(RB.y)+','+SBA_IntToStr(RB.x)+') for row '+SBA_IntToStr(LT.y)+'+'+SBA_IntToStr(LB.y));
                    end;


                    // Row (row match, remove from column)
                    CountA := 0;
                    CountB := 0;
                    for p := 0 to 8 do
                    begin
                        if pos(SBA_IntToStr(i), hint[LT.y, p]) <> 0 then
                            CountA := CountA + 1;

                        if pos(SBA_IntToStr(i), hint[LB.y, p]) <> 0 then
                            CountB := CountB + 1;
                    end;

                    if (CountA = 2) and (CountB = 2) then
                    begin
                        // Remove others from rows (except in LT, RT, LB, RB)
                        HasRemoved := false;
                        for p := 0 to 8 do
                        begin
                            if (pos(SBA_IntToStr(i), hint[p, LT.x]) <> 0) and (p <> LT.y) and (p <> LB.y) then
                            begin
                                hint[p, LT.x] := SBA_RemoveAt(hint[p, LT.x], pos(SBA_IntToStr(i), hint[p, LT.x]));
                                HasRemoved := true;
                            end;

                            if (pos(SBA_IntToStr(i), hint[p, RT.x]) <> 0) and (p <> RT.y) and (p <> RB.y) then
                            begin
                                hint[p, RT.x] := SBA_RemoveAt(hint[p, RT.x], pos(SBA_IntToStr(i), hint[p, RT.x]));
                                HasRemoved := true;
                            end;
                        end;

                        if HasRemoved then
                            WriteStepHint(fileHandler, LT.y, LT.x, 'X-Wing ', '-['+SBA_IntToStr(i)+'] due to ('+SBA_IntToStr(LT.y)+','+SBA_IntToStr(LT.x)+')+('+SBA_IntToStr(RB.y)+','+SBA_IntToStr(RB.x)+') for col '+SBA_IntToStr(LT.x)+'+'+SBA_IntToStr(RT.x));
                    end;
                end;
            end;
    end;
end;

end.