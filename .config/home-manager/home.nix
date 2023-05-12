{ config, pkgs, ... }:

{
  home.username = "jruz";

  # Linux path
  # home.homeDirectory = "/home/jruz";
  # MacOS path
  # home.homeDirectory = "/Users/jruz";

  home.homeDirectory = if pkgs.system == "x86_64-darwin" then "/Users/jruz" else "/home/jruz";

  home.stateVersion = "22.11";

  home.packages = [
    pkgs.asdf
    pkgs.asdf
    pkgs.bat
    pkgs.curl
    pkgs.fd
    pkgs.fontconfig
    pkgs.frawk
    pkgs.fzf
    pkgs.gawk
    pkgs.git
    pkgs.gnupg
    pkgs.jq
    pkgs.just
    pkgs.lsd
    pkgs.procs
    pkgs.ripgrep
    pkgs.rlwrap
    pkgs.tmux
    pkgs.tmuxinator
    pkgs.unzip
    pkgs.vim
    pkgs.wget
    pkgs.xclip
    pkgs.zplug
    pkgs.zsh
    (pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
    pkgs.stylua
    pkgs.nixfmt
    pkgs.zip
    pkgs.awscli2
  ];

  home.file = {
    ".config/alacritty/alacritty.yml".source = ~/dev/dotfiles/.config/alacritty/alacritty.yml;
    ".config/kitty/kitty.conf".source = ~/dev/dotfiles/.config/kitty/kitty.conf;
    ".config/nix/nix.conf".source = ~/dev/dotfiles/.config/nix/nix.conf;
    ".config/nvim".source = ~/dev/dotfiles/.config/nvim;
    ".gitconfig".source = ~/dev/dotfiles/.gitconfig;
    ".gitignore_global".source = ~/dev/dotfiles/.gitignore_global;
    ".tmux.conf".source = ~/dev/dotfiles/.tmux.conf;
    ".tool-versions".source = ~/dev/dotfiles/.tool-versions;
    ".zshrc".source = ~/dev/dotfiles/.zshrc;
    "Brewfile".source = ~/dev/dotfiles/Brewfile;
    "Brewfile.lock.json".source = ~/dev/dotfiles/Brewfile.lock.json;
  };

  programs.neovim = {
    enable = true;
    withNodeJs = true;
    plugins = with pkgs.vimPlugins; [
      auto-pairs
      copilot-vim
      fzf-vim
      nerdtree
      vim-airline
      vim-airline-themes
      vim-devicons
      vim-gitgutter
      vim-nix
      vim-over
      vim-polyglot
      vim-sandwich
      nerdcommenter
      vim-surround

      #vim-monokai # theme
      catppuccin-nvim # theme

      # LSP stuff
      fidget-nvim
      mason-lspconfig-nvim
      mason-nvim
      mason-tool-installer-nvim
      neodev-nvim
      #null-ls-nvim
      nvim-dap
      nvim-lspconfig
      nvim-treesitter
      nvim-web-devicons
      trouble-nvim
    ];
  };

  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;
}
