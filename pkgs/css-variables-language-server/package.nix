{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "css-variables-language-server";
  version = "2.8.3";

  src = pkgs.fetchFromGitHub {
    owner = "vunguyentuan";
    repo = "vscode-css-variables";
    rev = "${pname}@${version}";
    hash = "sha256-bWHah9ztGDeviMoNxgWs4LleDvUWTGZHT50vv5a/jyA=";
  };

  npmWorkspace = "packages/css-variables-language-server";
  npmDepsHash = "sha256-cgX/M05UGsx87QO/Ge0VCD2hQ9MkfJarJVNCj/IcnM0=";

  nativeBuildInputs = with pkgs; [
    pkg-config
    python3 # needed by node-gyp
  ];
  buildInputs = with pkgs; [
    libsecret
  ];

  preBuild = ''
    wrapNodeBinSymlinks() {
      local d="$1"
      [ -d "$d" ] || return 0

      # Replace symlinked npm bin shims with wrappers (avoids /usr/bin/env)
      find "$d" -maxdepth 1 -type l -print0 | while IFS= read -r -d "" link; do
        local target
        target="$(readlink -f "$link")"
        rm -f "$link"
        cat > "$link" <<WRAPPER
    #!${pkgs.runtimeShell}
    exec ${pkgs.nodejs}/bin/node "$target" "\$@"
    WRAPPER
        chmod +x "$link"
      done
      patchShebangs "$d"
    }

    wrapNodeBinSymlinks packages/css-variables-language-server/node_modules/.bin
  '';

  postInstall = ''
    pkgRoot="$out/lib/node_modules/root"

    # Copy workspace packages to satisfy npm symlinks
    mkdir -p "$pkgRoot/packages"
    cp -r packages/css-variables-language-server "$pkgRoot/packages/"
    cp -r packages/vscode-css-variables "$pkgRoot/packages/"

    # Fix bin wrapper to point to the workspace package
    rm -f "$out/bin/css-variables-language-server"
    cat > "$out/bin/css-variables-language-server" <<WRAPPER
    #!${pkgs.runtimeShell}
    exec ${pkgs.nodejs}/bin/node "$pkgRoot/packages/css-variables-language-server/bin/index.js" "\$@"
    WRAPPER
    chmod +x "$out/bin/css-variables-language-server"

    # Remove .o files that cause noisy patchelf warnings
    find "$pkgRoot" -name '*.o' -delete
  '';

  meta = with lib; {
    description = "Language server for CSS variables providing autocomplete and go-to-definition";
    homepage = "https://github.com/vunguyentuan/vscode-css-variables";
    license = licenses.mit;
    mainProgram = "css-variables-language-server";
  };
}
