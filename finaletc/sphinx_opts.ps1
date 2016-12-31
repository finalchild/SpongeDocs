$arg = $args[0]
$locale=$(echo $arg | sed s/_/-/)

foreach ($lang In (Get-Content langs.json | ConvertFrom-Json)) {
    if ($locale -eq $lang.locale) {
        $crowdin_code = $lang.crowdin_code
    }
}

Write-Output "-D language=$arg source dist/$BRANCHNAME/$crowdin_code"
