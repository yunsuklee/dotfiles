#######################################################
# MODERN TOOL REPLACEMENTS
#######################################################

if (Get-Command fd -ErrorAction SilentlyContinue) {
    function find { fd @args }
}

if (Get-Command rg -ErrorAction SilentlyContinue) {
    function grep { rg @args }
}

#######################################################
# NATIVE POWERSHELL SOLUTIONS
#######################################################

Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
function ls { Get-ChildItem -Force @args }
function ll { Get-ChildItem -Force @args | Format-Table Mode, LastWriteTime, Length, Name -AutoSize }

function cat { Get-Content @args }

#######################################################
# NAVIGATION WITH AUTO-LS
#######################################################

function Set-LocationWithList {
    param([string]$Path = "~")
    Set-Location $Path
    ls
}

Remove-Item Alias:cd -Force -ErrorAction SilentlyContinue
Set-Alias cd Set-LocationWithList

#######################################################
# SHORTCUTS
#######################################################

# Navigation
function .. { Set-Location .. }
function ... { Set-Location ../.. }

# Editor
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Set-Alias vi nvim -Force
    Set-Alias vim nvim -Force
}

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
# INITIALIZATION
#######################################################

# Set environment
$env:EDITOR = "nvim"

# Only initialize zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })

    function z {
        & (Get-Command __zoxide_z -CommandType Function) @args
        if ($?) { ls }
    }
}

# Initialize starship
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (starship init powershell | Out-String) })
}

# Add to your profile for permanent chocolatey support
if (Test-Path $env:ChocolateyInstall\helpers\chocolateyProfile.psm1) {
    Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
}

function Enable-MSVC {
    # Load VS 2022 environment without starting dev shell
    $vsPath = "${env:ProgramFiles}\Microsoft Visual Studio\2022"
    $editions = @("Enterprise", "Professional", "Community")

    foreach ($edition in $editions) {
        $vcvarsPath = "$vsPath\$edition\VC\Auxiliary\Build\vcvars64.bat"
        if (Test-Path $vcvarsPath) {
            # Import VS environment variables
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
