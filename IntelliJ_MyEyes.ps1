# IntelliJ_MyEyes.ps1

# Purpose: This script automates the process of recovering "My Eyes Only" PIN Codes from SnapChat app.

# Open PowerShell Terminal (Admin) and run the script with the following command:
# Clone: ~ Invoke-WebRequest -Uri https://raw.githubusercontent.com/arghya339/IntelliJ-MyEyes/refs/heads/master/IntelliJ_MyEyes.ps1 -OutFile "$env:USERPROFILE\Downloads\IntelliJ_MyEyes.ps1"
# Serial: ~ adb devices
# Usage: ~ .\IntelliJ_MyEyes.ps1.ps1 [DEVICE_SERIAL]
# ie. ~ Set-ExecutionPolicy Bypass -Scope Process -Force; $serial = (adb devices | Select-String -Pattern '(\S+)\s+device' | ForEach-Object { $_.Matches.Groups[1].Value }); Set-ExecutionPolicy Bypass -Scope Process -Force; & "$env:USERPROFILE\Downloads\IntelliJ_MyEyes.ps1" $serial
# or  ~ Set-ExecutionPolicy Bypass -Scope Process -Force; & "$env:USERPROFILE\Downloads\IntelliJ_MyEyes.ps1" [DEVICE_SERIAL]

# Prerequisites:
# - Android device with USB debugging enabled (and enable it form Developer options and you can enable Developer options by tapping the build number 7 times from Device Settings)
# - Android device with SanpChat installed (and you know your SnapChat accouts password with Memories Smart Backup feature enabled)
# - A PC with working internet connection

# Disclaimer:
# This script is for educational purposes only. 
# Modifying and reinstalling APKs can be risky and may violate app terms of service or legal regulations. 
# Use it responsibly and at your own risk.

# Saftey:
# After My Eyes Only PinCode Recovery Complite Please Disabled Developer options from Device Settings.
# or Uninstall SnapChat Debug APK and install SnapChat Release APK form Google PlayStore.

# Powered by Hashcat (github.com/hashcat/hashcat)
# Inspired by meobrute (github.com/sdushantha/meobrute)
# Author: arghya339 (github.com/arghya339)

# --- Define the eye color (adjust as desired) ---
$eyeColor = 'Green'  # primary color
# Construct the eye shape using string concatenation
$eye = @"
  ______            __              __ __ __    _____      __       __          ________                            
|      \          |  \            |  \  \  \  |     \    |  \     /  \        |        \                           
 \▓▓▓▓▓▓_______  _| ▓▓_    ______ | ▓▓ ▓▓\▓▓   \▓▓▓▓▓    | ▓▓\   /  ▓▓__    __| ▓▓▓▓▓▓▓▓__    __  ______   _______ 
  | ▓▓ |       \|   ▓▓ \  /      \| ▓▓ ▓▓  \     | ▓▓    | ▓▓▓\ /  ▓▓▓  \  |  \ ▓▓__   |  \  |  \/      \ /       \
  | ▓▓ | ▓▓▓▓▓▓▓\\▓▓▓▓▓▓ |  ▓▓▓▓▓▓\ ▓▓ ▓▓ ▓▓__   | ▓▓    | ▓▓▓▓\  ▓▓▓▓ ▓▓  | ▓▓ ▓▓  \  | ▓▓  | ▓▓  ▓▓▓▓▓▓\  ▓▓▓▓▓▓▓
  | ▓▓ | ▓▓  | ▓▓ | ▓▓ __| ▓▓    ▓▓ ▓▓ ▓▓ ▓▓  \  | ▓▓    | ▓▓\▓▓ ▓▓ ▓▓ ▓▓  | ▓▓ ▓▓▓▓▓  | ▓▓  | ▓▓ ▓▓    ▓▓\▓▓    \ 
 _| ▓▓_| ▓▓  | ▓▓ | ▓▓|  \ ▓▓▓▓▓▓▓▓ ▓▓ ▓▓ ▓▓ ▓▓__| ▓▓    | ▓▓ \▓▓▓| ▓▓ ▓▓__/ ▓▓ ▓▓_____| ▓▓__/ ▓▓ ▓▓▓▓▓▓▓▓_\▓▓▓▓▓▓\
|   ▓▓ \ ▓▓  | ▓▓  \▓▓  ▓▓\▓▓     \ ▓▓ ▓▓ ▓▓\▓▓    ▓▓    | ▓▓  \▓ | ▓▓\▓▓    ▓▓ ▓▓     \\▓▓    ▓▓\▓▓     \       ▓▓
 \▓▓▓▓▓▓\▓▓   \▓▓   \▓▓▓▓  \▓▓▓▓▓▓▓\▓▓\▓▓\▓▓ \▓▓▓▓▓▓      \▓▓      \▓▓_\▓▓▓▓▓▓▓\▓▓▓▓▓▓▓▓_\▓▓▓▓▓▓▓ \▓▓▓▓▓▓▓\▓▓▓▓▓▓▓ 
                                                                     |  \__| ▓▓        |  \__| ▓▓                  
                                                                      \▓▓    ▓▓         \▓▓    ▓▓                  
https://github.com/arghya339/IntelliJ-MyEyes                           \▓▓▓▓▓▓           \▓▓▓▓▓▓ >_𝒟𝑒𝓋𝑒𝓁𝑜𝓅𝑒𝓇: @𝒶𝓇𝑔𝒽𝓎𝒶𝟥𝟥𝟫
"@
# Set the console foreground color for the eyes
Write-Host $eye -ForegroundColor $eyeColor
Write-Host ""  # Space

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "# --- Colored log indicators  ---"
Write-Host "[+]" -ForegroundColor Green "-good"  # "[🗸]"
Write-Host "[x]" -ForegroundColor Red "-bad"  # "[✘]"
Write-Host "[i]" -ForegroundColor Blue "-info"
Write-Host "[~]" -ForegroundColor White "-running"
Write-Host "[!]" -ForegroundColor Yellow "-notice"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# PowerShell valid enumerator names lists
<#
Write-Host "[#]" -ForegroundColor Yellow "-Yellow"
Write-Host "[#]" -ForegroundColor DarkYellow "-DarkYellow"

Write-Host "[#]" -ForegroundColor Magenta "-Magenta"
Write-Host "[#]" -ForegroundColor DarkMagenta "-DarkMagenta"

Write-Host "[#]" -ForegroundColor Red "-Red"
Write-Host "[#]" -ForegroundColor DarkRed "-DarkRed"

Write-Host "[#]" -ForegroundColor Cyan "-Cyan"
Write-Host "[#]" -ForegroundColor DarkCyan "-DarkCyan"
Write-Host "[#]" -ForegroundColor Blue "-Blue"
Write-Host "[#]" -ForegroundColor DarkBlue "-DarkBlue"

Write-Host "[#]" -ForegroundColor Green "-Green"
Write-Host "[#]" -ForegroundColor DarkGreen "-DarkGreen"

Write-Host "[#]" -ForegroundColor White "-White"
Write-Host "[#]" -ForegroundColor Gray "-Gray"

Write-Host "[#]" -ForegroundColor DarkGray "-DarkGray"

Write-Host "[#]" -ForegroundColor Black -BackgroundColor White "-Black"
#>

# --- Checking Internet Connection using google.com IPv4-IP Address (8.8.8.8) ---
Write-Host "[~]" -ForegroundColor White "Checking internet Connection..."
if (!(Test-Connection 8.8.8.8 -Count 1 -Quiet)) {
  Write-Host "[x]" -ForegroundColor Red "Oops! No Internet Connection available.`nConnect to the Internet and try again later."
  return 1
}

# --- local Variables ---
$fullScriptPath = $MyInvocation.MyCommand.Path  # running script path
$meo = Join-Path $env:USERPROFILE "meo"  # $env:USERPROFILE\meo dir
# --- Create the $meo directory if it doesn't exist ---
if (!(Test-Path $meo)) {
  mkdir $meo -Force
}
# $potfile = Join-Path $meo "hashcat-6.2.6\hashcat.profile"  # $env:USERPROFILE\meo\hashcat.potfile file, Hashcat store Craked Passcode in this file for Later use
$potfile = "C:\tools\hashcat-6.2.6\hashcat.potfile"  # hashcat.potfile refers to hashcat.password list file
$hashed_passcode_file = Join-Path $meo "hashed_passcode.txt"  # $env:USERPROFILE\meo\hashed_passcode.txt file
$pullDir = Join-Path $meo "snapchat_apks"  # $env:USERPROFILE\meo\snapchat_apks dir (apks pull dir)
$zipFilePath = Join-Path $meo "snapchat.zip"  # snapchat.zip file path
$apksFilePath = Join-Path $meo "snapchat.apks"  # snapchat.apks file path
$apkFilePath = Join-Path $meo "snapchat.apk"  # snapchat.apk file path
$signed_apkFilePath = Join-Path $meo "snapchat_signed.apk"  # snapchat_signed.apk file path
$debug_apkFilePath = Join-Path $meo "snapchat_debug.apk"  # snapchat_debug.apk file path

