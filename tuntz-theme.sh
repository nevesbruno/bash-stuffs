##
# ZSH Theme: Tuntz
# This theme is based in Bira what i used to use
# Bira template came already installed on .oh-my-zsh/themes/ folder
# Preview[Bira]: http://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
##

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
local user_host='%{$fg[green]%}%n ::%{$reset_color%}'
local current_dir='%{$terminfo[bold]$fg[white]%} %~%{$reset_color%}'
local git_branch='$(git_prompt_info)%{$reset_color%}'

PROMPT="╭─${user_host} ${current_dir} ${git_branch}
╰─%B$%b "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
