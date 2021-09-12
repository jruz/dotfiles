install:
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
  echo "source ~/dev/dotfiles/.zshrc" >> ~/.zshrc

asdf:
  git clone --force https://github.com/asdf-vm/asdf.git ~/.asdf
  cat .tool-versions | gawk '{print $1}' | xargs -l asdf plugin-add
  cat .tool-versions | xargs -l asdf install
  asdf current

asdf-upgrade:
  asdf update
  cat .tool-versions | gawk '{system("asdf install " $1 " latest")}'
  cat .tool-versions | gawk '{system("asdf global " $1 " latest")}'

alias:
  -ln -s ~/dev/dotfiles/.tool-versions ~/.tool-versions
  -ln -s ~/dev/dotfiles/.tmux.conf ~/.tmux.conf

git:
  git config --global user.email "javi@jruz.io"
  git config --global user.name "jruz"

