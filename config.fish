switch (uname)
  case Darwin
    # For homebrew asdf
    source (brew --prefix asdf)/libexec/asdf.fish >> ~/.config/fish/config.fish
    if test -d (brew --prefix)"/share/fish/completions"
      set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
        set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
  case '*'
    source ~/.asdf/asdf.fish
end


# contains /snap/bin $PATH; or set -x PATH $PATH /snap/bin
contains $HOME/.local/bin $PATH; or set -x PATH $PATH $HOME/.local/bin
contains $HOME/.cargo/bin $PATH; or set -x PATH $PATH $HOME/.cargo/bin
contains $HOME/go/bin $PATH; or set -x PATH $PATH $HOME/go/bin
set -x GOPATH $HOME/go

alias k "kubectl"
alias kctx "kubectx"
alias kns "kubens"

function add-ssh-key
    set -l fingerprint (ssh-keygen -l -f $argv[1] | awk '{split($0,a); print a[2]}')
    set -l results (ssh-add -l | grep $fingerprint | wc -l)
    if test $results -eq 0
        ssh-add $argv[1]
        echo "Added SSH key $argv[1]"
    end
end

function init-ssh
    set -l agent_check (ps ax | grep ssh-agent | wc -l)
    echo $agent_check
    if test $agent_check -lt 2
      eval (ssh-agent -c)
    end
    # Add keys here
end

function gen-pass
    argparse --name=gen-pass  'h/help' 'c/count=!_validate_int --min 8' 's/charset=' -- $argv

    if set --query _flag_help
        printf "Usage: gen-pass [OPTIONS]\n\n"
        printf "Options:\n"
        printf "  -c/--count=NUM      The number of characters for password\n\n"
        printf "  -s/--charset    The set of charaters from which to create the password\n"
        return 0
    end

    set --query _flag_count; or set --local _flag_count 42
    set --query _flag_charset; or set --local _flag_charset "A-Za-z0-9"
    tr -dc $_flag_charset </dev/urandom | head -c $_flag_count ; echo ''
end
