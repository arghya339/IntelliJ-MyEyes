#!/usr/bin/bash

# Clone IntelliJ_MyEyes.sh: ~ curl --progress-bar -o "$HOME/IntelliJ_MyEyes.sh" "https://raw.githubusercontent.com/arghya339/IntelliJ-MyEyes/refs/heads/main/IntelliJ_MyEyes.sh"
# Usage instructions: ~ bash $HOME/IntelliJ_MyEyes.sh

# Colored log indicators
good="\033[92;1m[✔]\033[0m"
bad="\033[91;1m[✘]\033[0m"
info="\033[94;1m[i]\033[0m"
running="\033[37;1m[~]\033[0m"
notice="\033[93;1m[!]\033[0m"
question="\033[93;1m[?]\033[0m"

<<comment
# --- dash supports ANSI escape codes for terminal text formatting ---
Color Forground_Color_Code Background_Color_Code
Black 30 40
Red 31 41
Green 32 42
Yellow 33 43
Blue 34 44
Magenta 35 45
Cyan 36 46
White 37 47

Gray_Background_Code 48
Default_background_Code 49

Color Bright_Color_Code
Bright-Black(Gray) 90
Bright-Red 91
Bright-Green 92
Bright-Yellow 93
Bright-Blue 94
Bright-Magenta 95
Bright-Cyan 96
Bright-White 97

Text_Format Code
Reset 0
Bold 1
Dim 2
Italic 3
Underline 4
Bold 5
Less Bold 6
Text with Background 7
invisible 8
Strikethrough 9

Examples
echo -e "\e[32mThis is green text\e[0m"
echo -e "\e[47mThis is a white background\e[0m"
echo -e "\e[32;47mThis is green text on white background\e[0m"
echo -e "\e[1;32;47mThis is bold green text on white background\e[0m"
comment

# Set the color for the eye (green in this case)
Green="\033[92;1m"
Red="\033[91m"
Blue="\033[94m"
White="\033[37m"
Yellow="\033[93m"
Reset="\033[0m"

# Construct the eye shape using string concatenation
eye=$(cat <<'EOF'
      https://github.com/arghya339/IntelliJ-MyEyes
       .----------------------------------------.
       |█ █▄ █ ▀█▀ ██▀ █   █   █   █   █▄ ▄█ ██▀|    
       |█ █ ▀█  █   ▄▄ █▄▄ █▄▄ █ ▀▄█   █ ▀ █ █▄▄|
       |                 >_𝒟𝑒𝓋𝑒𝓁𝑜𝓅𝑒𝓇: @𝒶𝓇𝑔𝒽𝓎𝒶𝟥𝟥𝟫|
       '----------------------------------------'      
EOF
)
clear  # Clear Terminal
echo -e "$Green$eye$Reset"  # Print the eye shape with the specified foreground color
echo ""  # Space

Android=$(getprop ro.build.version.release | cut -d. -f1)  # Get major Android version

# --- Storage Permission Check Logic ---
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

# --- Termux SuperUser Permission Check ---
if su -c "id" >/dev/null 2>&1; then
# -c allows you to run a single command as root without opening an interactive root shell.
  echo -e "$good SU permission is granted."
else
  echo -e "$bad SU permission is not granted."
  echo -e "$notice Please open the Magisk/KernelSU/APatch app and manually grant root permissions to Termux."
  return 1
fi

# --- Checking Internet Connection ---
if ! ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1 ; then
    echo -e "$bad Oops! No Internet Connection available.\n$notice Connect to the Internet and try again later."
    return 1
else
  echo -e "$good Internet connection available."
fi
# Downloading latest IntelliJ_MyEyes.sh file from GitHub
curl -sL -o "$HOME/IntelliJ_MyEyes.sh" "https://raw.githubusercontent.com/arghya339/IntelliJ-MyEyes/refs/heads/main/IntelliJ_MyEyes.sh"

# --- Update Termux pkg ---
echo -e "$running Updating Termux pkg.."
pkill pkg && { pkg update && pkg upgrade -y; } > /dev/null 2>&1  # discarding output

