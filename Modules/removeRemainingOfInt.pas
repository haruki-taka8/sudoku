unit removeRemainingOfInt;

interface
uses types, auxiliary;
procedure RemoveRemainingOfInt (var grid : TIntegerGrid; InputHint : TStringGrid);


implementation

procedure RemoveRemainingOfInt (var grid : TIntegerGrid; InputHint : TStringGrid);
var x, y, p, ThisPosX, ThisPosY : integer;
    PossibleX, PossibleY : string;
begin
    for p := 1 to 9 do
    begin
        PossibleX := '012345678';
        PossibleY := '012345678';
        
        // Elminate impossible X and Y coordinates for digit p
        for y := 0 to 8 do
            for x := 0 to 8 do
                if grid[y, x] = p then
                begin
                    ThisPosY := pos(SBA_IntToStr(y), PossibleY);
                    ThisPosX := pos(SBA_IntToStr(x), PossibleX);
                    
                    if (ThisPosY <> 0) and (ThisPosX <> 0) then
                    begin
                        possibleY := SBA_RemoveAt(PossibleY, ThisPosY)
                    end;
                end;
        
        // If only one count of digit missing, locate the missing cell
        if ((length(PossibleY) = 1) and (length(PossibleX) = 1)) then
            begin
                grid[SBA_StrToInt(PossibleY), SBA_StrToInt(PossibleX)] := p;
                if VERBOSE then
                    writeln('Set (', PossibleY, ',', PossibleX, ') to ', p, ' by remaining 1 digit');
            end;
    end;
end;

end.