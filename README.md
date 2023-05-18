# zbx-hyperv
PowerShell script for Zabbix to monitor Hyper-V server.  
  
Zabbix Share page: https://share.zabbix.com/virtualization/hyper-v/hyper-v-server  
Also you can contact me with Telegram: @asand3r (English, Russian)  
Rate it on Zabbix Share page, if it helps you. =)

![alt_text](https://pp.userapi.com/c831508/v831508836/1d54c4/aL5ve9-JYSc.jpg)
![alt_text](https://pp.userapi.com/c831508/v831508836/1d54ce/WtGekdXFRHk.jpg)
zbx-hyperv provides possibility to make Low Level Discovery of Hyper-V server VMs and retrieve their parameters, such "Memory Assigned", "CPU Usage", "State" etc. Attached template works only with Zabbix 4.0 and above.  
The script wrote with PowerShell and requires at least version 3.0 and Hyper-V module installed.

**Latest stable version:** 0.2.5

__Please, read [Requirements and Installation](https://github.com/asand3r/zbx-hyperv/wiki/Requirements-and-Installation) section in Wiki before use.__  

To install the script you need to do some steps:

1. Copy the script to folder where zabbix_agentd.exe installed. For example, in the template I'm using "C:\Program Files\Zabbix Agent\scripts";
2. Add new UserParameter to zabbix_agentd.conf (you can find an example in zabbix_agentd_userparameter.txt file; in our environment we using "C:\Program Files\Zabbix Agent\userparameters" directory to store custom UserParameter files and including them in common Zabbix Agent config file with "Include" directive):
```
UserParameter=ms.hyperv[*],powershell -NoProfile -NoLogo -File "%ProgramFiles%\Zabbix Agent\scripts\zbx-hyperv.ps1" 
```
3. You need to add an alias into zabbix config and probably increase timeout to allow the script to finish in time
```
   Alias=service.discovery[hyperv]:service.discovery
   Timeout=15
```
4. Restart Zabbix Agent service:
```
PS C:\> Restart-Service "Zabbix Agent"
```
5. Make a test from a new items with zabbix_get utility:
```
[root@zabbix ~]# zabbix_get -s server01 -k 'ms.hyperv[lld]'
{"data":[{"{#VM.NAME}":"vm01","{#VM.STATE}":"RUNNING","{#VM.VERSION}":"5.0","{#VM.CLUSTERED}":1,"{#VM.HOST}":"hv01","{#VM.GEN}":2}, ... }
```
6. Now it works, so you need to configure new discovery rules, items and trigger. You may use my template from sources as example, or use it out of box. Be careful, it works only with Zabbix Server 4.0 and above!



## Dependencies
 - PowerShell v3.0+

## Feautres  
**Low Level Discovery:**
 - [x] Virtual Machines
 - [x] Hyper-V Services

**Component status:**
 - [x] JSON for dependent items for VMs

## Supported arguments  
**-action**  
What we want to do - make LLD or get JSON with metric for dependent items (takes: lld, full)  
**-version**  
Print script version and exit.  

## Usage 
- LLD of virtual machines:
```powershell
PS C:\> .\zbx-hyperv.ps1 lld
{"data":[{"{#VM.NAME}":"vm01","{#VM.VERSION}":"5.0","{#VM.CLUSTERED}":1,"{#VM.HOST}":"hv01","{#VM.GEN}":2,"{#VM.ISREPLICA}":0}, ...}
```
- Request JSON with all VMs metrics:
```powershell
PS C:\> .\zbx-hyperv.ps1 full
{"vm01":{"IntSvcVer":"6.3.9600.18692","ReplMode":0,"Memory":4294967296,"ReplState":0,"NumaSockets":1,"Uptime":53505,"State":2,
"NumaNodes":1,"ReplHealth":0,"CPUUsage":0,"IntSvcState":0},...}
```

## Zabbix templates
In addition I've attached preconfigured Zabbix Template for version 4.0 and above (doesn't work with 3.0, 3.2, 3.4!), so you can use it in your environment. It's using Low Level Discovery functionality.

**Tested with**:  
Hyper-V on Windows Server 2012, 2012 R2 and 2016 and doesn't work with Hyper-V 2008 R2 and lower.