echo "deb https://mirrors.ustc.edu.cn/termux/termux-main stable main" > $PREFIX/etc/apt/sources.list && pkg update >/dev/null 2>&1 && pkg --check-mirror update >/dev/null 2>&1  # termux-change-repo && pkg --check-mirror update

# --- Global Veriable ---
fullScriptPath=$(realpath "$0")  # Get the full path of the currently running script
if [ "$(su -c 'getenforce 2>/dev/null')" = "Enforcing" ]; then
  su -c "setenforce 0"  # set SELinux to Permissive mode to unblock unauthorized operations
  package=$(su -c "pm list packages | grep com.snapchat.android" 2>/dev/null)  # SnapChat packages list
  su -c "setenforce 1"  # set SELinux to Enforcing mode to block unauthorized operations
else
  package=$(su -c "pm list packages | grep 'com.snapchat.android'" 2>/dev/null)  # SnapChat packages list
fi
meo="$HOME/meo"  # meo dir inside Termux $HOME dir
installedPKG=$(pkg list-installed 2>/dev/null)  # list of installed pkg
pkg update > /dev/null 2>&1  # It downloads latest package list with versions from Termux remote repository, then compares them to local (installed) pkg versions, and shows a list of what can be upgraded if they are different.
outdatedPKG=$(apt list --upgradable 2>/dev/null)  # list of outdated pkg
arch=$(getprop ro.product.cpu.abi)  # get device arch
model=$(getprop ro.product.model)  # get device model
hashed_passcode_file="$meo/hashed_passcode.txt"  # hashed_passcode.txt file
potfile="/root/hashcat.potfile"  # Hashcat potfile variable

# --- Create $meo dir if it does't exist ---
mkdir -p "$meo"

# --- pkg upgrade function ---
pkgUpdate() {
  local pkg=$1
  if echo "$outdatedPKG" | grep -q "^$pkg/" 2>/dev/null; then
    echo -e "$running Upgrading $pkg pkg.."
    pkg install --only-upgrade "$pkg" -y > /dev/null 2>&1
  fi
}

# --- pkg install/update function ---
pkgInstall() {
  local pkg=$1
  if echo "$installedPKG" | grep -q "^$pkg/" 2>/dev/null; then
    pkgUpdate "$pkg"
  else
    echo -e "$running Installing $pkg pkg.."
    pkg install "$pkg" -y > /dev/null 2>&1
  fi
}

pkgInstall "dpkg"  # dpkg update
pkgInstall "termux-core"  # it's contains basic essential cli utilities, such as: ls, cp, mv, rm, mkdir, cat, echo, etc.
pkgInstall "termux-tools"  # it's provide essential commands, sush as: termux-change-repo, termux-setup-storage, termux-open, termux-share, etc.
pkgInstall "termux-keyring"  # it's use during pkg install/update to verify digital signature of the pkg and remote repository
pkgInstall "termux-am"  # termux am (activity manager) update
pkgInstall "termux-am-socket"  # termux am socket (when run: am start -n activity ,termux-am take & send to termux-am-stcket and it's send to Termux Core to execute am command) update
pkgInstall "curl"  # curl update
pkgInstall "libcurl"  # curl lib update
pkgInstall "jq"  # jq install/update
pkgInstall "grep"  # grep update

