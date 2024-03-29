# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../shared.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "mrugankDesktop"; # Define your hostname.
  networking.interfaces.enp42s0.wakeOnLan = {
    enable = true;
  };

  # Kernel
  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
  boot.kernelModules = ["i2c-dev" "ddcci_backlight"];
  services.udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';

  # Monitors listing
  services.xserver.xrandrHeads = [
    "DP-2"
    "HDMI-A-1"
  ];

  # Enable AMDVLK
  hardware.amdgpu.amdvlk = true;

  # Enable Openrazer
  hardware.openrazer.enable = true;
  
  # services.hardware.openrgb = {
  #   enable = true;
  #   motherboard = "amd";
  # };

  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };

  services.pipewire.lowLatency.enable = true;
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    r2modman
    openrazer-daemon
  ];
}
