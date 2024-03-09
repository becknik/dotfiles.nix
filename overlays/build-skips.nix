{ inputs, ... }:

final: prev:
let
  lib = prev.lib;
  mapToClean = packages: lib.attrsets.mapAttrs
    (name: value: prev.clean.${name})
    packages;

  packagesElectron = lib.attrsets.filterAttrs
    (with lib.strings; name: value: (hasPrefix "electron" name) && !(hasSuffix "bin" name))
    prev;

  packagesNode = lib.attrsets.filterAttrs
    (name: value: lib.strings.hasPrefix "nodejs" name)
    prev;

  packagesLlvm = lib.attrsets.filterAttrs
    (name: value: (lib.strings.hasPrefix "llvm" name)
      && (name != "llvmPackages" || name != "llvmPackages_16" || name != "llvmPackages_17"))
    prev;
    /* && value != prev.llvmPackages */ # TODO: Inifinte recursion

  packagesClang = lib.attrsets.filterAttrs
    (name: value: lib.strings.hasPrefix "clang" name && (name != "clang" || name != "clang_16" || name != "clang_17"))
    prev;

  packagesLibreOffice = lib.attrsets.filterAttrs (name: value: lib.strings.hasPrefix "libreoffice" name) prev;

  packagesOpenJDK = lib.attrsets.filterAttrs (name: value: lib.strings.hasPrefix "openjdk" name) prev;
in
mapToClean packagesElectron // mapToClean packagesNode // mapToClean packagesLlvm // mapToClean packagesClang //
mapToClean packagesOpenJDK // mapToClean packagesLibreOffice // {

  ## Webkit
  webkitgtk = prev.clean.webkitgtk;
  webkitgtk_6_0 = prev.clean.webkitgtk_6_0;
  webkitgtk_4_1 = prev.clean.webkitgtk_4_1;

  ## Qt
  qt5 = prev.clean.qt5;
  libsForQt5 = prev.clean.libsForQt5;
  qt6 = prev.clean.qt6;
  qt6Packages = prev.clean.qt6Packages;

  # https://discourse.nixos.org/t/overriding-src-of-qt5-kde-plasma-pkgs/17677/8
  # Works, but enventually fails with:
  # > Error: detected mismatched Qt dependencies:
  # >     /nix/store/57bzw90q7i44cspbwdn9xd7wbf49d64x-qtbase-5.15.12-dev
  # >     /nix/store/sbhh5lhs8zq0hmh2shpsnvqwcgrxic8i-qtbase-5.15.12-dev
  /* libsForQt5 = prev.libsForQt5.overrideScope (_qFinal: _qPrev: {
    qtwebview = prev.clean.libsForQt5.qtwebview;
    qtwebengine = prev.clean.libsForQt5.qtwebengine;
    #qtdeclarative = prev.clean.libsForQt5.qtdeclarative; # Seems to be strongly coupled to qtbase
    });
    qt5 = prev.qt5.overrideScope (_qFinal: _qPrev: {
    qtwebview = prev.clean.qt5.qtwebview;
    qtwebengine = prev.clean.qt5.qtwebengine;
  }); */
  /* qt6Packages = prev.qt6Packages.overrideScope (_qFinal: _qPrev: {
    qtwebview = prev.clean.qt6Packages.qtwebview;
    qtwebengine = prev.clean.qt6Packages.qtwebengine;
    });
    qt6 = prev.qt6.overrideScope (p: f: {
    qtwebview = prev.clean.qt6.qtwebview;
    qtwebengine = prev.clean.qt6.qtwebengine;
    #qtdeclarative = prev.clean.qt6Packages.qtdeclarative;
    #qtdeclarative = prev.clean.qt6.qtdeclarative;
    #qtdeclarative = prev.clean.qt6.qtdeclarative;
  }); */


  ## Further
  tor-browser = prev.clean.tor-browser;
  krita = prev.clean.krita;
  ungoogled-chromium = prev.clean.ungoogled-chromium;
  #thunderbird = prev.clean.thunderbird;
  #spidermonkey = prev.clean.spidermondkey;

  /* libreoffice = prev.libreoffice.overrideAttrs (old: {
    doCheck = false;
  }); */
}
