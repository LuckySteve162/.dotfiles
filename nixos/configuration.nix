# Confix for base Nix

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # System identity
  networking.hostName = "nixos";
  time.timeZone = "America/Chicago";

  # Networking
  networking = {
    interfaces.enp5s0 = {
      ipv4.addresses = [{
        address = "172.16.122.14";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "172.16.122.1";
      interface = "enp5s0";
    };
    firewall = {
      allowedTCPPorts = [ 
        47984 47989 47990 48010 # For Sunshine RDP
        ];
      allowedUDPPorts = [ 
        47998 47999 48000 48010 # For Sunshine RDP
        ];
    };
    # DNS Management
    nameservers = [ "1.1.1.1" ];
  };


  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # OpenSSH daemon
  services.openssh.enable = true;

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # User with sudo access
  users.users.luckysteve = {
    isNormalUser = true;
    extraGroups = [ 
    "wheel" # For sudo
    "video" "render" "input" "audio" # For sunshine RDP
    ]; 
    packages = with pkgs; [  ];
  };

  # Wayland environment
  programs.hyprland.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Core system services
  services.dbus.enable = true;

  # Remote desktop services
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Core environment
    hyprland wofi wezterm tmux ranger

    # UI / UX
    swww waybar mako

    # Clipboard
    cliphist wl-clipboard wtype

    # Audio
    pulsemixer pipewire wireplumber

    # Text Editor
    neovim

    # Power & lock
    batsignal waylock cage swayidle

    # Networking CLI
    iproute2

    # Remote Management
    waypipe sunshine

    # Utilities
    grim slurp btop git stow ffmpeg
  ];

  system.stateVersion = "24.11";
}