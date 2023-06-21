{ config, pkgs, ... }:

{
  home.username = "jruz";

  # Linux path
  # home.homeDirectory = "/home/jruz";
  # MacOS path
  # home.homeDirectory = "/Users/jruz";

  home.homeDirectory = if pkgs.system == "x86_64-darwin" then "/Users/jruz" else "/home/jruz";

  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    asdf
    asdf
    bat
    curl
    fd
    fontconfig
    frawk
    fzf
    gawk
    git
    gnupg
    jq
    just
    lsd
    procs
    ripgrep
    rlwrap
    tmux
    tmuxinator
    unzip
    vim
    wget
    xclip
    zplug
    zsh
    (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
    stylua
    nixfmt
    zip
    awscli2
    terraform
    tree-sitter
    stow
  ];

  home.file = {
    #".config/alacritty/alacritty.yml".source = ~/dev/dotfiles/.config/alacritty/alacritty.yml;
    #".config/kitty/kitty.conf".source = ~/dev/dotfiles/.config/kitty/kitty.conf;
    #".config/nix/nix.conf".source = ~/dev/dotfiles/.config/nix/nix.conf;
    #".config/nvim".source = ~/dev/dotfiles/.config/nvim;
    #".gitconfig".source = ~/dev/dotfiles/.gitconfig;
    #".gitignore_global".source = ~/dev/dotfiles/.gitignore_global;
    #".tmux.conf".source = ~/dev/dotfiles/.tmux.conf;
    #".tool-versions".source = ~/dev/dotfiles/.tool-versions;
    #".zshrc".source = ~/dev/dotfiles/.zshrc;
    #"Brewfile".source = ~/dev/dotfiles/Brewfile;
    #"Brewfile.lock.json".source = ~/dev/dotfiles/Brewfile.lock.json;
  };

  programs.neovim = {
    enable = true;
    withNodeJs = true;
  };
}