# --- Check if Termux Version is Latest ---
if [ $Android -ge 8 ]; then
  latestReleases=$(curl -s https://api.github.com/repos/termux/termux-app/releases/latest | jq -r '.tag_name | sub("^v"; "")')  # 0.118.0
  if [ "$TERMUX_VERSION" != "$latestReleases" ]; then
    echo -e "$bad Termux app is outdated!"
    echo -e "$running Downloading Termux app update.."
    while true; do
      su -c "$PREFIX/bin/curl -L --progress-bar -C - -o '/data/local/tmp/termux-app_v${latestReleases}+github-debug_$arch.apk' 'https://github.com/termux/termux-app/releases/download/v$latestReleases/termux-app_v${latestReleases}+github-debug_$arch.apk'"
      if [ $? -eq 0 ]; then
        break  # break the resuming download loop
      fi
      echo -e "$notice Retrying in 5 seconds.." && sleep 5  # wait 5 seconds
    done
    echo -e "$notice Please rerun this script again after Termux app update!"
    echo -e "$running Installing app update and restarting Termux app.." && sleep 3
    # Temporary Disable SELinux Enforcing during installation if it not in Permissive
    if [ "$(su -c 'getenforce 2>/dev/null')" = "Enforcing" ]; then
      su -c "setenforce 0"  # set SELinux to Permissive mode to unblock unauthorized operations
      touch "$meo/setenforce0"
      su -c "pm install -i com.android.vending '/data/local/tmp/termux-app_v${latestReleases}+github-debug_$arch.apk'"
    else
      su -c "pm install -i com.android.vending '/data/local/tmp/termux-app_v${latestReleases}+github-debug_$arch.apk'"
    fi
  else
    if su -c "ls -l '/data/local/tmp/termux-app_v${latestReleases}+github-debug_$arch.apk'" >/dev/null 2>&1; then
      if [ "$(su -c 'getenforce 2>/dev/null')" = "Permissive" ] && [ -f "$meo/setenforce0" ]; then
        su -c "setenforce 1"  # set SELinux to Enforcing mode to block unauthorized operations
        rm -f "$meo/setenforce0"
      fi
      su -c "rm '/data/local/tmp/termux-app_v${latestReleases}+github-debug_$arch.apk'"
    fi
  fi
else
  if [ $Android -eq 7 ]; then
    variant=7
  else
    variant=5
  fi
  lastReleases=$(curl -s https://api.github.com/repos/termux/termux-app/tags | jq -r '.[0].name | sub("^v"; "")')  # 0.119.0-beta.2
  if [ "$TERMUX_VERSION" != "$lastReleases" ]; then
    echo -e "$bad Termux app is outdated!"
    echo -e "$running Downloading Termux app update.."
    while true; do
      su -c "$PREFIX/bin/curl -L --progress-bar -C - -o '/data/local/tmp/termux-app_v${lastReleases}+apt-android-$variant-github-debug_$arch.apk' 'https://github.com/termux/termux-app/releases/download/v$lastReleases/termux-app_v${lastReleases}+apt-android-$variant-github-debug_$arch.apk'"
      if [ $? -eq 0 ]; then
        break  # break the resuming download loop
      fi
      echo -e "$notice Retrying in 5 seconds.." && sleep 5  # wait 5 seconds
    done
    echo -e "$notice Please rerun this script again after Termux app update!"
    echo -e "$running Installing app update and restarting Termux app.." && sleep 3
    # Temporary Disable SELinux Enforcing during installation if it not in Permissive
    if [ "$(su -c 'getenforce 2>/dev/null')" = "Enforcing" ]; then
      su -c "setenforce 0"  # set SELinux to Permissive mode to unblock unauthorized operations
      touch "$meo/setenforce0"
      su -c "pm install -i com.android.vending '/data/local/tmp/termux-app_v${lastReleases}+apt-android-$variant-github-debug_$arch.apk'"
    else
      su -c "pm install -i com.android.vending '/data/local/tmp/termux-app_v${lastReleases}+apt-android-$variant-github-debug_$arch.apk'"
    fi
  else
    if su -c "ls -l '/data/local/tmp/termux-app_v${lastReleases}+apt-android-$variant-github-debug_$arch.apk'" >/dev/null 2>&1; then
      if [ "$(su -c 'getenforce 2>/dev/null')" = "Permissive" ] && [ -f "$meo/setenforce0" ]; then
        su -c "setenforce 1"  # set SELinux to Enforcing mode to block unauthorized operations
        rm -f "$meo/setenforce0"
      fi
      su -c "rm '/data/local/tmp/termux-app_v${lastReleases}+apt-android-$variant-github-debug_$arch.apk'"
    fi
  fi
fi

# Colored prompt function
Write_ColoredPrompt() {
    local message="$1"
    local color="$2"
    local prompt_message="$3"
    
    local color_code reset_code
    reset_code=$(printf '\033[0m')
    
    case "$color" in
        red) color_code=$(printf '\033[31m') ;;
        green) color_code=$(printf '\033[32m') ;;
        yellow) color_code=$(printf '\033[33m') ;;
        blue) color_code=$(printf '\033[34m') ;;
        *) color_code="$reset_code" ;;
    esac

    printf "%s%s %s%s" "$color_code" "$message" "$prompt_message" "$reset_code" >&2
    read -r input
    printf "%s" "$input"
}
question_mark="[?]"

