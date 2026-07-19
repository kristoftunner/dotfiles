$ErrorActionPreference = 'SilentlyContinue'

$inputJson = [Console]::In.ReadToEnd()
$data = $inputJson | ConvertFrom-Json

$cwd = $data.workspace.current_dir
if (-not $cwd) { $cwd = $data.cwd }
if (-not $cwd) { $cwd = "" }

$ctxSize = $data.context_window.context_window_size
$tokensUsed = $data.context_window.total_input_tokens

if ($ctxSize) {
    $ctxLabel = "{0:N0}k" -f ([double]$ctxSize / 1000)
} else {
    $ctxLabel = "?k"
}

if ($null -ne $tokensUsed) {
    $usedLabel = "$tokensUsed"
} else {
    $usedLabel = "?"
}

$esc = [char]27
Write-Output "$esc[01;34m$cwd$esc[00m $esc[0;33mctx:$ctxLabel$esc[00m $esc[0;36mused:$usedLabel$esc[00m"
