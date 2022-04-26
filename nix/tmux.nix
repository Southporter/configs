{ config, pkgs, ... }:

let
  unstable = import inputs.pkgs-unstable { inherit (pkgs.stdenv.targetPlatform) system; };
in
{

  programs.tmux = {
    enable = true;
    package = unstable.tmux;

    prefix = "s";
    shell = "${pkgs.fish}/bin/fish";
    keyMode = "vi";

    plugins = with pkgs; [
      tmuxPlugins.sensible
      # resurrect
      tmuxPlugins.yank
      vimPlugins.vim-tmux-navigator
    ];

    extraConfig = ''
      set -g mouse on
      bind -n C-h select-pane -L
      bind -n C-j select-pane -D
      bind -n C-k select-pane -U
      bind -n C-l select-pane -R

      # status line
      set -g status-justify left
      set -g status-bg default
      set -g status-fg colour12
      set -g status-interval 2


      # window status
      setw -g window-status-format " #F#I:#W#F "
      setw -g window-status-current-format " #F#I:#W#F "
      setw -g window-status-format "#[fg=magenta]#[bg=black] #I #[bg=cyan]#[fg=colour8] #W "
      setw -g window-status-current-format "#[bg=brightmagenta]#[fg=colour8] #I #[fg=colour8]#[bg=colour14] #W "

      # Info on left (I don't have a session display for now)
      set -g status-left ""

      # loud or quiet?
      set-option -g visual-activity off
      set-option -g visual-bell off
      set-option -g visual-silence off
      set-window-option -g monitor-activity off
      set-option -g bell-action none

      # The modes {
      setw -g clock-mode-colour colour135
      # }

      # The statusbar {
      set -g status-position bottom
      set -g status-bg colour234
      set -g status-fg colour137
      set -g status-left ""
      set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
      set -g status-right-length 50
      set -g status-left-length 30

      setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '

      setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
      # }

      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"
      set -g @yank_with_mouse on
    '';
  };
}
