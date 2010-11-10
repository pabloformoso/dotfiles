# Given an array GO_SHORTCUTS defined elsewhere with pairs shorcut -> directory:
#
#   GO_SHORTCUTS=(
#     rails
#     $HOME/prj/rails
#
#     tmp
#     $HOME/tmp
#  )
#
# you can cd into the destination directories given the shortcut. For example
#
#   go rails
#
# takes you to $HOME/prj/rails from anywhere.
GO_SHORTCUTS=(
)

function go {
    local target=$1
    local len=${#GO_SHORTCUTS[@]}
    for (( i=0; i<$len; i+=2 ));
    do
        if [[ "$1" = "${GO_SHORTCUTS[$i]}" ]]; then
            cd "${GO_SHORTCUTS[$i+1]}"
            return
        fi
    done
    echo "unknown shortcut"
}

# Uncompresses the given tarball, and cds into the uncompressed directory:
#
#    fxn@halmos:~/tmp$ xcd ruby-1.9.2-p0.tar.gz 
#    fxn@halmos:~/tmp/ruby-1.9.2-p0$
#
# Accepts tar.gz, tar.bz2, and zip.
function xcd {
    local tarball=$1
    if [[ "$tarball" == *.tar.gz ]]; then
        tar xzf "$tarball" && cd "${tarball%.tar.gz}"
    elif [[ "$tarball" == *.tar.bz2 ]]; then
        tar xjf "$tarball" && cd "${tarball%.tar.bz2}"
    elif [[ "$tarball" == *.zip ]]; then
        unzip "$tarball" && cd "${tarball%.zip}"
    else
        echo "unknown tarball"
    fi
}

# If the cwd is a git repo, put the branch in the prompt.
export PS1='\u@\h:\W`git_branch` $ '
function git_branch {
    local branch=`git branch 2>/dev/null | cut -f2 -d\* -s | sed "s/^ //"`
    if [ -n "$branch" ]; then
        echo " ($branch)"
    else
        echo ''
    fi
}

#
# --- Rails commands ----------------------------------------------------------
#
alias rgs='rails generate scaffold'
alias rgc='rails generate controller'
alias rs='rails server'

# tail -f shortcut for Rails log files.
#
# It selects the log file to tail depending on the environment, priority is:
#
#   1. argument, eg rl test
#   2. RAILS_ENV environment variable
#   3. Defaults to 'development'
#
# Thanks to pgas in #bash for the idiom to chain the defaults.
function rl {
    tail -f log/${1-${RAILS_ENV-development}}.log
}

# Reboots Passenger.
alias rb='touch tmp/restart.txt'

# Git aliases
alias gr='git reset --hard HEAD^'
alias gc='git commit -m'
alias ga='git add .'
alias gp='git push origin master'

#Proyect Caampus Ester
alias tail_campus_pro='ssh pformoso@persei.customer.attikh.net tail -n 2000 -f /var/www/rails/campus.persei.eu/current/log/production.log'
alias ssh_persei_pro='ssh pformoso@persei.customer.attikh.net'

alias tdcampus='./Volumes/Proyectos/Persei/PerseiCmsExamns/cap staging deploy'