#!/usr/bin/bash

# Clone IntelliJ_MyEyes.sh: ~ wget "https://raw.githubusercontent.com/arghya339/IntelliJ-MyEyes/refs/heads/main/IntelliJ_MyEyes.sh" -O $HOME/IntelliJ_MyEyes.sh
# Usage instructions: ~ sh $HOME/IntelliJ_MyEyes.sh

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
Red="\033[91"
Blue="\033[94"
White="\033[37"
Yellow="\033[93"
Reset="\033[0m"

# Construct the eye shape using string concatenation
eye=$(cat <<'EOF'
.----------------------------------------.
|█ █▄ █ ▀█▀ ██▀ █   █   █   █   █▄ ▄█ ██▀|    
|█ █ ▀█  █   ▄▄ █▄▄ █▄▄ █ ▀▄█   █ ▀ █ █▄▄|
|                 >_𝒟𝑒𝓋𝑒𝓁𝑜𝓅𝑒𝓇: @𝒶𝓇𝑔𝒽𝓎𝒶𝟥𝟥𝟫|
'----------------------------------------'\nhttps://github.com/arghya339/IntelliJ-MyEyes
EOF
)
# Print the eye shape with the specified foreground color
echo "$Green$eye$Reset"
echo ""  # Space

# Colored log indicators with color codes
echo "--- Colored log indicators ---"
echo "$good - good"
echo "$bad - bad"
echo "$info - info"
echo "$running - running"
echo "$notice - notice"
echo ""  # Space

# --- Termux Storage Permission Check Logic ---
if [ -d "$HOME/storage/shared" ]; then
    echo "${Green}${good} Storage permission already granted."
else
    # Attempt to list /storage/emulated/0 to trigger the error
    error=$(ls /storage/emulated/0 2>&1)
    expected_error="ls: cannot open directory '/storage/emulated/0': Permission denied"

    if echo "$error" | grep -qF "$expected_error"; then
        echo "${Yellow}${notice} Storage permission not granted. Running termux-setup-storage.."
        termux-setup-storage
        exit 1  # Exit the script after handling the error
    else
        echo "${Red}${bad} Unknown error: $error"
        exit 1  # Exit on any other error
    fi
fi

# --- Termux SuperUser Permission Check ---
if su -c "id" >/dev/null 2>&1; then
# -c allows you to run a single command as root without opening an interactive root shell.
  echo "$good SU permission is granted."
else
  echo "$bad SU permission is not granted."
  echo "$notice Please open the Magisk/KernelSU/APatch app and manually grant root permissions to Termux."
fi

# --- Checking Internet Connection ---
echo "$running Checking internet Connection.."
if ! ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1 ; then
    echo "$bad Oops! No Internet Connection available.\nConnect to the Internet and try again later."
    return 1
fi

# --- Update Termux pkg ---
echo "$running Updating Termux pkg.."
pkill pkg && { pkg update && pkg upgrade -y; } > /dev/null 2>&1  # discarding output

# --- local Veriable ---
fullScriptPath=$(realpath "$0")  # Get the full path of the currently running script
bin=/data/data/com.termux/files/usr/bin  # Termux $bin dir
package=$(su -c "pm list packages | grep com.snapchat.android" 2>/dev/null)  # SnapChat packages list
meo="$HOME/meo"  # $meo dir in Termux $HOME path
arch=$(getprop ro.product.cpu.abi)  # get device arch
model=$(getprop ro.product.model)  # get device model
hashed_passcode_file="$meo/hashed_passcode.txt"  # hashed_passcode.txt file
potfile="/root/hashcat.potfile"  # Hashcat potfile variable

# --- Create $meo dir if it does't exist ---
mkdir -p "$meo"

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

# --- Check if Snapchat is installed ---
if [ -n "$package" ]; then
  echo "$good Snapchat is installed on the device."
