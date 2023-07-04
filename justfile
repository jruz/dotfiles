zgen:
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

asdf-install:
  cat ~/.tool-versions | gawk '{print $1}' | xargs -L 1 asdf plugin-add
  asdf install
  asdf current

# updates all asdf plugins and installs the latest version of each tool
asdf-upgrade:
  asdf update
  asdf plugin-update --all
  cat .tool-versions | gawk '{system("asdf install " $1 " latest")}'
  cat .tool-versions | gawk '{system("asdf global " $1 " latest")}'

git:
  git config --global user.email "javi@jruz.io"
  git config --global user.name "jruz"
  git config --global core.excludesfile ~/dev/dotfiles/.gitignore_global
  git --no-pager config --global -l

vim:
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

tmux:
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  # do ctrl+a I to install the plugins
