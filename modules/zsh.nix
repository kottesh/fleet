{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    histSize = 10000;
    histFile = "$HOME/.local/share/zsh/history";

    shellAliases = {
      cat = "bat";
      grep = "rg";
      v = "nvim";
    };

    interactiveShellInit = ''
            # Keep history shared across concurrent shells.
            mkdir -p "''${HISTFILE:h}"
            touch "$HISTFILE"

            setopt HIST_IGNORE_DUPS
            setopt HIST_IGNORE_SPACE
            setopt APPEND_HISTORY
            setopt INC_APPEND_HISTORY
            setopt SHARE_HISTORY
            setopt HIST_FCNTL_LOCK

            autoload -Uz vcs_info
            zstyle ':vcs_info:*' enable git
            zstyle ':vcs_info:*' check-for-changes true
            zstyle ':vcs_info:*' unstagedstr '*'
            zstyle ':vcs_info:*' stagedstr '+'
            zstyle ':vcs_info:git:*' formats '%r:%b%u%c'
            
            setopt PROMPT_SUBST

            precmd() {
              vcs_info

              PROMPT="%F{blue}%~%f"
              [[ -n "$IN_NIX_SHELL" ]] && PROMPT+="%F{cyan} [nix]%f"
              PROMPT+="
      %(?.%F{green}⨳%f.%F{red}⨳%f) "

              RPROMPT="%F{yellow}''${vcs_info_msg_0_:+(''${vcs_info_msg_0_})}%f"
            }

            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
            zstyle ':completion:*' menu select

            bindkey "^[[1;5C" forward-word
            bindkey "^[[1;5D" backward-word

            bindkey -v

            export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'
            export FZF_CTRL_R_OPTS='--preview-window=hidden'

            source ${pkgs.fzf}/share/fzf/key-bindings.zsh
            source ${pkgs.fzf}/share/fzf/completion.zsh

            bindkey '^R' fzf-history-widget
    '';
  };
}