else

  echo "$bad Snapchat is not installed on the device."
  echo "$notice Please manually install it from the Play Store."
  # open the Play Store page for SnapChat
  termux-open-url "https://play.google.com/store/apps/details?id=com.snapchat.android"

  # --- Prompt the user for input ---
  userInput=$(Write_ColoredPrompt $question_mark "yellow" "Are you sure you have already installed the SnapChat app from PlayStore on your $model device? (Yes/No) ")
  # Check the user's input
  case "$userInput" in
      [Yy]*)
          echo "$running Proceeding.."
          ;;
      [Nn]*)
          echo "$bad Please manually install SnapChat app from PlayStore on your $model device then rerun the script again."
          # Open Snapchat app page on Play Store
          termux-open-url "https://play.google.com/store/apps/details?id=com.snapchat.android"
          exit 1
          ;;
      *)
          echo "$info ${Blue}Invalid input. Please enter Yes or No.${Reset}"
          ;;
  esac

fi

# --- install dependency ---
# --- Installing proot-distro in Termux ---
pkill dpkg && yes | dpkg --configure -a  # Forcefully kill dpkg process and configure dpkg
if [ ! -f "/data/data/com.termux/files/usr/bin/proot-distro" ]; then
echo "$running Installing proot-distro.."
pkg install proot-distro -y > /dev/null 2>&1  # discarding output
else
echo "$good proot-distro pkg already installed in Termux"
fi

# --- installing the ubuntu distribution using proot-distro ---
# Check if Ubuntu is already installed via proot-distro
if ! ls "$PREFIX/var/lib/proot-distro/installed-rootfs/" 2>/dev/null | grep -iq "ubuntu"; then
echo "$running Installing Ubuntu using proot-distro.."
proot-distro install ubuntu > /dev/null 2>&1  # discarding output
else
echo "$good Ubuntu already installed via proot-distro"
fi

# --- Update Ubuntu ---
echo "$running Updating Ubuntu distribution.."
proot-distro login ubuntu -- bash -c "export DEBIAN_FRONTEND=noninteractive && { apt update && apt upgrade -y; } > /dev/null 2>&1"

# --- Install Hashcat ---
if ! proot-distro login ubuntu -- test -f /usr/bin/hashcat; then
echo "$running Installing Hashcat in Ubuntu.."
proot-distro login ubuntu -- bash -c "apt install hashcat -y > /dev/null 2>&1"
else
echo "$good Hashcat already installed on ubuntu"
fi
# --- Check Hashcat Version ---
echo "$running Checking Hashcat --version.."
proot-distro login ubuntu -- bash -c "hashcat --version"

# --- Check if wget is installed ---
if [ ! -f $bin/wget ]; then
# installing wget for downloading files
echo "$running installing wget pkg.."
pkg install wget -y > /dev/null 2>&1
else
echo "$good wget already installed."
fi

# --- Prompt the user for input ---
userInput=$(Write_ColoredPrompt $question_mark "yellow" "Are you sure you have already logged into your SnapChat account in the SnapChat app on your $model device? (Yes/No) ")
# Check the user's input
case "$userInput" in
    [Yy]*)
        echo "$running Proceeding.."
        ;;
    [Nn]*)
        echo "$bad Please login your SnapChat account in the SnapChat app first, then rerun the script again."
        # Launch the Snapchat app
        su -c "monkey -p com.snapchat.android -c android.intent.category.LAUNCHER 1 > /dev/null 2>&1"
        exit 1
        ;;
    *)
        echo "$info ${Blue}Invalid input. Please enter Yes or No.${Reset}"
        ;;
esac

# --- Download sqlite Binary ---
if [ ! -f $meo/sqlite ]; then
  echo "$running Downloading SQLite Binary for Android.."
  # wget "https://github.com/arghya339/sqlite3-android/releases/download/all/sqlite-$arch" -O "$meo/sqlite" 2>&1 | sed -un '/% /p; / saved /p'
  wget "https://github.com/arghya339/sqlite3-android/releases/download/all/sqlite-$arch" -O "$meo/sqlite" > /dev/null 2>&1  # discarding wget output from Termux
fi

