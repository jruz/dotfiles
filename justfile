stow:
  make stow

zgen-install:
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"


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
  git config --global user.signingkey CECD4EB5EC6AAF54
  git config --global commit.gpgsign true

tmux-plugins:
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  # do ctrl+a I to install the plugins

mac-outdated:
  brew outdated
  mas outdated

mac-update:
  brew update
  brew upgrade
  mas upgrade
