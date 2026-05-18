
  ########################################
  ##                                    ##
  ##  Bruno Neves <bruno.tntex@gmail>	##
  ##                                    ##
  ########################################


#
# Some helpful stuff
#

# Mounting drives
function mountGdrive(){
    if [ ! -d /mnt/g ]; then
        sudo mkdir /mnt/g
    fi
    sudo mount -t drvfs G: /mnt/gdrive
}

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
alias valias=a

function getOff() {
    echo "Alrighty! Putting WSL to bed. Goodnight, little penguin! 🐧💤"
    powershell.exe -Command "wsl --shutdown"
}

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
    mkdir -p "$1"
    mkdir -p "$1/docs"
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
# alias glog="git log --graph --all --pretty=format:'%C(yellow)%h %ad %Cblue%an%C(auto)%d %Creset%s' --date=short --decorate"
alias glog="git log --graph --pretty=format:'%C(yellow)%h%Creset %C(magenta)%ad%Creset %s %C(black)%C(bold)- %an%Creset%C(auto)%d%Creset' --date=format:'%d/%m %H:%M' --color --max-count=20"

alias gdiff="git diff"
alias gcp="git cherry-pick"

### Functions
gfind() {
  local author=""
  local since=""
  local message=""

  while getopts "a:d:m:" opt; do
    case $opt in
      a) author="--author=$OPTARG" ;;
      d) since="--since=$OPTARG" ;;
      m) message="--grep=$OPTARG" ;;
      *) echo "Uso: gfind [-a autor] [-d data/desde] [-m mensagem]"; return 1 ;;
    esac
  done

  # Se não passar flags, assume que o argumento é uma busca por mensagem
  if [ $OPTIND -eq 1 ]; then
    message="--grep=$1"
  fi

  git log --graph --all --pretty=format:'%C(auto)%h%C(reset) %C(magenta)%ad%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --date=format:'%d/%m %H:%M' $author $since "$message"
}

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
alias ib="proj && cd portal"
alias inst="proj && cd master-institucional"
alias mas="inst"
alias nrd="npm run dev"
alias play="code . && nrd"

#Python
function venv(){
    source venv/bin/activate
}

#XAMP
alias xampp="sudo /opt/lampp/lampp start"
alias xampp-stop="sudo /opt/lampp/lampp stop"
alias xampp-restart="sudo /opt/lampp/lampp restart"
alias xampp-status="sudo /opt/lampp/lampp status"

alias htdocs="cd /opt/lampp/htdocs"

