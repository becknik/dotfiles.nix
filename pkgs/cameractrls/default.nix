{ lib
, python3Packages
, SDL2
, libjpeg
, gobject-introspection
, fetchFromGitHub
, wrapGAppsHook
, gtk4
}:

let
  pname = "cameractrls";
  description = "Camera controls for Linux";

  desktopItem = lib.makeDesktopItem {
    name = pname;
    desktopName = "Deezer";
    comment = description;
    icon = "deezer";
    categories = [ "Camera" "Settings" ];
    type = "Application";
    startupWMClass = "cameractrls";
    exec = "cameractrls %u";
    path = "$out/bin";
    startupNotify = true;
  };
in
python3Packages.buildPythonApplication rec {
  inherit pname;
  version = "v0.5.13";
  format = "other";

  src = fetchFromGitHub {
    owner = "soyersoyer";
    repo = pname;
    rev = version;
    sha256 = lib.fakeSha256;
  };

  dontBuild = true;

  buildInputs = [
    SDL2
    libjpeg
    gtk4
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
  ];

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp cameractrls.py $out/share
    cp cameractrlsgtk4.py $out/bin/cameractrls-gtk
    cp pkg/hu.ril.cameractrls.svg $out/share/icons
  '';

  makeWrapperArgs = [
    "--prefix PYTHONPATH : ${placeholder "out"}/share"
  ];

  inherit desktopItem;

  meta = with lib;
    {
      description = description;
      homepage = "https://github.com/soyersoyer/cameractrls";
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ becknik ];
      mainProgram = "cameractrlsgtk4.py";
    };
}
