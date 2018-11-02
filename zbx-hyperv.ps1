<#
    .SYNOPSIS
    Script for monitoring Hyper-V servers.

    .DESCRIPTION
    Provides LLD for Virtual Machines on the server and
    can retrieve JSON with found VMs parameters for dependent items.

    Works only with PowerShell 3.0 and above.
    
    .PARAMETER action
    What we want to do - make LLD or get full JSON with metrics.

    .PARAMETER VMName
    Virtual Machine name if you want to get JSON only for one VM.

    .PARAMETER version
    Print verion number and exit.

    .EXAMPLE
    zbx-hyperv.ps1 lld
    {"data":[{"{#VM.NAME}":"vm01","{#VM.STATE}":"RUNNING","{#VM.VERSION}":"5.0","{#VM.CLUSTERED}":1,"{#VM.HOST}":"hv01","{#VM.GEN}":2}}

    .EXAMPLE
    zbx-hyperv.ps1 full
    {"shv-vhaproxy01":{"IntegrationServicesState":"","MemoryAssigned":1073741824,"IntegrationServicesVersion":"","NumaSockets":1,
    "Uptime":131276,"State":"Running","NumaNodes":1,"CPUUsage":0,"Status":"Operating normally"}, ...}
    
    .NOTES
    Author: Khatsayuk Alexander
    Github: https://github.com/asand3r/
#>

Param (
    [switch]$version = $False,
    [ValidateSet("lld","full")][Parameter(Position=0,Mandatory=$True)][string]$action,
    [Parameter(Position=1,Mandatory=$False)]$VMName
)

# Script version
$VERSION_NUM="0.1"
if ($version) {
    Write-Host $VERSION_NUM
    break
}


function Make-LLD() {
    $vms = Get-VM | Select @{name = "{#VM.NAME}"; e={$_.VMName}},
                           @{name = "{#VM.STATE}"; e={$_.State.tostring().ToUpper()}},
                           @{name = "{#VM.VERSION}"; e={$_.Version}},
                           @{name = "{#VM.CLUSTERED}"; e={[int]$_.IsClustered}},
                           @{name = "{#VM.HOST}"; e={$_.ComputerName}},
                           @{name = "{#VM.GEN}"; e={$_.Generation}}
    return ConvertTo-Json @{"data" = $vms} -Compress
}

function Get-FullJSON() {
    Param (
        [string]$VM
    )

    $to_json = @{}
    
    if ($VM) {
        $vms = $VM
    } else {
        $vms = '*'
    }

    Get-VM -Name $vms | ForEach-Object {
        $vm_data = [psobject]@{"State" = [string]$_.State;
                               "Status" = $_.Status;
                               "Uptime" = $_.Uptime.TotalSeconds;
                               "NumaNodes" = $_.NumaNodesCount;
                               "NumaSockets" = $_.NumaSocketCount;
                               "IntegrationServicesVersion" = [string]$_.IntegrationServicesVersion;
                               "IntegrationServicesState" = $_.IntegrationServicesState;
                               "CPUUsage" = $_.Cpuusage;
                               "MemoryAssigned" = $_.MemoryAssigned;
                               }
        $to_json += @{$_.VMName = $vm_data}
    }
    ConvertTo-Json $to_json -Compress
}

switch ($action) {
    "lld" {
        Write-Host $(Make-LLD)
    }
    "full" {
        Write-Host $(Get-FullJSON -VM $VMName)
    }
}