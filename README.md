# Dotfiles

Managing dotfiles via git worktree shenanigans. Credits to
<https://www.atlassian.com/git/tutorials/dotfiles>.

```bash
alias cfg='git --git-dir="$HOME/cfg.git/" --work-tree="$HOME"'
```

## Using the dotfiles

```bash
git clone --bare git@github.com:bluebrown/cfg.git 
cfg checkout
```

## Creating your own

```bash
git init --bare ~/cfg
cfg remote add origin git@github.com:<your-user>/cfg.git
cfg add .myconfig
cfg commit -s
cfg push -u origin main
```
