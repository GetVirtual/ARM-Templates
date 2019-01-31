Get-AzSubscription -SubscriptionName "Microsoft Azure Internal Consumption" -ErrorAction SilentlyContinue | Set-AzContext

Remove-AzResourceGroup -Name "ARM" -Force -ErrorAction SilentlyContinue
New-AzResourceGroup -Name "ARM" -Location "West Europe"

Start-Sleep -Second 5

Test-AzResourceGroupDeployment -ResourceGroupName "ARM" -TemplateFile .\azuredeploy.json -ErrorAction Stop -WarningAction Stop

New-AzResourceGroupDeployment -Name "Deployment" -ResourceGroupName "ARM" -TemplateFile .\azuredeploy.json -Verbose