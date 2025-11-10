#!/usr/bin/env bash
set -euo pipefail

# 🎯 Configuração
PKG_NAME="rovium"
PKG_PATH="pkgs/by-name/ro/rovium/package.nix"
UPSTREAM_URL_BASE="https://rovium.dev/releases"

# 🚀 Descobre versão mais recente no site (ajusta se o padrão mudar)
LATEST_VERSION=$(curl -s "$UPSTREAM_URL_BASE/" | grep -Eo 'rovium_[0-9]+\.[0-9]+\.[0-9]+_amd64\.deb' | sort -V | tail -n 1 | sed -E 's/rovium_([0-9.]+)_amd64\.deb/\1/')

if [[ -z "$LATEST_VERSION" ]]; then
  echo "❌ Não foi possível detectar nova versão no upstream."
  exit 1
fi

echo "📦 Última versão detectada: $LATEST_VERSION"

# 🧮 Prefetch novo .deb e calcula hash
URL="$UPSTREAM_URL_BASE/rovium_${LATEST_VERSION}_amd64.deb"
HASH=$(nix-prefetch-url "$URL" 2>/dev/null)

echo "🔢 Novo hash: $HASH"

# 🧱 Atualiza package.nix
sed -i "s|version = \".*\";|version = \"$LATEST_VERSION\";|" "$PKG_PATH"
sed -i "s|url = \".*\";|url = \"$URL\";|" "$PKG_PATH"
sed -i "s|sha256 = \".*\";|sha256 = \"$HASH\";|" "$PKG_PATH"

# ✅ Testa build localmente
echo "🏗️ Testando build..."
nix build .#${PKG_NAME} -L

# 🧾 Abre PR automático no GitHub (se tiver hub instalado)
BRANCH="rovium-${LATEST_VERSION}"
git checkout -b "$BRANCH"
git add "$PKG_PATH"
git commit -m "${PKG_NAME}: update to ${LATEST_VERSION}"
git push origin "$BRANCH"

if command -v gh &>/dev/null; then
  gh pr create --fill --title "${PKG_NAME}: ${LATEST_VERSION}" --body "Update ${PKG_NAME} to version ${LATEST_VERSION}"
  echo "✅ PR criado automaticamente!"
else
  echo "🚀 PR pronto! Crie manualmente a partir da branch ${BRANCH}"
fi
