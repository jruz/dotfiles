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
  git --no-pager config --global -l

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