# --- Check for dependencies ---
foreach ($dependency in @("choco", "java", "jdk", "android-sdk", "python", "hashcat"<#, "7z"#>)) {
  $installed = $false
  if ($dependency -eq "java") {
    # Custom check for java installation
    if (Test-Path "C:\Program Files\Java\jdk-17\bin") {
        $installed = $true
    }
  } else {
    # General check for executables
    if (Get-Command $dependency -ErrorAction SilentlyContinue) {
        $installed = $true
    }
  }

  if ($dependency -eq "jdk") {
    # Custom check for java 8 installation
    if (Test-Path "C:\Program Files\AdoptOpenJDK\jdk-8.0.292.10-hotspot\bin") {
        $installed = $true
    }
  } else {
    # General check for executables
    if (Get-Command $dependency -ErrorAction SilentlyContinue) {
        $installed = $true
    }
  }

  if ($dependency -eq "android-sdk") {
      # Custom check for Android SDK installation
      if (Test-Path "C:\Android\android-sdk") {
          $installed = $true
      }
  } else {
      # General check for executables
      if (Get-Command $dependency -ErrorAction SilentlyContinue) {
          $installed = $true
      }
  }

  if ($dependency -eq "python") {
    # Custom check for python installation
    if (Test-Path "$env:USERPROFILE\AppData\Local\Programs\Python\Python313") {
        $installed = $true
    }
  } else {
    # General check for executables
    if (Get-Command $dependency -ErrorAction SilentlyContinue) {
        $installed = $true
    }
  }

  if ($dependency -eq "hashcat") {
    # Custom check for hashcat installation
    if (Test-Path "C:\tools\hashcat-6.2.6\hashcat.exe") {
        $installed = $true
    }
  } else {
    # General check for executables
    if (Get-Command $dependency -ErrorAction SilentlyContinue) {
        $installed = $true
    }
  }

  if (-not $installed) {
      Write-Host "[!]" -ForegroundColor Yellow "Could not find '$dependency', attempting to install..."

      switch ($dependency) {
          "choco" {
              <#  
              # Install Chocolatey using PS
              Write-Host "[!] Attempting to install Chocolatey..."
              $result = winget install Chocolatey.Chocolatey --silent --force | Out-String
              if ($result -notmatch "Successfully installed") {
                Write-Host "[x] Winget installation failed. Attempting manual installation..." -ForegroundColor Yellow
                Set-ExecutionPolicy Bypass -Scope Process -Force;
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
                iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
              }
              if (-not (Test-Path "C:\ProgramData\chocolatey\bin\choco.exe")) {
                Write-Host "[x] Chocolatey installation failed. Please install it manually." -ForegroundColor Red
                exit 1
              }
              Write-Host "[+] Chocolatey installed successfully." -ForegroundColor Green
              #>
              # Install Chocolatey using Winget [Apache 2.0]
              Write-Host "[!] Attempting to install Chocolatey using Winget..." -ForegroundColor Yellow
              $result = winget install Chocolatey.Chocolatey --silent --force | Out-String
              # choco --version  # check chocolatey version
              if ($result -notmatch "Successfully installed") {
                Write-Host "[x] Winget installation failed. Attempting manual installation..." -ForegroundColor Yellow
                Set-ExecutionPolicy Bypass -Scope Process -Force
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
                iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
              }
              # Verify Installation
              if (-not (Test-Path "C:\ProgramData\chocolatey\bin\choco.exe")) {
                Write-Host "[x] Chocolatey installation failed. Please install it manually." -ForegroundColor Red
                exit 1
              }
              Write-Host "[+] Chocolatey installed successfully." -ForegroundColor Green
              # Ensure Chocolatey path is in environment variables
              Write-Host "[!] Checking environment variables..." -ForegroundColor Yellow
              $envPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine") -split ';'
              if (-not ($envPath -contains "C:\ProgramData\chocolatey\bin")) {
                $envPath += "C:\ProgramData\chocolatey\bin"
                [System.Environment]::SetEnvironmentVariable("Path", ($envPath -join ';'), "Machine")
                Write-Host "[+] Chocolatey path added to environment variables." -ForegroundColor Green
              } else {
                Write-Host "[!] Chocolatey path already present in environment variables." -ForegroundColor Green
              }
              # Remove-Item -Recurse -Force C:\ProgramData\chocolatey  # Uninstall Chocolatey using PS
              # winget uninstall Chocolatey.Chocolatey  # Uninstall chocolatey using winget
              # Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name "ChocolateyInstall" -ErrorAction SilentlyContinue
          }
          "java" {
              # Install Oracle.JDK.17 using Winget due to latest in winget  # [GFTC]
              winget install Oracle.JDK.17 --silent --force
              # Verify Installation
              if (-not (Test-Path "C:\Program Files\Java\jdk-17\bin")) {
                Write-Host "[x] Oracle.JDK.17 installation failed. Please install it manually." -ForegroundColor Red
                exit 1
              }
              Write-Host "[+] Oracle.JDK.17 installed successfully." -ForegroundColor Green
              # Add Oracle.JDK.17 path in environment variables
              $path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\Program Files\Java\jdk-17\bin"
              [Environment]::SetEnvironmentVariable("Path", $path, "Machine")
              # java -version  # check java version
              # install Microsoft openjdk
              # winget install Microsoft.OpenJDK.17 --silent --force
              # $path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\Program Files\Microsoft\jdk-17.0.13.11-hotspot\bin"
              # [Environment]::SetEnvironmentVariable("Path", $path, "Machine")
              # winget uninstall Oracle.JDK.17  # Uninstall oracle jdk using winget
              # winget uninstall Microsoft.OpenJDK.17  # Uninstall microsoft jdk using winget
          }
          "jdk" {
              # install java 8 using winget for sdkmanager required for downloading build-tools to use apksigner
              winget install AdoptOpenJDK.OpenJDK.8 --force --silent
              # Verify Installation
              if (-not (Test-Path "C:\Program Files\AdoptOpenJDK\jdk-8.0.292.10-hotspot\bin")) {
                Write-Host "[x] AdoptOpenJDK.OpenJDK.8 installation failed. Please install it manually." -ForegroundColor Red
                exit 1
              }
              Write-Host "[+] AdoptOpenJDK.OpenJDK.8 installed successfully." -ForegroundColor Green
              # Add AdoptOpenJDK.OpenJDK.8 path in environment variables
              $path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\Program Files\AdoptOpenJDK\jdk-8.0.292.10-hotspot\bin"
              [Environment]::SetEnvironmentVariable("Path", $path, "Machine")
              $env:JAVA_HOME="C:\Program Files\AdoptOpenJDK\jdk-8.0.292.10-hotspot"
          }
          "android-sdk" {
              # Install SDK (SDK, PlatformTools) using Choco due to winget installs only the platform tools (adb and fastboot) [Apache 2.0]
              $result = choco install android-sdk -y --no-progress -r | Out-String
              # install PlatformTools (adb and fastboot) using Winget due to requred PlatformTools only [Apache 2.0]
              # winget install Google.PlatformTools -y --no-progress
              if ($result -match "already installed") {
                  Write-Host "[+]" -ForegroundColor Green "'android-sdk' is already installed."
              } elseif ($result -match "Chocolatey installed 1/1 packages") {
                  Write-Host "[+]" -ForegroundColor Green "'android-sdk' installed successfully."
              } else {
                  Write-Host "[x]" -ForegroundColor Red "Failed to install 'android-sdk'. Please check the logs for details."
                  exit 1
              }
              $path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\Android\android-sdk\tools\bin"
              [Environment]::SetEnvironmentVariable("Path", $path, "Machine")
              $path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\Android\android-sdk\platform-tools"
              [Environment]::SetEnvironmentVariable("Path", $path, "Machine")
              # check platform-tools: ~ adb devices
              # choco uninstall android-sdk -y  # Uninstall android-sdk using choco
              # Remove-Item -Recurse -Force C:\Android\android-sdk Uninstall android-sdk using PS
              # winget uninstall Google.PlatformTools #  Uninatall PlatformTools using winget
              # Remove-Item -Recurse -Force $env:USERPROFILE\AppData\Local\Android\Sdk\platform-tools  # Uninatall PlatformTools using PS
          }
          "python" {
              # Install Python using Winget due to outdated in Chocolatey [PSF / GPL]
              winget install Python.Python.3.13 --silent --force
              # Verify Installation
              if (-not (Test-Path "$env:USERPROFILE\AppData\Local\Programs\Python\Python313")) {
                Write-Host "[x] Python.3.13 installation failed. Please install it manually." -ForegroundColor Red
                exit 1
              }
              Write-Host "[+] Python.3.13 installed successfully." -ForegroundColor Green
              # Add Python.3.13 path in environment variables
              $path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";$env:USERPROFILE\AppData\Local\Programs\Python\Python313"
              [Environment]::SetEnvironmentVariable("Path", $path, "Machine")
              $path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";$env:USERPROFILE\AppData\Local\Programs\Python\Python313\Scripts"
              [Environment]::SetEnvironmentVariable("Path", $path, "Machine")
              # python --version
              # winget uninstall Python.Python.3.13  # Uninstall Python 3.13 using winget
              # Remove-Item -Recurse -Force $env:USERPROFILE\AppData\Local\Programs\Python\Python313  # Uninatall Python313 using PS
              # Remove-Item -Recurse -Force C:\Python312  # Uninatall Python312 using PS
          }
          "hashcat" {
            # Install Hashcat using choco due to its only available in chocolatey [MIT]
            choco install hashcat -y --no-progress
            # cd C:\tools\hashcat-6.2.6; C:\tools\hashcat-6.2.6\hashcat.exe -V  # check hashcat version
            # Verify Installation
            if (-not (Test-Path "C:\tools\hashcat-6.2.6\hashcat.exe")) {
              Write-Host "[x] Hashcat installation failed. Please install it manually." -ForegroundColor Red
              exit 1
            }
            Write-Host "[+] Hashcat installed successfully." -ForegroundColor Green
            # choco uninstall hashcat -y  # Uninstall hashcat using choco
            # Remove-Item -Recurse -Force C:\tools\hashcat-6.2.6  # Uninatall Hashcat using PS
          }
          <#"7z" {
              # Install 7zip using Winget due to latest in winget
              winget install 7zip.7zip --silent --force
              # 7z --version  # check 7z version
              # winget uninstall 7zip.7zip  # Uninstall 7zip using 
              # Remove-Item -Recurse -Force C:\Program Files\7-Zip  # Uninatall 7z using PS
          }#>
      }
      
      # Recheck java Installation
      if ($dependency -eq "java") {
        $installed = Test-Path "C:\Program Files\Java\jdk-17\bin"
      } else {
        $installed = Get-Command $dependency -ErrorAction SilentlyContinue
      }

      # Recheck java 8 Installation
      if ($dependency -eq "jdk") {
        $installed = Test-Path "C:\Program Files\AdoptOpenJDK\jdk-8.0.292.10-hotspot\bin"
      } else {
        $installed = Get-Command $dependency -ErrorAction SilentlyContinue
      }

      # Recheck android-sdk Installation
      if ($dependency -eq "android-sdk") {
          $installed = Test-Path "C:\Android\android-sdk"
      } else {
          $installed = Get-Command $dependency -ErrorAction SilentlyContinue
      }

      # Recheck python Installation
      if ($dependency -eq "python") {
        $installed = Test-Path "$env:USERPROFILE\AppData\Local\Programs\Python\Python313"
      } else {
        $installed = Get-Command $dependency -ErrorAction SilentlyContinue
      }
      
      # Recheck hashcat Installation
      if ($dependency -eq "hashcat") {
        $installed = Test-Path "C:\tools\hashcat-6.2.6\hashcat.exe"
      } else {
        $installed = Get-Command $dependency -ErrorAction SilentlyContinue
      }

      if (-not $installed) {
          Write-Host "[x]" -ForegroundColor Red "Failed to install '$dependency'. Please install it manually."
          exit 1
      } else {
          Write-Host "[+]" -ForegroundColor Green "'$dependency' installed successfully."
      }
  } else {
      Write-Host "[+]" -ForegroundColor Green "'$dependency' is already installed."
  }
}

