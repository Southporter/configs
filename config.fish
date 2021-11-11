source ~/.asdf/asdf.fish


set -x PATH $PATH /home/ssedrick/.local/bin /home/ssedrick/.cargo/bin /home/ssedrick/go/bin
set -x GOPATH /home/ssedrick/go

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
    add-ssh-key ~/.ssh/id_rsa
    add-ssh-key ~/.ssh/dev_rsa
    add-ssh-key ~/.ssh/sandbox_rsa
end

function ecr-login
     aws ecr get-login-password --profile eu --region eu-west-1 | podman login --username AWS --password-stdin  004782760466.dkr.ecr.eu-west-1.amazonaws.com
end

function source-enc
    sops -d $argv[1] | jq -r ".data" | source -
end

function source-sops
    sops -d $argv[1] | source -
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
