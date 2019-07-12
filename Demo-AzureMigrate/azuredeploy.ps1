$RG = "AdminCenter"

Get-AzSubscription -SubscriptionName "Microsoft Azure Internal Consumption" -ErrorAction SilentlyContinue | Set-AzContext

Remove-AzResourceGroup -Name $RG -Force -ErrorAction SilentlyContinue
New-AzResourceGroup -Name $RG -Location "West Europe"

Start-Sleep -Second 5

#Test-AzResourceGroupDeployment -ResourceGroupName "ARM" -TemplateFile .\azuredeploy.json

New-AzResourceGroupDeployment -Name "Deployment" -ResourceGroupName $RG -TemplateFile .\azuredeploy.json -Verbose -Mode Complete -Force