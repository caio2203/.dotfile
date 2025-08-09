#!/bin/bash

if [ "$1" = "toggle" ]; then
    # Alternar entre perfis
    current=$(powerprofilesctl get 2>/dev/null || echo "balanced")
    case "$current" in
        "power-saver") powerprofilesctl set balanced ;;
        "balanced") powerprofilesctl set performance ;;
        "performance") powerprofilesctl set power-saver ;;
    esac
else
    # Mostrar perfil atual
    current=$(powerprofilesctl get 2>/dev/null || echo "balanced")
    case "$current" in
        "power-saver") echo "󰾆" ;;
        "performance") echo "󰓅" ;;
        *) echo "󰾅" ;;
    esac
fi
