# New machine setup

```sh
git init --bare "$HOME/.dotfiles"
alias dotfiles="/usr/bin/env git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

dotfiles remote add origin https://github.com/bethebunny/dotfiles
dotfiles fetch
dotfiles checkout origin/master

# most dotfiles now available, not necessarily active
dotfiles co -b master
dotfiles --set-upstream-to=origin/master
```

- Restart shell/vim/whatever to make everything take effect
- Add new dotfiles with `dotfiles add .blah && dotfiles commit -m 'adding .blah' && dotfiles push`
- Sync with `dotfiles pull`
