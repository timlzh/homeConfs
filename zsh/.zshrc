if [[ -z "$TMUX"  ]]  && [ "$WT_SESSION" != "" ] && [[ -z "$VSCODE_INJECTION" ]]; then
    tmux attach -t default || exec tmux new-session -A -s default
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
if [[ "$VSCODE_INJECTION" == "" ]]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
else
    ZSH_THEME="robbyrussell"
fi

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' mode disabled
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
        git
        zsh-autosuggestions
        zsh-syntax-highlighting
        vi-mode
        fzf-zsh-plugin
        sudo
        copypath
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
export PROXY=http://127.0.0.1:7890
alias proxyEnable="export ALL_PROXY=$PROXY
export all_proxy=$PROXY
export HTTP_PROXY=$PROXY
export http_proxy=$PROXY
export NO_PROXY=localhost,127.0.0.1,::1
export no_proxy=$NO_PROXY"

alias proxyDisable="unset ALL_PROXY
unset all_proxy
unset HTTP_PROXY
unset http_proxy
unset NO_PROXY
unset no_proxy"

alias killName='func() { ps -ef | grep $1 | grep -v grep | awk '\''{print $2}'\'' | xargs kill -9;}; func'
alias killPort='func() { lsof -i:$1 | awk '\''{if($2!="PID") print $2}'\'' | xargs kill -9;}; func'

alias showPort='func() { lsof -i:$1;}; func'

alias ..='cd ..'
alias his='history | grep'

alias dc='docker compose'

alias lazydocker='/home/timlzh/.local/bin/lazydocker'
alias clash='nohup /opt/clash/cfw 2>&1 > /dev/null &'
alias cproxy='proxychains -f ~/clashproxy.conf'

# alias volatility='python3 ~/Documents/CNSS/volatility3/vol.py'
# alias volatility2='python2 ~/Documents/CNSS/volatility2/vol.py --plugins=/home/timlzh/Documents/volatility_profiles'
alias volatility='python2 ~/Apps/volatility/vol.py'

export PATH=$PATH:/usr/bin:/usr/local/go/bin:~/Documents/CNSS/NSSCTF/DexPatcher-scripts:/home/timlzh/.local/bin:/home/timlzh/Apps/Android-NDK:/home/timlzh/Apps/Android-NDK/toolchains/llvm/prebuilt/linux-x86_64/bin
export ANDROID_SDK_ROOT=~/Android/SDK
export GOROOT=/usr/local/go
export GO111MODULE=on
export GOPROXY=https://goproxy.cn

export SSLKEYLOGFILE='/home/timlzh/sslkeylog.log'

function cccat() {
    local style="monokai"
    if [ $# -eq 0 ]; then
        pygmentize -P style=$style -P tabsize=4 -f terminal256 -g
    else
        for NAME in $@; do
            pygmentize -P style=$style -P tabsize=4 -f terminal256 -g "$NAME"
        done
    fi
}

alias cat="cccat"

alias chr="python -c 'import sys; print(chr(int(sys.argv[1],16) if \"0x\" in sys.argv[1] else int(sys.argv[1])).encode())'"
alias ord="python -c 'import sys; print(ord(sys.argv[1]))'"
alias hex="python -c 'import sys; print(hex(int(sys.argv[1])))'"

alias godzilla="(cd ~/Apps/Godzilla && java -jar godzilla.jar)"
alias pwninit="~/Apps/pwninit"
alias ida32='wine ~/Apps/IDA8/ida.exe'
alias ida64='wine ~/Apps/IDA8/ida64.exe'
function ida() {
    fileName=$1
    if [ -z "$fileName" ]; then
        echo "Usage: ida <file>"
        return
    fi
    if [ ! -f "$fileName" ]; then
        echo "File not found: $fileName"
        return
    fi

    file $fileName
    fileType=$(file $fileName)
    
    if [[ $fileType == *"64-bit"* ]]; then
        # ida64 $fileName &
        nohup wine ~/Apps/IDA8/ida64.exe $fileName 2>&1 > /dev/null &
    elif [[ $fileType == *"32-bit"* ]]; then
        # ida32 $fileName &
        nohup wine ~/Apps/IDA8/ida.exe $fileName 2>&1 > /dev/null &
    else
        echo "Unknown file type: $fileType"
    fi

    checksec $fileName
}

RED='\033[0;31m'
NC='\033[0m'

function socatStart() {
    local fileName=$1
    local port=$2

    if [ -z "$fileName" ]; then
        echo "Usage: socatStart <file> [port]"
        return
    fi

    if [ -z "$port" ]; then
        port=10001
        echo "Using default port: $port"
    fi

    if [ ! -f "$fileName" ]; then
        echo "File not found: $fileName"
        return
    fi

    file $fileName
    echo ''
    echo "socat tcp-listen:$RED$port$NC,reuseaddr,fork EXEC:$RED$fileName$NC,pty,raw,echo=0"
    socat tcp-listen:$port,reuseaddr,fork EXEC:$fileName,pty,raw,echo=0
}


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
