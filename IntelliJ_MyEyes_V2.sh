#!/usr/bin/bash

# Copyright (C) 2025, Arghyadeep Mondal <github.com/arghya339>

good="\033[92;1m[✔]\033[0m"
bad="\033[91;1m[✘]\033[0m"
info="\033[94;1m[i]\033[0m"
running="\033[37;1m[~]\033[0m"
notice="\033[93;1m[!]\033[0m"
question="\033[93;1m[?]\033[0m"

Green="\033[92;1m"
Red="\033[91m"
Blue="\033[94m"
Cyan="\033[96m"
White="\033[37m"
Yellow="\033[93m"
whiteBG="\e[47m\e[30m"
Reset="\033[0m"

branding=$(cat <<'EOF'
       .----------------------------------------.
       |█ █▄ █ ▀█▀ ██▀ █   █   █   █   █▄ ▄█ ██▀|    
       |█ █ ▀█  █   ▄▄ █▄▄ █▄▄ █ ▀▄█   █ ▀ █ █▄▄|
       '----------------------------------------'      
EOF
)
clear && echo -e "${Green}$branding${Reset}\n"

Android=$(getprop ro.build.version.release | cut -d. -f1)
# --- Grant Storage Permission ---
if ! ls /sdcard/ 2>/dev/null | grep -E -q "^(Android|Download)"; then
  echo -e "${notice} ${Yellow}Storage permission not granted!${Reset}\n$running ${Green}termux-setup-storage${Reset}.."
  if [ "$Android" -gt 5 ]; then  # for Android 5 storage permissions grant during app installation time, so Termux API termux-setup-storage command not required
    count=0
    while true; do
      if [ "$count" -ge 2 ]; then
        echo -e "$bad Failed to get storage permissions after $count attempts!"
        echo -e "$notice Please grant permissions manually in Termux App info > Permissions > Files > File permission → Allow."
        am start -a android.settings.APPLICATION_DETAILS_SETTINGS -d package:com.termux &> /dev/null
        exit 0
      fi
      termux-setup-storage  # ask Termux Storage permissions
      sleep 3  # wait 3 seconds
      if ls /sdcard/ 2>/dev/null | grep -q "^Android" || ls "$HOME/storage/shared/" 2>/dev/null | grep -q "^Android"; then
        if [ "$Android" -lt 8 ]; then
          exit 0  # Exit the script
        fi
        break
      fi
      ((count++))
    done
  fi
fi

if su -c "id" &>/dev/null; then
  echo -e "$good SU permission is granted."
else
  echo -e "$bad SU permission is not granted!"
  echo -e "$notice Please open the Magisk/KernelSU/APatch app and manually grant root permissions to Termux."
  am start -n com.topjohnwu.magisk/.ui.MainActivity &>/dev/null || am start -n me.weishu.kernelsu/.ui.MainActivity &>/dev/null || am start -n me.bmax.apatch/.ui.MainActivity &>/dev/null
  exit 1
fi

! ping -c 1 -W 2 8.8.8.8 &>/dev/null && { echo -e "$bad Oops! No Internet Connection available.\n$notice Connect to the Internet and try again later."; exit 1; }

curl -sL -o "$HOME/IntelliJ_MyEyes.sh" "https://raw.githubusercontent.com/arghya339/IntelliJ-MyEyes/refs/heads/main/IntelliJ_MyEyes_V2.sh"

scriptPath=$(realpath "$0")
[ "$(su -c 'getenforce 2>/dev/null')" = "Enforcing" ] && { su -c "setenforce 0"; writeSELinux=true; } || writeSELinux=false
package=$(su -c "pm list packages | grep com.snapchat.android" 2>/dev/null)
[ $writeSELinux == true ] && su -c "setenforce 1"
installedPKG=$(pkg list-installed 2>/dev/null)
pkg update &>/dev/null  # It downloads latest package list with versions from Termux remote repository, then compares them to local (installed) pkg versions, and shows a list of what can be upgraded if they are different.
outdatedPKG=$(apt list --upgradable 2>/dev/null)
echo "$outdatedPKG" | grep -q "dpkg was interrupted" 2>/dev/null && { yes "N" | dpkg --configure -a; outdatedPKG=$(apt list --upgradable 2>/dev/null); }
arch=$(getprop ro.product.cpu.abi)
model=$(getprop ro.product.model)
hashes="$HOME/hashes.txt"
potfile="/root/.local/share/hashcat/hashcat.potfile"

