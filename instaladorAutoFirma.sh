#!/bin/bash

set -euo pipefail

################################################################################
# AutoFirma para ChromeOS
# https://github.com/davidjimeneztv/AutoFirma-ChromeOS
################################################################################

VERSION="2.0"

AUTOFIRMA_URL="https://firmaelectronica.gob.es/content/dam/firmaelectronica/descargas-software/autofirma19/Autofirma_Linux_Debian.zip"

TMP="/tmp/autofirma-installer"

ZIP="$TMP/autofirma.zip"

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m"

################################################################################

info() {

echo -e "${BLUE}[INFO]${NC} $1"

}

ok() {

echo -e "${GREEN}[OK]${NC} $1"

}

warn() {

echo -e "${YELLOW}[AVISO]${NC} $1"

}

error() {

echo -e "${RED}[ERROR]${NC} $1"

}

################################################################################

ayuda() {

cat <<EOF

AutoFirma para ChromeOS

Instalar:

sudo bash $0 -i

Actualizar:

sudo bash $0 -a

Desinstalar:

sudo bash $0 -d

Ayuda:

sudo bash $0 -h

EOF

exit 0

}

################################################################################

comprobar_root() {

if [ "$EUID" -ne 0 ]; then

error "Ejecute este script con sudo."

exit 1

fi

}

################################################################################

crear_tmp() {

rm -rf "$TMP"

mkdir -p "$TMP"

}

################################################################################

dependencias() {

info "Actualizando repositorios..."

apt update

PKGS=(
wget
curl
gnupg
ca-certificates
unzip
default-jre
libnspr4
libnss3
libnss3-tools
xdg-utils
)

if apt-cache show software-properties-common >/dev/null 2>&1; then
PKGS+=(software-properties-common)
fi

info "Instalando dependencias..."

apt install -y "${PKGS[@]}"

ok "Dependencias instaladas."

}

################################################################################

instalar_firefox() {

    read -rp "¿Desea instalar Mozilla Firefox? (s/n): " RESP

    case "$RESP" in
        s|S|si|SI|sí|Sí) ;;
        *) return 0 ;;
    esac

    info "Instalando Firefox..."

    # Repositorio oficial Mozilla
    install -d -m 0755 /etc/apt/keyrings

    if [ ! -f /etc/apt/keyrings/packages.mozilla.org.asc ]; then
        wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg \
            -O /etc/apt/keyrings/packages.mozilla.org.asc
    fi

    cat >/etc/apt/sources.list.d/mozilla.list <<EOF
deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main
EOF

    cat >/etc/apt/preferences.d/mozilla <<EOF
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

    apt update

    PAQUETE=""

    # Intentar firefox
    if apt install -y firefox; then
        PAQUETE="firefox"
    elif apt install -y firefox-esr; then
        PAQUETE="firefox-esr"
    else

        error "No ha sido posible instalar Firefox."

        read -rp "¿Continuar únicamente con AutoFirma? (s/n): " RESP2

        case "$RESP2" in
            s|S|si|SI|sí|Sí)
                return 0
                ;;
            *)
                exit 1
                ;;
        esac

    fi

    # Idioma (si existe)
    apt install -y firefox-l10n-es 2>/dev/null || true
    apt install -y firefox-esr-l10n-es 2>/dev/null || true

    ok "$PAQUETE instalado correctamente."

}

################################################################################

descargar_autofirma() {

crear_tmp

info "Descargando AutoFirma..."

wget -O "$ZIP" "$AUTOFIRMA_URL"

info "Descomprimiendo..."

mkdir "$TMP/zip"

unzip -oq "$ZIP" -d "$TMP/zip"

cd "$TMP/zip"

DEB=$(find . -name "*.deb" | head -n1)

if [ -z "$DEB" ]; then

error "No se encontró el paquete .deb."

exit 1

fi

info "Instalando AutoFirma..."

if ! dpkg -i "$DEB"; then

    warn "Corrigiendo dependencias..."

    apt-get install -f -y

    info "Reintentando instalación..."

    dpkg -i "$DEB"

fi

ok "AutoFirma instalada."

rm -rf "$TMP"

}

################################################################################

primera_ejecucion() {

BINARIO=""

if command -v AutoFirma >/dev/null 2>&1; then

    BINARIO="$(command -v AutoFirma)"

elif command -v autofirma >/dev/null 2>&1; then

    BINARIO="$(command -v autofirma)"

elif [ -x /usr/bin/AutoFirma ]; then

    BINARIO="/usr/bin/AutoFirma"

elif [ -x /usr/bin/autofirma ]; then

    BINARIO="/usr/bin/autofirma"

fi

if [ -n "$BINARIO" ]; then

    info "Realizando primera ejecución..."

    "$BINARIO" >/dev/null 2>&1 &

    PID=$!

    sleep 5

    kill "$PID" >/dev/null 2>&1 || true

fi

}

################################################################################

instalar() {

dependencias

instalar_firefox

descargar_autofirma

primera_ejecucion

echo

ok "Instalación completada."

echo

echo "Si alguna sede electrónica no detecta AutoFirma:"

echo

echo "  1. Abra AutoFirma."

echo "  2. Herramientas -> Restaurar instalación."

echo "  3. Reinicie Firefox."

echo

}

################################################################################

actualizar() {

descargar_autofirma

primera_ejecucion

ok "AutoFirma actualizada."

}

################################################################################

desinstalar() {

info "Desinstalando AutoFirma..."

if dpkg -l | grep -q autofirma; then

    apt purge -y autofirma

fi

apt autoremove -y

rm -rf ~/.afirma 2>/dev/null || true
rm -rf ~/.config/AutoFirma 2>/dev/null || true
rm -rf ~/.config/autofirma 2>/dev/null || true

echo

read -rp "¿Desinstalar Firefox? (s/n): " RESP

case "$RESP" in

s|S|si|SI|sí|Sí)

;;

*)

ok "Firefox conservado."

return

;;

esac

if dpkg -l | grep -q "^ii  firefox "; then

    apt purge -y firefox

fi

if dpkg -l | grep -q "^ii  firefox-esr "; then

    apt purge -y firefox-esr

fi

apt autoremove -y

ok "Firefox desinstalado."

ok "AutoFirma desinstalada."

}

################################################################################

case "${1:-}" in

-i)

comprobar_root

instalar

;;

-a)

comprobar_root

actualizar

;;

-d)

comprobar_root

desinstalar

;;

-h|--help|"")

ayuda

;;

*)

error "Opción no válida."

echo

ayuda

;;

esac

exit 0
