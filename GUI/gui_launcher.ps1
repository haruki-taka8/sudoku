Add-Type -AssemblyName PresentationFramework
Set-Location $PSScriptRoot

# Read/Parse the window
[Xml] $Xaml = Get-Content '.\gui.xaml'
$Form = [Windows.Markup.XamlReader]::Load([Xml.XmlNodeReader]::New($Xaml))
$script:sudoku = [Hashtable]::Synchronized(@{})
$Xaml.SelectNodes('//*[@Name]').Name.ForEach({
    $sudoku[$_] = $Form.FindName($_)
})

# Event handler for solve button
$sudoku.Solve.Add_Click({

    # Input validation
    $InGrid = $sudoku.Input.Text -replace ' ','' -replace '\D', '0'
    if ($InGrid.Length -ne 81) {
        $sudoku.Steps.Text = 'Input must be 81 digits'
        return
    } else {
        $sudoku.Steps.Text = ''
    }

    # Solve the puzzle
    Push-Location ..

    & '.\sudoku.exe' TRUE Plain FALSE $InGrid

    # Retrieve log
    $LogName = 'Sudoku_Steps_' + $InGrid.Substring(0,9) + '.txt'
    $Log = (Get-Content $LogName -Raw).Replace("`r`n", "`n")

    # Display steps
    $sudoku.Steps.Text = $Log

    # Retreieve completed board
    foreach ($Line in ($Log.Split("`n"))) {
        if ($Line -match '^\d{81}$') {
            $OutString = $Line
        }
    }

    # Convert to CSV and display in DataGrid
    $OutString = '012345678' + $OutString
    $OutString = $OutString -Replace '(\d{9})', "`$1`n"
    $OutString = $OutString -Replace '(\d)(?=\d)', "`$1,"
    $OutGrid = $OutString | ConvertFrom-CSV
    $sudoku.SudokuGrid.ItemsSource = $OutGrid

    if (!$sudoku.KeepLog.IsChecked) {Remove-Item $LogName}
    Pop-Location
})

$sudoku.Window.Add_Closing({
    Remove-Variable -Scope Script sudoku
})

# Hide console
if ($Host.Name -eq 'ConsoleHost') {
    powershell.exe -Window Minimized '#'
}

[Void] $sudoku.Window.ShowDialog()
