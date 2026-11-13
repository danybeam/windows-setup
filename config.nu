# config.nu
#
# Installed by:
# version = "0.108.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# CONFIG
## nushell
$env.config.show_banner = false
## Editor
$env.config.buffer_editor = 'code'

const NU_LIB_DIRS = $NU_LIB_DIRS ++ [
    'C:\Users\Daniel\AppData\Roaming\nushell\modules'
]

## Zoxide
zoxide init nushell | save -f ~/.nu/.zoxide.nu
source ~/.nu/.zoxide.nu
alias cd = z

## JJ
jj util completion nushell | save -f ~/.nu/.completions-jj.nu
source ~/.nu/.completions-jj.nu

# HELPER FUNCTIONS
## Sort youtube playlist
def sort-youtube-ids-by-duration [
    input_file: path,
    output_file?: path
] {
    let ids = open $input_file
    let total = ($ids | length)

    let sorted = (
        | $ids
        | enumerate
        | each {|id|
            let current = ($id.index + 1)
            let percent = (($current * 100) / $total | math round)
            let bar = (
                (0..<$percent | each { "#" } | str join)
                +
                (0..<(100 - $percent) | each { "-" } | str join)
            )

            print $"[($bar)] ($percent)% - ($id.item)"

            {
                id: $id
                duration: (
                    do -i {
                        sleep 1sec
                        yt-dlp --cookies Z:\Videos\yt-cookies.txt --dump-single-json $"https://youtube.com/watch?v=($id.item)"
                        | from json
                        | get duration
                    }
                )
            }
        }
        | sort-by duration
        | get id
    )

    let output = ($output_file | default $input_file)

    $sorted
    | get item
    | to json --indent 2
    | save --force $output
}

## helper to get git branch safely
def get-git-branch [] {
    do -i {
        git rev-parse --abbrev-ref HEAD e> nul | str trim
    }
}

## helper to get JJ revision safely
def get-jj-rev [] {
    do -i {
        jj show -T 'change_id' @ e> nul | str trim | str substring 0..4
    }
}

## helper to get dir segment
def get-dir-segment [] {
    let homeDir = "[TODO: REPLACE ME]"
    let NASBaseDir = "[TODO: REPLACE ME]"
    let ArchiveBaseDir = "[TODO: REPLACE ME]"
    let DDriveBase = "D:\\"
    let SrcBase = "D:\\src"
    let MdlBase = "D:\\mdl"
    let onedriveBase = "D:\\OneDrive"
    let cachedPWD = (pwd)

    mut cwd = (pwd)
   
    # If we're under the home dir
    if ($cachedPWD | str starts-with -i $homeDir) {
        $cwd = "󱂵"
        
        if (($cachedPWD | str length) > ($homeDir | str length)) {
            $cwd = [$cwd,"❯"] | str join " "
            $cwd = [$cwd,($cachedPWD | path basename | str trim)] | str join
        }
    }

    # If we're under the NAS
    if ($cachedPWD | str starts-with -i $NASBaseDir) {
        $cwd = "󰒋"
        
        if (($cachedPWD | str length) > ($NASBaseDir | str length)) {
            $cwd = [$cwd,"❯"] | str join " "
            $cwd = [$cwd,($cachedPWD | path basename | str trim)] | str join
        }
    }

    # If we're under the NAS Archive folder specificially
    if ($cachedPWD | str starts-with -i $ArchiveBaseDir) {
        $cwd = ""
        
        if (($cachedPWD | str length) > ($ArchiveBaseDir | str length)) {
            $cwd = [$cwd,"❯"] | str join " "
            $cwd = [$cwd,($cachedPWD | path basename | str trim)] | str join
        }
    }

    # If we're under the D: drive
    if ($cachedPWD | str starts-with -i $DDriveBase) {
        $cwd = "󰂻"
        
        if (($cachedPWD | str length) > ($DDriveBase | str length)) {
            $cwd = [$cwd,"❯"] | str join " "
            $cwd = [$cwd,($cachedPWD | path basename | str trim)] | str join
        }
    }

    # If we're under onedrive
    if ($cachedPWD | str starts-with -i $onedriveBase) {
        $cwd = "󰏊"
        
        if (($cachedPWD | str length) > ($onedriveBase | str length)) {
            $cwd = [$cwd,"❯"] | str join " "
            $cwd = [$cwd,($cachedPWD | path basename | str trim)] | str join
        }
    }

    # If we're under src folder
    if ($cachedPWD | str starts-with -i $SrcBase) {
        $cwd = ""
        
        if (($cachedPWD | str length) > ($SrcBase | str length)) {
            $cwd = [$cwd,"❯"] | str join " "
            $cwd = [$cwd,($cachedPWD | path basename | str trim)] | str join
        }
    }

    # If we're under mdl folder
    if ($cachedPWD | str starts-with -i $MdlBase) {
        $cwd = "󰇥"
        
        if (($cachedPWD | str length) > ($MdlBase | str length)) {
            $cwd = [$cwd,"❯"] | str join " "
            $cwd = [$cwd,($cachedPWD | path basename | str trim)] | str join
        }
    }

    $"(ansi -e {bg: '#3b82f6', fg: 'white'}) ($cwd) (ansi reset)"
}

## helper to get overlay segment
def get-overlay-segment [] {
    let current_segment = (overlay list | where active | last | get name)
    if ($current_segment == "zero") {
        ""
    } else {
        $"(ansi -e {bg: '#d8d513', fg: 'black'}) ($current_segment) (ansi reset)"
    }
}


# PROMPT
## left prompt
$env.PROMPT_COMMAND = {||
    let branch = (get-git-branch)
    let jjRev = (get-jj-rev)

    let dir_segment = (get-dir-segment)

    let overlay_segment = (get-overlay-segment)
    
    let jj_segment = if ($jjRev | is-empty) {
        ""
    } else {
        $"(ansi -e {bg: '#c121d6', fg: 'black'})  ($jjRev) (ansi reset)"
    }

    let git_segment = if ($branch | is-empty) {
        ""
    } else if ($jjRev | is-not-empty) {
        $"(ansi -e {bg: '#16a34a', fg: 'black'})  (ansi reset)"
    } else {
        $"(ansi -e {bg: '#16a34a', fg: 'black'})  ($branch) (ansi reset)"
    }

    $"($dir_segment)($overlay_segment)($jj_segment)($git_segment) "
}

## right prompt (optional info on the right side)
$env.PROMPT_COMMAND_RIGHT = {||
    let last_exit = $env.LAST_EXIT_CODE

    if $last_exit != 0 {
        $"(ansi -e {fg: 'white', bg: '#dc2626'}) ✖ ($last_exit) (ansi reset)"
    } else {
        $"(ansi -e {fg: 'white', bg: '#3bdc26'}) ✔️ ($last_exit) (ansi reset)"
    }
}

## prompt indicator (arrow)
$env.PROMPT_INDICATOR = {||
    $"(ansi -e {fg: '#9ca3af'})❯ (ansi reset)"
}

# FAST FETCH
## Run fastfetch on start
fastfetch

# Initialize fnm for this shell.
^fnm env --use-on-cd --version-file-strategy=recursive --json | from json | load-env

# On Windows, Node lives directly in the multishell directory.
$env.PATH = ($env.PATH | prepend $env.FNM_MULTISHELL_PATH)
$env.Path = ($env.Path | split row (char esep) | prepend ($env.USERPROFILE | path join ".local" "bin"))
