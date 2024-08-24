$env:Path += ";C:\Users\{USER}\AppData\Local\Programs\oh-my-posh\bin"
oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config ~/omp.json | Invoke-Expression
