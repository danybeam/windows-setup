# PRIVATE
## Get uproject file on a directory
def get-uproject [] {
    let files = ls | where name ends-with '.uproject' | first
    if ($files == null) { return null }
    return ($files | get name)
}

# PUBLIC
## Fix unreal config file for this project
export def fix-unreal-project [] {
    let file = get-uproject
    if ($file == null) { return "Unreal project not found" }

    let engine = $file | open | from json | get EngineAssociation

    if ($engine != "5.7" and $engine != "5.8") { 
        return $"Engine version (($engine)) not supported"
    }

    let goodConfig = $"C:/Program Files/Epic Games/UE_($engine)/Templates/TP_BaseTemplateBP/Config/DefaultEngine.ini"
    let badConfig = ([$env.pwd,"/Config/DefaultEngine.ini"] | str join "")

    cp $goodConfig $badConfig

    return $"Copied config from\n($goodConfig) to\n($badConfig)"
}

## Utility to build an unreal engine project for multiple versions of the engine
export def build-plugin [
    engine_version: string,             # e.g. 5.0
    plugin_name: string,                # e.g. MyPlugin
    --plugin: string,                   # Optional plugin path
    --package: string                   # Optional package path
] {
    let engine_path = $"C:/Program Files/Epic Games/UE_($engine_version)"
    let plugin_path = ($plugin | default $"./Plugins/($plugin_name)") | path join $"($plugin_name).uplugin" | path expand
    let package_path = $package | default $"D:/Builds/($plugin_name)_($engine_version)" | path expand
    
    ^$"($engine_path)/Engine/Build/BatchFiles/RunUAT.bat" BuildPlugin $"-Plugin=($plugin_path)" $"-Package=($package_path)" -TargetPlatforms=Win64 -Rocket -NoDeleteHostProject
}
