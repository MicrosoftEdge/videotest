If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

function Disable-AutoUpdate () {
    # Add registry entries to turn off automatic updates
    New-Item HKLM:\SOFTWARE\Policies\Microsoft\Windows -Name WindowsUpdate -Force
    New-Item HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name AU -Force
    New-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name NoAutoUpdate -PropertyType DWORD -Value 1 -Force
    
    # Set wuauserv servie to Manual start
    $Computer = Get-WmiObject -Class Win32_ComputerSystem
    $DUT=$Computer.Name
    $service = Get-WmiObject Win32_Service -Filter 'Name="wuauserv"'
    
    if ($service.StartMode -ne "Manual") {
        $result = $service.ChangeStartMode("Manual").ReturnValue
        if ($result) {
            "Failed to change the 'wuauserv' service to manual start on $DUT. The return value was $result."
        } else {
            "Success to change Start Mode to Manual for the 'wuauserv' service on $DUT."
        }
    } else {
        "The 'wuauserv' service on $DUT is already Manual."
    }

    # If service is running, stop the service.
    if ($service.State -eq "Running") {
        $result = $service.StopService().ReturnValue
        if ($result) {
            "Failed to stop the 'wuauserv' service on $DUT. The return value was $result."
        } else {
            "Success to stop the 'wuauserv' service on $DUT."
        }
    } else {
        "The 'wuauserv' service on $DUT is already stopped."
    }

    # If there is any scheduled update task, disable them.
    Disable-ScheduledTask -taskpath "\microsoft\windows\WindowsUpdate" -TaskName "Scheduled Start"
    Disable-ScheduledTask -taskpath "\microsoft\windows\WindowsUpdate" -TaskName "Automatic App Update"
}

function Set-PowerSettings () {
    # Disable monitor timeout.
    powercfg /Change monitor-timeout-dc 0
    powercfg /Change monitor-timeout-ac 0
    # Disable adaptive screen brightness.
    powercfg /SetdcValueIndex SCHEME_CURRENT SUB_VIDEO ADAPTBRIGHT 0
    powercfg /SetacValueIndex SCHEME_CURRENT SUB_VIDEO ADAPTBRIGHT 0
    # Set video brightness to 50%.
    powercfg /SetdcValueIndex SCHEME_CURRENT SUB_VIDEO aded5e82-b909-4619-9949-f5d71dac0bcb 50
    powercfg /SetacValueIndex SCHEME_CURRENT SUB_VIDEO aded5e82-b909-4619-9949-f5d71dac0bcb 50
    # Disable video idle state.
    powercfg /SetdcValueIndex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 0
    powercfg /SetacValueIndex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 0
    # Disable sleep.
    powercfg /Change standby-timeout-dc 0
    powercfg /Change standby-timeout-ac 0
    # Disable hibernate.
    powercfg /Change hibernate-timeout-dc 0
    powercfg /Change hibernate-timeout-ac 0
    # Set disk timout.
    powercfg /Change disk-timeout-dc 15
    powercfg /Change disk-timeout-ac 15
    # Turn off computer when battery is critical (at 4).
    powercfg /SetdcValueIndex SCHEME_CURRENT SUB_BATTERY BATACTIONCRIT 3
    powercfg /SetdcValueIndex SCHEME_CURRENT SUB_BATTERY BATLEVELCRIT 4
    # Disable low battery action.
    powercfg /SetdcValueIndex SCHEME_CURRENT SUB_BATTERY BATACTIONLOW 0
    # Disable critical and low battery notifications.
    powercfg /SetdcValueIndex SCHEME_CURRENT SUB_BATTERY BATFLAGSCRIT 0
    powercfg /SetdcValueIndex SCHEME_CURRENT SUB_BATTERY BATFLAGSLOW 0

    powercfg /SetActive SCHEME_CURRENT
}

Disable-AutoUpdate
Set-PowerSettings

# Build Defender Cache 
& $(Join-Path $env:ProgramFiles "\Windows Defender\mpcmdrun.exe") BuildSFC -Timeout 7200000

# Build NGen Cache
& $(Join-Path $env:WinDir "\Microsoft.NET\Framework\v4.0.30319\ngen.exe") ExecuteQueuedItems
