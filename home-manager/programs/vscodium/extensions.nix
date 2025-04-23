{ pkgs, ... }:

{
  # Soruces:
  # https://raw.githubusercontent.com/nix-community/nix-vscode-extensions/refs/heads/master/data/cache/open-vsx-latest.json
  # https://raw.githubusercontent.com/nix-community/nix-vscode-extensions/refs/heads/master/data/cache/vscode-marketplace-latest.json

  programs.vscode.extensions =
    with pkgs.open-vsx; [
      ## Management
      alefragnani.project-manager
      alefragnani.bookmarks
      mkhl.direnv

      ## Editor Config, Autocompletion, etc.
      # asvetliakov.vscode-neovim # TODO
      vscodevim.vim
      formulahendry.code-runner
      streetsidesoftware.code-spell-checker
      streetsidesoftware.code-spell-checker-german
      usernamehw.errorlens
      sonarsource.sonarlint-vscode

      ## Eye Candy
      adpyke.codesnap
      johnpapa.vscode-peacock # TODO why isn't this working?

      ### Git
      eamodio.gitlens
      mhutchie.git-graph

      ## Deployment
      github.vscode-github-actions
      # ms-kubernetes-tools.vscode-kubernetes-tools

      ## Interface
      graphql.vscode-graphql # graphql => graphql-syntax necessary
      graphql.vscode-graphql-syntax

      ## Frontend Stuff
      gencer.html-slim-scss-css-class-completion # does this anything?
      firefox-devtools.vscode-firefox-debug
      stylelint.vscode-stylelint
      naumovs.color-highlight
      bierner.color-info

      ## Languages & Frameworks

      ### Declarative
      redhat.vscode-yaml
      tamasfe.even-better-toml
      mikestead.dotenv
      redhat.vscode-xml

      ### Markup
      yzhang.markdown-all-in-one
      davidanson.vscode-markdownlint

      ### Scripting
      mtxr.sqltools
      mtxr.sqltools-driver-pg
      mtxr.sqltools-driver-sqlite

      #### JS/TS
      denoland.vscode-deno
      vue.volar
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      # unifiedjs.vscode-mdx
      yoavbls.pretty-ts-errors

      ### Nix
      jnoortheen.nix-ide
      arrterian.nix-env-selector

      ### LaTeX
      james-yu.latex-workshop

      ### Haskell
      justusadam.language-haskell # Syntax highlighting
      haskell.haskell # Linting etc.

      ### Cpp
      llvm-vs-code-extensions.vscode-clangd
      vadimcn.vscode-lldb
      #ms-vscode.cpptools
      #twxs.cmake #?

    ] ++ (with pkgs.open-vsx-release; [
      ### Rust
      rust-lang.rust-analyzer
    ]) ++ (with pkgs.vscode-marketplace; [
      # extensions listed here are either not present on open-vsx, or outdated

      ## Management
      gruntfuggly.todo-tree
      tobias-z.vscode-harpoon

      ## Editor Config, Autocompletion, etc.
      ryanlaws.toggle-case
      christian-kohler.path-intellisense
      pflannery.vscode-versionlens # just minor version tag behind, but some weeks back now

      ## Themes
      fabiospampinato.vscode-monokai-night
      monokai.theme-monokai-pro-vscode

      ## Git
      gitworktrees.git-worktrees

      ## Interface
      meta.relay

      ## Languages & Frameworks

      ### Scripting
      mads-hartmann.bash-ide-vscode
      ms-python.vscode-pylance #ms-pyright.pyright is included in pylance
      ms-python.python # seems to lag behind ~1w, but who knows...
      ms-toolsai.jupyter-keymap
      ms-toolsai.vscode-jupyter-slideshow
      ms-toolsai.vscode-jupyter-cell-tags

      #### JS/ TS
      expo.vscode-expo-tools
      bradlc.vscode-tailwindcss
      kimuson.ts-type-expand
      orta.vscode-jest # latest version only available here

      ### Cpp
      ms-vscode.cmake-tools
    ]) ++ (with pkgs.vscode-marketplace-release; [
      # prevents preview builds to be picket which aren't compatible with the current vscode version
      github.copilot
      github.vscode-pull-request-github # this is way to outdated on nixpkgs; hence having to check every flake update manually?? :(

      ms-toolsai.jupyter
    ]) ++ (with pkgs.unstable.vscode-extensions; [
      # fallback to nixpkgs, since not working with the upper...
      ms-vsliveshare.vsliveshare
    ]) ++ (with pkgs.vscode-extensions; [
      # fuck the package incompatibility...
      github.copilot-chat
    ]);
}