# --- Check if SnapChat is installed ---
if [ -n "$package" ]; then
  echo -e "$good SnapChat is installed on this device."
else

  echo -e "$bad SnapChat is not installed on this device!"
  echo -e "$notice Please manually install it from the Play Store."
  # open the Play Store page for SnapChat
  termux-open-url "https://play.google.com/store/apps/details?id=com.snapchat.android"
  su -c "input tap 540 590"  # tap on install button. x540, y590
  
  # --- Prompt the user for input ---
  userInput=$(Write_ColoredPrompt $question_mark "yellow" "Are you sure you have already installed the SnapChat app from PlayStore on your $model device? (Yes/No) ")
  # Check the user's input
  case "$userInput" in
      [Yy]*) echo -e "$running Proceeding.." ;;
      [Nn]*)
          echo -e "$bad Please manually install SnapChat app from PlayStore on your $model device then rerun the script again."
          # Open SnapChat app page on Play Store
          termux-open-url "https://play.google.com/store/apps/details?id=com.snapchat.android"
          exit 1
          ;;
      *) echo -e "$info ${Blue}Invalid input. Please enter Yes or No.${Reset}" ;;
  esac

fi

# --- install dependency ---
# --- Installing proot-distro in Termux ---
pkill dpkg && yes | dpkg --configure -a  # Forcefully kill dpkg process and configure dpkg
if [ ! -f "$PREFIX/bin/proot-distro" ]; then
  echo -e "$running Installing proot-distro.."
  pkg install proot-distro -y > /dev/null 2>&1  # discarding output
else
  echo -e "$good proot-distro pkg already installed inside Termux."
fi

# --- installing the Ubuntu distribution using proot-distro ---
# Check if Ubuntu is already installed via proot-distro
if ! ls "$PREFIX/var/lib/proot-distro/installed-rootfs/" 2>/dev/null | grep -iq "ubuntu" && [ -f "$PREFIX/bin/proot-distro" ]; then
  echo -e "$running Installing Ubuntu using proot-distro.."
  proot-distro install ubuntu > /dev/null 2>&1  # discarding output
else
  echo -e "$good Ubuntu already installed via proot-distro."
fi

# --- Update Ubuntu ---
if ls "$PREFIX/var/lib/proot-distro/installed-rootfs/" 2>/dev/null | grep -iq "ubuntu"; then
  echo -e "$running Updating Ubuntu distribution.."
  proot-distro login ubuntu -- bash -c "export DEBIAN_FRONTEND=noninteractive && { apt update && apt upgrade -y; } > /dev/null 2>&1"
fi

# --- Install Hashcat ---
if ! proot-distro login ubuntu -- test -f /usr/bin/hashcat && ls "$PREFIX/var/lib/proot-distro/installed-rootfs/" 2>/dev/null | grep -iq "ubuntu"; then
  echo -e "$running Installing HashCat inside PRoot Ubuntu.."
  proot-distro login ubuntu -- bash -c "apt install hashcat -y > /dev/null 2>&1"
else
  echo -e "$good HashCat already installed inside Ubuntu."
fi
# --- Check if Hashcat is installed inside the PRoot Ubuntu environment ---
if proot-distro login ubuntu -- which hashcat > /dev/null 2>&1; then
  hashcatVersion=$(proot-distro login ubuntu -- bash -c "hashcat --version" 2>/dev/null)
  echo -e "$running hashcat --version → HashCat $hashcatVersion"
