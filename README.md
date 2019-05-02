1. Install Pester
`
Install-Module -Name Pester -Force
`

2. RG must pre-exist

`
Connect-AzAccount

New-AzResourceGroup -Name mk-arm-test-rg -Location EastUS
`

3. Run test
`
$result = Invoke-Pester -Script ./testtemplate.test.ps1 -PassThru

if ($result.failedCount -ne 0) { 
    Write-Error "Pester returned errors"
}
`