# --- Check SQLite exist on $meo dir ---
if [ -f "$meo/sqlite" ]; then
echo "$good SQLite Binary exist on $meo dir"
fi

# --- Copy SQLite Binary to SnapChat data dir ---
echo "$running Copy SQLite Binary from device $meo to SnapChat /data dir.."
su -c "cp $meo/sqlite /data/data/com.snapchat.android"
# --- Give execute (--x) permission to SQLite Binary
su -c "chmod +x /data/data/com.snapchat.android/sqlite"
# --- Check SQLite --version ---
echo "$running Checking SQLite --version.."
su -c "/data/data/com.snapchat.android/sqlite --version"

# --- Get the hashed passcode ---
if su -c "ls -l /data/data/com.snapchat.android/databases/memories.db" >/dev/null 2>&1; then
  hashed_passcode=$(su -c "/data/data/com.snapchat.android/sqlite /data/data/com.snapchat.android/databases/memories.db 'select hashed_passcode from memories_meo_confidential;'")
  echo "\033[1;30;47m[####] Fetched hashed passcode: [$hashed_passcode]\033[0m"

  # --- Save the hashed passcode into a .txt file ---
  echo "$hashed_passcode" > "$hashed_passcode_file"

  # Hashcat stores cracked hashes in a file called a $potfile, Removing the $potfile ensures the results are freshly computed for each execution.

  if [ -f $potfile ]; then
    proot-distro login ubuntu -- bash -c "rm -rf $potfile"
  fi
  # proot-distro login ubuntu -- bash -c " touch $potfile"  # create $potfile file
  
  # which hashcat || whereis hashcat  # get hashcat executable path, its located in root@localhost:/usr/bin# dir

  # --- Brute-force the hash ---
  echo "$running Brute forcing hash using Hashcat.."
  # echo "$HOME/meo/hashed_passcode.txt file content:" && proot-distro login ubuntu -- /bin/bash -c "cat $hashed_passcode_file"
  proot-distro login ubuntu -- /bin/bash -c "hashcat -m 3200 -a 3 '$hashed_passcode_file' '?d?d?d?d' --potfile-disable --force -o '$potfile' > /dev/null 2>&1"
