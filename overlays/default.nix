{ config, pkgs, lib, ... }:


{
  nixpkgs.overlays = [        
    (self: super: {
      sddm-astronaut-theme = super callPackage /home/mrugank/sddm-themes/sddm-themes.nix {};
    })
  ];
}