pkgUpdate() {
  local pkg=$1
  if echo "$outdatedPKG" | grep -q "^$pkg/" 2>/dev/null; then
    echo -e "$running Upgrading $pkg pkg.."
    output=$(yes "N" | apt install --only-upgrade "$pkg" -y 2>/dev/null)
    echo "$output" | grep -q "dpkg was interrupted" 2>/dev/null && { yes "N" | dpkg --configure -a; yes "N" | apt install --only-upgrade "$pkg" -y > /dev/null 2>&1; }
  fi
}

pkgInstall() {
  local pkg=$1
  if echo "$installedPKG" | grep -q "^$pkg/" 2>/dev/null; then
    pkgUpdate "$pkg"
  else
    echo -e "$running Installing $pkg pkg.."
    output=$(pkg install "$pkg" -y 2>/dev/null)
    echo "$output" | grep -q "dpkg was interrupted" 2>/dev/null && { yes "N" | dpkg --configure -a; yes "N" | pkg install "$pkg" -y > /dev/null 2>&1; }
  fi
}

pkgInstall "apt"  # apt update
pkgInstall "dpkg"  # dpkg update
pkgInstall "bash"  # bash update
pkgInstall "libgnutls"  # pm apt & dpkg use it to securely download packages from repositories over HTTPS
pkgInstall "coreutils"  # It provides basic file, shell, & text manipulation utilities. such as: ls, cp, mv, rm, mkdir, cat, echo, etc.
pkgInstall "termux-core"  # it's contains basic essential cli utilities, such as: ls, cp, mv, rm, mkdir, cat, echo, etc.
pkgInstall "termux-tools"  # it's provide essential commands, sush as: termux-change-repo, termux-setup-storage, termux-open, termux-share, etc.
pkgInstall "termux-keyring"  # it's use during pkg install/update to verify digital signature of the pkg and remote repository
pkgInstall "termux-am"  # termux am (activity manager) update
pkgInstall "termux-am-socket"  # termux am socket (when run: am start -n activity ,termux-am take & send to termux-am-stcket and it's send to Termux Core to execute am command) update
pkgInstall "inetutils"  # ping utils is provided by inetutils
pkgInstall "util-linux"  # it provides: kill, killall, uptime, uname, chsh, lscpu
pkgInstall "libsmartcols"  # a library from the util-linux pkg
pkgInstall "curl"  # curl update
pkgInstall "libcurl"  # curl lib update
pkgInstall "openssl"  # openssl install/update
pkgInstall "jq"  # jq install/update
pkgInstall "grep"  # grep update

