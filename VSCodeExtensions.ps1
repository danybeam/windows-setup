code
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
if (Test-Path "$env:APPDATA\Code") {
  foreach ($item in $VSCodeExtensions) {
    code --install-extension $item
  }
}
else {
  Write-Output "VSCode was not found in $env:APPDATA\Code please verify VSCode is installed"
  Write-Output "If you have VSCode installed in another location please contact danybeam@gmail.com so that the issue can be addressed"
}