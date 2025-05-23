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
    interfaces.enp61s0f0 = {
      ipv4.addresses = [{
        address = "172.16.124.23";
        prefixLength = 24;
      }];
    };
    firewall = {
      allowedTCPPorts = [ 
        47984 47989 47990 48000 48010 # For Sunshine RDP
        ];
      allowedUDPPorts = [ 
        47998 47999 48000 48010 # For Sunshine RDP
        ];
    };
  };

  networking.wireless.iwd.enable = true;
  networking.interfaces.wlo1.useDHCP = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
  };
  hardware.firmware = with pkgs; [
    sof-firmware
    linux-firmware
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Thunderbolt support
  services.hardware.bolt.enable = true;

  # OpenSSH daemon
  services.openssh.enable = true;

  # Graphics
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.enableAllFirmware = true;
  boot.kernelParams = [
    "i915.force_probe=*"
    "i915.enable_psr=0"
  ];
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
    libva
    libva-utils
  ];
  

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

  # Remote desktop services
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
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

  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Core environment
    hyprland wofi wezterm tmux ranger

    # UI / UX
    swww waybar mako

    # Clipboard
    cliphist wl-clipboard wtype

    # work apps
    bitwarden-desktop nmap 

    # Entertainment
    spotify discord 

    # Audio
    pipewire helvum pulseaudio

    # Text Editor
    neovim

    # Remote Desktop
    moonlight-qt libva-utils

    # setting gui's
    nwg-displays nwg-look

    # Browser
    brave

    # Power & lock
    swaync swaylock cage swayidle

    # Networking CLI
    iproute2

    # Remote Management
    waypipe sunshine

    # Utilities
    grim slurp btop git stow ffmpeg pciutils mesa-demos bottles
  ];

  system.stateVersion = "24.11";
}
