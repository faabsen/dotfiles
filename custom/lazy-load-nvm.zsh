# add this to ~/.zshrc to load homebrew zsh on demand, rather than making each shell start more slowly
# modified from http://broken-by.me/lazy-load-nvm/ to use brew nvm
export NVM_DIR="$HOME/.nvm"
if [[ $(uname -m) = "x86_64" ]]
then
    export NVM_OPT="/usr/local/opt/nvm"    # intel
else
    export NVM_OPT="/opt/homebrew/opt/nvm" # arm64 / aarch64
fi

load-nvm() {
    if [[ ! `type nvm` =~ '/Cellar/' ]]; then
        [ -s "$NVM_OPT/nvm.sh" ] && . "$NVM_OPT/nvm.sh" # loads nvm
    fi 
}

nvm() {
    unset -f nvm
    load-nvm
    nvm "$@"
}

node() {
    unset -f node
    load-nvm
    node "$@"
}
  
npm() {
    unset -f npm
    load-nvm
    npm "$@"
}

npx() {
    unset -f npx
    load-nvm
    npx "$@"
}

function chpwd() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  fi
}
chpwd