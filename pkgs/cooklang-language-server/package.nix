{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "cooklang-language-server";
  version = "unstable-2026-04-18";

  cargoHash = "sha256-HTSn0a2MbOSTv9VtZDB6zmROGfad8NaisnYXWF6f2fQ=";

  src = fetchFromGitHub {
    owner = "cooklang";
    repo = "cooklang-language-server";
    rev = "31e559457b1b755edaf15b316c01a882a4da61f6";
    hash = "sha256-fmxwVTTz9WvjdW6P+ODe4K1MpwQ+IeTWP1uJqOybbIo=";
  };

  doInstallCheck = false;

  meta = {
    description = "A Language Server Protocol (LSP) implementation for Cooklang, the markup language for recipes";
    homepage = "https://cooklang.org/";
    license = with lib.licenses; [
      mit
    ];
    # maintainers = with lib.maintainers; [ oxalica ];
    mainProgram = "cooklang-language-server";
  };
}