# --- Update Termux if outdated ---
if [ $Android -ge 8 ]; then
  latestReleases=$(curl -s https://api.github.com/repos/termux/termux-app/releases/latest | jq -r '.tag_name | sub("^v"; "")')  # 0.118.0
  dlUrl="https://github.com/termux/termux-app/releases/download/v$latestReleases/termux-app_v${latestReleases}+github-debug_$arch.apk"
  fileName="termux-app_v${latestReleases}+github-debug_$arch.apk"
else
  latestReleases=$(curl -s https://api.github.com/repos/termux/termux-app/tags | jq -r '.[0].name' | sed 's/^v//')  # 0.119.0-beta.2
  [ $Android -eq 7 ] && variant=7 || variant=5
  dlUrl="https://github.com/termux/termux-app/releases/download/v$latestReleases/termux-app_v${latestReleases}+apt-android-$variant-github-debug_$arch.apk"
  fileName="termux-app_v${latestReleases}+apt-android-$variant-github-debug_$arch.apk"
fi
filePath="/data/local/tmp/$fileName"
if [ "$TERMUX_VERSION" != "$latestReleases" ]; then
  echo -e "$bad Termux app is outdated!"
  echo -e "$running Downloading Termux app update.."
  while true; do
    su -c "$PREFIX/bin/curl -L --progress-bar -C - -o '$filePath' '$dlUrl'"
    [ $? -eq 0 ] && break || { echo -e "$notice Retrying in 5 seconds.."; sleep 5; }
  done
  echo -e "$notice Please rerun this script again after Termux app update!"
  echo -e "$running Installing app update and restarting Termux app.." && sleep 3
  [ "$(su -c 'getenforce 2>/dev/null')" = "Enforcing" ] && { su -c "setenforce 0"; touch "$meo/writeSELinux"; }
  su -c "pm install -i com.android.vending '$filePath'"
else
  if su -c "[ -f '$filePath' ]"; then
    if [ "$(su -c 'getenforce 2>/dev/null')" = "Permissive" ] && [ -f "$meo/writeSELinux" ]; then
      su -c "setenforce 1" && rm -f "$meo/writeSELinux"
    fi
    su -c "rm -f '$filePath'"
  fi
fi

confirmPrompt() {
  Prompt=${1}
  Selected=${2:-0}  # :- set value as 0 if unset
  cols=$(stty size | awk '{print $2}')
  
  # breaks long prompts into multiple lines
  mapfile -t lines < <(fmt -w "$cols" <<< "$Prompt")
  
  # print all-lines except last-line
  last_line_index=$(( ${#lines[@]} - 1 ))  # ${#lines[@]} = number of elements in lines array
  for (( i=0; i<last_line_index; i++ )); do
    echo "${lines[i]}"
  done
  
  last_line="${lines[$last_line_index]}"
  llcc=${#last_line}
  
  [ $((cols - llcc)) -ge 17 ] && fits_on_last=true || { fits_on_last=false; echo -e "$last_line"; }
  
  echo -ne '\033[?25l'  # Hide cursor
  while true; do
    show_prompt() {
      echo -ne "\r\033[K"  # n=noNewLine r=returnCursorToStartOfLine \033[K=clearLine
      [ $fits_on_last == true ] && echo -ne "$last_line "
      [ $Selected -eq 0 ] && echo -ne "${whiteBG}➤ <Yes> $Reset   <No>" || echo -ne "  <Yes>  ${whiteBG}➤ <No> $Reset"  # highlight selected bt with white bg
    }; show_prompt

    read -rsn1 key
    case $key in
      $'\E')
      # /bin/bash -c 'read -r -p "Type any ESC key: " input && printf "You Entered: %q\n" "$input"'  # q=safelyQuoted
        read -rsn2 -t 0.1 key2  # -r=readRawInput -s=silent(noOutput) -t=timeout -n2=readTwoChar | waits upto 0.1s=100ms to read key 
        case $key2 in 
          '[C') Selected=1 ;;  # right arrow key
          '[D') Selected=0 ;;  # left arrow key
        esac
        ;;
      [Yy]*) Selected=0; show_prompt; break ;;
      [Nn]*) Selected=1; show_prompt; break ;;
      "") break ;;  # Enter key
    esac
  done
  echo -e '\033[?25h' # Show cursor
  return $Selected  # return Selected int index from this fun
}

# --- Check if SnapChat is installed ---
if [ -n "$package" ]; then
  echo -e "$good SnapChat is installed on this device."
else
  echo -e "$bad SnapChat is not installed on this device!"
  echo -e "$notice Please manually install it from the Play Store."
  termux-open-url "https://play.google.com/store/apps/details?id=com.snapchat.android"
  su -c "input tap 540 590"  # Tap on install button: x540, y590
  
  confirmPrompt "Have you installed Snapchat app from PlayStore on your $model device?" && userInput=Yes || userInput=No
  case "$userInput" in
    Yes) echo -e "$running Proceeding.." ;;
    No) 
      echo -e "$bad Please manually install SnapChat app from PlayStore on your $model device, then rerun the script again."
      termux-open "https://play.google.com/store/apps/details?id=com.snapchat.android"
      exit 1
      ;;
  esac
fi

# --- Installing proot-distro in Termux ---
[ ! -f "$PREFIX/bin/proot-distro" ] && pkgInstall "proot-distro" || echo -e "$good proot-distro pkg already installed inside Termux."

# --- Installing the Ubuntu distribution using proot-distro ---
if ! ls $PREFIX/var/lib/proot-distro/*/ 2>/dev/null | grep -iq "ubuntu" && [ -f "$PREFIX/bin/proot-distro" ]; then
  echo -e "$running Installing Ubuntu using proot-distro.."
  proot-distro install ubuntu &>/dev/null
else
  echo -e "$good Ubuntu already installed via proot-distro."
fi

# --- Update Ubuntu ---
if ls $PREFIX/var/lib/proot-distro/*/ 2>/dev/null | grep -iq "ubuntu"; then
  #echo -e "$running Updating Ubuntu distribution.."
  #proot-distro login ubuntu -- bash -c "export DEBIAN_FRONTEND=noninteractive && { apt update && apt upgrade -y; } &>/dev/null"
  proot-distro login ubuntu -- bash -c "export DEBIAN_FRONTEND=noninteractive && { apt update && apt install --only-upgrade apt libc6 libssl3t64 libgnutls30t64 openssl -y; } &>/dev/null"
