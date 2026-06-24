#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
BIN_PATH="${INSTALL_DIR}/mihomo"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require_cmd curl
require_cmd gzip
require_cmd grep
require_cmd head
require_cmd uname

os="$(uname -s | tr '[:upper:]' '[:lower:]')"
arch="$(uname -m)"

case "${os}" in
  linux) os_name="linux" ;;
  *)
    echo "Unsupported OS: ${os}" >&2
    exit 1
    ;;
esac

case "${arch}" in
  x86_64|amd64) arch_name="amd64" ;;
  aarch64|arm64) arch_name="arm64" ;;
  armv7l) arch_name="armv7" ;;
  *)
    echo "Unsupported architecture: ${arch}" >&2
    exit 1
    ;;
esac

tmp_dir="$(mktemp -d)"
cleanup() {
  rm -rf "${tmp_dir}"
}
trap cleanup EXIT

api_url="https://api.github.com/repos/MetaCubeX/mihomo/releases/latest"
release_json="${tmp_dir}/release.json"
curl -fsSL "${api_url}" -o "${release_json}"

asset_url="$(
  grep -Eo "https://[^\" ]*mihomo-${os_name}-${arch_name}-v[0-9]+\.[^\" ]*\\.gz" "${release_json}" |
    grep -vE "compatible|go[0-9]|debug|sha256|checksums" |
    head -n 1
)"

if [[ -z "${asset_url}" ]]; then
  asset_url="$(
    grep -Eo "https://[^\" ]*mihomo-${os_name}-${arch_name}[^\" ]*\\.gz" "${release_json}" |
      grep -vE "compatible|go[0-9]|debug|sha256|checksums" |
      head -n 1
  )"
fi

if [[ -z "${asset_url}" ]]; then
  echo "Could not find a Mihomo release asset for ${os_name}-${arch_name}." >&2
  exit 1
fi

archive="${tmp_dir}/mihomo.gz"
binary="${tmp_dir}/mihomo"

echo "Downloading ${asset_url}"
curl -fL "${asset_url}" -o "${archive}"
gzip -dc "${archive}" > "${binary}"
chmod +x "${binary}"

if [[ ! -d "${INSTALL_DIR}" ]]; then
  sudo mkdir -p "${INSTALL_DIR}"
fi

if [[ -w "${INSTALL_DIR}" ]]; then
  mv "${binary}" "${BIN_PATH}"
else
  sudo mv "${binary}" "${BIN_PATH}"
fi

"${BIN_PATH}" -v
echo "Installed: ${BIN_PATH}"
