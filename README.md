# Dotfiles

## Using the dotfiles

    git clone --bare git@github.com:bluebrown/dotfiles.git 
    git --git-dir "$HOME/dotfiles.git" --work-tree="$HOME" checkout
    dash -x .config/deps.sh

## Creating your own

    git init --bare ~/cfg.git
    alias cfg='git --git-dir="$HOME/cfg.git/" --work-tree="$HOME"'
    cfg remote add origin git@github.com:<your-user>/cfg.git
    cfg add -f .myconfig
    cfg commit -s
    cfg push -u origin main

## See Also

- <https://www.atlassian.com/git/tutorials/dotfiles>.
