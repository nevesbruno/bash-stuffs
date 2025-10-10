

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


# Docker helpers
alias dps="docker ps"
alias dpsa="docker ps -a"
# alias drma="docker rm -f $(docker ps -qa)"
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

function audsat(){
    echo -e "\e[1;34mIniciando XAMPP...\e[0m"
    xamp start && echo -e "\e[1;32mXAMPP iniciado com sucesso.\e[0m"
    
    echo -e "\e[1;34mAbrindo o diretório do projeto no Cursor...\e[0m"
    cursor /opt/lampp/htdocs/audsat-export && echo -e "\e[1;32mDiretório do projeto aberto no Cursor.\e[0m"
    
    echo -e "\e[1;34mNavegando para o diretório do tema...\e[0m"
    cd /opt/lampp/htdocs/audsat-export/wp-content/themes/audsat && echo -e "\e[1;32mAgora no diretório do tema Audsat.\e[0m"
    
    echo -e "\e[1;34mIniciando o observador Sass...\e[0m"
    npm run sass:watch
    echo -e "\e[1;33mObservador Sass iniciado. Pressione Ctrl+C para parar.\e[0m"
}

#Python
function venv(){
    source venv/bin/activate
}

#XAMP
functino xamp(){
    sudo /opt/lampp/lampp $1

}

alias freela="cd /opt/lampp/htdocs"

# SimpleBase
alias sb-app="cd ~/projects/simplebase/app && cursor . && npm start"
alias sb-api="cd ~/projects/simplebase/api && cursor . && venv && uvicorn main:app --reload"

# Misc
alias htdocs="cd /opt/lampp/htdocs/"


# Montar pendrive no ubuntu WSL2 D:
function mount-pendrive(){
    # Criar o ponto de montagem
    sudo mkdir -p /mnt/d

    # Montar manualmente o drive D:
    sudo mount -t drvfs D: /mnt/d
}