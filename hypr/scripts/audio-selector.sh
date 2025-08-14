#!/bin/bash
# ~/.config/hypr/scripts/audio-selector.sh - Versão 5, com nomes de variáveis corretos

# Função genérica para gerar o menu.
generate_menu() {
    local type="$1" # "sinks" ou "sources"
    local default_device_name=$(pactl get-default-${type%s})

    # O comando awk, agora com um nome de variável seguro ("def_dev")
    pactl list short "$type" | awk -v def_dev="$default_device_name" '
    BEGIN {
        # Tradução e palavra-chave
        FIELD_NAME = "Nome:"
        FIELD_DESC = "Descrição:"
        
        # Cria o mapa de descrições lendo a saída completa UMA VEZ.
        cmd = "pactl list '"$type"'"
        while ((cmd | getline line) > 0) {
            if (line ~ FIELD_NAME) {
                split(line, parts, ": ")
                current_name = parts[2]
            }
            if (line ~ FIELD_DESC) {
                split(line, parts, ": ")
                desc = parts[2]
                descriptions[current_name] = desc
            }
        }
        close(cmd)
    }
    {
        # Processa a lista curta para construir o menu
        device_name = $2
        
        # Pega a descrição do nosso mapa
        desc = descriptions[device_name]

        # Pula monitores de áudio e entradas vazias
        if (desc ~ /^Monitor of / || desc == "") {
            next
        }
        
        # Formata a linha para o wofi
        if (device_name == def_dev) {
            printf "● %s\n", desc
        } else {
            printf "  %s\n", desc
        }
    }'
}

# Converte a descrição amigável de volta para o nome técnico
get_name_from_desc() {
    local type="$1"
    local target_desc="$2"

    pactl list "$type" | awk -v target="$target_desc" '
    BEGIN { 
        RS = ""; # Modo de parágrafo
        FIELD_NAME = "Nome:"
        FIELD_DESC = "Descrição:"
    }
    {
        name = ""
        desc = ""
        # Itera sobre as linhas do bloco
        for (i = 1; i <= NF; i++) {
            if ($i ~ FIELD_NAME) {
                split($i, parts, ": ")
                name = parts[2]
            }
            if ($i ~ FIELD_DESC) {
                split($i, parts, ": ")
                desc = parts[2]
            }
        }
        if (desc == target) {
            print name
            exit
        }
    }'
}

# Lógica principal do script
case "$1" in
    output)
        prompt="󰕾 Saída de Áudio"
        type="sinks"
        ;;
    input)
        prompt="󰍬 Entrada de Áudio"
        type="sources"
        ;;
    *)
        pavucontrol &
        exit 0
        ;;
esac

menu_options=$(generate_menu "$type")

if [ -z "$menu_options" ]; then
    notify-send "Erro de Áudio" "Nenhum dispositivo do tipo '$type' foi encontrado."
    exit 1
fi

choice=$(echo -e "$menu_options" | wofi --dmenu --prompt "$prompt" --width 550 --height 300)

if [ -n "$choice" ]; then
    target_desc=$(echo "$choice" | sed -e 's/^● //' -e 's/^  //')
    device_name=$(get_name_from_desc "$type" "$target_desc")
    
    if [ -n "$device_name" ]; then
        pactl set-default-${type%s} "$device_name"
        notify-send "Áudio" "Dispositivo ativo:\n$target_desc" -i "audio-headphones"
    fi
fi
