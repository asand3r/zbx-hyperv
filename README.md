# zbx-hyperv
PowerShell script for Zabbix to monitor Hyper-V server.  
  
Zabbix Share page:  
Also you can contact me with Telegram: @asand3r  

zbx-hyperv provides possibility to make Low Level Discovery of Hyper-V server VMs and retrieve their parameters, such "Memory Assigned", "CPU Usage", "Status" etc.  
The script wrote with PowerShell and requires at least version 3.0 and Hyper-V module installed.  
**Latest stable version:** 0.1

__Please, read [Requirements and Installation](https://github.com/asand3r/zbx-hpsmartarray/wiki/Requirements-and-Installation) section in Wiki before use. Need to edit zabbix_agentd.conf file.__  

## Dependencies
 - None

## Feautres  
**Low Level Discovery:**
 - [x] Virtual Machines

**Component status:**
 - [x] JSON for dependent items for VMs

## Supported arguments  
**-action**  
What we want to do - make LLD or get component health status (takes: lld, full)  
**-VMName**  
Virtual Machine name if you want to get JSON only for one VM.  
**-version**  
Print script version and exit.  

## Usage
Soon, you will find more examples on Wiki page, but I placed some cases here too.  
- LLD of enclosures, controllers, virtual disks and physical disks:
```powershell
PS C:\> .\zbx-hyperv.ps1 lld

{"data":[{"{#VM.NAME}":"vm01","{#VM.STATE}":"RUNNING","{#VM.VERSION}":"5.0","{#VM.CLUSTERED}":1,"{#VM.HOST}":"hv01","{#VM.GEN}":2}, ...}
```
- Request JSON with all VMs parameters:
```powershell
PS C:\> .\zbx-hyperv.ps1 full
{"vm01":{"IntegrationServicesState":"","MemoryAssigned":1073741824,"IntegrationServicesVersion":"","NumaSockets":1,"Uptime":132565,
"State":"Running","NumaNodes":1,"CPUUsage":0,"Status":"Operating normally"},... }
```

## Zabbix templates
In addition I've attached preconfigured Zabbix Template here, so you can use it in your environment. It's using Low Level Discovery functionality.   
Have fun and rate it on [share.zabbix.com](https://share.zabbix.com/storage-devices/hp/hp-smart-array-controller) if you like it. =)

**Tested with**:  
Hyper-V on Windows Server 2012 R2
