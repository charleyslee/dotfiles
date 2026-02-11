#!/usr/bin/env bash
set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()  { echo -e "${BLUE}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[SKIP]${NC}  $*"; }

OS="$(uname -s)"
ARCH="$(uname -m)"
info "Detected OS: $OS ($ARCH)"

config() {
  /usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" "$@"
}

########################################
# Step 1: Clone bare repo
########################################
info "Step 1: Dotfiles bare repo"

if [ -d "$HOME/.cfg" ]; then
  warn "~/.cfg already exists, skipping clone"
else
  info "Cloning dotfiles bare repo..."
  git clone --bare git@github.com:charleyslee/dotfiles.git "$HOME/.cfg"

  # Attempt checkout, backing up conflicts
  if ! config checkout 2>/dev/null; then
    info "Backing up conflicting files to ~/.cfg-backup/"
    mkdir -p "$HOME/.cfg-backup"
    config checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | while read -r file; do
      mkdir -p "$HOME/.cfg-backup/$(dirname "$file")"
      mv "$HOME/$file" "$HOME/.cfg-backup/$file"
    done
    config checkout
  fi
  ok "Dotfiles checked out"
fi

config config --local status.showUntrackedFiles no

# Init/update submodules (zsh plugins)
info "Updating submodules..."
config submodule update --init --recursive
ok "Submodules up to date"

########################################
# Step 2: Install packages (OS-dependent)
########################################
info "Step 2: Installing packages"

if [ "$OS" = "Darwin" ]; then
  # --- macOS: Homebrew ---
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ok "Homebrew installed"
  else
    warn "Homebrew already installed"
  fi

  info "Running brew bundle..."
  brew bundle --file="$HOME/.Brewfile"
  ok "Homebrew packages installed"

elif [ "$OS" = "Linux" ]; then
  # --- Linux (Debian/Ubuntu): apt ---
  if command -v apt &>/dev/null; then
    info "Installing apt packages..."
    sudo apt update -y
    sudo apt install -y \
      git curl build-essential \
      tmux fish fzf fd-find bat jq tree \
      ripgrep direnv zoxide btop neofetch \
      git-lfs cmake gnupg libclang-dev

    ok "apt packages installed"

    # Starship
    if ! command -v starship &>/dev/null; then
      info "Installing starship..."
      curl -sS https://starship.rs/install.sh | sh -s -- -y
      ok "Starship installed"
    else
      warn "Starship already installed"
    fi

    # Nushell
    if ! command -v nu &>/dev/null; then
      info "Installing nushell..."
      NU_VERSION="0.108.0"
      NU_TAR="nu-${NU_VERSION}-${ARCH}-unknown-linux-gnu.tar.gz"
      curl -fsSL "https://github.com/nushell/nushell/releases/download/${NU_VERSION}/${NU_TAR}" -o "/tmp/${NU_TAR}"
      tar xzf "/tmp/${NU_TAR}" -C /tmp
      sudo cp "/tmp/nu-${NU_VERSION}-${ARCH}-unknown-linux-gnu/nu" /usr/local/bin/nu
      rm -rf "/tmp/${NU_TAR}" "/tmp/nu-${NU_VERSION}-${ARCH}-unknown-linux-gnu"
      ok "Nushell installed"
    else
      warn "Nushell already installed"
    fi

    # Zellij
    if ! command -v zellij &>/dev/null; then
      info "Installing zellij..."
      ZJ_VERSION="$(curl -fsSL https://api.github.com/repos/zellij-org/zellij/releases/latest | jq -r .tag_name)"
      curl -fsSL "https://github.com/zellij-org/zellij/releases/download/${ZJ_VERSION}/zellij-${ARCH}-unknown-linux-musl.tar.gz" -o /tmp/zellij.tar.gz
      tar xzf /tmp/zellij.tar.gz -C /tmp
      sudo cp /tmp/zellij /usr/local/bin/zellij
      rm -f /tmp/zellij /tmp/zellij.tar.gz
      ok "Zellij installed"
    else
      warn "Zellij already installed"
    fi

    # Lazygit
    if ! command -v lazygit &>/dev/null; then
      info "Installing lazygit..."
      LG_VERSION="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r .tag_name | sed 's/^v//')"
      [ "$ARCH" = "x86_64" ] && LG_ARCH="x86_64" || LG_ARCH="arm64"
      curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LG_VERSION}/lazygit_${LG_VERSION}_Linux_${LG_ARCH}.tar.gz" -o /tmp/lazygit.tar.gz
      tar xzf /tmp/lazygit.tar.gz -C /tmp lazygit
      sudo mv /tmp/lazygit /usr/local/bin/lazygit
      rm -f /tmp/lazygit.tar.gz
      ok "Lazygit installed"
    else
      warn "Lazygit already installed"
    fi

    # fnm (fast node manager)
    if ! command -v fnm &>/dev/null; then
      info "Installing fnm..."
      curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
      ok "fnm installed"
    else
      warn "fnm already installed"
    fi

    # mise
    if ! command -v mise &>/dev/null; then
      info "Installing mise..."
      curl https://mise.run | sh
      ok "mise installed"
    else
      warn "mise already installed"
    fi

    # Ghostty — no prebuilt Linux binary, print instructions
    if ! command -v ghostty &>/dev/null; then
      warn "Ghostty not installed — build from source: https://ghostty.org/docs/install"
    fi
  else
    warn "Unsupported Linux package manager (apt not found)"
  fi
