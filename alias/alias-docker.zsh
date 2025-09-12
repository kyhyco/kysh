docker-ps-fzf() {
  docker ps | fzf +m --layout=reverse --header-lines=1 --preview-window=right,50%,cycle --preview="docker inspect {1} | bat --color always -l json --plain" | awk '{print $1}'
}

alias ds="docker-ps-fzf | xargs docker stop"
alias de="docker-ps-fzf | xargs echo -n | awk '{ print \$1 \" /bin/bash\"}' | xargs -o docker exec -it"

compose-ps-fzf() {
  docker-compose ps | fzf +m --layout=reverse --header-lines=1 --preview-window=right,50%,cycle --preview="docker inspect {1} | bat --color always -l json --plain" | awk '{print $1}'
}

#log
alias cl="compose-ps-fzf | xargs echo -n | awk '{print \$1 }' | xargs docker logs"
#stop
alias cs='docker-ps-fzf | xargs docker stop'
#exec
alias ce="docker-ps-fzf | xargs echo -n | awk '{print \$1 \" /bin/bash\"}' | xargs -o docker exec -it"
