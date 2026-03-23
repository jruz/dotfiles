{
  description = "Darwin setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
    let
      configuration = { pkgs, ... }: {
        environment.systemPackages = [ ];

        environment.variables = {
          XDG_CONFIG_HOME = "$HOME/.config";
        };

        system.primaryUser = "jruz";

        homebrew = {
          enable = true;
        };

        system.defaults.dock = {
          show-recents = false;
          wvous-tl-corner = 2; # Mission Control
          wvous-tr-corner = 3; # Application Windows
          wvous-bl-corner = 13; # Lock Screen
          persistent-apps = [
            "/Applications/Safari.app"
            "/Applications/Firefox.app"
            "/Applications/Google Chrome.app"
            "/Applications/Alacritty.app"
            "/Applications/Ghostty.app"
            "/Applications/Zed.app"
            "/Applications/Xcode.app"
            "/Applications/OrbStack.app"
            "/Users/jruz/Applications/IB Gateway 10.30/IB Gateway 10.30.app"
            "/Users/jruz/Applications/Trader Workstation/Trader Workstation.app"
            "/Applications/Signal.app"
            "/Applications/Telegram.app"
            "/Applications/Obsidian.app"
            "/System/Applications/Notes.app"
            "/System/Applications/Reminders.app"
            "/System/Applications/Calendar.app"
            "/Applications/Transmission.app"
            "/Applications/MEGAVPN.app"
            "/Applications/NextDNS.app"
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

        security.pam.services.sudo_local.touchIdAuth = true;

        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";
        nix.settings.substituters = [
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
        ];
        nix.settings.trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        programs.zsh.enable = true;

        environment.shells = [ pkgs.nushell ];

        users.users.jruz = {
          shell = pkgs.nushell;
        };

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