adb devices > $null 2>&1  # Silently Starting adb daemon

# --- Number of devices connected to computer through USB ---
$devices = (adb devices | Select-String -Pattern "\sdevice$")
$devicescount = $devices.Count

<#
# --- If only one device is connected, use its serial ---
if ($devicescount -eq 1) {
  $serial = (adb devices | Where-Object { $_ -match '\s+device$' } | ForEach-Object { $_.Split()[0] })
  Set-ExecutionPolicy Bypass -Scope Process -Force; & $fullScriptPath $serial  # Run this script if only one deivce attached in adb
}
#>

# --- Store the serial numbers and models in an array ---
$deviceInfo = @()
if ($devicescount -gt 0) {
    $deviceInfo = $devices | ForEach-Object {
        $serial = ($_ -split "\s+")[0]
        if ($serial -ne "List") {
            $model = adb -s $serial shell "getprop ro.product.model" | Out-String
            $model = $model.Trim()  # Remove any trailing newline or whitespace
            [PSCustomObject]@{
                Serial = $serial
                Model  = $model
            }
        }
    }
}

if ($deviceInfo.Count -ge 7) {
    Write-Host "Error: More than seven devices attached in adb!"
    exit 1
}

# Usage instructions with device model included
function usage {
  Write-Host "[i]" -ForegroundColor Blue "Usage examples:"
  Write-Host "[i]" -ForegroundColor Blue "usage: ~ Set-ExecutionPolicy Bypass -Scope Process -Force; & $fullScriptPath [SERIAL]"
  Write-Host "[i]" -ForegroundColor Blue "The serial number of the device can be found by running ~ adb devices."
  foreach ($device in $deviceInfo) {
      Write-Host "[i]" -ForegroundColor Blue "  $($device.Model) ~ Set-ExecutionPolicy Bypass -Scope Process -Force; & $fullScriptPath $($device.Serial)"
  }
  # Write-Host "[i]" -ForegroundColor Blue "If only one device is connected, the serial number is not needed."
  exit 1
}

# Check if arguments are passed, else show usage
if ($args.Length -eq 0) {
  usage
}

# Assign the passed serial number
$serial = $args[0]

# --- adb dependent Variables ---
$packagePath = adb -s $serial shell "pm path com.snapchat.android"  # "/data/app/com.snapchat.android-*/base.apk" or "^/data/app(/~[^/]+)?/com\.snapchat\.android.*$/base.apk" path
$CorePatchPath = adb -s $serial shell "pm path com.coderstory.toolkit"  # Core Patch LSPosed Module APK Path
$apksPath = $packagePath | ForEach-Object { ($_ -split ":")[1] -replace "/[^/]+\.apk", "" } | Select-Object -Unique  # "/data/app*/com.snapchat.android*" or "^/data/app(/~[^/]+)?/com\.snapchat\.android.*$" path
$databasesOutput = & adb -s $serial shell run-as com.snapchat.android ls -d /data/data/com.snapchat.android/databases 2>$null  # SnapChat databases dir
$meoriesOutput = & adb -s $serial shell run-as com.snapchat.android ls -f /data/data/com.snapchat.android/databases/memories.db 2>$null  # SnapChat memories.db file path
$cpu_abi = adb -s $serial shell getprop ro.product.cpu.abi  # get device arch
# --- Function to get the DPI category based on density ---
function Get-DPICategory {
  # Get the device screen density using wm density
  $density = adb -s $serial shell wm density

  # Extract the numeric value (e.g., "Physical density: 440")
  if ($density -match "Physical density:\s*(\d+)") {
      $densityValue = $matches[1]
      # Write-Host "[i]" "Device screen density: $densityValue DPI"

      # Map the density to DPI category
      switch ($densityValue) {
          {$_ -le 160} { return "mdpi" }             # (Medium Density)
          {$_ -le 240} { return "hdpi" }             # (High Density)
          {$_ -le 320} { return "xhdpi" }            # (Extra High Density)
          {$_ -le 440} { return "xxhdpi" }           # (Extra Extra High Density)
          {$_ -gt 440} { return "xxxhdpi" }          # (Extra Extra Extra High Density)
          default { return "Unknown DPI Category" }
      }
  }
  else {
      Write-Host "[x] Failed to retrieve valid density value. Ensure the device is connected and accessible."
      return "Error: Invalid or empty DPI value"
  }
}
$DPICategory = Get-DPICategory  # get device DPI
# $languageCode = (adb -s $serial shell getprop persist.sys.locale).Split('-')[0] > $null 2>&1  # get device language code (ie.'en')
$languageCode = adb -s $serial shell getprop persist.sys.locale | ForEach-Object { ($_ -split '-')[0] }
if ($languageCode) {
    $languageCode.Split('-')[0] > $null 2>&1
} else {
    Write-Host "No output from adb command. Value is null or empty."
}


# --- Check if the device is connected, authorized or offline via adb ---
# $devicestatus = (adb devices | Where-Object { $_ -match $serial } | ForEach-Object { $_ -split "\s+" })[1] > $null 2>&1
# Run adb devices and filter output for the serial number
$deviceOutput = adb devices | Where-Object { $_ -match $serial }
# Check if any matching device output was found
if ($deviceOutput) {
    # Split the output and extract the second field
    $devicestatus = ($deviceOutput | ForEach-Object { $_ -split "\s+" })[1]
    Write-Host "Device status: $devicestatus"
} else {
    Write-Host "No matching device found for serial: $serial"
    $devicestatus = $null
}

if ($devicestatus -eq 'device') {
  Write-Host "[+]" -ForegroundColor Green "Device '$serial' is connected."
} elseif ($devicestatus -eq 'unauthorized') {
  Write-Host "[x]" -ForegroundColor Red "Device '$serial' is not authorized."
  Write-Host "[!]" -ForegroundColor Yellow "Check for a confirmation dialog on your device."
  exit 1  # Exit the script with an errorimmediately and stops the execution
} else {
  Write-Host "[x]" -ForegroundColor Red "Device '$serial' is offline."
  Write-Host "[!]" -ForegroundColor Yellow "Check if the device is connected and USB debugging is enabled."
  exit 1
}

