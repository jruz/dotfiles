{ config, pkgs, ... }:

{
  home.username = "jruz";
  home.homeDirectory = "/home/jruz";

  home.stateVersion = "22.11";

  home.packages = [
    pkgs.asdf
    pkgs.asdf
    pkgs.bat
    pkgs.curl
    pkgs.fd
    pkgs.fontconfig
    pkgs.fzf
    pkgs.gawk
    pkgs.git
    pkgs.jq
    pkgs.just
    pkgs.lsd
    pkgs.neovim
    pkgs.procs
    pkgs.ripgrep
    pkgs.rlwrap
    pkgs.tmux
    pkgs.tmuxinator
    pkgs.unzip
    pkgs.wget
    pkgs.xclip
    pkgs.zplug
    pkgs.zsh
    (pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
  ];

  home.file = {
    ".config/alacritty".source = ~/dev/dotfiles/.config/alacritty;
    ".config/nix/nix.conf".source = ~/dev/dotfiles/.config/nix/nix.conf;
    ".config/nvim".source = ~/dev/dotfiles/.config/nvim;
    ".gitconfig".source = ~/dev/dotfiles/.gitconfig;
    ".gitignore_global".source = ~/dev/dotfiles/.gitignore_global;
    ".tmux.conf".source = ~/dev/dotfiles/.tmux.conf;
    ".tool-versions".source = ~/dev/dotfiles/.tool-versions;
    ".vimrc".source = ~/dev/dotfiles/.vimrc;
    ".zshrc".source = ~/dev/dotfiles/.zshrc;
  };

  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;
}