#CURSOR helpers
function clean-docs(){
    echo "Movendo arquivos de 'docs/' para '../sanepar-docs/docs'..."
    mv docs/* ../sanepar-docs/docs
    if [ $? -eq 0 ]; then
        echo "Arquivos movidos com sucesso."
        echo "Removendo diretório 'docs/'..."
        rm -r docs
        if [ $? -eq 0 ]; then
            echo "Diretório 'docs/' removido com sucesso."
        else
            echo "Erro ao remover o diretório 'docs/'."
        fi
    else
        echo "Erro ao mover arquivos, diretório 'docs/' não removido."
    fi
}

# NTozo Aliases & Functions
alias proj="cd ~/ntozo/projetos"


# Add new alias or function using IA

# ====================================================================
# AI ALIAS - CLI Inteligente (DeepSeek)
# ====================================================================
# Use: ai-alias
#
# O código completo deste módulo foi refatorado para:
#   ~/.config/ai-alias/modules/ai-alias-cli.sh
#
# Para editar o módulo manualmente:
#   vim ~/.config/ai-alias/modules/ai-alias-cli.sh
# ====================================================================

# Carrega módulo da CLI de IA
_AI_ALIAS_MODULE="$HOME/.config/ai-alias/modules/ai-alias-cli.sh"
if [ -f "$_AI_ALIAS_MODULE" ]; then
    source "$_AI_ALIAS_MODULE"
else
    echo "⚠️  Módulo ai-alias-cli não encontrado!"
    echo "   Esperado em: $_AI_ALIAS_MODULE"
    echo "   Execute o setup ou copie manualmente para esse local."
fi


###############################################################################
#                                                                             #
#    ███████╗  █████  ███╗   ██╗███████╗██████╗  █████╗ ██████╗   ██████╗     #
#    ██╔════╝ ██╔══██╗████╗  ██║██╔════╝██╔══██╗██╔══██╗██╔══██╗ ██╔═══██╗    #
#    ███████╗ ███████║██╔██╗ ██║█████╗  ██████╔╝███████║██║  ██║ ██║   ██║    #
#    ╚════██║ ██╔══██║██║╚██╗██║██╔══╝  ██╔══██╗██╔══██║██║  ██║ ██║   ██║    #
#    ███████║ ██║  ██║██║ ╚████║███████╗██║  ██║██║  ██║██████╔╝ ╚██████╔╝    #
#    ╚══════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝   ╚═════╝     #
#                                                                             #
#                        >>>>>>>>>  SANEPAR BELOW  <<<<<<<<<                 #
#                                                                             #
#                     >>>>>>>>>>>  SANEPAR BELLOW HERE  <<<<<<<<<<<<<         #
#                                                                             #
#-----------------------------------------------------------------------------#
#                                                                             #
###############################################################################





# Lando-Drupal helpers
alias lstart="lando start"
alias lstop="lando stop"
alias lrestart="lando restart"
alias lstatus="lando status"
alias ldrush="lando drush @portalcliente.local $1"
alias portalcliente-export="./scripts/setup.sh ss-export portalcliente"
alias lcr="ldrush cr"

alias gstq="git status | grep modified"

# Site Studio helpers
alias ss-import="lando drush @portalcliente.local sitestudio:package:import"
alias ss-export="lando drush @portalcliente.local sitestudio:package:export"
alias ss-rebuild="lando drush @portalcliente.local cohesion:rebuild"

function portalcliente-fetch-prod(){
    ldrush sql-create
    lando drush sql:sync @portalcliente.prod @portalcliente.local --debug
    lando drush rsync @portalcliente.prod:%files @portalcliente.local:%files --debug
    ldrush cr
}

function portalcliente-fetch-dev(){
    ldrush sql-create
    lando drush sql:sync @portalcliente.dev @portalcliente.local --debug
    lando drush rsync @portalcliente.dev:%files @portalcliente.local:%files --debug
    ldrush cr
}

function portalcliente-import-config(){
    local cyan='\033[1;36m'
    local green='\033[1;32m'
    local red='\033[1;31m'
    local yellow='\033[1;33m'
    local reset='\033[0m'
    local start_time=$(date +%s)
    # echo -e "${cyan}»${reset} ${green}Importing Drupal configurations...${reset}"
# ./scripts/setup.sh drupal-import portalcliente <<< "4"

    # echo -e "${cyan}»${reset} ${green}Importing Site Studio components...${reset}"
    # ./scripts/setup.sh ss-import portalcliente <<< "4"

    echo -e "${cyan}»${reset} ${green}Importing Drupal configurations from config folder...${reset}"
    ldrush config:import --partial --source=../config/sync/portalcliente -y

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    echo
    echo -e "${cyan}╔══════════════════════════════╗"
    echo -e "${cyan}║${reset} 🏁 ${green}Done in${yellow} $duration ${green}s. ${cyan}║"
    echo -e "${cyan}╚══════════════════════════════╝${reset}"
}

function portalcliente-refresh() {
    local cyan='\033[1;36m'
    local green='\033[1;32m'
    local red='\033[1;31m'
    local yellow='\033[1;33m'
    local reset='\033[0m'
    local start_time=$(date +%s)

    echo -e "${cyan}╔═════════════════════════════╗"
    echo -e "${cyan}║${reset} 🚀 ${yellow}Refreshing...${cyan} ║"
    echo -e "${cyan}╚═════════════════════════════╝${reset}"
    echo

    echo -e "${cyan}»${reset} ${green}Fetching prod DB/files...${reset}"
    printf '\n\n\n' | portalcliente-fetch-prod
    if [ $? -eq 0 ]; then
        echo -e "${green}✔ Fetched production data.${reset}"
    else
        echo -e "${red}✖ Failed to fetch data.${reset}"
        return 1
    fi
    echo

    echo -e "${cyan}»${reset} ${green}Importing config...${reset}"
    portalcliente-import-config
    if [ $? -eq 0 ]; then
        echo -e "${green}✔ Config import complete.${reset}"
    else
        echo -e "${red}✖ Config import failed.${reset}"
        return 1
    fi
    echo

    echo -e "${cyan}»${reset} ${green}Clearing cache...${reset}"
    ldrush cr
    echo -e "${cyan}»${reset} ${green}Rebuilding cohesion...${reset}"
    ldrush cohesion:rebuild

    echo -e "${cyan}»${reset} ${green}Removing vendor folder...${reset}"
    rm -rf vendor

    echo -e "${cyan}»${reset} ${green}Rebuilding Lando...${reset}"
    lando rebuild -y

    echo -e "${cyan}»${reset} ${yellow}One-time login URL:${reset}"
    ldrush uli --name saulo.paiva@squadra.com.br

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    echo
    echo -e "${cyan}╔══════════════════════════════╗"
    echo -e "${cyan}║${reset} 🏁 ${green}Done in${yellow} $duration ${green}s. ${cyan}║"
    echo -e "${cyan}╚══════════════════════════════╝${reset}"
}

function portalcliente-refresh-from-dev(){
    local cyan="\033[36m"
    local yellow="\033[33m"
    local green="\033[32m"
    local red="\033[31m"
    local reset="\033[0m"

    local start_time=$(date +%s)

    echo -e "${cyan}╔═════════════════════════════╗"
    echo -e "${cyan}║${reset} 🚀 ${yellow}Refreshing...${cyan} ║"
    echo -e "${cyan}╚═════════════════════════════╝${reset}"
    echo

    echo -e "${cyan}»${reset} ${green}Fetching dev DB/files...${reset}"
    printf '\n\n\n' | portalcliente-fetch-dev
    if [ $? -eq 0 ]; then
        echo -e "${green}✔ Fetched development data.${reset}"
    else
        echo -e "${red}✖ Failed to fetch data.${reset}"
        return 1
    fi
    echo

    echo -e "${cyan}»${reset} ${green}Importing config...${reset}"
    portalcliente-import-config
    if [ $? -eq 0 ]; then
        echo -e "${green}✔ Config import complete.${reset}"
    else
        echo -e "${red}✖ Config import failed.${reset}"
        return 1
    fi
    echo

    echo -e "${cyan}»${reset} ${green}Clearing cache...${reset}"
    ldrush cr
    echo -e "${cyan}»${reset} ${green}Rebuilding cohesion...${reset}"
    ldrush cohesion:rebuild

    echo -e "${cyan}»${reset} ${green}Removing vendor folder...${reset}"
    rm -rf vendor

    echo -e "${cyan}»${reset} ${green}Rebuilding Lando...${reset}"
    lando rebuild -y

    echo -e "${cyan}»${reset} ${yellow}One-time login URL:${reset}"
    ldrush uli --name saulo.paiva@squadra.com.br

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    echo
    echo -e "${cyan}╔══════════════════════════════╗"
    echo -e "${cyan}║${reset} 🏁 ${green}Done in${yellow} $duration ${green}s. ${cyan}║"
    echo -e "${cyan}╚══════════════════════════════╝${reset}"
}

function portalcliente-refresh-cache(){
    ldrush cr
    ldrush cohesion:rebuild
}

function portal-cliente-export-all(){
    ./scripts/setup.sh drupal-export portalcliente
    ./scripts/setup.sh ss-export portalcliente
}

function goToHell(){
    echo "Wrapping up another triumphant day battling buggy apps. Powering down... 🧑‍💻💀"
    lando stop
    getOff
}