else
  echo -e "$notice HashCat binary not found inside PRoot Ubuntu!"
  echo -e "$running Installing HashCat by rerunning 'IntelliJ MyEyes' script again.."
  bash "$fullScriptPath"
  exit 1  # exit from loop
fi

# --- Prompt the user for input ---
userInput=$(Write_ColoredPrompt $question_mark "yellow" "Are you sure you have already logged into your SnapChat account in the SnapChat app on your $model device? (Yes/No) ")
# Check the user's input
case "$userInput" in
    [Yy]*) echo -e "$running Proceeding.." ;;
    [Nn]*)
        echo -e "$bad Please login your SnapChat account in the SnapChat app first, then rerun the script again."
        # Launch the SnapChat app
        su -c "monkey -p com.snapchat.android -c android.intent.category.LAUNCHER 1 > /dev/null 2>&1"
        exit 1
        ;;
    *) echo -e "$info ${Blue}Invalid input. Please enter Yes or No.${Reset}" ;;
esac

# --- Download SQLite Binary ---
if ! su -c "ls -l '/data/data/com.snapchat.android/sqlite'" >/dev/null 2>&1; then
  echo -e "$running Downloading SQLite Binary for Android from ${Blue}https://github.com/arghya339/sqlite3-android/releases/download/all/sqlite-$arch${Reset}.."
  while true; do
      su -c "$PREFIX/bin/curl -L --progress-bar -C - -o '/data/data/com.snapchat.android/sqlite' 'https://github.com/arghya339/sqlite3-android/releases/download/all/sqlite-$arch'"
      if [ $? -eq 0 ]; then
        break  # break the resuming download loop
      fi
      echo -e "$notice Retrying in 5 seconds.." && sleep 5  # wait 5 seconds
  done
fi

