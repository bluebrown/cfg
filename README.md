# Dotfiles

## Using the dotfiles

    git clone --bare git@github.com:bluebrown/cfg.git 
    alias cfg='git --git-dir="$HOME/cfg.git/" --work-tree="$HOME"'
    cfg checkout

## Creating your own

    git init --bare ~/cfg
    alias cfg='git --git-dir="$HOME/cfg.git/" --work-tree="$HOME"'
    cfg remote add origin git@github.com:<your-user>/cfg.git
    cfg add -f .myconfig
    cfg commit -s
    cfg push -u origin main

## See Also

- <https://www.atlassian.com/git/tutorials/dotfiles>.
