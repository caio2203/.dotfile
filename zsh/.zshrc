# Carrega tmuxc
[ -f ~/.tmux_aliases ] && source ~/.tmux_aliases

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/themes/tema-neutro.json)"

# Auto-iniciar tmux
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmuxc
fi
