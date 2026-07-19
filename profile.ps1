# zoxide - smarter cd, equivalent of .setup_tooling's zoxide init
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# atuin - shell history, equivalent of .setup_tooling's atuin init
if (Get-Command atuin -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (atuin init powershell --disable-up-arrow | Out-String) })
}

# fzf keybindings, equivalent of .setup_tooling's fzf --bash
if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

function vimf(){
    vim $(fzf)
}
function nvimf(){
    nvim $(fzf)
}
function cdf(){
    $dir = Get-ChildItem -Recurse -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName | fzf
    if ($dir) { Set-Location $dir }
}
function fzkill(){
    $proc = Get-Process | Sort-Object Id | ForEach-Object { "$($_.Id)`t$($_.ProcessName)" } | fzf
    if ($proc) {
        $procId = ($proc -split "`t")[0]
        Stop-Process -Id $procId -Force
    }
}
function gl(){
    git log @args
}
function gs(){
    git status @args
}
function gwl(){
    git worktree list
}
function gfo(){
    git fetch origin
}