# using --potfile-disable flag to Temporarily ignore the potfile for the current session becouse i dont know hashcat default potfile path
# ---  Check Previously Cracked Hashes ---
# proot-distro login ubuntu -- /bin/bash -c "hashcat --show -m 3200 '$hashed_passcode_file'"

  # --- Extract pincode from potfile ---
  pincode=$(proot-distro login ubuntu -- /bin/bash -c "grep -o '[^:]*$' '$potfile' | tail -n1") > /dev/null 2>&1

  # --- Validate and display result ---
  if [ ${#pincode} -eq 4 ]; then
    echo "\033[1;92;47m[****] Cracked My Eyes Only pincode: [$pincode]\033[0m"
    echo "$info Please Open SnapChat app and try cracked 'My Eyes Only' Pincode: $pincode"
    su -c "monkey -p com.snapchat.android -c android.intent.category.LAUNCHER 1 > /dev/null 2>&1"
  else 
    echo "$bad Failed to crack pincode using hashcat."
    exit 1
  fi

  # --- Cleanup Hashcat reqired files ---
  proot-distro login ubuntu -- /bin/bash -c "rm -rf '$potfile' '$hashed_passcode_file'"

  # --- Check if pincode length is 4 ---
  if [ ${#pincode} -eq 4 ]; then
    echo "${Green}☆ Star & -{ Fork me..${Reset}"
    # Open GitHub URL
    termux-open-url "https://github.com/arghya339/IntelliJ-MyEyes"
    echo "${Green}Donation: PayPal/@arghyadeep339${Reset}"
    # Open PayPal URL
    termux-open-url "https://www.paypal.com/paypalme/arghyadeep339"
    echo "${Green}Subscribe: YouTube/@MrPalash360${Reset}"
    # Open YouTube URL for subscription
    termux-open-url "https://www.youtube.com/channel/UC_OnjACMLvOR9SXjDdp2Pgg/videos?sub_confirmation=1"
    echo "${Green}Follow: Telegram${Reset}"
    # Open Telegram update channel URL
    termux-open-url "https://t.me/MrPalash360"
    echo "${Green}Join: Telegram${Reset}"
    # Open Telegram discussion channel URL
    termux-open-url "https://t.me/MrPalash360Discussion"
  fi

elif [ ! su -c ls -l /data/data/com.snapchat.android/databases/memories.db ]; then
  # File not found
  echo "$bad memories.db file not found in /data/data/com.snapchat.android/databases dir on $model device!"
  echo "$question Are you sure 'My Eyes Only' SnapChat features are turned on in the $model device?"
fi

# --- Prompt the user for input ---
userInput=$(Write_ColoredPrompt $question_mark "yellow" "Are you finding any bugs in this script? (Yes/No) ")
# Check the user's input
case "$userInput" in
    [Yy]*)
        # If user says Yes, ask for issue description
        echo "$running Wait, creating a new bug reporting template using your keywords.."
  
        # Ask user to describe the bug
        issue_description=$(Write_ColoredPrompt $question_mark "yellow" "Please describe what's not working in this script? (Write here..) ")

        # Open the GitHub issue page with prefilled title and body
        termux-open-url "https://github.com/arghya339/IntelliJ-MyEyes/issues/new?title=Bug&body=$issue_description"
        
        echo "🖤 Thanks for reporting!"
        ;;
    [Nn]*)
        echo "♥️ Thanks for using this script. Regards, @Arghya"
        ;;
    *)
        # If user provides an invalid input
        echo "$info ${Blue}Invalid input. Please enter Yes or No.${Reset}"
        ;;
esac

# --- Prompt the user for input ---
userInput=$(Write_ColoredPrompt $question_mark "yellow" "Are you want to rerun this script again? (Yes/No) ")
# Check the user's input
case "$userInput" in
    [Yy]*)
        # If user says Yes, rerun the script
        clear
        echo "$running Rerunning 'IntelliJ MyEyes' script again.."
        sh "$fullScriptPath"
        exit 1  # exit from loop
        ;;
    [Nn]*)
        # If user says No, proceed with purging script related files
        echo "$info Proceeding with purge IntelliJ MyEyes script related files and directory.."
        rm -rf "$meo"
        rm -rf "$fullScriptPath"
          su -c "rm -rf /data/data/com.snapchat.android/sqlite"
        ;;
    *)
        # If user provides an invalid input
        echo "$info ${Blue}Invalid input. Please enter Yes or No.${Reset}"
        ;;
esac

# --- Prompt the user for input ---
userInput=$(Write_ColoredPrompt $question_mark "yellow" "Do you want to remove this script-related dependency? (Yes/No) ")
# Check the user's input
case "$userInput" in
    [Yy]*)
        # If the user confirms, proceed with removing dependencies
        echo "$running Proceeding with removal of dependencies.."
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
        echo "$info Proceeding without removing script-related dependencies."
        ;;
    *)
        # If user provides an invalid input
        echo "$info ${Blue}Invalid input. Please enter Yes or No.${Reset}"
        ;;
esac

# --- Developer Info ---
echo "$Green Powered by Hashcat (github.com/hashcat/hashcat)"
termux-open-url "https://github.com/hashcat/hashcat/"
echo "$Green Inspired by meobrute (github.com/sdushantha/meobrute)"
echo "$Green Developer: @arghya339 (github.com/arghya339)"

# --- External Dependencies ---
echo "$info External Dependencies: 'PRoot Distro' [GNU 3.0], 'Ubuntu' [CC-BY-SA 3.0], 'Hashcat' [MIT] 'SQLite' [BSD-style]"
echo "$info LICENSE: This script is licensed under the 'MIT' License."

# --- Close Terminal Prompt ---
echo "$info Are you want to close Termux? (Enter 'exit' to close)"
##################################################################
