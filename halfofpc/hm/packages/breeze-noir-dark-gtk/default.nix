{ lib
, stdenvNoCC
, fetchFromGitHub
, gnome-themes-extra
, gtk-engine-murrine
}:
stdenvNoCC.mkDerivation rec {
  pname = "breeze-noir-dark-gtk-theme";
  version = "nwm";

  src = fetchFromGitHub {
    owner = "L4ki";
    repo = "Breeze-Noir-Dark-GTK";
    rev = "e7c82315744efa4a42e68d465449b4e12558fed6";
    sha256 = "sha256-b5mSv7d1ZQAOt+JLHOjY8AKGlZJtZOI9jn3SsDuzL6c=";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  buildInputs = [
    gnome-themes-extra
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  # meta = with lib; {
  #   description = "A Gtk theme based on the Gruvbox colour pallete";
  #   homepage = "https://www.pling.com/p/1681313/";
  #   license = licenses.gpl3Only;
  #   platforms = platforms.unix;
  #   maintainers = [ maintainers.math-42 ];
  # };
}
