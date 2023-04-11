#variable
$spName = "e&-ms-sp-devops-reader"
$role = "Reader"
$SubscriptionId = "xxxxxxx-xxxxxx-xxxxx-xxxxx"

#create new AD Service Principal
$sp = New-AzADServicePrincipal -DisplayName $spName

#Assign the role to subscription
New-AzRoleAssignment -ApplicationId $sp.AppId -RoleDefinitionName $role -Scope "/subscriptions/$SubscriptionId"

#connect to the portal using this service principal
$AppId = $sp.AppId
$TenantId = $sp.AppOwnerOrganizationId
$SecretKey = $sp.PasswordCredentials.SecretText

$azurePassword = ConvertTo-SecureString $SecretKey -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($AppId, $azurePassword)
Connect-AzAccount -ServicePrincipal -TenantId $TenantId -Credential $Credential -Subscription $SubscriptionId