# --- Check SQLite exist on SnapChat /data/ dir ---
if su -c "ls -l '/data/data/com.snapchat.android/sqlite'" >/dev/null 2>&1; then
  echo -e "$good SQLite Binary exist on SnapChat /data/ dir."
  # --- Give execute (--x) permission to SQLite Binary
  echo -e "$running Give execute (--x) permission to SQLite Binary.."
  su -c "chmod +x /data/data/com.snapchat.android/sqlite"
  # --- Checking SQLite --version ---
  SQLiteVersion=$(su -c "/data/data/com.snapchat.android/sqlite --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1")
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
  su -c "input touchscreen swipe 540 406 44 406 200"  # swipe the horizontal scroll bar
  sleep 2  # wait 2 seconds
  su -c "input tap 714 406 992 481"  # tap on 'My Eyes Only'
  
  # Define the input tap coordinates for each key
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
if su -c "ls -l /data/data/com.snapchat.android/databases/memories.db" >/dev/null 2>&1; then
  hashed_passcode=$(su -c "/data/data/com.snapchat.android/sqlite /data/data/com.snapchat.android/databases/memories.db 'select hashed_passcode from memories_meo_confidential;'")
  #  --- check if $hashed_passcode is null ---
  if [ -z $hashed_passcode ]; then
    echo -e "$bad Failed to fetched hashed PassCode using SQLite."
    termux-open-url "https://github.com/arghya339/IntelliJ-MyEyes/blob/main/docs%2Fhashed_passcode_null_error.md"  # open hashed_passcode_null_error docs if fetched hashed passcode is null
    exit 1  # Terminate script execution
  else
    echo -e "\033[1;30;47m[####] Fetched hashed PassCode: [$hashed_passcode]\033[0m"
    # --- Save the hashed passcode into a .txt file ---
    echo "$hashed_passcode" > "$hashed_passcode_file"
  fi

  # Hashcat stores cracked hashes in a file called a $potfile, Removing the $potfile ensures the results are freshly computed for each execution.

  if [ -f $potfile ]; then
    proot-distro login ubuntu -- bash -c "rm -rf $potfile"
  fi
  # proot-distro login ubuntu -- bash -c " touch $potfile"  # create $potfile file
  
  # which hashcat || whereis hashcat  # get hashcat executable path, its located in root@localhost:/usr/bin# dir

  # --- Brute-force the hash ---
  echo -e "$running Brute forcing hash using HashCat.."
  # echo "$HOME/meo/hashed_passcode.txt file content:" && proot-distro login ubuntu -- /bin/bash -c "cat $hashed_passcode_file"
  if [ "$(su -c 'getenforce 2>/dev/null')" = "Enforcing" ]; then
    su -c "setenforce 0"  # set SELinux to Permissive mode to unblock unauthorized operations
    su -c "cmd deviceidle whitelist +com.termux"
    su -c "setenforce 1"  # set SELinux to Enforcing mode to block unauthorized operations
  else
    su -c "cmd deviceidle whitelist +com.termux"
  fi
  termux-wake-lock
  proot-distro login ubuntu -- /bin/bash -c "hashcat -m 3200 -a 3 '$hashed_passcode_file' '?d?d?d?d' --potfile-disable --force -o '$potfile' > /dev/null 2>&1"
  termux-wake-unlock
  # using --potfile-disable flag to Temporarily ignore the potfile for the current session becouse i dont know hashcat default potfile path
  # ---  Check Previously Cracked Hashes ---
  # proot-distro login ubuntu -- /bin/bash -c "hashcat --show -m 3200 '$hashed_passcode_file'"

  # --- Extract pincode from potfile ---
  pincode=$(proot-distro login ubuntu -- /bin/bash -c "grep -o '[^:]*$' '$potfile' | tail -n1" 2>/dev/null)

  # --- Validate and display result ---
  if [ ${#pincode} -eq 4 ]; then
    echo -e "\033[1;92;47m[****] Cracked My Eyes Only PinCode: [$pincode]\033[0m"
    
    if [ "$(su -c 'getenforce 2>/dev/null')" = "Enforcing" ]; then
      su -c "setenforce 0"  # set SELinux to Permissive mode to unblock unauthorized operations
      tryMEO  # Call the auto try MEO PassCode function
      su -c "setenforce 1"  # set SELinux to Enforcing mode to block unauthorized operations
    else
      tryMEO
    fi
    
    echo -e "${Green}☆ Star & -{ Fork me..${Reset}"
    # Open GitHub URL
    termux-open-url "https://github.com/arghya339/IntelliJ-MyEyes"
    sleep 0.5  # 0.5 seconds = 500 milliseconds
    echo -e "${Green}Donation: PayPal/@arghyadeep339${Reset}"
    # Open PayPal URL
    termux-open-url "https://www.paypal.com/paypalme/arghyadeep339"
    sleep 0.5  # 0.5 seconds = 500 milliseconds
    echo -e "${Green}Subscribe: YouTube/@MrPalash360${Reset}"
    # Open YouTube URL for subscription
    termux-open-url "https://www.youtube.com/channel/UC_OnjACMLvOR9SXjDdp2Pgg/videos?sub_confirmation=1"
    #sleep 0.5  # 0.5 seconds = 500 milliseconds
    #echo -e "${Green}Follow: Telegram${Reset}"
    # Open Telegram update channel URL
    #termux-open-url "https://t.me/MrPalash360"
    #sleep 0.5  # 0.5 seconds = 500 milliseconds
    #echo -e "${Green}Join: Telegram${Reset}"
    # Open Telegram discussion channel URL
    #termux-open-url "https://t.me/MrPalash360Discussion"

  else 
    
    echo -e "$bad Failed to crack PinCode using HashCat."
    
    # --- Prompt the user for input ---
    userInput=$(Write_ColoredPrompt $question_mark "yellow" "Did you find any bugs in this script? (Yes/No) ")
    # Check the user's input
    case "$userInput" in
        [Yy]*)
            # If user says Yes, ask for issue description
            echo -e "$running Wait, creating a new bug reporting template using your keywords.."
  
            # Ask user to describe the bug
            issue_description=$(Write_ColoredPrompt $question_mark "yellow" "Please describe what's not working in this script? (Write here..) ")

            # Open the GitHub issue page with prefilled title and body
            termux-open-url "https://github.com/arghya339/IntelliJ-MyEyes/issues/new?title=Bug&body=$issue_description"
        
            echo "🖤 Thanks for reporting!"
            ;;
        [Nn]*) echo -e "$running Proceeding.." ;;
        *)
            # If user provides an invalid input
            echo -e "$info ${Blue}Invalid input. Please enter Yes or No.${Reset}"
            ;;
    esac
    proot-distro login ubuntu -- /bin/bash -c "rm -rf '$potfile' '$hashed_passcode_file'"
    exit 1
    
  fi

  # --- Cleanup Hashcat reqired files ---
  proot-distro login ubuntu -- /bin/bash -c "rm -rf '$potfile' '$hashed_passcode_file'"