# --- Get the device model ---
if ($serial) {
  Write-Host "Using device serial: $serial"
  
  try {
      # Fetch the product model using adb
      $product_model = adb -s $serial shell "getprop ro.product.model"
      Write-Host "Device model: $product_model"
  }
  catch {
      Write-Host "[x]" -ForegroundColor Red "Error: Couldn't fetch the product model for '$serial' devices."
      exit 1
  }
} else {
  Write-Host "[x]" -ForegroundColor Red "No device found or '$serial' is invalid."
  exit 1
}

Write-Host "[i]" -ForegroundColor Blue "Target device: $serial ($product_model)"

# --- Check if SnapChat is installed on the device ---
if (!($packagePath)) {
  Write-Host "[x]" -ForegroundColor Red "SnapChat is not installed on the $product_model device, Please manually install it form Play Store."
  adb -s $serial shell am start -a android.intent.action.VIEW -d "market://details?id=com.snapchat.android" > $null 2>&1
  Write-Host "[i]" -ForegroundColor Blue "Then try again."
}

# --- Define a custom function for colored prompts ---
function Write-ColoredPrompt {
  param(
    [string]$Message,
    [ConsoleColor]$ForegroundColor,
    [string]$PromptMessage
  )

  Write-Host $Message -NoNewline -ForegroundColor $ForegroundColor
  Write-Host " " $PromptMessage -NoNewline -ForegroundColor $ForegroundColor  # Apply color to prompt message
  return Read-Host
}

# --- Prompt the user for input ---
$userInput = Write-ColoredPrompt -Message "[?]" -ForegroundColor Yellow -PromptMessage "Are you sure you have already installed SnapChat app form PlayStore on Your $product_model device? (Yes/No)"
# Check the user's input
if ($userInput -in @("Yes", "yes", "Y", "y")) {
  Write-Host "[+]" -ForegroundColor Green "Proceeding..."
}
elseif ($userInput -in @("No", "no", "N", "n")) {
  Write-Host "[x]" -ForegroundColor Red "Please manually install SnapChat app form PlayStore on your $product_model device then rerun script again..."
  adb -s $serial shell am start -a android.intent.action.VIEW -d "market://details?id=com.snapchat.android" 2>$null
  return 1
}
else {
  Write-Host "[i]" -ForegroundColor Blue "Invalid input. Please enter Yes or No."
}

# --- Use the custom function to prompt the user ---
$userInput = Write-ColoredPrompt -Message "[?]" -ForegroundColor Yellow -PromptMessage "Are you sure you have already turned on the 'Memories Backup' feature in the Snapchat app? (Yes/No)"
# Check the user's input
if ($userInput -in @("Yes", "yes", "Y", "y")) {
  Write-Host "[+]" -ForegroundColor Green "Proceeding..."
} elseif ($userInput -in @("No", "no", "N", "n")) {
  Write-Host "[!]" -ForegroundColor Blue "Turn on 'Memories Backup when WiFi is unabailable': Open 'SnapChat' app > Settings > Memories > 'Smart Backup'"
  adb -s $serial shell am force-stop com.snapchat.android
  Start-Sleep -Milliseconds 500  # Wait for 500 milliseconds
  adb -s $serial shell monkey -p com.snapchat.android -c android.intent.category.LAUNCHER 1 *> $null 2>&1  # Open SnapChat app
  Start-Sleep -Milliseconds 10000  # Wait for 10000 milliseconds
  # adb shell uiautomator dump; adb pull /storage/emulated/0/window_dump.xml "$env:USERPROFILE\Downloads\window_dump.xml"  # Powered by @uiautomator  # Tested on SnapChat v13.23.0.38
  adb -s $serial shell input tap 28 125 127 224  # tap on 'Profile' icon
  Start-Sleep -Milliseconds 3500  # Wait for 3500 milliseconds
  adb -s $serial shell input tap 934 117 1039 222  # tap on 'Gear' icon
  Start-Sleep -Milliseconds 4000  # Wait for 4000 milliseconds
  adb -s $serial shell input swipe 500 800 500 500 46 1  # swipe down to 'PRIVACY CONTROL' section by changing form 46 to 50 miliseconds its decrease scrolling speed
  Start-Sleep -Milliseconds 3000  # Wait for 3000 milliseconds
  adb -s $serial shell input tap 44 1374 234 1442  # tap on 'Memories' Settings
  Start-Sleep -Milliseconds 500  # Wait for 500 milliseconds
  adb -s $serial shell input tap 948 626 1025 703  # tap on 'Smart Backup'
  Write-Host "[x]" -ForegroundColor Red "Please rerun script again, when 'Memories Backup' are complited..."
  return 1
} else {
  Write-Host "[i]" -ForegroundColor Blue "Invalid input. Please enter Yes or No."
}

