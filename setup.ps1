<#
    Windows setup script - PowerShell equivalent of setup.sh.
    Uses scoop as the package manager (matches what's already used on this
    machine for fzf/zoxide/bat/rg). tmux is intentionally skipped - it's a
    Linux-only tool in setup.sh.
#>

$ErrorActionPreference = 'Stop'
$scriptDir = $PSScriptRoot

function Install-ScoopApp {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$CheckCommand
    )
    if (Get-Command $CheckCommand -ErrorAction SilentlyContinue) {
        Write-Host "$CheckCommand already installed, skipping"
        return
    }
    scoop install $Name
}

function Get-NvimVersion {
    if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) { return $null }
    $line = nvim --version | Select-Object -First 1
    if ($line -match 'v(\d+)\.(\d+)\.(\d+)') {
        return [version]"$($Matches[1]).$($Matches[2]).$($Matches[3])"
    }
    return $null
}

Write-Host "Checking for scoop"
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing scoop"
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

Write-Host "Installing fzf"
Install-ScoopApp -Name fzf -CheckCommand fzf

Write-Host "Installing exports"
Copy-Item "$scriptDir\user_exports" "$HOME\.user_exports" -Force
[Environment]::SetEnvironmentVariable("EDITOR", "nvim", "User")
$env:EDITOR = "nvim"

Write-Host "Installing zoxide"
Install-ScoopApp -Name zoxide -CheckCommand zoxide

Write-Host "Removing neovim configs"
$nvimConfig = "$env:LOCALAPPDATA\nvim"
$nvimData = "$env:LOCALAPPDATA\nvim-data"
if (Test-Path $nvimConfig) { Remove-Item -Recurse -Force $nvimConfig }
if (Test-Path $nvimData) { Remove-Item -Recurse -Force $nvimData }
Copy-Item -Recurse "$scriptDir\nvim" $nvimConfig

Write-Host "Installing vimrc"
Copy-Item "$scriptDir\.vimrc" "$HOME\.vimrc" -Force

Write-Host "Installing yazi"
Install-ScoopApp -Name yazi -CheckCommand yazi

$yaziConfig = "$env:APPDATA\yazi\config"
New-Item -ItemType Directory -Force -Path $yaziConfig | Out-Null
if (-not (Test-Path "$yaziConfig\flavors")) {
    git clone https://github.com/yazi-rs/flavors.git "$yaziConfig\flavors"
}
Copy-Item "$scriptDir\theme.toml" "$yaziConfig\" -Force

Write-Host "Installing rustup"
Install-ScoopApp -Name rustup -CheckCommand rustup
if (Get-Command rustup -ErrorAction SilentlyContinue) {
    rustup update
    # used by the neovim lang.rust extra (rustaceanvim)
    rustup component add rust-analyzer
}

Write-Host "Installing atuin"
Install-ScoopApp -Name atuin -CheckCommand atuin

Write-Host "Installing PSFzf (fzf keybindings for PowerShell)"
if (-not (Get-Module -ListAvailable -Name PSFzf)) {
    Install-Module -Name PSFzf -Scope CurrentUser -Force
}

Write-Host "Installing aliases / profile"
Copy-Item "$scriptDir\profile.ps1" "$HOME\.dotfiles_profile.ps1" -Force
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Force -Path $PROFILE | Out-Null
}
$sourceLine = '. "$HOME\.dotfiles_profile.ps1"'
$profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if ($null -eq $profileContent -or -not $profileContent.Contains($sourceLine)) {
    Add-Content -Path $PROFILE -Value $sourceLine
}

Write-Host "Installing neovim"
# LazyVim and the lang.rust extra require neovim >= 0.12
$minNvim = [version]'0.12.0'
$nvimVersion = Get-NvimVersion
if ($null -eq $nvimVersion) {
    scoop install neovim
} elseif ($nvimVersion -lt $minNvim) {
    Write-Host "neovim $nvimVersion is older than $minNvim, updating"
    scoop update neovim
} else {
    Write-Host "neovim $nvimVersion already installed, skipping"
}

# pick up the scoop shims if neovim was just installed in this session
$env:PATH = [Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [Environment]::GetEnvironmentVariable("PATH", "User")
$nvimVersion = Get-NvimVersion
if ($null -eq $nvimVersion -or $nvimVersion -lt $minNvim) {
    throw "Failed to install neovim >= $minNvim (found: $nvimVersion)"
}

Write-Host "Make sure to update neovim plugins with Lazy and install LSP from Mason"

Write-Host "Installing Claude Code settings"
$claudeHome = "$HOME\.claude"
if (Test-Path $claudeHome) {
    Remove-Item -Recurse -Force $claudeHome
}
New-Item -ItemType Directory -Force -Path $claudeHome | Out-Null
Copy-Item "$scriptDir\claude\*" $claudeHome -Force

$settingsPath = "$claudeHome\settings.json"
$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
$settings.statusLine.command = "powershell -NoProfile -ExecutionPolicy Bypass -File `"$claudeHome\statusline-command.ps1`""
$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath

Write-Host "Installing rtk"
Install-ScoopApp -Name rtk -CheckCommand rtk
rtk init -g
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Failed to initialize rtk"
}
