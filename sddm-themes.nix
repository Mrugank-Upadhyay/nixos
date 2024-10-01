{ stdenv, fetchFromGitHub }:

{
  sddm-astronaut-theme = stdenv.mkDerivation rec {
    pname = "sddm-astronaut-theme";
    version = "";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sddm-astronaut-theme
    '';
    src = fetchFromGitHub {
      owner = "Mrugank-Upadhyay";
      repo = "sddm-astronaut-theme";
      rev = "28c8e73a71ea79367397453c5feaaf04db3e6950";
      sha256 = "oPFQ2c+N4yDGZTtAU6azgQK/X83wNw2LPQbSBY+KKYc=";
    };
  };
}