elif [ ! su -c ls -l /data/data/com.snapchat.android/databases/memories.db ]; then
  # File not found
  echo -e "$bad memories.db file not found in /data/data/com.snapchat.android/databases dir on $model device!"
  echo -e "$question Are you sure 'My Eyes Only' SnapChat features are turned on in the $model device?"
fi

# --- Prompt the user for input ---
userInput=$(Write_ColoredPrompt $question_mark "yellow" "Do you want to rerun this script again? (Yes/No) ")
# Check the user's input
case "$userInput" in
    [Yy]*)
        # If user says Yes, rerun the script
        clear
        echo -e "$running Rerunning 'IntelliJ MyEyes' script again.."
        bash "$fullScriptPath"
        exit 1  # exit from loop
        ;;
    [Nn]*)
        # If user says No, proceed with purging script related files
        echo -e "$info Proceeding with purge IntelliJ MyEyes script related files and directory.."
        rm -rf "$meo"
        su -c "rm -rf /data/data/com.snapchat.android/sqlite"
        echo "♥️ Thanks for using this script. Regards, @Arghya"
        ;;
    *) echo -e "$info ${Blue}Invalid input. Please enter Yes or No.${Reset}" ;;
esac

# --- Prompt the user for input ---
userInput=$(Write_ColoredPrompt $question_mark "yellow" "Do you want to remove this script-related dependency? (Yes/No) ")
# Check the user's input
case "$userInput" in
    [Yy]*)
        # If the user confirms, proceed with removing dependencies
        echo -e "$running Proceeding with removal of dependencies.."
        # uninstall Hashcat from Ubuntu
        proot-distro login ubuntu -- bash -c "apt remove hashcat -y" > /dev/null 2>&1
        # uninstall ubuntu using proot-distro
        proot-distro remove ubuntu > /dev/null 2>&1
        # uninstall proot-distro pkg from Termux
        pkg uninstall proot-distro -y > /dev/null 2>&1
        # remove proot-distro dependencies
        apt autoremove -y > /dev/null 2>&1
        ;;
    [Nn]*)
        echo -e "$info Proceeding without removing script-related dependencies!"
        ;;
    *) echo -e "$info ${Blue}Invalid input. Please enter Yes or No.${Reset}" ;;
esac

# --- Developer Info ---
echo -e "${Green}Powered by Hashcat (github.com/hashcat/hashcat)"
termux-open-url "https://github.com/hashcat/hashcat/"
echo -e "${Green}Inspired by meobrute (github.com/sdushantha/meobrute)"
echo -e "${Green}Developer: @arghya339 (github.com/arghya339)"

# --- External Dependencies ---
echo -e "$info External Dependencies: 'PRoot Distro' [GNU 3.0], 'Ubuntu' [CC-BY-SA 3.0], 'Hashcat' [MIT] 'SQLite' [BSD-style]"
echo -e "$info LICENSE: This script is licensed under the 'MIT' License."

# --- Close Terminal Prompt ---
echo -e "$info Do you want to close Termux? (Enter ${Green}exit${Reset} to close)"

rm -f "$fullScriptPath"  # Remove meo script
#################################################################
