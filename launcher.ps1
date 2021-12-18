
# Check main executable
if (!(Test-Path '.\sudoku.exe')) {
    Write-Error 'sudoku.exe cannot be found.'
    Exit 1
}

# Check configuration file
if (!(Test-Path '.\defaults.ini')) {
    Write-Warning 'Configuration file not found; creating a default file'
    (
        'interactive = FALSE',
        'verbose = TRUE',
        'theme = Plain',
        '',
        '; Option values are case-insensitive',
        '',
        '; interactive',
        '; --------------------------------------------------------------',
        '; DEFAULT FALSE  -  ACCEPTS TRUE/FALSE',
        '; Pause after each iteration with cell modified',
        '',
        '; verbose',
        '; --------------------------------------------------------------',
        '; DEFAULT TRUE   -  ACCEPTS TRUE/FALSE',
        '; Whether or not output each step to Sudoku_Steps_xxxxxxxxx.txt',
        '',
        '; theme',
        '; --------------------------------------------------------------',
        '; DEFAULT Plain  -  ACCEPTS Plain',
        '; Themes may be added by changing ioGrid.pas and rebuilding',
        ''
    ) | Out-File '.\defaults.ini' -Encoding ASCII

}

Write-Host
Write-Host 'Starting sudoku'
& .\sudoku.exe