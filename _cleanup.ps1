# Remove *.o and *.ppu files

Write-Output $PSCommandPath
Write-Output $('-' * $PSCommandPath.Length)
Get-ChildItem ('*.o', '*.ppu') -Recurse | ForEach-Object ({

    Write-Output "Removing: $($_.Name)"
    Remove-Item $_
})