#!/bin/sh
set -eu

org="puppetlabs"
repo="pdkgo"

app="pct"
appPkgName="pct"

noTel="${1:-false}"

if [ "$noTel" = "--no-telemetry" ]; then
  appPkgName="notel_pct"
fi

arch="x86_64"
os="$(uname -s | tr '[:upper:]' '[:lower:]')"
ext=".tar.gz"

releases="$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/${org}/${repo}/releases")"

ver="$(echo "$releases" | grep -oE -m 1 '"tag_name": "(([0-9]+\.)+[0-9]+(-pre+)?)"' | cut -d '"' -f 4 | head -1)"

file="${appPkgName}_${ver}_${os}_${arch}${ext}"

downloadURL="https://github.com/${org}/${repo}/releases/download/${ver}/${file}"

destination="${HOME}/.puppetlabs/pct"

[ -d "${destination}" ] || mkdir -p "${destination}"

if [ "$noTel" = "--no-telemetry" ]; then
    echo "Downloading and extracting ${app} ${ver} (TELEMETRY DISABLED VERSION) to ${destination}"
else
    echo "Downloading and extracting ${app} ${ver} to ${destination}"
fi

curl -L -s "${downloadURL}" -o - | tar xz -C "${destination}"

echo 'Remember to add the pct app to your path:'
echo 'export PATH=$PATH:'${destination}
