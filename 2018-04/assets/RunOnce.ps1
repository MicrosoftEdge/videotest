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

function Disable-Sleep () {
    # Never Sleep
    powercfg -SETDCVALUEINDEX scheme_balanced sub_sleep 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0
    powercfg -SETACVALUEINDEX scheme_balanced sub_sleep 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0
    # Never Hibernate
    powercfg -SETDCVALUEINDEX scheme_balanced sub_sleep 9d7815a6-7ee4-497e-8888-515a05f02364 0
    powercfg -SETACVALUEINDEX scheme_balanced sub_sleep 9d7815a6-7ee4-497e-8888-515a05f02364 0
    # Disable system unattended sleep timeout
    powercfg -SETDCVALUEINDEX scheme_balanced sub_sleep 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0
    powercfg -SETACVALUEINDEX scheme_balanced sub_sleep 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0
    # Never auto-dim display
    powercfg -SETDCVALUEINDEX scheme_balanced sub_video 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0
    powercfg -SETACVALUEINDEX scheme_balanced sub_video 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0
    # Never turn off display
    powercfg -SETDCVALUEINDEX scheme_balanced sub_video 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
    powercfg -SETACVALUEINDEX scheme_balanced sub_video 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
    powercfg -SETACTIVE scheme_balanced
}

Disable-AutoUpdate
Disable-Sleep

# REM Build Defender Cache 
& $(Join-Path $env:ProgramFiles "\Windows Defender\mpcmdrun.exe") BuildSFC -Timeout 7200000

# Disable adaptive screen brightness.
powercfg.exe -setacvalueindex scheme_current sub_video adaptbright 0
powercfg.exe -setdcvalueindex scheme_current sub_video adaptbright 0
powercfg.exe -setactive scheme_current

# Build NGen Cache
& $(Join-Path $env:WinDir "\Microsoft.NET\Framework\v4.0.30319\ngen.exe") ExecuteQueuedItems
