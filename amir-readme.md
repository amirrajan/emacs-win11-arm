1. open powershell in admin mode
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
2. restart powershell in admin mode
```
choco install msys2
```
3. run this script to create a shortcut to mingw64 with admin rights
```
Set-ExecutionPolicy Bypass -Scope Process -Force
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\MINGW64.lnk")
$Shortcut.TargetPath = "C:\tools\msys64\mingw64.exe"
$Shortcut.Save()
$Shortcut.FullName

$bytes = [System.IO.File]::ReadAllBytes($Shortcut.FullName)
$bytes[0x15] = $bytes[0x15] -bor 0x20 #set run as admin flag
[System.IO.File]::WriteAllBytes($Shortcut.FullName, $bytes)
```
4. open up mingw64 install packages, clone emacs fork, build
```
pacman -S git --noconfirm
mkdir -p ~/projects
rm -rf ~/projects/emacs-win11-arm
cd ~/projects
git clone https://github.com/amirrajan/emacs-win11-arm.git
git config core.autocrlf false
cd ~/projects/emacs-win11-arm
```
5. install packages:
```
sh ./amir-pacman.sh
```
6. build emacs and install:
```
sh ./amir-build-emacs.sh
```
