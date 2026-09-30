#!/usr/bin/env bash
# Build kanata from this fork's source and install it (KobeTools fork).
# Run in MSYS2 / Git Bash on Windows with the Rust MSVC toolchain.
#
# Features: `gui` (tray icon, no console window) only. Not built: `tcp_server`
# (a network control port, upstream default), `cmd` (lets a config run shell
# commands), `interception_driver` (a kernel driver). The keyboard hook is the
# stock Windows low-level hook, no driver.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"
RUST_VERSION="${RUST_VERSION:-1.94.1}"

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) ;;
  *) echo "Run this on Windows (MSYS2 or Git Bash)." >&2; exit 1 ;;
esac

rustc_version="$(rustc --version 2>/dev/null | awk '{print $2}')"
[[ "$rustc_version" == "$RUST_VERSION" ]] || {
  echo "Rust $RUST_VERSION required (found ${rustc_version:-none}): rustup install $RUST_VERSION && rustup default $RUST_VERSION" >&2
  exit 1
}

echo "Building kanata $(git describe --tags --always) (gui only, no tcp_server/cmd)..."
cargo build --release --locked --no-default-features --features gui

dest="$(cygpath -u "$LOCALAPPDATA")/Programs/kanata"
mkdir -p "$dest"
taskkill //IM kanata.exe //F >/dev/null 2>&1 || true
cp target/release/kanata.exe "$dest/kanata.exe"
(cd "$dest" && sha256sum kanata.exe)
echo "Installed to $(cygpath -w "$dest")\\kanata.exe (unsigned: SmartScreen may ask)."