fi

# --- Install Hashcat ---
if ! proot-distro login ubuntu -- test -f /usr/bin/hashcat && ls $PREFIX/var/lib/proot-distro/*/ 2>/dev/null | grep -iq "ubuntu"; then
  echo -e "$running Installing HashCat inside PRoot Ubuntu.."
  proot-distro login ubuntu -- bash -c "export DEBIAN_FRONTEND=noninteractive && apt install hashcat -y &>/dev/null"
  proot-distro login ubuntu -- bash -c "export DEBIAN_FRONTEND=noninteractive && yes 'N' | dpkg --configure -a"
  proot-distro login ubuntu -- bash -c "export DEBIAN_FRONTEND=noninteractive && apt install clinfo -y"
else
  echo -e "$good HashCat already installed inside Ubuntu."
fi
# --- Check if Hashcat is installed inside the PRoot Ubuntu environment ---
if proot-distro login ubuntu -- which hashcat &>/dev/null; then
  hashcatVersion=$(proot-distro login ubuntu -- bash -c "hashcat --version" 2>/dev/null)
  echo -e "$running hashcat --version → HashCat $hashcatVersion"
else
  echo -e "$notice HashCat binary not found inside PRoot Ubuntu!"
  echo -e "$running Installing HashCat by rerunning 'IntelliJ MyEyes' script again.."
  bash "$scriptPath"
  exit 1
fi

# --- Prompt the user for input ---
confirmPrompt "Is your Snapchat account already logged in on your $model device?" && userInput=Yes || userInput=No
case "$userInput" in
  Yes) echo -e "$running Proceeding.." ;;
  No)
    echo -e "$bad Please login your SnapChat account in the SnapChat app first, then rerun the script again."
    su -c "monkey -p com.snapchat.android -c android.intent.category.LAUNCHER 1 &>/dev/null"
    exit 1
    ;;
esac

# --- Download SQLite Binary ---
if ! su -c "[ -f '/data/data/com.snapchat.android/sqlite3' ]"; then
  echo -e "$running Downloading SQLite Binary for Android from ${Blue}https://raw.githubusercontent.com/arghya339/sqlite3-android/refs/heads/master/binary/$arch/sqlite3${Reset}.."
  while true; do
    su -c "$PREFIX/bin/curl -L --progress-bar -C - -o '/data/data/com.snapchat.android/sqlite3' 'https://raw.githubusercontent.com/arghya339/sqlite3-android/refs/heads/master/binary/$arch/sqlite3'"
    [ $? -eq 0 ] && break || { echo -e "$notice Retrying in 5 seconds.." && sleep 5; }
  done
fi

# --- Check SQLite exist on SnapChat /data/ dir ---
if su -c "[ -f '/data/data/com.snapchat.android/sqlite3' ]"; then
  echo -e "$good SQLite Binary exist on ${Cyan}/data/data/com.snapchat.android/${Reset} dir."
  su -c [ ! -x "/data/data/com.snapchat.android/sqlite3" ] && { echo -e "$running Give execute (--x) permission to SQLite Binary.."; su -c "chmod +x /data/data/com.snapchat.android/sqlite3"; } || echo -e "$good SQLite binary already has execute (--x) permissions."
  SQLiteVersion=$(su -c "/data/data/com.snapchat.android/sqlite3 --version" | awk '{print $1}')
  echo -e "$running sqlite --version → SQLite v$SQLiteVersion"
fi

# --- Automatically try Cracked MEO PassCode ---
tryMEO() {
  su -c "am force-stop com.snapchat.android"  # Force stop SnapChat
  sleep 0.5  # Wait for 500 milliseconds
  su -c "monkey -p com.snapchat.android -c android.intent.category.LAUNCHER 1 > /dev/null 2>&1"  # Open SnapChat app
  sleep 10  # wait 10 seconds
  #su -c "input tap 0 1789 110 1940"  # tap on Memories @AndroidSDK/uiautomator
  su -c "input tap 318 1855"  # Tap on Memories @Settings/System/DeveloperOptions/PointerLocation (SnapChat/Memories > X:318, Y:1855)
  sleep 2  # Wait 2 seconds
  su -c "input touchscreen swipe 540 406 44 406 200"  # Swipe the horizontal scroll bar
  sleep 2  # Wait 2 seconds
  su -c "input tap 714 406 992 481"  # Tap on 'My Eyes Only'
  
  # Define the input tap coordinates for each key using associative array
  declare -A MyEyesOnlyKey=(
    ['1']="su -c 'input tap 171 995 369 1193'"  # MyEyesOnly Key 1
    ['2']="su -c 'input tap 441 995 639 1193'"  # MyEyesOnly Key 2
    ['3']="su -c 'input tap 711 995 909 1193'"  # MyEyesOnly Key 3
    ['4']="su -c 'input tap 171 1259 369 1457'"  # MyEyesOnly Key 4
    ['5']="su -c 'input tap 441 1259 639 1457'"  # MyEyesOnly Key 5
    ['6']="su -c 'input tap 711 1259 909 1457'"  # MyEyesOnly Key 6
    ['7']="su -c 'input tap 171 1523 369 1721'"  # MyEyesOnly Key 7
    ['8']="su -c 'input tap 441 1523 639 1721'"  # MyEyesOnly Key 8
    ['9']="su -c 'input tap 711 1523 909 1721'"  # MyEyesOnly Key 9
    ['0']="su -c 'input tap 441 1787 639 1985'"  # MyEyesOnly Key 0
  )
  
  sleep 0.5  # Wait 500 milliseconds
  # Check if PinCode is valid
  if [ -n "$pincode" ]; then
    echo -e "$running Trying Cracked My Eyes Only PinCode: $pincode"
    # Loop through each digit in the PinCode
    for (( i=0; i<${#pincode}; i++ )); do
      digit=${pincode:$i:1}
      if [[ -v MyEyesOnlyKey["$digit"] ]]; then
        command=${MyEyesOnlyKey["$digit"]}
        # echo "Executing tap for digit $digit : $command"
        eval "$command"
        sleep 0.5
      else
        echo -e "$notice Invalid digit: $digit"
      fi
    done
  else
    echo -e "$bad Failed to extract PinCode."
  fi
}

# --- Get the hashed PassCode ---
if su -c "[ -f /data/data/com.snapchat.android/databases/memories.db ]"; then
  su -c "/data/data/com.snapchat.android/sqlite3 /data/data/com.snapchat.android/databases/memories.db 'select hashed_passcode from memories_meo_confidential;'" > "$hashes"
  #  --- Check if $hashes is null ---
  if [ -z $(cat $hashes) ]; then
    echo -e "$bad Failed to fetched hashed PassCode using SQLite."
    termux-open-url "https://github.com/arghya339/IntelliJ-MyEyes/blob/main/docs%2Fhashed_passcode_null_error.md"  # Open hashed_passcode_null_error docs if fetched hashed passcode is null
    exit 1  # Terminate script execution
  else
    echo -e "\033[1;30;47m[####] Fetched hashed PassCode: [$(cat $hashes)]\033[0m"
  fi
  
  # --- Brute-force the hash ---
  echo -e "$running Brute forcing hash using HashCat.."
  [ "$(su -c 'getenforce 2>/dev/null')" = "Enforcing" ] && { su -c "setenforce 0"; writeSELinux=true; } || writeSELinux=false
  su -c "cmd deviceidle whitelist +com.termux" &> /dev/null
  [ $writeSELinux == true ] && su -c "setenforce 1"
  termux-wake-lock
  pincode=$(proot-distro login ubuntu -- /bin/bash -c "hashcat -m 3200 -a 3 $hashes ?d?d?d?d --potfile-disable --restore-disable --force --quiet" 2>/dev/null | awk -F: '{print $2}')
  [ -z "$pincode" ] && pincode=$(> /sdcard/MEO.txt; proot-distro login ubuntu -- /bin/bash -c "hashcat -m 3200 -a 3 $hashes ?d?d?d?d --potfile-path=$potfile --force --quiet && { hashcat -m 3200 -a 3 $hashes ?d?d?d?d --show -o /sdcard/MEO.txt; rm -f $potfile; }" 2>/dev/null | cut -d: -f2)
  termux-wake-unlock
  
  # --- Validate and display result ---
  if [ ${#pincode} -eq 4 ]; then
    rm -f "$hashes"
    echo -e "\033[1;92;100m[****] Cracked My Eyes Only PinCode: [$pincode]\033[0m"
    [ "$(su -c 'getenforce 2>/dev/null')" = "Enforcing" ] && { su -c "setenforce 0"; writeSELinux=true; } || writeSELinux=false
    tryMEO
    [ $writeSELinux == true ] && su -c "setenforce 1"
    echo -e "${Green}Star & Fork me on GitHub..${Reset}"
    termux-open-url "https://github.com/arghya339/IntelliJ-MyEyes"  # Open GitHub URL
    sleep 0.5  # 0.5 seconds = 500 milliseconds
    echo -e "${Green}Donation: PayPal/@arghyadeep339${Reset}"
    termux-open-url "https://www.paypal.com/paypalme/arghyadeep339"  # Open PayPal URL
    sleep 0.5  # 0.5 seconds = 500 milliseconds
    echo -e "${Green}Subscribe: YouTube/@MrPalash360${Reset}"
    termux-open-url "https://www.youtube.com/@mrpalash360?sub_confirmation=1"  # Open YouTube URL for subscription
  else
    echo -e "$bad Failed to crack PinCode using HashCat!"
    # --- Prompt the user for input ---
    confirmPrompt "Did you find any bugs in this script?" && userInput=Yes || userInput=No
    case "$userInput" in
      Yes)
        echo -e "$running Wait, creating a new bug reporting template using your keywords.."
        read -r -p "Please describe what's not working in this script? " issue_description
        termux-open-url "https://github.com/arghya339/IntelliJ-MyEyes/issues/new?title=Bug&body=${issue_description}"
        echo "🖤 Thanks for reporting!"
        ;;
      No) echo -e "$running Proceeding.." ;;
    esac
    rm -f "$hashes"
    exit 1 
  fi
else
  echo -e "$bad memories.db file not found in SnpChat ${Cyan}/data/data/com.snapchat.android/databases${Reset} dir on $model device!"
  echo -e "[?] Have you enabled Snapchat's 'My Eyes Only' feature on your $model device?"
  termux-open-url "https://github.com/arghya339/IntelliJ-MyEyes/blob/main/docs%2Fhashed_passcode_null_error.md"
  exit 1
fi

# --- Prompt the user for input ---
confirmPrompt "Do you want to rerun this script again?" "1" && userInput=Yes || userInput=No
case "$userInput" in
  Yes)
    clear
    echo -e "$running Rerunning 'IntelliJ MyEyes' script again.."
    bash "$scriptPath"
    exit 1
    ;;
  No)
    echo -e "$info Proceeding with purge IntelliJ MyEyes script related files.."
    su -c "rm -f /data/data/com.snapchat.android/sqlite3"
    echo "♥️ Thanks for using this script! Regards, @Arghya"
    ;;
esac

# --- Prompt the user for input ---
confirmPrompt "Do you want to remove this script-related dependency?" && userInput=Yes || userInput=No
case "$userInput" in
  Yes)
    echo -e "$running Proceeding with removal of dependencies.."
    proot-distro login ubuntu -- bash -c "apt remove hashcat -y" &>/dev/null  # Uninstall Hashcat from Ubuntu
    proot-distro remove ubuntu &>/dev/null  # Uninstall ubuntu using proot-distro
    pkg uninstall proot-distro -y &>/dev/null  # Uninstall proot-distro pkg from Termux
    apt autoremove -y &>/dev/null  # Remove proot-distro dependencies
    ;;
  No)
    echo -e "$info Proceeding without removing script-related dependencies!"
    ;;
esac

echo -e "${Green}Powered by Hashcat (github.com/hashcat/hashcat)"
termux-open-url "https://github.com/hashcat/hashcat"
echo -e "${Green}Inspired by meobrute (github.com/sdushantha/meobrute)"
echo -e "${Green}Developer: @arghya339 (github.com/arghya339)"

echo -e "$info Do you want to close Termux? (Enter ${Green}exit${Reset} to close)"

rm -f "$scriptPath"  # Remove meo script
########################################