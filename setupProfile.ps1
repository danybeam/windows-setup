# This is intended to be used with Chris Titus Powershell profile
# This is a (hopefully) temporary workaround to the fact that his profile executes last, therefore overrides my settings
# You need to make sure PERSONAL_SCRIPT_LOCK is set up in the environment variables... or set it here.
if(-not (Test-Path $env:PERSONAL_SCRIPT_LOCK))
{
Set-Content -Path $env:PERSONAL_SCRIPT_LOCK -Value "not empty"
Add-Content -Path $PROFILE -Value @'
# Oh-my-posh and fancy terminal
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/danybeam.omp.json" | Invoke-Expression
oh-my-posh config migrate glyphs --write
Import-Module -Name Terminal-Icons

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Predictive text
#Import-Module PSReadLine

# Autocompleteion for Arrow keys
Set-PSReadLineOption -HistorySearchCursorMovesToEnd


Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -CompletionQueryItems 65

Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -PredictionViewStyle ListView

# Shows navigable menu of all options when hitting Tab
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Invoke-Expression (& { (jj util completion power-shell | Out-String) })
'@

function Update-MyProfile {
  Remove-Item $env:PERSONAL_SCRIPT_LOCK
  Update-Profile
}
}
