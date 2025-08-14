#!/bin/bash

# ~/.config/waybar/scripts/power-menu.sh - Versão corrigida

options="󰍁 Bloquear
󰍃 Sair da Sessão  
󰜉 Reiniciar
󰐥 Desligar
󰒲 Suspender"

choice=$(echo "$options" | wofi --dmenu --prompt "󰉁 Sistema:" --width 250 --height 220)

case "$choice" in
    *"󰍁"*|*"Bloquear"*)
        # Verificar se hyprlock está instalado
        if command -v hyprlock >/dev/null 2>&1; then
            hyprlock
        else
            notify-send "󰀦 Erro" "Nenhum bloqueador de tela instalado"
        fi
        ;;
    *"󰍃"*|*"Sair"*)
        hyprctl dispatch exit
        ;;
    *"󰜉"*|*"Reiniciar"*)
        systemctl reboot
        ;;
    *"󰐥"*|*"Desligar"*)
        systemctl poweroff
        ;;
    *"󰒲"*|*"Suspender"*)
        systemctl suspend
        ;;
    *)
        # Nada selecionado ou ESC pressionado
        exit 0
        ;;
esac
