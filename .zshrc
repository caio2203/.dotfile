# Created by newuser for 5.9
fastfetch

# Terminal config
export TERMINAL=ghostty
export EDITOR=nvim

# Configuração Java
export JAVA_HOME="/usr/lib/jvm/java-24-openjdk"
export PATH="$JAVA_HOME/bin:$PATH"

# Primeiro: colocar o oh-my-posh no PATH
export PATH="$HOME/.local/bin:$PATH"
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/themes/earthstone.omp.json)"

export PATH=$PATH:/home/caio/.spicetify

# Aliases para substituir vi/vim por neovim
alias vi='nvim'
alias vim='nvim'
alias nv='nvim'

#comando help
help() {
  local topic="$1"
  local help_dir="$HOME/.linux-help"

  if [[ -z "$topic" ]]; then
    echo "Use: help <tópico>"
    echo "Tópicos disponíveis:"
    ls "$help_dir"
    return
  fi

  local file="$help_dir/$topic"
  if [[ -f "$file" ]]; then
    cat "$file"
  else
    echo "Ajuda para '$topic' não encontrada."
    echo "Tópicos disponíveis:"
    ls "$help_dir"
  fi
}

# ollama
# Iniciar o Ollama com o modelo phi3 (serve em background)
alias ollama-start='nohup ollama serve --model phi3 > ~/ollama_phi3.log 2>&1 & echo "Ollama phi3 iniciado."'

# Parar o servidor (e modelo junto)
alias ollama-stop='sudo pkill -f "/usr/local/bin/ollama serve" && echo "Ollama parado." || echo "Processo não encontrado."'

# Conversar com o modelo phi3 (modo interativo)
alias ollama-chat='ollama run phi3'

# comando boa noite
alias desligar="sudo shutdown now"

# Zen (para Hyprland)
alias zen="flatpak run app.zen_browser.zen &"

# GPU-switch
export PATH="$HOME/bin:$PATH"

# Servidor local
alias serverl="ssh 192.168.0.125"
