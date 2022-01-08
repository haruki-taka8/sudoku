# Remove *.o and *.ppu files

function Remove-CompilerFile {
    param (
        [Parameter()] [Boolean] $Silent
    )

    # Gather & display files to delete
    [Collections.ArrayList] $ToRemove = Get-ChildItem ('*.o', '*.ppu') -Recurse
    
    Write-Output "Files to remove: x$($ToRemove.Count)"
    Write-Output $('-' * $PSCommandPath.Length)
    $ToRemove.Name

    # Ask for confirmation
    if (!$Silent -and $ToRemove) {
        Write-Output ''
        Read-Host 'Press ENTER to confirm removal'
    }

    # Delete files
    foreach ($Item in $ToRemove) {Remove-Item $Item}

    if ($ToRemove) {
        Write-Output $('-' * $PSCommandPath.Length)
        Write-Output 'Files removed'
    }
}
