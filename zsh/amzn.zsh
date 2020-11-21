EDA_AUTO=$(mktemp -d)
eda completions zsh > $EDA_AUTO/_eda
fpath=($EDA_AUTO $fpath)
