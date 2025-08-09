#!/bin/bash

# Verificar atualizações do dnf
updates=$(dnf check-update -q 2>/dev/null | grep -c "^[a-zA-Z]" || echo "0")

if [ "$updates" -gt 0 ]; then
    echo "󰚰 $updates"
else
    echo ""
fi
