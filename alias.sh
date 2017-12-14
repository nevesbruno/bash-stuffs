

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

# Add all non commited files and set a commit message
function cmt(){
    git add .
    echo "All files added"
    git commit -m "$1"
}
