Describe "VM Deployment Tests" {
  BeforeAll {
    $vmpass = ConvertTo-SecureString 'mypassword' -asplaintext -force              

    $DebugPreference = "Continue"    
  }
}

AfterAll {
    $DebugPreference = "SilentlyContinue"
}

Context "When deploying vms with valid params" {
    $output = Test-AzResourceGroupDeployment `
        -ResourceGroupName mk-arm-test-rg `
        -TemplateFile .\testtemplate.json `
        -TemplateParameterFile .\testtemplate.parameters.json `
        -ErrorAction Stop `
        5>&1

    $result = (($output[22] -split "Body:")[1] | ConvertFrom-Json).properties

  It "Should be deployed successfully" {
    $result.provisioningState | Should -Be "Succeeded"
  }

  $resource = $result.validatedResources[4]

  It "Should have VM name matching pattern" {

    $resource.name | Should -MatchExactly ".*VM"
  }

  It "Should have tags matching pattern" {

    $resource.properties.tags.application | Should -Not -BeNullOrEmpty
    $resource.properties.tags.application | Should -Be "App1"
  }
}
