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
Import-Module -Name Terminal-Icons

# Predictive text
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# better cd'ing
Import-Module z