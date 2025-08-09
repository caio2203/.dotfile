#!/bin/bash

show_wifi_networks() {
    echo "󰜉 Atualizando redes..."
    echo " Configurações de Rede"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Escanear redes
    nmcli device wifi rescan 2>/dev/null
    sleep 1
    
    # Obter rede atual
    current_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes:' | cut -d':' -f2)
    
    # Listar redes disponíveis
    nmcli -f SSID,SECURITY,SIGNAL,IN-USE dev wifi list | tail -n +2 | sort -k3 -nr | head -15 | while read -r line; do
        ssid=$(echo "$line" | awk '{print $1}')
        security=$(echo "$line" | awk '{print $2}')
        signal=$(echo "$line" | awk '{print $3}')
        in_use=$(echo "$line" | awk '{print $4}')
        
        if [ "$ssid" != "--" ] && [ ! -z "$ssid" ]; then
            if [ "$in_use" = "*" ] || [ "$ssid" = "$current_ssid" ]; then
                if [ "$security" = "--" ]; then
                    echo "● $ssid (${signal}%) 󰖩"
                else
                    echo "● $ssid (${signal}%) 󰖩"
                fi
            else
                if [ "$security" = "--" ]; then
                    echo "  $ssid (${signal}%) 󰖩"
                else
                    echo "  $ssid (${signal}%) 󰖩" 
                fi
            fi
        fi
    done
}

if [ "$1" = "wifi" ]; then
    choice=$(show_wifi_networks | wofi --dmenu --prompt "󰤨 Redes WiFi:" --width 450 --height 400)
    
    case "$choice" in
        "󰜉 Atualizando"*)
            # Ignorar
            ;;
        " Configurações"*)
            nm-connection-editor &
            ;;
        "━━━━━━━"*)
            # Ignorar separador
            ;;
        *)
            if [ ! -z "$choice" ] && [[ "$choice" == *")"* ]]; then
                # Extrair SSID
                ssid=$(echo "$choice" | sed 's/^[●] *//' | sed 's/ ([0-9]*%) .*//')
                
                if [[ "$choice" == *""* ]]; then
                    # Rede protegida
                    password=$(echo "" | wofi --dmenu --prompt " Senha para $ssid:" --password --width 350 --height 100)
                    if [ ! -z "$password" ]; then
                        if nmcli device wifi connect "$ssid" password "$password"; then
                            notify-send "󰖩 Rede" "Conectado a $ssid"
                        else
                            notify-send "❌ Rede" "Falha ao conectar a $ssid"
                        fi
                    fi
                else
                    # Rede aberta
                    if nmcli device wifi connect "$ssid"; then
                        notify-send "󰖩 Rede" "Conectado a $ssid"
                    else
                        notify-send "❌ Rede" "Falha ao conectar a $ssid"
                    fi
                fi
            fi
            ;;
    esac
else
    nm-connection-editor &
fi
