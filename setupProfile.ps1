function Set-PredictionSource_Override {
  Set-PSReadLineOption -ShowToolTips
  Set-PSReadLineOption -PredictionSource HistoryAndPlugin
  Set-PSReadLineOption -HistoryNoDuplicates
  Set-PSReadLineOption -MaximumHistoryCount 10000
  Set-PSReadLineOption -CompletionQueryItems 65
  Invoke-Expression (& { (jj util completion power-shell | Out-String) })
}

function Get-Theme_Override {
  # Oh-my-posh and fancy terminal
  oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/danybeam.omp.json" | Invoke-Expression
  oh-my-posh config migrate glyphs --write
  Import-Module -Name Terminal-Icons
}
