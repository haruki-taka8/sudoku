unit pointingPair;

interface
uses types, auxiliary;
procedure RemoveHint (var hint : TStringGrid);


implementation

function Contains (SearchFrom : string; Key : integer) : integer;
var Output : integer;
begin
    if (pos(SBA_IntToStr(Key), SearchFrom)) = 0 then
        Output := 0
    else
        Output := 1;
    Contains := Output;
end;

procedure RemoveHint (var hint: TStringGrid);
var x, y, p, q, r, s, ThisX, ThisY, LeftX, LeftY, Count : integer;
    Cell1, Cell2, Cell3 : integer;
begin
    for y := 0 to 8 do
        for x := 0 to 8 do
            for p := 1 to 9 do
            begin
                Count := 0;
                LeftX := 3 * (x div 3);
                LeftY := 3 * (y div 3);

                // Row (claiming)
                for r := 0 to 2 do
                    for s := 0 to 2 do
                    begin
                        ThisX := LeftX + s;
                        ThisY := LeftY + r;

                        if (Contains(hint[ThisY, ThisX], p)) = 1 then
                            Count := Count + 1;
                    end;

                Cell1 := Contains(hint[y, LeftX],   p);
                Cell2 := Contains(hint[y, LeftX+1], p);
                Cell3 := Contains(hint[y, LeftX+2], p);
                if ((Cell1+Cell2+Cell3) = 2) and (Count = 2) then
                begin
                    // Remove from row
                    for q := 0 to 8 do
                        if (pos(SBA_IntToStr(p), hint[y, q]) <> 0) and ((q div 3) <> (x div 3)) then
                        begin
                            hint[y, q] := SBA_RemoveAt(hint[y, q], pos(SBA_IntToStr(p), hint[y, q]));
            
                            if VERBOSE then
                                writeln('Remove ', p, ' from (', y, ',', q, ') by pointing pair, row-row');
                        end;

                    // Remove from subgrid?
                end;


                // Column (claiming)
                for r := 0 to 2 do
                    for s := 0 to 2 do
                    begin
                        ThisX := LeftX + s;
                        ThisY := LeftY + r;

                        if (Contains(hint[ThisY, ThisX], p)) = 1 then
                            Count := Count + 1;
                    end;

                Cell1 := Contains(hint[LeftY, x],   p);
                Cell2 := Contains(hint[LeftY+1, x], p);
                Cell3 := Contains(hint[LeftY+2, x], p);
                if ((Cell1+Cell2+Cell3) = 2) and (Count = 2) then
                begin
                    for q := 0 to 8 do
                        if (pos(SBA_IntToStr(p), hint[q, x]) <> 0) and ((q div 3) <> (x div 3)) then
                        begin
                            hint[q, x] := SBA_RemoveAt(hint[q, x], pos(SBA_IntToStr(p), hint[q, x]));
            
                            if VERBOSE then
                                writeln('Remove ', p, ' from (', q, ',', x, ') by pointing pair, col-col' )
                        end;
                end;
            end;
end;

end.