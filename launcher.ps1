
# Check main executable
if (!(Test-Path '.\sudoku.exe')) {
    Write-Error 'sudoku.exe cannot be found.'
    Exit 1
}

# Check configuration file
if (!(Test-Path '.\defaults.ini')) {
    Write-Warning 'Configuration file not found; creating a default file'

    (
        '[sudoku-defaults]',
        'verbose=TRUE',
        'theme=Switch',
        'input=Space',
        'inputFile=stdin',
        '',
        '; Option values are case and space-sensitive',
        '',
        '; verbose',
        '; ---------------------------------------------',
        '; TRUE/FALSE    Output each action done to Sudoku_Steps_xxxxxxxxx.txt ',
        '',
        '',
        '; theme',
        '; ---------------------------------------------',
        '; Plain OR Switch OR E257',
        '',
        '',
        '; input',
        '; ---------------------------------------------',
        '; Space       Delimit each number with space, 0 for empty cells, single or multi-line allowed',
        '; Continuous  No delimiter between characters, use space or 0 or . for empty cells, single line only',
        '',
        '',
        '; inputFile',
        '; ---------------------------------------------',
        '; stdin OR a valid file name',
        ''
    ) | Out-File '.\defaults.ini' -Encoding ASCII

}

Write-Host
Write-Host 'Starting sudoku'
& .\sudoku.exe