# --- Check if the Snapchat Debug APK exists ---
if ($databasesOutput -ne "/data/data/com.snapchat.android/databases") {
    Write-Host "[i]" -ForegroundColor Blue "This SnapChat app is not Debuggable. You need a Debug build of the app to proceed."

    # --- Create a directory to store the extracted APKs and others files ---
    if (!(Test-Path $pullDir)) {
      mkdir $pullDir -Force
    }

    # --- Pull all APKs from device to the $pullDir directory ---
    Write-Host "[~]" -ForegroundColor White "Attempting to pull APK / APKs from path: $apksPath"
      # Only pull the APK if it's not an empty string
      if ($apksPath -like "/data/app*/com.snapchat.android*") {
        # $packagePath = adb shell "pm path com.snapchat.android"; $apksPath = $packagePath | ForEach-Object { ($_ -split ":")[1] -replace "/[^/]+\.apk", "" } | Select-Object -Unique; $apksPath -like "/data/app*/com.snapchat.android*"  # SnapChat v13.24.1.0
        Write-Host "[~]" -ForegroundColor White "Pulling APKs to path: $pullDir"
        # Check if $cpu_abi needs to be renamed
        if ($cpu_abi -eq "arm64-v8a") {
          $cpu_abi = "arm64_v8a"
        } elseif ($cpu_abi -eq "armeabi-v7a") {
          $cpu_abi = "armeabi_v7a"
        }
          try {
            adb -s $serial pull "$apksPath/base.apk" $pullDir > $null 2>&1  # to discard output.
            adb -s $serial pull "$apksPath/split_config.$cpu_abi.apk" $pullDir > $null 2>&1  # to discard output.
            adb -s $serial pull "$apksPath/split_config.$languageCode.apk" $pullDir > $null 2>&1  # to discard output.
            adb -s $serial pull "$apksPath/split_config.$DPICategory.apk" $pullDir > $null 2>&1  # to discard output.
          } catch {
            Write-Host "[x]" -ForegroundColor Red "Failed to pull APKs. Error: $_"
          }
      } elseif ($apksPath -notlike "/data/app*/com.snapchat.android*") {
          Write-Host "[x]" -ForegroundColor Red "APKs path is empty or not specified. Cannot proceed with pulling APKs."
      }
      $requiredApks = @(
        (Join-Path $pullDir "base.apk"),
        (Join-Path $pullDir "split_config.$cpu_abi.apk"),
        (Join-Path $pullDir "split_config.$languageCode.apk"),
        (Join-Path $pullDir "split_config.$DPICategory.apk")
      )
      $missingApks = $requiredApks | Where-Object { -not (Test-Path $_) }
      Write-Host "[i] Missing APKs: $($missingApks -join ', ')" -ForegroundColor Cyan
      if ($missingApks.Count -gt 0) {
        Write-Host "[x]" -ForegroundColor Red "Missing the following APKs: $($missingApks -join ', ')"
      } else {
        Write-Host "[+]" -ForegroundColor Green "All necessary APKs are present in $pullDir dir."
      }
      
      <#
      if ($apksPath -match "^/data/app(/~[^/]+)?/com\.snapchat\.android.*$") {
        Write-Host "[~]" -ForegroundColor White "Pulling APK to path: $meo\base.apk"
        try {
          adb -s $serial pull "$apksPath/base.apk" $meo > $null 2>&1  # to discard output.
        } catch {
          Write-Host "[x]" -ForegroundColor Red "Failed to APK. Error: $_"
        }
      } elseif ($apksPath -notmatch "^/data/app(/~[^/]+)?/com\.snapchat\.android.*$") {
      Write-Host "[x]" -ForegroundColor Red "APK path is empty or not specified. Cannot proceed with pulling APK."
      }
      $requiredApk = @((Join-Path $meo "base.apk"))
      $missingApk = $requiredApk | Where-Object { -not (Test-Path $_)}
      Write-Host "[i] Missing APKs: $($missingApk -join ', ')" -ForegroundColor Cyan
      if ($missingApk.Count -eq 1) {
        Write-Host "[x]" -ForegroundColor Red "Missing the following APK: $($missingApk -join ', ')"
      } else {
        Write-Host "[+]" -ForegroundColor Green "SnapChat 'base.apk' are present in $meo dir."
      }
      #>

      # --- Create the .zip archive of the pulled APKs ---
      if ($missingApks.Count -eq 0) {
        Write-Host "[~]" -ForegroundColor White "Creating a zip archive of the pulled APKs..."
        try {
          Compress-Archive -Path "$pullDir\*" -DestinationPath $zipFilePath -Force
          Write-Host "[+]" -ForegroundColor Green "APKs zipped successfully: $zipFilePath"
        } catch {
          Write-Host "[x]" -ForegroundColor Red "Failed to create zip file: $zipFilePath"
        }
      }
      
      # Check if the .zip file was created and rename it
      if (Test-Path $zipFilePath) {
        Write-Host "[~]" -ForegroundColor White "Renaming the .zip file to .apks"
        try {
          Rename-Item -Path $zipFilePath -NewName "$apksFilePath"
          Write-Host "[+]" -ForegroundColor Green "Renamed $zipFilePath to $apksFilePath"
        } catch {
          Write-Host "[x]" -ForegroundColor Red "Failed to rename .zip file to .apks"
        }
      }

      # Check if the .apks file exists after renaming
      if (Test-Path $apksFilePath) {
        Write-Host "[+]" -ForegroundColor Green "APKs extracted successfully and saved as snapchat.apks"
        Remove-Item -Path "$pullDir" -Recurse -Force
      } else {
        Write-Host "[x]" -ForegroundColor Red "Failed to create SnapChat.APKs"
      }
      
      # --- Download APKEditor.jar if it doesn't exist ---
      if (!(Test-Path (Join-Path $meo "APKEditor-1.4.1.jar"))) {
        Write-Host "[~]" -ForegroundColor White "Downloading APKEditor-*.jar..."
        Invoke-WebRequest -Uri https://github.com/REAndroid/APKEditor/releases/download/V1.4.1/APKEditor-1.4.1.jar -OutFile $meo\APKEditor-1.4.1.jar
      }

      # --- Merge split .APKs into a standalone .APK using APKEditor-*.jar and java 17 ---
      if (Test-Path $apksFilePath) {
        Write-Host "[~]" -ForegroundColor White "Merge Split .apks to Standalone .apk..."
        java -jar $meo\APKEditor-1.4.1.jar m -i $apksFilePath -o $apkFilePath *> $null  # to discard output.
      } elseif (!(Test-Path $apksFilePath)) {
        Write-Host "[i]" -ForegroundColor Blue "snapchat.apks not found."
      } elseif (Test-Path $apkFilePath) {
        Write-Host "[+]" -ForegroundColor Green "Successfully Merge Split to Standalone apk: $apkFilePath"
        Remove-Item -Path $apksFilePath -Force
      } else {
        Write-Host "[x]" -ForegroundColor Red "Failed to built APK form APKs."
      }

      # --- create a keystore if it doesn't exist using keytool that comes with java 17 ---
      if  (!(Test-Path (Join-Path $meo "ks.keystore"))) {
        Write-Host "[~]" -ForegroundColor White "Creating a keystore for signed apk..."
        # keytool -genkey -v -storetype pkcs12 -keystore (Join-Path $meo "ks.keystore") -alias ReVancedKey -keyalg RSA -keysize 2048 -validity 36050 -dname "CN=arghya339, OU=Android Development Team, O=ReVanced, L=Kolkata, S=West Bengal, C=In" -storepass 123456 -keypass 123456
        keytool -genkey -v -storetype JKS -keystore (Join-Path $meo "ks.keystore") -alias ReVancedKey -keyalg RSA -keysize 2048 -validity 36050 -dname "CN=arghya339, OU=Android Development Team, O=ReVanced, L=Kolkata, S=West Bengal, C=In" -storepass 123456 -keypass 123456 > $null 2>&1  # to discard output.
      }
      
      # Download build-tool using sdkmanager that comes with android-sdk and using java 8 with set env variable
      $env:JAVA_HOME="C:\Program Files\AdoptOpenJDK\jdk-8.0.292.10-hotspot"
      Push-Location "C:\Android\android-sdk\tools\bin"; sdkmanager.bat "build-tools;34.0.0"
      $env:Path += ";C:\Android\android-sdk\build-tools\34.0.0"
      Push-Location $env:USERPROFILE

      # --- Signed snapchat.apk using apksigner.jar that comes with Google.SDK and using java 17 ---
      if (Test-Path $apkFilePath) {
        Write-Host "[~]" -ForegroundColor White "Signing the SnapChat APK..."
        apksigner sign --ks $meo\ks.keystore --ks-key-alias ReVancedKey --ks-pass pass:123456 --key-pass pass:123456 --out $signed_apkFilePath $apkFilePath
      } elseif (!(Test-Path $apkFilePath)) {
        Write-Host "[i]" -ForegroundColor Blue "snapchat.apk not found."
      } elseif (Test-Path $signed_apkFilePath) {
        Write-Host "[+]" -ForegroundColor Green "SnapChat APK signed successfully: $signed_apkFilePath"
        Remove-Item -Path "$moe\snapchat_signed.apk.idsig" -Force
        Remove-Item -Path $apkFilePath -Force
      } else {
        Write-Host "[x]" -ForegroundColor Red "Failed to signed the SnapChat APK."
      }
    
      <#
      # --- Signed snapchat base.apk using apksigner.jar that comes with Google.SDK and using java 17 ---
      if (Test-Path $meo\base.apk) {
        Write-Host "[~]" -ForegroundColor White "Signing the SnapChat base APK..."
        apksigner sign --ks $meo\ks.keystore --ks-key-alias ReVancedKey --ks-pass pass:123456 --key-pass pass:123456 --out $signed_apkFilePath $meo\base.apk
      } elseif (!(Test-Path $meo\base.apk)) {
        Write-Host "[i]" -ForegroundColor Blue "snapchat base.apk not found."
      } elseif (Test-Path $signed_apkFilePath) {
        Write-Host "[+]" -ForegroundColor Green "SnapChat base APK signed successfully: $signed_apkFilePath"
        Remove-Item -Path "$moe\snapchat_signed.apk.idsig" -Force
        Remove-Item -Path "$meo\base.apk" -Force
      } else {
        Write-Host "[x]" -ForegroundColor Red "Failed to signed the SnapChat base APK."
      }
      #>

    # --- download makeDebuggable.py ---
    if (!(Test-Path (Join-Path $meo "makeDebuggable.py"))) {
      Write-Host "[~]" -ForegroundColor White "Downloading makeDebuggable.py..."
      Invoke-WebRequest -Uri https://raw.githubusercontent.com/julKali/makeDebuggable/refs/heads/master/makeDebuggable.py -OutFile $meo\makeDebuggable.py
    }

    # --- Building the SnapChat Debug APK using makeDebuggable.py, python, java 17, ks.keystore and Google.SDK ---
    if (Test-Path $signed_apkFilePath) {
      Remove-Item -Path "$meo\snapchat_signed.apk.idsig" -Force
      Write-Host "[~]" -ForegroundColor White "Building the SnapChat Debug APK..."
      python $meo\makeDebuggable.py apk $signed_apkFilePath $debug_apkFilePath $meo\ks.keystore ReVancedKey 123456 > $null 2>&1  # to discard output.      
    } elseif (!(Test-Path $signed_apkFilePath)) {
      Write-Host "[i]" -ForegroundColor Blue "snapchat_signed.apk not found."
    } else {
      Write-Host "[x]" -ForegroundColor Red "Failed to Build the SnapChat DeBug APK using SnapChat apk."
    }

    if (Test-Path $debug_apkFilePath) {
      Write-Host "[+]" -ForegroundColor Green "SnapChat Debug APK built successfully: $debug_apkFilePath"
      
      Remove-Item -Path $signed_apkFilePath -Force 2>$null
      Remove-Item -Path "$meo\snapchat_debug.apk.idsig" -Force 2>$null
      Remove-Item -Path "$meo\snapchat_debug.apk.tmp" -Force 2>$null
      
      if (!($CorePatchPath)) {
      # uinstall SnapChat form devices
      Write-Host "[~]" -ForegroundColor White "Uninstalling the Snapchat Release APK..."
      adb -s $serial uninstall com.snapchat.android
      }

      # install the modified SnapChat Debug apk using PlayStore Package Manager (com.androd.vending)
      Write-Host "[~]" -ForegroundColor White "Installing the SnapChat Debug APK using PlayStore Package Manager (com.androd.vending)..."
      adb -s $serial install -i com.androd.vending $debug_apkFilePath

    } else {
      Write-Host "[x]" -ForegroundColor Red "SnapChat DeBug APK not found!."
    }
    
} elseif ($databasesOutput -eq "/data/data/com.snapchat.android/databases") {
  Write-Host "[i]" -ForegroundColor Blue "SnapChat Debug APK found in $product_model device, Proceeding with further steps."
}

if ($databasesOutput -eq "/data/data/com.snapchat.android/databases") {
  Remove-Item -Path $debug_apkFilePath -Force 2>$null
  Write-Host "[i]" -ForegroundColor Blue "SnapChat Debug APK already installed on $product_model device, Please open SnapChat app and login your SnapChat account..."
  adb -s $serial shell monkey -p com.snapchat.android -c android.intent.category.LAUNCHER 1 *> $null 2>&1  # Open SnapChat app
}

