#!/bin/bash

show_bluetooth_options() {
    bt_status=$(bluetoothctl show | grep "Powered: yes")
    
    if [ -z "$bt_status" ]; then
        echo "󰂯 Ativar Bluetooth"
        echo "  Configurações"
    else
        echo "󰂲 Desativar Bluetooth"
        echo " Procurar Dispositivos"
        echo "  Configurações"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        # Mostrar dispositivos pareados
        bluetoothctl devices | while read -r device; do
            mac=$(echo "$device" | awk '{print $2}')
            name=$(echo "$device" | cut -d' ' -f3-)
            
            # Verificar se está conectado
            if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
                echo "● $name 󰂱"
            else
                echo "  $name 󰂯"
            fi
        done
    fi
}

choice=$(show_bluetooth_options | wofi --dmenu --prompt "󰂯 Bluetooth:" --width 400 --height 350)

case "$choice" in
    "󰂯 Ativar"*)
        bluetoothctl power on
        notify-send "🔵 Bluetooth" "Ativado"
        ;;
    "󰂲 Desativar"*)
        bluetoothctl power off
        notify-send "🔵 Bluetooth" "Desativado"
        ;;
    " Procurar"*)
        notify-send "🔵 Bluetooth" "Procurando dispositivos..."
        bluetoothctl scan on &
        sleep 5
        bluetoothctl scan off
        blueman-manager &
        ;;
    "  Configurações"*)
        blueman-manager &
        ;;
    *)
        if [ ! -z "$choice" ] && [ "$choice" != "━━━━━━━━━━━━━━━━━━━━━━━━━━━" ]; then
            device_name=$(echo "$choice" | sed 's/^[●] *//' | sed 's/ 󰂱$//' | sed 's/ 󰂯$//')
            mac=$(bluetoothctl devices | grep "$device_name" | awk '{print $2}')
            
            if [ ! -z "$mac" ]; then
                if [[ "$choice" == *"●"* ]]; then
                    # Desconectar
                    bluetoothctl disconnect "$mac"
                    notify-send "🔵 Bluetooth" "Desconectado de $device_name"
                else
                    # Conectar
                    bluetoothctl connect "$mac"
                    notify-send "🔵 Bluetooth" "Conectando a $device_name"
                fi
            fi
        fi
        ;;
esac
