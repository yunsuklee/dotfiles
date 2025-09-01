#######################################################
# MODERN TOOL REPLACEMENTS
#######################################################

function find { fd @args }
function grep { rg @args }

#######################################################
# NATIVE POWERSHELL SOLUTIONS
#######################################################

Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
function ls { Get-ChildItem -Force @args }
function ll { Get-ChildItem -Force @args | Format-Table Mode, LastWriteTime, Length, Name -AutoSize }
function cat { Get-Content @args }
function rmd {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$Path
    )

    if (-Not (Test-Path $Path)) {
        Write-Warning "Path '$Path' does not exist."
        return
    }

    if (-Not (Get-Item $Path).PSIsContainer) {
        Write-Warning "'$Path' is not a directory."
        return
    }

    try {
        Remove-Item -Path $Path -Recurse -Force -Confirm:$false -ErrorAction Stop
        Write-Host "Directory '$Path' removed successfully." -ForegroundColor Green
    } catch {
        Write-Error "Failed to remove '$Path': $_"
    }
}
Remove-Item Alias:pwd -Force -ErrorAction SilentlyContinue
function pwd { (Get-Location).Path }

#######################################################
# ZOXIDE INITIALIZATION
#######################################################

Invoke-Expression (& { (zoxide init powershell | Out-String) })

#######################################################
# LAZY POSH-GIT SETUP
#######################################################

# Global variable to track if posh-git is loaded
$global:PoshGitLoaded = $false

# Function to load posh-git when needed
function Enable-PoshGit {
    if (-not $global:PoshGitLoaded) {
        Import-Module posh-git

        # Configure posh-git settings AFTER importing
        $GitPromptSettings.EnablePromptStatus = $true
        $GitPromptSettings.EnableFileStatus = $false
        $GitPromptSettings.ShowStatusWhenZero = $false
        $GitPromptSettings.AutoRefreshIndex = $false
        $GitPromptSettings.EnableStashStatus = $false

        $global:PoshGitLoaded = $true
    }
}
Set-Alias gitenv Enable-PoshGit

#######################################################
# NAVIGATION WITH AUTO-LS AND GIT DETECTION
#######################################################

# Override zoxide's cd to add auto-ls and git detection
function cd {
    __zoxide_z @args
    if ($?) {
        # Load posh-git if we're in a git repo
        if (Test-Path .git -PathType Container) {
            Enable-PoshGit
        }
        ls
    }
}

#######################################################
# SHORTCUTS
#######################################################

# Navigation
function .. {
    Set-Location ..
    # Track with zoxide
    if (Get-Command __zoxide_hook -ErrorAction SilentlyContinue) {
        __zoxide_hook
    }
}
function ... {
    Set-Location ../..
    # Track with zoxide
    if (Get-Command __zoxide_hook -ErrorAction SilentlyContinue) {
        __zoxide_hook
    }
}

# Go back to previous directory
function back { Set-Location - }

# Editor
Set-Alias vi nvim -Force
Set-Alias vim nvim -Force
$env:EDITOR = "nvim"

# mkdir with parents
function mkdir { New-Item -ItemType Directory -Force @args }

# Touch command
function touch {
    param([string[]]$Paths)
    foreach ($Path in $Paths) {
        if (Test-Path $Path) {
            (Get-Item $Path).LastWriteTime = Get-Date
        } else {
            New-Item -ItemType File -Path $Path -Force | Out-Null
        }
    }
}

#######################################################
# PROMPT FUNCTION
#######################################################

# Pure-style prompt function
function prompt {
    Write-Host ""  # Blank line before prompt

    $currentPath = (Get-Location).Path.Replace($HOME, "~")
    Write-Host $currentPath -ForegroundColor Cyan -NoNewline

    # Check if we're in a git repo and load posh-git if needed
    if (Test-Path .git -PathType Container) {
        Enable-PoshGit

        $gitStatus = Get-GitStatus
        if ($gitStatus) {
            $gitInfo = " $($gitStatus.Branch)"
            if ($gitStatus.HasUntracked) { $gitInfo += "*" }
            if ($gitStatus.HasWorking) { $gitInfo += "!" }
            if ($gitStatus.AheadBy -gt 0) { $gitInfo += " ⇡" }
            if ($gitStatus.BehindBy -gt 0) { $gitInfo += " ⇣" }

            Write-Host $gitInfo -ForegroundColor Yellow
        } else {
            Write-Host ""
        }
    } else {
        Write-Host ""
    }

    return "❯ "
}

#######################################################
# CHOCOLATEY SUPPORT
#######################################################

function refreshenv {
    if (-not (Get-Module chocolateyProfile)) {
        Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
    }
    refreshenv
}

#######################################################
# VISUAL STUDIO ENVIRONMENT
#######################################################

function Enable-MSVC {
    $vsPath = "${env:ProgramFiles}\Microsoft Visual Studio\2022"
    $editions = @("Enterprise", "Professional", "Community")

    foreach ($edition in $editions) {
        $vcvarsPath = "$vsPath\$edition\VC\Auxiliary\Build\vcvars64.bat"
        if (Test-Path $vcvarsPath) {
            cmd /c "`"$vcvarsPath`" > nul 2>&1 && set" | ForEach-Object {
                if ($_ -match '^([^=]+)=(.*)$') {
                    [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2], 'Process')
                }
            }
            Write-Host "MSVC environment loaded" -ForegroundColor Green
            return
        }
    }
    Write-Host "Visual Studio 2022 not found" -ForegroundColor Red
}
Set-Alias vsenv Enable-MSVC

#######################################################
# INITIALIZATION COMPLETE
#######################################################

