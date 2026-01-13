{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    sesh
  ];

  systemd.user.services.tmux = {
    Unit = {
      Description = "tmux default session (detached)";
      Documentation = [ "man:tmux(1)" ];
    };

    Service =
      let
        resurrectScriptPath = "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts";
      in
      {
        Type = "forking";
        Environment = [
          "DISPLAY=:0"
          "TMUX_TMPDIR=/run/user/1000"
          "PATH=$PATH:${
            lib.makeBinPath (
              with pkgs;
              [
                coreutils
                hostname
                gnused
                gnugrep
                gnutar
                gzip
                gawk
                ps
                diffutils
              ]
              ++ [ config.programs.tmux.package ]
            )
          }"
        ];
        ExecStart = "${lib.getExe config.programs.tmux.package} start-server";
        ExecStartPost = [
          "${resurrectScriptPath}/restore.sh"
        ];
        ExecStop = [
          "${resurrectScriptPath}/save.sh"
        ];
        KillMode = "control-group";
        RestartSec = 2;
      };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  programs.tmux = {
    enable = true;

    # keyMode = "vi";
    mouse = true; # scroll through terminal buffer
    baseIndex = 1;
    clock24 = true;

    prefix = "C-q"; # "C-a" already used in VIM to increment number
    escapeTime = 0;

    extraConfig = builtins.concatStringsSep "\n" [
      "bind '\\' split-window -h -c \"#{pane_current_path}\""
      "bind - split-window -v -c \"#{pane_current_path}\""
      "bind -r r move-window -r" # reorder windows to fill in "gap indices"

      # already used for opening some kind of pop-up with command explanations
      "bind-key < swap-window -t -1\\; previous-window"
      "bind-key > swap-window -t +1\\; next-window"

      # without prefix key provided by vim-navigator plugin
      # "bind h select-pane -L"
      # "bind j select-pane -D"
      # "bind k select-pane -U"
      # "bind l select-pane -R"

      "bind -r H resize-pane -L 5"
      "bind -r J resize-pane -D 5"
      "bind -r K resize-pane -U 5"
      "bind -r L resize-pane -R 5"

      "set -g status-justify centre"
      "setw -g monitor-activity on" # highlights the window name in status line on activity
      # "set -g visual-activity on" # show message in status line as well - I find this to be annoying

      # set vi-mode
      "set-window-option -g mode-keys vi"
      # keybindings
      "bind-key -T copy-mode-vi v send-keys -X begin-selection" # use v instead of c-v space
      "bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle" # toggle between line & rectangle select mode
      "bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel"

      "set -g repeat-time 200" # ms to recognize repeated key presses
      "set -g focus-events on" # send focus-lost event to neovim when alt-tabbing away

      # https://github.com/joshmedeski/sesh?tab=readme-ov-file#tmux--fzf
      ''
        bind-key t run-shell "${lib.getExe pkgs.sesh} connect \"$(
          ${lib.getExe pkgs.sesh} list --icons | ${pkgs.fzf}/bin/fzf-tmux -p 80%,70% \
            --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
            --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
              --bind 'tab:down,btab:up' \
              --bind 'ctrl-a:change-prompt(⚡  )+reload(${lib.getExe pkgs.sesh} list --icons)' \
            --bind 'ctrl-t:change-prompt(🪟  )+reload(${lib.getExe pkgs.sesh} list -t --icons)' \
            --bind 'ctrl-g:change-prompt(⚙️  )+reload(${lib.getExe pkgs.sesh} list -c --icons)' \
            --bind 'ctrl-x:change-prompt(📁  )+reload(${lib.getExe pkgs.sesh} list -z --icons)' \
            --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
            --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(${lib.getExe pkgs.sesh} list --icons)' \
            --preview-window 'right:55%' \
            --preview '${lib.getExe pkgs.sesh} preview {}'
          )\""

        # https://github.com/joshmedeski/sesh?tab=readme-ov-file#recommended-tmux-settings
        bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt
        set -g detach-on-destroy off  # don't exit from tmux when closing a session

        bind -N "last-session (via sesh) " L run-shell "${lib.getExe pkgs.sesh} last"
      ''
      /* tmux */ ''set-option -g default-terminal "tmux-256color"''
      # Undercurl & undercurl color support
      /* tmux */
      ''
        set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm' # undercurl support
        set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m' # underscore colours - needs tmux-3.0
      ''
    ];
    plugins = with pkgs.tmuxPlugins; [
      yank
      vim-tmux-navigator
      prefix-highlight
      tmux-fzf
      {
        plugin = resurrect;
        extraConfig = /* tmux */ ''
          set -g default-shell "${lib.getExe config.programs.zsh.package}"
          set -g default-command "exec ${lib.getExe config.programs.zsh.package}"
          set-option -g update-environment "DISPLAY SSH_ASKPASS SSH_AUTH_SOCK SSH_AGENT_PID SSH_TTY PATH"

          resurrect_dir="$HOME/.tmux/resurrect"
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-dir $resurrect_dir
          set -g @resurrect-capture-pane-contents 'on'

          # this is such a mess...
          # source: https://discourse.nixos.org/t/how-to-get-tmux-resurrect-to-restore-neovim-sessions/30819/11
          # set -g @resurrect-processes '"~nvim"'
            # set -g @resurrect-hook-post-save-all "sed -i 's/--cmd lua.*--cmd set packpath/--cmd \"lua/g; s/--cmd set rtp.*\$/\"/' $resurrect_dir/last"

        '';
      }
      {
        plugin = continuum;
        extraConfig = /* tmux */ ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10' # minutes
        '';
      }
    ];
  };

}