fi

########################################
# Step 3: Install Rust/Cargo
########################################
info "Step 3: Rust toolchain"

if ! command -v rustup &>/dev/null; then
  info "Installing Rust via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
  ok "Rust installed"
else
  warn "Rust already installed"
fi

########################################
# Step 4: Install cargo packages
########################################
info "Step 4: Cargo packages"

CARGO_PKGS=(bob-nvim ripgrep tokei tree-sitter-cli)
for pkg in "${CARGO_PKGS[@]}"; do
  if cargo install --list 2>/dev/null | grep -q "^${pkg} "; then
    warn "cargo: $pkg already installed"
  else
    info "Installing cargo package: $pkg"
    cargo install "$pkg"
    ok "cargo: $pkg installed"
  fi
done

########################################
# Step 5: Install Neovim via bob
########################################
info "Step 5: Neovim (via bob)"

if command -v bob &>/dev/null; then
  if bob ls 2>/dev/null | grep -q "Used"; then
    warn "Neovim already installed via bob"
  else
    info "Installing Neovim stable via bob..."
    bob install stable
    bob use stable
    ok "Neovim installed via bob"
  fi
else
  warn "bob not found, skipping Neovim install (install cargo packages first)"
fi

########################################
# Step 6: Install Bun
########################################
info "Step 6: Bun"

if command -v bun &>/dev/null; then
  warn "Bun already installed"
else
  info "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
  ok "Bun installed"
fi

########################################
# Step 7: Install uv
########################################
info "Step 7: uv"

if command -v uv &>/dev/null; then
  warn "uv already installed"
else
  info "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ok "uv installed"
fi

########################################
# Step 8: Nerd Font (JetBrainsMono)
########################################
info "Step 8: JetBrainsMono Nerd Font"

if [ "$OS" = "Darwin" ]; then
  # Check if already installed via font file
  if ls "$HOME/Library/Fonts"/JetBrainsMonoNerdFont* &>/dev/null 2>&1 || \
     ls /Library/Fonts/JetBrainsMonoNerdFont* &>/dev/null 2>&1; then
    warn "JetBrainsMono Nerd Font already installed"
  else
    info "Installing JetBrainsMono Nerd Font..."
    brew install --cask font-jetbrains-mono-nerd-font 2>/dev/null || {
      warn "brew cask not available, download manually from https://www.nerdfonts.com/font-downloads"
    }
    ok "JetBrainsMono Nerd Font installed"
  fi
elif [ "$OS" = "Linux" ]; then
  FONT_DIR="$HOME/.local/share/fonts"
  if ls "$FONT_DIR"/JetBrainsMonoNerdFont* &>/dev/null 2>&1; then
    warn "JetBrainsMono Nerd Font already installed"
  else
    info "Installing JetBrainsMono Nerd Font..."
    mkdir -p "$FONT_DIR"
    NF_VERSION="$(curl -fsSL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r .tag_name)"
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/${NF_VERSION}/JetBrainsMono.tar.xz" -o /tmp/JetBrainsMono.tar.xz
    tar xJf /tmp/JetBrainsMono.tar.xz -C "$FONT_DIR"
    rm -f /tmp/JetBrainsMono.tar.xz
    fc-cache -fv "$FONT_DIR"
    ok "JetBrainsMono Nerd Font installed"
  fi
fi

########################################
# Step 9: Default shell
########################################
info "Step 9: Shell setup"

NU_PATH="$(command -v nu 2>/dev/null || true)"
if [ -n "$NU_PATH" ]; then
  if [ "$SHELL" = "$NU_PATH" ]; then
    warn "Default shell is already nushell"
  else
    info "To set nushell as your default shell, run:"
    info "  echo '$NU_PATH' | sudo tee -a /etc/shells"
    info "  chsh -s '$NU_PATH'"
  fi
else
  warn "nushell not found, skipping shell setup"
fi

########################################
echo ""
ok "Setup complete!"
