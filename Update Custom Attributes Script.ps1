# If CSV contains the VM's from multiple vCenters you can specify all the corresponding vCenters in the script
$vCenterName = ''
# Set PowerCLI configuration using below command in case of certificate error
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
# Connect to vCenter with credentials having appropriate permissions
connect-viserver $vCenterName
# Specify the complete CSV file path
$FileList = ""
# Import CSV
$VMList=Import-CSV $FileList
# Read and update the custom attributes for VM's that exist in vCenter
ForEach($Line in $VMList)
{
    $vm = Get-Vm $Line.Name -ErrorAction SilentlyContinue
    if($vm -ne $null){
        # If VM exist in vCenter
        Get-Vm $vm | Set-Annotation -CustomAttribute "Business Group" -Value $Line.BusinessGroup
        Get-Vm $vm | Set-Annotation -CustomAttribute "VM Owner" -Value $Line.VMOwner
        Get-Vm $vm | Set-Annotation -CustomAttribute "Application" -Value $Line.Application
        Get-Vm $vm | Set-Annotation -CustomAttribute "VM Justification" -Value $Line.VMJustification
        Get-Vm $vm | Set-Annotation -CustomAttribute "VRM Owner" -Value $Line.VRMOwner
    }
    else {
        Write-Host "VM does not exist in vCenter"
    }
}
# Disconnect vCenter
Disconnect-VIServer -Server $vCenterName -Confirm:$False
