[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $subscriptionId
)

$deploymentName = "Multi-sub-deployment"
$deploymentLocation = "westeurope"
$templateFile = ".\ARM-Templates\storage-Account\azuredeploy.json"
$templateParameterFile = ".\ARM-Templates\storage-Account\azuredeploy.parameters.json"


$excludedSubs = (
    ""

)

if ($subscriptionId -eq "ALL") {

    $subscriptions = Get-AzSubscription | Where-Object { $_.Id -NotIn $excludedSubs }
    # getting all subscriptions

    Write-Output "No subscription specified. Deploying to all subscriptions" -Verbose
    foreach ($subscription in $subscriptions) {
        
        $subscriptionId = $subscription.id
        Set-AzContext -SubscriptionId $subscriptionId

        New-AzSubscriptionDeployment -Name $deploymentName -Location $deploymentLocation `
            -TemplateParameterFile $templateParameterFile -TemplateFile $templateFile
    }
}

else {
    # using specified subscription

    Write-Output "Subscription specified at pipeline. Targeting $subscriptionId" -Verbose
    Set-AzContext -SubscriptionId $subscriptionId

    New-AzSubscriptionDeployment -Name $deploymentName -Location $deploymentLocation `
        -TemplateParameterFile $templateParameterFile -TemplateFile $templateFile
}