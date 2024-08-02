$PAT = $env:PAT
$CHOCO_API_KEY = $env:CHOCO_API_KEY
$GIT_REPOS = $env:GIT_REPOS

function Run-Command {
    param([string]$cmd)
    Write-Output "Running: $cmd"
    Invoke-Expression $cmd
}

$repos = $GIT_REPOS -split ';'
foreach ($repo in $repos) {
    $repoName = $repo.Split('/')[-1].Replace('.git', '')
    if (-not (Test-Path $repoName)) {
        Run-Command "git clone https://$($PAT)@$repo"
    } else {
        Set-Location $repoName
        Run-Command "git pull"
        Set-Location ..
    }

    $updateScriptPath = Get-ChildItem -Recurse -Filter "update.ps1" -ErrorAction SilentlyContinue
    if ($updateScriptPath) {
        Set-Location $updateScriptPath.Directory
        Run-Command "./update.ps1"
		
		$changes = git status --porcelain
		if ($changes) {
			Run-Command "git add ."
			Run-Command "git commit -m 'Automated update commit'"
			Run-Command "git push origin main"
		}
		
        $nupkgFile = Get-ChildItem -Recurse -Filter "*.nupkg" -ErrorAction SilentlyContinue
        if ($nupkgFile) {
            Run-Command "choco push $nupkgFile --source https://push.chocolatey.org/ --api-key $CHOCO_API_KEY"
        }
        Set-Location ..
    }
}
