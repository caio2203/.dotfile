<img width="1918" height="1078" alt="image" src="https://github.com/user-attachments/assets/d475637d-9d5b-48a6-aab4-e8c71bf605f7" />


# Dotfiles

Minhas configurações pessoais para Arch Linux + Hyprland, gerenciadas com GNU Stow.

## Conteúdo

- **Hyprland** - Compositor Wayland
- **Kitty** - Terminal emulador
- **Neovim** - Editor de texto
- **Waybar** - Barra de status
- **Wofi** - Launcher de aplicações
- **Tmux** - Multiplexador de terminal
- **Zsh** - Shell
- **Oh My Posh** - Prompt customizado
- **Fastfetch** - Informações do sistema
- **GTK-3.0** - Temas GTK

## Instalação

### Pré-requisitos

```bash
sudo pacman -S stow git
```

### Clone o repositório

```bash
git clone https://github.com/seu-usuario/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Aplicar configurações

```bash
# Aplicar todas as configurações
stow */

# Ou aplicar individualmente
stow hypr
stow kitty
stow nvim
stow waybar
stow wofi
stow zsh
stow tmux
```

## Estrutura

```
~/dotfiles/
├── fastfetch/.config/fastfetch/
├── gtk-3.0/.config/gtk-3.0/
├── hypr/.config/hypr/
├── kitty/.config/kitty/
├── nvim/.config/nvim/
├── oh-my-posh/.config/oh-my-posh/
├── tmux/
├── waybar/.config/waybar/
├── wofi/.config/wofi/
├── xdg-desktop-portal/.config/xdg-desktop-portal/
└── zsh/
```

## Características

- Configuração modular com GNU Stow
- Tema consistente em todas as aplicações
- Fácil de manter e versionar
- Instalação simples e rápida
- Atualizações automáticas via symlinks

## Atualizando

Como o Stow usa symlinks, qualquer alteração nos arquivos é refletida automaticamente. Você só precisa rodar `stow` novamente ao adicionar novos arquivos ou pastas.

## Removendo configurações

```bash
# Remover todas
stow -D */

# Remover específica
stow -D kitty
```

## Dependências principais

```bash
# Hyprland e ferramentas essenciais
sudo pacman -S hyprland kitty waybar wofi

# Terminal e shell
sudo pacman -S zsh tmux

# Editor
sudo pacman -S neovim

# Fontes Nerd
sudo pacman -S ttf-jetbrains-mono-nerd ttf-firacode-nerd

# Utilitários
sudo pacman -S fastfetch
```

## Como usar

1. **Faça backup** das suas configurações atuais
2. Clone este repositório em `~/dotfiles`
3. Execute `stow */` para aplicar todas as configurações
4. Reinicie sua sessão ou recarregue os aplicativos

## Contribuindo

Sinta-se livre para usar essas configurações como base para as suas! Se encontrar algum problema ou tiver sugestões, abra uma issue.

## Licença

MIT License - sinta-se livre para usar e modificar.

## Inspiração

Estas dotfiles foram criadas para uso pessoal no Arch Linux com foco em produtividade e estética minimalista.

---

Se você gostou dessas configurações, considere dar uma estrela no repositório!