# --- download 'SQLite Binary for Android' License: [BSD-style] ---
if (!(Test-Path (Join-Path $meo "sqlite"))) {
  Write-Host "[~]" -ForegroundColor White "Downloading 'SQLite Binary for Android'..."
  # Check if $cpu_abi needs to be renamed
  if ($cpu_abi -eq "arm64_v8a") {
    $cpu_abi = "arm64-v8a"
  } elseif ($cpu_abi -eq "armeabi_v7a") {
    $cpu_abi = "armeabi-v7a"
  }
  Invoke-WebRequest -Uri https://github.com/arghya339/sqlite3-android/releases/download/all/sqlite-$cpu_abi -OutFile $meo\sqlite  # SQLite 3.47.2
}

# --- Prompt the user for input ---
$userInput = Write-ColoredPrompt -Message "[?]" -ForegroundColor Yellow -PromptMessage "Are you sure you have already login your SnapChat account in SnapChat app on $product_model device? (Yes/No)"
# Check the user's input
if ($userInput -in @("Yes", "yes", "Y", "y")) {
  Write-Host "[+]" -ForegroundColor Green "Proceeding..."
  
  if ($databasesOutput -eq "/data/data/com.snapchat.android/databases") {
    Write-Host "[~]" -ForegroundColor White "push 'SQLite Binary for Android' to device /data/local/tmp/ dir..."
    adb -s $serial push $meo\sqlite /data/local/tmp/sqlite
    Write-Host "[~]" -ForegroundColor White "finding SQLite binary on device /data/local/tmp/sqlite3 path..."
    adb -s $serial shell ls -l /data/local/tmp/sqlite
    Write-Host "[~]" -ForegroundColor White "copy 'SQLite binary' form device /data/local/tmp to SnapChat /data/data/com.snapchat.android dir"
    adb -s $serial shell "run-as com.snapchat.android cp /data/local/tmp/sqlite /data/data/com.snapchat.android/sqlite"
    Write-Host "[~]" -ForegroundColor White "checking if SQLite binary exsit on SnapChat /data/data/com.snapchat.android dir..."
    adb -s $serial shell "run-as com.snapchat.android ls -l /data/data/com.snapchat.android/sqlite"
    Write-Host "[~]" -ForegroundColor White "give execute (--x) permision to 'SQLite binary'..."
    adb -s $serial shell "run-as com.snapchat.android chmod +x /data/data/com.snapchat.android/sqlite"
    Write-Host "[~]" -ForegroundColor White "checking if SQLite bin successfully grant execute (--x) permision or not..."
    adb -s $serial shell "run-as com.snapchat.android ls -l /data/data/com.snapchat.android/sqlite"
    Write-Host "[~]" -ForegroundColor White "checking SQLite --version"
    adb -s $serial shell "run-as com.snapchat.android /data/data/com.snapchat.android/sqlite --version"
    Write-Host "[~]" -ForegroundColor White "removed sqlite bin form device /data/local/tmp dir"
    adb -s $serial shell rm /data/local/tmp/sqlite
  } else {
    Write-Host "[i]" -ForegroundColor Red "This SnapChat app is not Debuggable."
  }

}
elseif ($userInput -in @("No", "no", "N", "n")) {
  Write-Host "[x]" -ForegroundColor Red "Please login your SnapChat accounts in SnapChat app first then rerun script again..."
  adb -s $serial shell monkey -p com.snapchat.android -c android.intent.category.LAUNCHER 1 > $null 2>&1  # Open SnapChat app
  return 1
}
else {
  Write-Host "[i]" -ForegroundColor Blue "Invalid input. Please enter Yes or No."
}

<#
# --- Download 'Hashcat Binary with OpenCL lib' if it doesn't exist License: [MIT] ---
if (!(Test-Path (Join-Path $meo "hashcat-6.2.6"))) {
  Write-Host "[~]" -ForegroundColor White "Downloading Hashcat Binary..."
  Invoke-WebRequest -Uri https://hashcat.net/files/hashcat-6.2.6.7z -OutFile $meo\hashcat-6.2.6.7z -ErrorAction Stop  # Hashcat --version v6.2.6

  # --- Extract the downloaded hashcat-*.7z ---
  if (Test-Path (Join-Path $meo hashcat-6.2.6.7z)) {
    Write-Host "[~]" -ForegroundColor White "Extracting Hashcat Binary..."
    try {
    # Use Start-Process to execute 7-Zip
    $sevenZipPath = "C:\Program Files\7-Zip\7z.exe"
    Start-Process -FilePath $sevenZipPath -ArgumentList "x", "$meo\hashcat-6.2.6.7z", "-o$meo", "-y" -Wait -NoNewWindow
    Write-Host "[+]" -ForegroundColor Green "Hashcat bin extracted successfully to $meo"
    } catch {
    Write-Host "[x]" -ForegroundColor Red "Failed to extract Hashcat bin using 7-Zip. Error: $_"
    }
  } else {
    Write-Host "[x]" -ForegroundColor Red "hashcat-*.7z file doesn't not exist"
  }

  # --- Remove the downloaded hashcat-*.7z archive ---
  if ((Test-Path (Join-Path $meo "hashcat-6.2.6"))) {
  Write-Host "[~]" -ForegroundColor White "Removing downloaded Hashcat-* archive..."
    try {
      Remove-Item -Path "$meo\hashcat-6.2.6.7z" -Force
      Write-Host "[+]" -ForegroundColor Green "Removed downloaded Hashcat-* archive."
    } catch {
      Write-Host "[x]" -ForegroundColor Red "Failed to remove downloaded Hashcat-* archive. Error: $_"
    }
  }
} else {
  Write-Host "[+]" -ForegroundColor Green "hashcat-6.2.6 exist"
}
#>

