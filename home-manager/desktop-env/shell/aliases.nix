{
  mkFlakeDir,
  userName,
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.zsh.shellAliases =
    let
      mkRebuildCmd =
        isDarwin: argument:
        (if isDarwin then ''osascript -e 'do shell script "'' else "")
        + (
          "sudo ${if isDarwin then "darwin" else "nixos"}-rebuild "
          + ''--flake \"${(mkFlakeDir userName config)}#$FLAKE_NIXOS_HOST\" ${argument}''
        )
        + (if isDarwin then ''" with administrator privileges' '' else "");

      mkRebuildCmdNh =
        argument: "nh os ${argument} ${(mkFlakeDir userName config)} --hostname $FLAKE_NIXOS_HOST";
    in
    {
      # Flake NixOS configuration equals hostname of machine
      # TODO this is ugly
      nrbs = (mkRebuildCmd false "switch");
      nrbb = (mkRebuildCmd false "boot");
      nrbt = (mkRebuildCmd false "test");

      nhs = (mkRebuildCmdNh "switch");
      nht = (mkRebuildCmdNh "boot");
      nhb = (mkRebuildCmdNh "test");

      # drbs = (mkBetterRebuildCmd true "switch");
      # drbb = (mkBetterRebuildCmd true "build");
      # drbc = (mkBetterRebuildCmd true "check");
      # FIXME git+file:///Users/jbecker/devel/own/dotfiles.nix' does not provide attribute 'packages.x86_64-darwin.nixosConfigurations.wnix.config.system.build.toplevel',
      # 'legacyPackages.x86_64-darwin.nixosConfigurations.wnix.config.system.build.toplevel' or 'nixosConfigurations.wnix.config.system.build.toplevel'

      drbs = (mkRebuildCmd true "switch");
      drbb = (mkRebuildCmd true "build");
      drbc = (mkRebuildCmd true "check");

      ngc = "sudo nix-collect-garbage";
      ngckeep = "sudo nix-collect-garbage --delete-older-than";
      ngcd = "sudo nix-collect-garbage -d";
      ngcdu = "nix-collect-garbage -d";
      # escapes necessary for nix string processing
      nrepl = ''nix repl --expr "builtins.getFlake \"${(mkFlakeDir userName config)}"\"'';

      # General
      fu = "sudo";
      sduo = "sudo";
      nivm = "nvim";
      seshc = ''${lib.getExe pkgs.sesh} connect "$(${lib.getExe pkgs.sesh} list -i | ${lib.getExe pkgs.fzf} --ansi)"'';
      sehsc = ''${lib.getExe pkgs.sesh} connect "$(${lib.getExe pkgs.sesh} list -i | ${lib.getExe pkgs.fzf} --ansi)"'';

      ## Some copy-pastes from ohmyzsh common-aliases which aren't shadowed by eza
      rm = "rm -i";
      mv = "mv -i";
      zshrc = "\${EDITOR} ~/.zshrc";
      zshenv = "\${EDITOR} ~/.zshenv";

      # Git
      gai = "git add --interactive";
      grsst = "git restore --staged"; # = grst
      grhp = "git reset -p"; # useful for unstaging staged hunks
      gclb = "git clone --recurse-submodules --bare";
      "gsw!" = "git switch --force";
      gla = "git pull --autostash";
      gstas = "git stash push --staged";
      grbis = "git rebase --interactive --autosquash";
      glgf = "git log --stat --pretty=fuller";
      glgpf = "git log --stat --patch --pretty=fuller";
      gdsw = "git diff --word-diff --staged";
      glo1 = "git log @{1}.. --pretty=fuller";

      ## Redefines
      gsh = "git show --format=fuller";

      ## Submodules
      gsub = "git submodule";
      gsubup = "git submodule update";
      gsubin = "git submodule init";
      gsubfe = "git submodule foreach";

      ## Frankensteins
      "gauc!" = "gau && gc!";
      "gaucmsg" = "gau && gcmsg";
      "gaucn!" = "gau && gcn!";
      gcnpf = "gcn! && gpf";
      gaucnpf = "gau && gcn! && gpf";

      # Aliases for zsh-forgit
      sgds = "sgd --staged";

      # Commands
      initlua = "tail -c 59 /etc/profiles/per-user/${userName}/bin/nvim | cut -d\" \" -f1";
    };
}
