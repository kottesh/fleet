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
      hms = "home-manager switch --flake ~/.config/home-manager";
      hmu = "nix flake update --flake ~/.config/home-manager && home-manager switch --flake ~/.config/home-manager";
      v = "nvim";
    };

    interactiveShellInit = ''
            # History options mapped for system Zsh
            setopt HIST_IGNORE_DUPS
            setopt HIST_IGNORE_SPACE
            setopt SHARE_HISTORY

            autoload -Uz vcs_info
            zstyle ':vcs_info:*' enable git
            zstyle ':vcs_info:*' check-for-changes true
            zstyle ':vcs_info:*' unstagedstr '*'
            zstyle ':vcs_info:*' stagedstr '+'
            zstyle ':vcs_info:git:*' formats '%r:%b%u%c'
            
            setopt PROMPT_SUBST

            precmd() {
              vcs_info
              local left_str="%~"
              [[ -n "$IN_NIX_SHELL" ]] && left_str+="%F{cyan} [nix]%f"

              local right_str="''${vcs_info_msg_0_}"
              
              local exp_left
              exp_left="$(print -P "$left_str")"
              local exp_right
              exp_right="$(print -P "$right_str")"

              local pad_len=$(( COLUMNS - ''${#exp_left} - ''${#exp_right} ))
              local pad=""
              if (( pad_len > 0 )); then
                pad="''${(l:$pad_len:: :)}"
              fi

              local git_part=""
              [[ -n "$right_str" ]] && git_part="%F{yellow}($right_str)%f"

              PROMPT="%F{blue}%~%f"
              [[ -n "$IN_NIX_SHELL" ]] && PROMPT+="%F{cyan} [nix]%f"
              PROMPT+="$pad$git_part
      %(?.%F{green}⨳%f.%F{red}⨳%f) "
            }

            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
            zstyle ':completion:*' menu select

            bindkey "^[[1;5C" forward-word
            bindkey "^[[1;5D" backward-word

            bindkey -v
    '';
  };
}
