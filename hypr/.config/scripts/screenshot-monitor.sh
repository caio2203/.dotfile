#!/bin/bash

# Screenshot Script - Estilo GNOME com Super+Shift+S
# Apenas símbolos Nerd Font

# Criar diretório se não existir
mkdir -p "$HOME/Imagens/Capturas de tela"

# Função para tirar screenshot
take_screenshot() {
    local mode="$1"
    local filename="screenshot-$(date +%Y%m%d-%H%M%S).png"
    local filepath="$HOME/Imagens/Capturas de tela/$filename"
    
    case "$mode" in
        "selection")
            # Área selecionada (padrão do GNOME)
            selection=$(slurp)
            if [ $? -eq 0 ]; then
                grim -g "$selection" "$filepath"
                notify-send "󰹑 Screenshot" "Área capturada" -t 2000
            else
                exit 1
            fi
            ;;
            
        "fullscreen")
            # Tela completa
            grim "$filepath"
            notify-send "󰹑 Screenshot" "Tela completa" -t 2000
            ;;
            
        "current-monitor")
            # Monitor atual
            cursor_pos=$(hyprctl cursorpos | tr -d ' ')
            cursor_x=$(echo $cursor_pos | cut -d',' -f1)
            cursor_y=$(echo $cursor_pos | cut -d',' -f2)
            
            monitor_info=$(hyprctl monitors -j | jq -r --argjson x "$cursor_x" --argjson y "$cursor_y" '
              .[] | select(
                .x <= $x and $x < (.x + .width) and 
                .y <= $y and $y < (.y + .height)
              ) | "\(.x),\(.y) \(.width)x\(.height)"
            ')
            
            if [ -z "$monitor_info" ]; then
                monitor_info=$(hyprctl monitors -j | jq -r '.[0] | "\(.x),\(.y) \(.width)x\(.height)"')
            fi
            
            grim -g "$monitor_info" "$filepath"
            notify-send "󰹑 Screenshot" "Monitor capturado" -t 2000
            ;;
            
        "active-window")
            # Janela ativa
            active_window=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
            if [ "$active_window" != "null,null 0x0" ]; then
                grim -g "$active_window" "$filepath"
                notify-send "󰹑 Screenshot" "Janela capturada" -t 2000
            else
                notify-send "󰀦 Erro" "Nenhuma janela ativa" -t 2000
                exit 1
            fi
            ;;
            
        "delayed")
            # Com delay (3 segundos)
            notify-send "󰔛 Screenshot" "Capturando em 3s..." -t 1000
            sleep 3
            grim "$filepath"
            notify-send "󰹑 Screenshot" "Tela capturada" -t 2000
            ;;
    esac
    
    # Copiar para clipboard
    if [ -f "$filepath" ]; then
        wl-copy < "$filepath"
    fi
}

# Menu estilo GNOME Screenshot
show_menu() {
    options="󰩭 Selecionar área
󰍹 Tela completa  
󰍺 Monitor atual
󰖲 Janela ativa
󰔛 Com delay (3s)"

    choice=$(echo "$options" | wofi --dmenu --prompt "󰹑 Screenshot" --width 250 --height 220)

    case "$choice" in
        *"󰩭"*)
            take_screenshot "selection"
            ;;
        *"󰍹"*)
            take_screenshot "fullscreen"
            ;;
        *"󰍺"*)
            take_screenshot "current-monitor"
            ;;
        *"󰖲"*)
            take_screenshot "active-window"
            ;;
        *"󰔛"*)
            take_screenshot "delayed"
            ;;
        *)
            exit 0
            ;;
    esac
}

# Verificar dependências essenciais
if ! command -v grim >/dev/null 2>&1 || ! command -v slurp >/dev/null 2>&1; then
    notify-send "󰀦 Erro" "Instale: grim slurp wl-clipboard jq" -t 3000
    exit 1
fi

# Executar menu
show_menu
