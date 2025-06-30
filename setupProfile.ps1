# TODO miniscript to chose one each day
# saving for later
# atomic.omp.json
# cert.omp.json
# clean-detailed.omp.json
# easy-term.omp.json
# free-ukraine.omp.json
# if_tea.omp.json
# markbull.omp.json
# sonicboom_light.omp.json
# velvet.omp.json

# Oh-my-posh and fancy terminal
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/danybeam.omp.json"| Invoke-Expression
oh-my-posh config migrate glyphs --write
Import-Module -Name Terminal-Icons

# better cd'ing
Import-Module z

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

function Update-Powershell {
  param ()
  iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
}
