{
  description = "Darwin setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
    let
      configuration = { pkgs, ... }: {
        environment.systemPackages = [ ];

        homebrew = {
          enable = true;
          brews = [
            "mas"
            "stow"
            "docker"
          ];
          casks = [
            "1Password"
            "alacritty"
            "copilot-for-xcode"
            "discord"
            "firefox"
            "firefox@developer-edition"
            "google-chrome"
            "ghostty"
            "istat-menus"
            "karabiner-elements"
            "lulu"
            "megasync"
            "native-access"
            "obsidian"
            "pgadmin4"
            "signal"
            "spotify"
            "swiftformat-for-xcode"
            "telegram"
            "the-unarchiver"
            "transmission"
            "wacom-tablet"
            "zed"
            "zen-browser"
          ];
          masApps = {
            "1Blocker" = 1365531024;
            "1Password for Safari" = 1569813296;
            "Mega VPN" = 6456784858;
            "Moom" = 419330170;
            "OneTab" = 1540160809;
            "SimplyJSON for Safari" = 1495193038;
            "Userscripts-Mac-App" = 1463298887;
            "Vimkey" = 1585682577;
            # "Xcode" = 497799835;
          };
        };

        system.defaults.dock = {
          show-recents = false;
          persistent-apps = [
            "/System/Applications/Launchpad.app"
            "/Applications/Safari.app"
            "/Applications/Zen Browser.app"
            "/Applications/Firefox Developer Edition.app"
            "/Applications/Google Chrome.app"
            "/Applications/Alacritty.app"
            "/Applications/Ghostty.app"
            "/Applications/kitty.app"
            "/Applications/Zed.app"
            "/Applications/Xcode.app"
            "/Applications/Visual Studio Code.app"
            "/Applications/pgAdmin 4.app"
            "/Applications/Docker.app"
            "/Users/jruz/Applications/IBKR Desktop/IBKR Desktop.app"
            "/Applications/VMware Fusion.app"
            "/Applications/Signal.app"
            "/Applications/Telegram.app"
            "/Applications/Discord.app"
            "/Applications/Insta360 Studio.app"
            "/Applications/DaVinci Resolve/DaVinci Resolve.app"
            "/Applications/Spotify.app"
            "/System/Applications/Music.app"
            "/Applications/Obsidian.app"
            "/System/Applications/Notes.app"
            "/System/Applications/Reminders.app"
            "/System/Applications/Calendar.app"
            "/Applications/Transmission.app"
            "/Applications/MEGAVPN.app"
            "/System/Applications/Calculator.app"
            "/System/Applications/Home.app"
            "/Applications/1Password.app"
            "/System/Applications/App Store.app"
            "/System/Applications/System Settings.app"
          ];
        };

        system.defaults.NSGlobalDomain = {
          AppleInterfaceStyle = "Dark";
          AppleInterfaceStyleSwitchesAutomatically = false;
          AppleMeasurementUnits = "Centimeters";
          AppleTemperatureUnit = "Celsius";
          AppleMetricUnits = 1;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticInlinePredictionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          "com.apple.mouse.tapBehavior" = null;
          "com.apple.swipescrolldirection" = null;
        };

        system.defaults.finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          ShowPathbar = true;
          ShowStatusBar = true;
          FXDefaultSearchScope = "SCcf"; # Search current folder
          FXPreferredViewStyle = "Nlsv"; # List view
          _FXSortFoldersFirst = true; # Sort folders first
        };

        system.defaults.loginwindow = {
          GuestEnabled = false;
          DisableConsoleAccess = true;
        };

        system.defaults.screensaver = {
          askForPassword = true;
        };

        system.defaults.dock = {
          wvous-tl-corner = 2; # Mission Control
          wvous-tr-corner = 3; # Application Windows
          wvous-bl-corner = 13; # Lock Screen
        };

        security.pam.enableSudoTouchIdAuth = true;

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true; # default shell on catalina
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#00000
      darwinConfigurations."00000" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."00000".pkgs;
    };
}