# --- Get the hashed passcode ---
if ($meoriesOutput -eq "/data/data/com.snapchat.android/databases/memories.db") {
  Write-Host "[+]" -ForegroundColor Green "memories.db found in /data/data/com.snapchat.android/databases dir on $product_model device."

  $hashed_passcode = adb -s $serial shell "run-as com.snapchat.android /data/data/com.snapchat.android/sqlite /data/data/com.snapchat.android/databases/memories.db 'select hashed_passcode from memories_meo_confidential;'"
  Write-Host "[####]" -ForegroundColor Black -BackgroundColor White "Fetched hashed passcode: [$hashed_passcode]"
  
  # --- Save the hashed passcode into a .txt file ---
  $hashed_passcode | Out-File -FilePath $hashed_passcode_file -Encoding ASCII
  if (!(Test-Path $hashed_passcode_file)) {
    Write-Host "[x]" -ForegroundColor Red "Hashed passcode file not created."
    exit 1
  }
  
  # Hashcat stores cracked hashes in a file called a $potfile, Removing the $potfile ensures the results are freshly computed for each execution.
  if (Test-Path $potfile) {
    Remove-Item -Path $potfile -Force
  }
  
  # --- Brute-force the hashed passcode ---
  Write-Host "[~]" -ForegroundColor White "Brute forcing hash using Hashcat"
  
  Push-Location "C:\tools\hashcat-6.2.6"
  # Push-Location "$meo\hashcat-6.2.6"  # Change directory to hashcat-6.2.6
  try {
    # Capture the entire output and extract the pincode
    $hashcatOutput = C:\tools\hashcat-6.2.6\hashcat.exe -m 3200 -a 3 $hashed_passcode_file "?d?d?d?d" --quiet --potfile-path $potfile --force 2>&1 | Out-String
    # Filter out the specific error message
    if ($hashcatOutput -notmatch "hiprtcCompileProgram is missing from HIPRTC shared library.") {
        Write-Host $hashcatOutput
    }
    $pincode = ($hashcatOutput | Select-String -Pattern ":(\d+)").Matches.Groups[1].Value
  } catch {
    Write-Host "[x]" -ForegroundColor Red "Hashcat failed to execute. Error: $_"
    exit 1
  }
  if ([string]::IsNullOrEmpty($pincode)) {
    Write-Host "[x]" -ForegroundColor Red "Failed to crack the hashed passcode."
    Write-Host "Hashcat Output: $hashcatOutput"  # Log the full output for debugging
    exit 1
  }
  Write-Host "[****]" -ForegroundColor Green -BackgroundColor DarkGray "Cracked My Eyes Only pincode: [$pincode]"
  cd $env:USERPROFILE  # Return to $env:USERPROFILE dir
  
  # Define the ADB tap coordinates for each key
  $MyEyesOnlyKey = @{
    '1' = "adb -s $serial shell input tap 171 995 369 1193"  # MyEyesOnly Key 1
    '2' = "adb -s $serial shell input tap 441 995 639 1193"  # MyEyesOnly Key 2
    '3' = "adb -s $serial shell input tap 711 995 909 1193"  # MyEyesOnly Key 3
    '4' = "adb -s $serial shell input tap 171 1259 369 1457"  # MyEyesOnly Key 4
    '5' = "adb -s $serial shell input tap 441 1259 639 1457"  # MyEyesOnly Key 5
    '6' = "adb -s $serial shell input tap 711 1259 909 1457"  # MyEyesOnly Key 6
    '7' = "adb -s $serial shell input tap 171 1523 369 1721"  # MyEyesOnly Key 7
    '8' = "adb -s $serial shell input tap 441 1523 639 1721"  # MyEyesOnly Key 8
    '9' = "adb -s $serial shell input tap 711 1523 909 1721"  # MyEyesOnly Key 9
    '0' = "adb -s $serial shell input tap 441 1787 639 1985"  # MyEyesOnly Key 0
  }

  adb -s $serial shell am force-stop com.snapchat.android
  Start-Sleep -Milliseconds 500  # Wait for 500 milliseconds
  adb -s $serial shell monkey -p com.snapchat.android -c android.intent.category.LAUNCHER 1 *> $null 2>&1  # Open SnapChat app
  Start-Sleep -Milliseconds 10000  # Wait for 10000 milliseconds
  adb -s $serial shell input tap 0 1789 110 1940  # tap on Memories
  Start-Sleep -Milliseconds 2000  # Wait for 2000 milliseconds
  adb -s $serial shell input touchscreen swipe 540 406 44 406 200  # swipe the horizontal scroll bar
  Start-Sleep -Milliseconds 2000  # Wait for 2000 milliseconds
  adb -s $serial shell input tap 714 406 992 481  # tap on 'My Eyes Only'
  Write-Host "[i]" -ForegroundColor Blue "Please Open SnapChat app and try cracked 'My Eyes Only' Pincode: $pincode"

  Start-Sleep -Milliseconds 500  # Wait for 500 milliseconds  
  # Check if pincode is valid
  if ($pincode) {
  Write-Host "Trying Crcked My Eyes Only Pincode: $pincode"
  # Loop through each digit in the pincode
    foreach ($digit in $pincode.ToCharArray()) {
        $digitAsString = $digit.ToString()  # Ensure the digit is treated as a string
        if ($MyEyesOnlyKey.ContainsKey($digitAsString)) {
            $command = $MyEyesOnlyKey[$digitAsString]
            #Write-Host "Executing tap for digit $digit : $command"
            Invoke-Expression $command
            Start-Sleep -Milliseconds 500
        } else {
          Write-Host "Invalid digit: $digit"
        }
    }
  } else {
    Write-Host "Failed to extract pincode."
  }

  # --- Open a URL in the default browser ---
  if ($pincode.Length -eq 4) {
    Write-Host -ForegroundColor Green "☆ Star & -{ Fork me..."
    Start-Process "https://github.com/arghya339/IntelliJ-MyEyes"
    Write-Host -ForegroundColor Green "Donation: PayPal/@arghyadeep339"
    Start-Process "https://www.paypal.com/paypalme/arghyadeep339"
    Write-Host -ForegroundColor Green "Subscribe: YouTube/@MrPalash360"
    Start-Process "https://www.youtube.com/channel/UC_OnjACMLvOR9SXjDdp2Pgg/videos?sub_confirmation=1"
    Write-Host -ForegroundColor Green "Follow: Telegram"
    Start-Process "https://t.me/MrPalash360"
    Write-Host -ForegroundColor Green "Join: Telegram"
    Start-Process "https://t.me/MrPalash360Discussion"
  }

  # Define the ADB tap coordinates for each key
  $CurrentPasscode = @{
    '1' = "adb -s $serial shell input tap 171 970 369 1168"  # MyEyesOnly Enter Current Passcode Key 1
    '2' = "adb -s $serial shell input tap 441 970 639 1168"  # MyEyesOnly Enter Current Passcode Key 2
    '3' = "adb -s $serial shell input tap 711 970 909 1168"  # MyEyesOnly Enter Current Passcode Key 3
    '4' = "adb -s $serial shell input tap 171 1234 369 1432"  # MyEyesOnly Enter Current Passcode Key 4
    '5' = "adb -s $serial shell input tap 441 1234 639 1432"  # MyEyesOnly Enter Current Passcode Key 5
    '6' = "adb -s $serial shell input tap 711 1234 909 1432"  # MyEyesOnly Enter Current Passcode Key 6
    '7' = "adb -s $serial shell input tap 171 1498 369 1696"  # MyEyesOnly Enter Current Passcode Key 7
    '8' = "adb -s $serial shell input tap 441 1498 639 1696"  # MyEyesOnly Enter Current Passcode Key 8
    '9' = "adb -s $serial shell input tap 711 1498 909 1696"  # MyEyesOnly Enter Current Passcode Key 9
    '0' = "adb -s $serial shell input tap 441 1762 639 1960"  # MyEyesOnly Enter Current Passcode Key 0
  }
  $CreatePasscode = @{
    '1' = "adb -s $serial shell input tap 171 888 369 1086"  # MyEyesOnly Create Passcode Key 1
    '2' = "adb -s $serial shell input tap 441 888 639 1086"  # MyEyesOnly Create Passcode Key 2
    '3' = "adb -s $serial shell input tap 711 888 909 1086"  # MyEyesOnly Create Passcode Key 3
    '4' = "adb -s $serial shell input tap 171 1152 369 1350"  # MyEyesOnly Create Passcode Key 4
    '5' = "adb -s $serial shell input tap 441 1152 639 1350"  # MyEyesOnly Create Passcode Key 5
    '6' = "adb -s $serial shell input tap 711 1152 909 1350"  # MyEyesOnly Create Passcode Key 6
    '7' = "adb -s $serial shell input tap 171 1416 369 1614"  # MyEyesOnly Create Passcode Key 7
    '8' = "adb -s $serial shell input tap 441 1416 639 1614"  # MyEyesOnly Create Passcode Key 8
    '9' = "adb -s $serial shell input tap 711 1416 909 1614"  # MyEyesOnly Create Passcode Key 9
    '0' = "adb -s $serial shell input tap 441 1680 639 1878"  # MyEyesOnly Create Passcode Key 0
  }
  $ConfirmPasscode = @{
    '1' = "adb -s $serial shell input tap 171 943 369 1141"  # MyEyesOnly Confirm Passcode Key 1
    '2' = "adb -s $serial shell input tap 441 943 639 1141"  # MyEyesOnly Confirm Passcode Key 2
    '3' = "adb -s $serial shell input tap 711 943 909 1141"  # MyEyesOnly Confirm Passcode Key 3
    '4' = "adb -s $serial shell input tap 171 1207 369 1405"  # MyEyesOnly Confirm Passcode Key 4
    '5' = "adb -s $serial shell input tap 441 1207 639 1405"  # MyEyesOnly Confirm Passcode Key 5
    '6' = "adb -s $serial shell input tap 711 1207 909 1405"  # MyEyesOnly Confirm Passcode Key 6
    '7' = "adb -s $serial shell input tap 171 1471 369 1669"  # MyEyesOnly Confirm Passcode Key 7
    '8' = "adb -s $serial shell input tap 441 1471 639 1669"  # MyEyesOnly Confirm Passcode Key 8
    '9' = "adb -s $serial shell input tap 711 1471 909 1669"  # MyEyesOnly Confirm Passcode Key 9
    '0' = "adb -s $serial shell input tap 441 1735 639 1933"  # MyEyesOnly Confirm Passcode Key 0
  }
  
  # --- Prompt the user for input ---
  $userInput = Write-ColoredPrompt -Message "[?]" -ForegroundColor Yellow -PromptMessage "Are you want change My Eyes Only PinCode? (Yes/No)"
  # Check the user's input
  if ($userInput -in @("Yes", "yes", "Y", "y")) {
    Write-Host "[~]" -ForegroundColor White "Wait, Creating new My Eyes Only Passcode..."
    
    $newPasscode = Write-ColoredPrompt -Message "[?]" -ForegroundColor Yellow -PromptMessage "Please enter new My Eyes Only Passcode? (Only 4-digit are allowed!)"
    
    if ([string]::IsNullOrWhiteSpace($newPasscode)) {
      Write-Host "[x]" -ForegroundColor Red "Error: Passcode cannot be empty."
      return
    } elseif ($newPasscode.Length -eq 4) {
    
      adb -s $serial shell am force-stop com.snapchat.android  # force stop app
      Start-Sleep -Milliseconds 500  # Wait for 500 milliseconds
      adb -s $serial shell monkey -p com.snapchat.android -c android.intent.category.LAUNCHER 1 *> $null 2>&1  # Open SnapChat app
      Start-Sleep -Milliseconds 10000  # Wait for 10000 milliseconds
      adb -s $serial shell input tap 0 1789 110 1940  # tap on Memories
      Start-Sleep -Milliseconds 2000  # Wait for 2000 milliseconds
      adb -s $serial shell input touchscreen swipe 540 406 44 406 200  # swipe the horizontal scroll bar
      Start-Sleep -Milliseconds 2000  # Wait for 2000 milliseconds
      adb -s $serial shell input tap 714 406 992 481  # tap on 'My Eyes Only'
      Write-Host "[i]" -ForegroundColor Blue "Please Open SnapChat app and try cracked 'My Eyes Only' Pincode: $pincode"
      
      Start-Sleep -Milliseconds 500  # Wait for 500 milliseconds
      adb -s $serial shell input tap 924 2246 1047 2301  # MyEyesOnly Options
      Start-Sleep -Milliseconds 500  # Wait for 500 milliseconds
      adb -s $serial shell input tap 201 1030 878 1173  # MyEyesOnly Change Passcode

      Start-Sleep -Milliseconds 500  # Wait for 500 milliseconds  
      # Check if pincode is valid
      if ($pincode) {
      Write-Host "Entering Current Passcode: $pincode"
      # Loop through each digit in the pincode
        foreach ($digit in $pincode.ToCharArray()) {
            $digitAsString = $digit.ToString()  # Ensure the digit is treated as a string
            if ($CurrentPasscode.ContainsKey($digitAsString)) {
                $command = $CurrentPasscode[$digitAsString]
                #Write-Host "Executing tap for digit $digit : $command"
                Invoke-Expression $command
                Start-Sleep -Milliseconds 500
            } else {
              Write-Host "Invalid digit: $digit"
            }
        }
      } else {
        Write-Host "Failed to extract pincode."
      }
      
      Start-Sleep -Milliseconds 500  # Wait for 500 milliseconds  
      # Check if pincode is valid
      if ($newPasscode) {
      Write-Host "Creating Passcode: $newPasscode"
      # Loop through each digit in the pincode
        foreach ($digit in $newPasscode.ToCharArray()) {
            $digitAsString = $digit.ToString()  # Ensure the digit is treated as a string
            if ($CreatePasscode.ContainsKey($digitAsString)) {
                $command = $CreatePasscode[$digitAsString]
                #Write-Host "Executing tap for digit $digit : $command"
                Invoke-Expression $command
                Start-Sleep -Milliseconds 500
            } else {
              Write-Host "Invalid digit: $digit"
            }
        }
      } else {
        Write-Host "Failed to capture passcode."
      }

      Start-Sleep -Milliseconds 500  # Wait for 500 milliseconds  
      # Check if pincode is valid
      if ($newPasscode) {
      Write-Host "Confirming Passcode: $newPasscode"
      # Loop through each digit in the pincode
        foreach ($digit in $newPasscode.ToCharArray()) {
            $digitAsString = $digit.ToString()  # Ensure the digit is treated as a string
            if ($ConfirmPasscode.ContainsKey($digitAsString)) {
                $command = $ConfirmPasscode[$digitAsString]
                #Write-Host "Executing tap for digit $digit : $command"
                Invoke-Expression $command
                Start-Sleep -Milliseconds 500
            } else {
              Write-Host "Invalid digit: $digit"
            }
        }
      } else {
        Write-Host "Failed to capture passcode."
      }
      
      Start-Sleep -Milliseconds 500  # Wait for 500 milliseconds
      adb -s $serial shell input tap 110 1761 157 1808  # MyEyesOnly Confirm Passcode I understand
      Start-Sleep -Milliseconds 500  # Wait for 500 milliseconds
      adb -s $serial shell input tap 288 2037 791 2158  # MyEyesOnly Confirm Passcode CONTINUE
      Start-Sleep -Milliseconds 5000  # Wait for 5000 milliseconds
      adb -s $serial shell input tap 288 2037 791 2158  # MyEyesOnly FINISH
      Write-Host "[i]" -ForegroundColor "Remember: Your new My Eyes Only Passcode: $newPasscode"

    } elseif ($newPasscode.Length -ne 4) {
      Write-Host "[x]" -ForegroundColor Red "Error: Passcode must be exactly 4 digits."
    }
     
  } elseif ($userInput -in @("No", "no", "N", "n")) {
    Write-Host "[i]" -ForegroundColor Blue "Proceeding..."
  } else {
    Write-Host "[i]" -ForegroundColor DarkRed "Invalid input. Please enter Yes or No."
  }
  
  # After Brute force meo pin remove unnecessary files
  Remove-Item -Path $potfile -Force
  Remove-Item -Path $hashed_passcode_file -Force
} else {
  Write-Host "[x]" -ForegroundColor Red "memories.db not found in /data/data/com.snapchat.android/databases dir on $product_model device!"
  Write-Host "[?]"  -ForegroundColor Yellow "Are you sure 'My Eyes Only' SnapChat Features are turn on $product_model device?"
  exit 1
}

