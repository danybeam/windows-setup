# TODO arguments to decide what to install and what not
# TODO Needs to download caskadya code nerd font or install it from folder
# TODO Set powershell defaul font to caskadya code mono
# TODO Set powershell to use ligatures

# Minimal setup
# install powershell
winget install Microsoft.Powershell
# install oh-my-posh
winget install JanDeDobbeleer.OhMyPosh -s winget
oh-my-posh config migrate glyphs --write

# Configure oh my posh
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
New-Item -Path $PROFILE -Type File -Force
Copy-Item "$PSScriptRoot/setupProfile.ps1" $PROFILE -Force

New-Item -Path "$env:POSH_THEMES_PATH/danybeam.omp.json" -Type File -Force
Copy-Item "$PSScriptRoot/danybeam.omp.json" "$env:POSH_THEMES_PATH/danybeam.omp.json" -Force

# Make terminal even fancier
Install-Module -Name Terminal-Icons -Repository PSGallery

# Add predictive text
Install-Module PSReadLine -AllowPrerelease -Force

# better cd'ing
Install-Module z -AllowClobber

# install Windows terminal
winget install Microsoft.WindowsTerminal
# install git
winget install Git.Git
# install vscode
winget install Microsoft.VisualStudioCode

# install powertoys
winget install Microsoft.PowerToys --source winget

#install notion
#winget install Notion.Notion
winget install Obsidian.Obsidian
winget install --id=Helix.Helix  -e
# install spotify does not work... yet?
# winget install Spotify.Spotify

# Install things with prompts
# TODO install rust
# TODO install python
# TODO install Visual Studio
# TODO install C/C++ tools for VS
# TODO install CMake
# TODO install Linux C/C++ compiler?
# TODO if I add linux tools install WSL
