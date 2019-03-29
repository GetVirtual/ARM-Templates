Get-AzSubscription -SubscriptionName "Microsoft Azure Internal Consumption" -ErrorAction SilentlyContinue | Set-AzContext

#Remove-AzResourceGroup -Name "Test-ARM" -Force -ErrorAction SilentlyContinue
#New-AzResourceGroup -Name "Test-ARM" -Location "West Europe"
#Start-Sleep -Second 5

New-AzResourceGroupDeployment -Name "Deployment" -ResourceGroupName "Test-ARM" -TemplateFile .\azuredeploy.json -Verbose -Mode Complete
