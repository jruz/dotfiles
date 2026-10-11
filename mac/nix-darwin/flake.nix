{
  description = "Darwin setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nix-darwin,
      ...
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          environment = {
            systemPackages = [ ];
            variables = {
              XDG_CONFIG_HOME = "$HOME/.config";
            };
            shells = [ pkgs.nushell ];
          };

          system = {
            primaryUser = "jruz";
            configurationRevision = self.rev or self.dirtyRev or null;
            stateVersion = 4;
            defaults = {
              dock = {
                show-recents = false;
                wvous-tl-corner = 2; # Mission Control
                wvous-tr-corner = 3; # Application Windows
                wvous-bl-corner = 13; # Lock Screen
                persistent-apps = [
                  "/Applications/Safari.app"
                  "/Applications/Firefox.app"
                  "/Applications/Brave Browser.app"
                  "/Applications/Google Chrome.app"
                  "/Applications/Alacritty.app"
                  "/Applications/Ghostty.app"
                  "/Applications/Zed.app"
                  "/Applications/Xcode.app"
                  "/Applications/OrbStack.app"
                  "/Users/jruz/Applications/IB Gateway 10.48/IB Gateway 10.48.app"
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
              NSGlobalDomain = {
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
              finder = {
                AppleShowAllExtensions = true;
                AppleShowAllFiles = true;
                ShowPathbar = true;
                ShowStatusBar = true;
                FXDefaultSearchScope = "SCcf"; # Search current folder
                FXPreferredViewStyle = "Nlsv"; # List view
                _FXSortFoldersFirst = true; # Sort folders first
              };
              loginwindow = {
                GuestEnabled = false;
                DisableConsoleAccess = true;
              };
              screensaver = {
                askForPassword = true;
              };
            };
          };

          homebrew = {
            enable = true;
          };

          services.openssh = {
            enable = true;
            extraConfig = ''
              PubkeyAuthentication yes
              AuthenticationMethods publickey
              PasswordAuthentication no
              KbdInteractiveAuthentication no
            '';
          };

          security.pam.services.sudo_local.touchIdAuth = true;

          nix = {
            settings = {
              experimental-features = "nix-command flakes";
              substituters = [
                "https://cache.nixos.org/"
                "https://nix-community.cachix.org"
              ];
              trusted-public-keys = [
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              ];
            };
          };

          programs.zsh.enable = true;

          users.users.jruz = {
            shell = pkgs.nushell;
          };

          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#macbook
      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.macbook.pkgs;
    };
}
