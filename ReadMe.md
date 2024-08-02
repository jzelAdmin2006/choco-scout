# ChocoScout

Keep your Chocolatey packages up-to-date as a maintainer who is independent from the software author.
## How to use:

Your packages should be in Git repos and have to contain an "update.ps1" script, e.g. "https://github.com/jzelAdmin2006/icedrive2choco/blob/main/icedrive/update.ps1". The repos can be provided in the schedule.yaml.

``` shell
kubectl create secret generic choco-update-secrets \
  --from-literal=PAT=your_github_pat \
  --from-literal=CHOCO_API_KEY=your_choco_api_key
kubectl apply -f schedule.yaml
```

