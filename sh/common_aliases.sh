# my aliasies
# alias ctags="`brew --prefix`/bin/ctags"
alias tmux-reload='tmux source-file ~/.tmux.conf'
alias tmux="env TERM=xterm-256color tmux"                                       # to support true color in vim in tmux.
# cat with syntax highlighting
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/history/history.plugin.zsh 
alias h='history 0'
alias hs='history 0 | grep'
alias hsi='history 0 | grep -i'
# tmux aliases
alias ta='tmux attach || tmux new'
