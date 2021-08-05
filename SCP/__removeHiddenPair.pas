unit removeHiddenPair;

interface
uses io, types, auxiliary;
procedure RemoveHiddenPair (var hint : TStringGrid);


implementation

type combination = array [0..71] of string;

function GetCombination (Input : string) : combination;
var
    Output : combination;
    y, x, i, j : integer;

begin
    i := 0;
    for y := 1 to length(Input)-1 do
        for x := y+1 to length(Input) do
        begin
            Output[i] := Input[y] + Input[x];
            i := i + 1;
        end;

    for j := i to 71 do Output[j] := '00';

    GetCombination := Output;
end;


procedure RemoveHiddenPair (var hint : TStringGrid);
var x, y, p, q, r, s, PairX, PairY, ThisX, ThisY, Matches, i : integer;
    ThisHint : string;
    ThisCombo : combination;

begin
    for y := 0 to 8 do
        for x := 0 to 8 do
        begin
            ThisCombo := GetCombination(hint[y, x]);
            for p := 0 to 71 do
                if ThisCombo[p] <> '00' then
                begin
            // for ThisHint in GetCombination(hint[y, x]) do
            //     if ThisHint <> '' then
            //     begin

                    // Elimination by subgroup
                    // ThisHint := hint[y, x][p] + hint[y, x][p+1];
                    Matches  := 0;
                    PairX := 0;
                    PairY := 0;

                    // if (y = 6) and (x = 2) then
                    // writeln(ThisHint);

                    // for q := 0 to 8 do
                    //     if x <> q then
                    //         if (pos(ThisHint[1], hint[y, q]) <> 0) or (pos(ThisHint[2], hint[y, q]) <> 0) then
                    //         begin
                    //             PairX := q;
                    //             PairY := y;
                    //             Matches := Matches + 1;
                    //         end;

                    for r := 0 to 2 do
                        for s := 0 to 2 do
                        begin
                            ThisY := 3 * (y div 3) + r;
                            ThisX := 3 * (x div 3) + s;

                            // No need to IF NOT (y, x) as Matches == 0
                            if (pos(ThisCombo[p][1], hint[ThisY, ThisX]) <> 0) or (pos(ThisCombo[p][2], hint[ThisY, ThisX]) <> 0) then
                            begin
                                PairX := ThisX;
                                PairY := ThisY;
                                Matches := Matches + 1;
                            end;
                        end;

                    if Matches = 2 then
                    begin
                        // Remove other canindates from (y, x) and (PairY, PairX)
                        writeln('DEBUG: Remove hidden pair of (',y,',',x,') and (',PairY,',',PairX,'), sub');


                        i := 1;
                        while length(hint[y, x]) > 2 do
                            if (hint[y, x][i] <> ThisCombo[p][1]) and (hint[y, x][i] <> ThisCombo[p][2]) then
                            begin
                                writeln('DEBUG: Remove ', SBA_IntToStr(Matches), '~', ThisCombo[p], '~', hint[y, x][i], ' from (', y, ',', x, ') by hidden pair of (',y,',',x,') and (',PairY,',',PairX,'), sub');
                                hint[y, x] := SBA_RemoveAt(hint[y, x], i);
                            end
                            else
                                i := i + 1;

                        i := 1;
                        while length(hint[PairY, PairX]) > 2 do
                            if (hint[PairY, PairX][i] <> ThisCombo[p][1]) and (hint[PairY, PairX][i] <> ThisCombo[p][2]) then
                            begin
                                writeln('DEBUG: Remove ', SBA_IntToStr(Matches), '~', ThisCombo[p], '~', hint[PairY, PairX][i], ' from (', PairY, ',', PairX, ') by hidden pair of (',y,',',x,') and (',PairY,',',PairX,'), row');
                                hint[PairY, PairX] := SBA_RemoveAt(hint[PairY, PairX], i);
                            end
                            else
                                i := i + 1;
                        // for p := 1 to length(hint[y, x]) do
                        //     if 
                        WriteHint(hint);
                    end;

                    // if Matches = 2 then
                    // begin
                        //for q := 0 to 8 do
                        //    if (q <> x) and (q <> PairX) then
                        //    begin
                        //        if pos(ThisHint[1], hint[q, x]) <> 0 then
                        //        begin
                        //            hint[q, x] := SBA_RemoveAt(hint[q, x], pos(ThisHint[1], hint[q, x]));

                        //            if VERBOSE then
                        //                writeln('Remove ', ThisHint[1], ' from (', q, ',', x, ') by hidden pair of (',y,',',x,') and (',PairY,',',PairX,'), row-row, 0');
                        //        end;
                        //        
                        //        if pos(ThisHint[2], hint[q, x]) <> 0 then
                        //        begin
                        //            hint[q, x] := SBA_RemoveAt(hint[q, x], pos(ThisHint[2], hint[q, x]));

                        //            if VERBOSE then
                        //                writeln('Remove ', ThisHint[2], ' from (', q, ',', x, ') by hidden pair of (',y,',',x,') and (',PairY,',',PairX,'), row-row, 1');
                        //        end;

                        //    end;

                    // end;      
                end;
        end;
end;

end.