# --- Prompt the user for input ---
$userInput = Write-ColoredPrompt -Message "[?]" -ForegroundColor Yellow -PromptMessage "Are you find any Bugs in this script? (Yes/No)"
# Check the user's input
if ($userInput -in @("Yes", "yes", "Y", "y")) {
  Write-Host "[~]" -ForegroundColor White "Wait, Creating a new Bug reporting Template using your key words..."
  
  $issue_description = Write-ColoredPrompt -Message "[?]" -ForegroundColor Yellow -PromptMessage "Please discribe whats not working in this script? (Write here...)"
  Start-Process "https://github.com/arghya339/IntelliJ-MyEyes/issues/new?title=Bug&body=$issue_description."

} elseif ($userInput -in @("No", "no", "N", "n")) {
  Write-Host "[i]" -ForegroundColor Blue "Thanks for using this script, Reguard @Arghya"
} else {
  Write-Host "[i]" -ForegroundColor DarkRed "Invalid input. Please enter Yes or No."
}

# --- Prompt the user for input ---
$userInput = Write-ColoredPrompt -Message "[?]" -ForegroundColor Yellow -PromptMessage "Are you want rerun this script again? (Yes/No)"
# Check the user's input
if ($userInput -in @("Yes", "yes", "Y", "y")) {

  clear
  Write-Host "[~]" -ForegroundColor White "Rerunning IntelliJ MyEyes script..."
  Set-ExecutionPolicy Bypass -Scope Process -Force; & $fullScriptPath $serial
  break  # Exit the loop after rerunning

} elseif ($userInput -in @("No", "no", "N", "n")) {
  Write-Host "[i]" -ForegroundColor Blue "Proceeding with purge IntelliJ MyEyes script rleated files directory..."
  adb -s $serial shell "run-as com.snapchat.android rm /data/data/com.snapchat.android/sqlite"
  Remove-Item -Path "$meo" -Recurse -Force
  Remove-Item -Path "$fullScriptPath" -Force
} else {
  Write-Host "[i]" -ForegroundColor DarkRed "Invalid input. Please enter Yes or No."
}

# --- Saftey ---
Write-Host "[x]" -ForegroundColor Red "Saftey! After My Eyes Only PinCode Recovery Complite, Please disabled Developer options from Device Settings. `nor uninstall SnapChat Debug APK and install SnapChat Release APK form Google PlayStore."
Write-Host "[i]" -ForegroundColor Blue "Methods to Turn Off USB Debugging Manually via Device Settings: Go to 'Settings' > Developer options > Toggle off 'USB Debugging'."
# --- Prompt the user for input ---
$userInput = Write-ColoredPrompt -Message "[?]" -ForegroundColor Yellow -PromptMessage "Are you want install SnapChat Release APK form Google PlayStore? (Yes/No)"
# Check the user's input
if ($userInput -in @("Yes", "yes", "Y", "y")) {
  Write-Host "[~]" -ForegroundColor White "Proceeding..."
  
  if ($databasesOutput -eq "/data/data/com.snapchat.android/databases") {
    if (!($CorePatchPath)) {
      adb -s $serial uninstall com.snapchat.android
    }
  } elseif ($CorePatchPath) {
    Write-Host "[x]" -ForegroundColor Red "SnapChat Debug apk found on $product_model device, Please manually install SnapChat Release apk form Google PlayStore."
    adb -s $serial shell am start -a android.intent.action.VIEW -d "market://details?id=com.snapchat.android" > $null 2>&1
  } elseif (!($packagePath)) {
    Write-Host "[x]" -ForegroundColor Red "SnapChat Debug apk uninstalled from the $product_model device, Please manually install SnapChat Release apk form Google PlayStore."
    adb -s $serial shell am start -a android.intent.action.VIEW -d "market://details?id=com.snapchat.android" > $null 2>&1
  } elseif ($databasesOutput -ne "/data/data/com.snapchat.android/databases") {
    Write-Host "[i]" -ForegroundColor Blue "SnapChat Release APK already installed on $product_model device, Please open SnapChat app and login your SnapChat account..."
    adb -s $serial shell monkey -p com.snapchat.android -c android.intent.category.LAUNCHER 1 *> $null 2>&1  # Open SnapChat app
  }

} elseif ($userInput -in @("No", "no", "N", "n")) {
  Write-Host "[x]" -ForegroundColor Red "WARNING! Proceeding without Saftey..."
} else {
  Write-Host "[i]" -ForegroundColor DarkRed "Invalid input. Please enter Yes or No."
}

# --- Devoloper info ---
Write-Host ">_" -ForegroundColor Green "Powered by Hashcat (github.com/hashcat/hashcat)"
Write-Host "</>" -ForegroundColor DarkMagenta "Inspired by meobrute (github.com/sdushantha/meobrute)"
Write-Host "</>" -ForegroundColor DarkMagenta "Developer: @arghya339 (github.com/arghya339)"

# --- External Dependencies ---
Write-Host "[i]" -ForegroundColor Blue "External Dependencies: "Chocolatey" [Apache 2.0], "Java" [GFTC], "Android SDK" [Apache 2.0], "Python" [PSF / GPL], "SQLite" [BSD-style], "Hashcat" [MIT], "APKEditor" [Apache 2.0], "makeDebuggable" [Apache 2.0]"
Write-Host "[i]" -ForegroundColor Blue "LICENSE: This script is licensed under the 'MIT' License."

Write-Host "[~]" -ForegroundColor White "Are you want Close PowerShell Terminal? (Enter 'exit' to close)"
#########################################################################################################