param (
  [switch]$AHK = $false,
  [switch]$All = $false,
  [switch]$ForceOMPProfile = $false,
  [switch]$kdiff3,
  [switch]$meld,
  [switch]$selfDestruct,
  [switch]$TerminalSettings,
  [switch]$VSCodeConfig,
  [switch]$7zip = $false,
  [switch]$h = $false,
  [switch]$help = $false
)
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not($isAdmin)) {
  Write-Output "You are not running this script with administration rights"
  Write-Output "Please re-run this script from and administrative powershell session"
  exit
}
# Check correct Powershell is running
Write-Information "Script start"
if (-not ($Host.Version.major -ge 6)) {
  Write-Output -Message "This script is intended for powershell version >=6.x.x please install that and run this from there"
}

if ($h -or $help) {
  Write-Output@"
  Usage:
  setup.ps1 [-AHK] [-All] [-ForceOMPProfile] [-TerminalSettings] [-VSCodeConfig] [-7zip] [-h | -help]
  -AHK              Installs Autohotkey                            (default: false)
  -All              Installs everything (overrides any other flag) (default: false)
  -ForceOMPProfile  Forces override of Oh my posh profile          (default: false => will try to copy but won't force)
  -kdiff3           Installs kdiff3                                (default: true => installs kdiff3)
  -meld             Installs meld                                  (default: true => installs meld)
  -selfDestruct     Cleans everything in the containing folder     (default: true => self destructs after instalation)
                    after instalation
  -TerminalSettings Copies included settings for windows terminal  (default: true => Copies settings)
  -VSCodeConfig     Copies Included settings for VSCode            (default: true => Copies settings)
  -7zip             Installs 7zip                                  (default: false)
  -h | -help        Shows this message
"@
  exit
}

Write-Information "Initializing variables"
# Global variables
$testchoco = ""
$VSCodeExtensions = @(
  "alexisvt.flutter-snippets",
  "CoenraadS.bracket-pair-colorizer-2",
  "Dart-Code.dart-code",
  "Dart-Code.flutter",
  "DavidAnson.vscode-markdownlint",
  "deerawan.vscode-dash",
  "esbenp.prettier-vscode",
  "esskar.vscode-flutter-i18n-json",
  "ms-python.python",
  "ms-vscode-remote.remote-wsl",
  "ms-vscode.cpptools",
  "ms-vscode.powershell",
  "Nash.awesome-flutter-snippets",
  "redhat.java",
  "RobbOwen.synthwave-vscode",
  "slevesque.vscode-autohotkey",
  "slevesque.vscode-hexdump",
  "VisualStudioExptTeam.vscodeintellicode",
  "vscjava.vscode-java-debug",
  "vscjava.vscode-java-dependency",
  "vscjava.vscode-java-pack",
  "vscjava.vscode-java-test",
  "vscjava.vscode-maven",
  "vscode-icons-team.vscode-icons",
  "vscodevim.vim",
  "will-shaw.ws-rainmeter",
  "yzhang.markdown-all-in-one"
)
function testChoco() {
  $testchoco = choco -v
  return $testchoco
}

New-Item "$PSScriptRoot\Download" -ItemType Directory
####################### INSTALLS #######################################

# Install chocolately
Write-Information "##### Chocolately #####"
if (-not(testchoco)) {
  Write-Output "Seems Chocolatey is not installed, installing now"
  Set-ExecutionPolicy Bypass -Scope Process -Force;
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
}
else {
  Write-Output "Chocolatey Version $testchoco is already installed"
}

# Install stuff with chocolately
Write-Output "##### Chocolately Instals #####"
if (testchoco) {
  Write-Output "##### Chocolately => Windows terminal #####"
  choco install microsoft-windows-terminal 
  Write-Output "##### Chocolately => Git #####"
  choco install git
  Write-Output "##### Chocolately => VSCode #####"
  choco install vscode
  start vscode://
}
else {
  Write-Output "Seems like chocolately was not properly installed, please install it manually and re-run the script"
  exit
}

# Install oh-my-posh
Write-Output "##### Install oh my posh #####"
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser  

# Install vscode extensions
Write-Output "##### Install VSCode Extensions ####"
if (Test-Path "$env:APPDATA\Code") {
  foreach ($item in $VSCodeExtensions) {
    code --install-extension $item
  }

  # Copy Config
  if ($VSCodeConfig -or $All) { 
    Copy-Item -Path "$PSScriptRoot\Config\VSCode\settings.json" -Destination "$env:APPDATA\Code\User" -Force
    if (-not (Test-Path "$env:APPDATA\Code\User")) {
      New-Item "$env:APPDATA\Code\User\snippets" -Path -ItemType Directory -Force
    }
    Copy-Item -Path  "$PSScriptRoot\Config\VSCode\snippets\*" "$env:APPDATA\Code\User\snippets" -Recurse -Force
  }
}
else {
  Write-Output "VSCode was not found in $env:APPDATA\Code please verify VSCode is installed"
  Write-Output "If you have VSCode installed in another location please contact danybeam@gmail.com so that the issue can be addressed"
}
  
# Install Autohotkey
if ($AHK -or $All) {
  Write-Output "##### Install Autohotkey ####"
  Start-Process "$PSScriptRoot\Installers\Autohotkey.exe" -Wait 
}

#Install 7zip
if ($7zip -or $All) {
  Write-Output "##### Install 7zip ####"
  $url = "https://www.7-zip.org/a/7z1900-x64.exe"
  $output = "$PSScriptRoot\Download\7zip.exe"
  (New-Object System.Net.WebClient).DownloadFile($url, $output)
  Start-Process $output -Wait
}

# install kdiff3
if ($kdiff3 -or $All) {
  Write-Output "##### Install kdiff3 ####"
  $output = "$PSScriptRoot\Installers\kdiff3.exe"
  Start-Process $output -Wait
}

if ($meld -or $All) {
  Write-Output "##### Install meld ####"
  $url = "https://download.gnome.org/binaries/win32/meld/3.20/Meld-3.20.2-mingw.msi"
  $output = "$PSScriptRoot\Download\meld.msi"
  (New-Object System.Net.WebClient).DownloadFile($url, $output)
  Start-Process msiexec.exe -Wait -ArgumentList "/I $output /quiet"
}
############################### Config Files #######################################

# oh my posh profile file
if ($ForceOMPProfile -or $All) {
  Write-Output "##### Copying Oh-my-posh profile ####"
  New-Item -Path "$env:HOME\Documents\PowerShell" -ItemType Directory -Force
  Copy-Item -Path "$PSScriptRoot\Config\Powershell\Microsoft.PowerShell_profile.ps1" -Destination "$env:HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Force
}
else {
  Copy-Item -Path "$PSScriptRoot\Config\Powershell\Microsoft.PowerShell_profile.ps1" -Destination "$env:HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" 
}

# Copy terminal settings file
if ($TerminalSettings -or $All) {
  Write-Output "##### Copying Windows terminal settings ####"
  Copy-Item -Path "$PSScriptRoot\Config\Windows terminal\settings.json" -Destination "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Force
}

Write-Output @"

############### DISCLAIMER ###############

All programms installed here were taken from my own current configuration and it's what *I* use to programm and tinker around.  
However I would love this to be as complete as possible with a default minimum config that can help the most people at the same time.

This is as far as this installer can get you.  
Stuff you should consider adding on your own:

Office Suite
Visual Studio 2019
Microsoft teams (if not included with office)
WSL (Windows Subsistem for linux)
Ubuntu (or any Linux distro for that matter)

Please open an issue in the repo for more software that could be added to the installed programms or to this disclaimer list :)
"@

if ($selfDestruct) {
  Remove-Item $PSScriptRoot -Recurse -Force
}