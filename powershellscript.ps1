param(
[Parameter(Mandatory=$true)][string]$resource_group_name,       #Enter the resourcegroup name of the Storageaccount
[Parameter(Mandatory=$true)][string]$storageaccount_names,        #Enter the storage account name(s) on which failover has to be initiated
[Parameter(Mandatory=$true)][string]$sku                       #Enter the SKU as Standard_GRS to re-enable geo-replication post failover
)

$securePassword = ConvertTo-SecureString "fLz8Q~8BA.M5xmcBfagAh1fnYdDnSnzbZ.ZTic6q" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "17f6ad18-c18b-4ba4-9539-73ef8db53a1e",$securePassword
Connect-AzAccount -ServicePrincipal -TenantId "36da45f1-dd2c-4d1f-af13-5abe46b99921" -Credential $Credential
Set-AzContext -Subscription "8468b937-7938-4c80-8bce-8ddbdc17364c"

#$storageaccounts = $storageaccount_names.split(",")
foreach($storageaccount_name in $storageaccount_names)
{
#Below command Invokes failover on the selected storage account(s)
$failover = Invoke-AzStorageAccountFailover -ResourceGroupName $resource_group_name -Name $storageaccount_name -Force -AsJob
}

Wait-Job $failover

foreach($storageaccount_name in $storageaccount_names)
{
#Below command updates the SKU of the storage account(s) to Standard_GRS post failover
Set-AzStorageAccount -ResourceGroupName $resource_group_name -Name $storageaccount_name -SkuName $sku -Force
}
