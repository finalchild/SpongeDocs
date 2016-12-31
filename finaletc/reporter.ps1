function print_u($text, $color, $underline = '=') {
    if ($color -eq $null) {
        Write-Host $text
        Write-Host ($underline * $text.Length)
    } else {
        Write-Host $text -ForegroundColor $color
        Write-Host ($underline * $text.Length) -ForegroundColor $color
    }
}

$arg = $args[0]
if ($arg -eq 'fail') {
    Write-Host ''
    print_u ':( ERRORS (These are causing your build to fail):' Red
    Write-Host ''
    foreach ($line in Get-Content errors) {
            Write-Host $line -ForegroundColor Red
    }
    Write-Host ''
    print_u 'END ERRORS' Red
    Write-Host ''
} elseif ($arg -eq 'pass') {
    Write-Host ''
    print_u ':D NO ERRORS (Good job!)' Green
    Write-Host ''
}
