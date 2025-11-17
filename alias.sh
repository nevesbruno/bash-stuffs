

  ########################################
  ##                                    ##
  ##  Bruno Neves <bruno.tntex@gmail>	##
  ##                                    ##
  ########################################


#
# Some helpful stuff
#

## Aliases
alias ws="cd ~/workspace"
alias c="clear"
alias cl="clear && ls -lha"
alias runserver="command python -m SimpleHTTPServer"
alias html5="command git clone https://github.com/h5bp/html5-boilerplate.git"
alias bashedit="vi ~/.zshrc"
alias a="vim ~/lab/bash-stuffs/alias.sh"
alias hosts="sudo vim /etc/hosts"
alias chosts="cat /etc/hosts"

## NPM
function clear-npm(){
    echo "Cleaning package-lock"
    rm ./package-lock.json
    echo "Cleaning node_modules"
    rm -r ./node_modules
    echo "Cleaning npm cache ~with the Force"
    npm cache clear --force
    echo "Reinstalling modules"
    npm i
}

## Sublime
function s(){
    subl $1 &
}

## Utils
function mkcd(){
    mkdir $1
    cd $1
}

function vimedit(){
   vim ~/.vim/janus/vim/vimrc
}

#
# Git stuff
#

### Aliases
alias gst="git status"
alias gbranch="git branch"
alias stash="git stash"
alias pop="git stash pop"
alias glog="git log --graph --all --pretty=format:'%C(yellow)%h %ad %Cblue%an%C(auto)%d %Creset%s' --date=short --decorate"

### Functions

# Clone repository
function clone(){
    git clone $1
}

# Pull and full update on a branch
function pullall(){
    git pull $1 $2
    echo "pulling from repositore..."
    git fetch --all
    echo "fetching all..."
    git fetch --tags
    echo "fetching tags..."
}

# Push to a branch
function push(){
    git push $1 $2
}

# Pull from a branch
function pull(){
    git pull $1 $2
}

# Checkout
function checkout(){
    git checkout $1 $2
}

# Merge
function merge(){
    git merge $1
}

# Add all non commited files and set a commit message
function cmt(){
    git add .
    echo "All files added"
    git commit -m "$1"
}

function clone-key() {
	echo "ssh-agent bash -c 'ssh-add $1; $2'"
	ssh-agent bash -c 'ssh-add $1; $2'
}


# Exemplo de uso:
# clone-lnv git@github.com:usuario/repo.git 
# clone-lnv git@github.com:usuario/repo.git meu-diretorio

clone-lnv(){
    local repo_url="$1"
    local ssh_key="/home/brunoneves/.ssh/lnv-2"
    local dest_dir="$2"

    if [ -z "$repo_url" ] || [ -z "$ssh_key" ]; then
        echo "Uso: clone_with_key <repo_url> <caminho_chave_ssh> [diretorio_destino]"
        return 1
    fi

    if [ ! -f "$ssh_key" ]; then
        echo "Erro: Chave SSH não encontrada: $ssh_key"
        return 1
    fi

    # Se o diretório de destino não for informado, usa o nome do repo como git faz por padrão
    if [ -z "$dest_dir" ]; then
        dest_dir=$(basename "$repo_url" .git)
    fi

    GIT_SSH_COMMAND="ssh -i $ssh_key -o IdentitiesOnly=yes" git clone "$repo_url" "$dest_dir"

    # Configura a chave SSH no git config local do projeto
    if [ -d "$dest_dir" ]; then
        cd "$dest_dir"
        git config core.sshCommand "ssh -i $(realpath "$ssh_key") -o IdentitiesOnly=yes"
        cd - > /dev/null
        echo "✓ Repositório clonado e configurado com a chave: $ssh_key"
    else
        echo "Erro: Diretório do repositório não encontrado"
        return 1
    fi
}

# Docker helpers
alias dps="docker ps"
alias dpsa="docker ps -a"
alias drma="docker rm -f $(docker ps -qa)"
function dbash(){
    docker exec -it $1 bash
}

function drm(){
    if [ "$1" = "-i" ]; then
        docker rmi $2
    else
        docker rm $1
    fi
}

function dexec(){
    docker exec -it $1 $2
}

# Work Stuff
alias proj="cd ~/projetos"
alias ib="proj && cd portal"
alias inst="proj && cd master-institucional"
alias mas="inst"
alias nrd="npm run dev"
alias play="code . && nrd"

#Python
function venv(){
    source venv/bin/activate
}
