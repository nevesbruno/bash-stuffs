#Some of this alias and bash functions are made by Weslley Araujo[ wparaujo.r7@gmail.com ]

#
#Some helpful shits
#

## Aliases
alias ws="cd ~/workspace"
alias c="clear"
alias cl="clear && l"
alias runserver="command python -m SimpleHTTPServer"
alias html5="command git clone https://github.com/h5bp/html5-boilerplate.git"
alias runjasmine="command rake jasmine"
alias bashedit="vi ~/.zshrc"
alias a="vim ~/lab/bash-stuffs/alias.sh"

## Sublime
alias s="subl"
alias ss="s . &"

## Functions
function mkcd(){
    mkdir $1
    cd $1
}

function vimedit(){
   vim ~/.vim/janus/vim/vimrc
}

#
#Git stuff
#

## Aliases
alias gst="git status"
alias stash="git stash"
alias pop="git stash pop"
alias push="git push"
alias pull="git pull"

## Functions
function clone(){
	git clone $1
}

function pullall(){
    git pull
    echo "pulling from repositore..."
    git fetch --all
    echo "fetching all..."
    git fetch --tags
    echo "fetching tags..."
}

function pushH(){
    git push $1 $2
}

function cmt(){
    git add .
    git commit -m $1
}
