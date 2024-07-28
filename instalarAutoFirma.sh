#!/bin/bash

# Función para mostrar ayuda
mostrar_ayuda() {
    echo "Instalador de AutoFirma para Chrome OS (https://github.com/davidjimeneztv/AutoFirma-ChromeOS)"
    echo "---------------------------------------"
    echo "Para instalar AutoFirma, introduce 'sudo bash $0 -i'."
    echo "Para desinstalar AutoFirma, introduce 'sudo bash $0 -d'."
    echo "Para leer la ayuda, introduce 'sudo bash $0 -h'."
    exit 0
}

# Función para instalar AutoFirma y opcionalmente Firefox
instalar() {
    echo "[INFO] >>> Iniciando la instalación de AutoFirma..."

    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y wget gnupg software-properties-common unzip libnspr4 libnss3 libnss3-tools default-jre

    # Preguntar si se quiere instalar Firefox
    read -p "[PREGUNTA] >>> ¿Quieres instalar Mozilla Firefox junto con AutoFirma? Será necesario para firmar documentos de Sedes Electrónicas e identificarte en alguna de ellas. (s/n): " instalar_firefox
    if [[ "$instalar_firefox" == "s" || "$instalar_firefox" == "S" ]]; then
        echo "[INFO] >>> Instalando Mozilla Firefox..."
        echo "[INFO] >>> Instalación de AutoFirma pausada hasta instalar Mozilla Firefox"
        
        sudo install -d -m 0755 /etc/apt/keyrings
        
        wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
        
        gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nLa huella digital coincide ("$0").\n"; else print "\nError de verificación: la huella digital ("$0") no coincide con la esperada.\n"}'
        
        echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null
        
        echo '
        Package: *
        Pin: origin packages.mozilla.org
        Pin-Priority: 1000
        ' | sudo tee /etc/apt/preferences.d/mozilla
        
        sudo apt-get update && sudo apt-get install -y firefox
        sudo apt-get install -y firefox-l10n-es
        echo "[RESULTADO] >>> Mozilla Firefox se instaló correctamente."
    fi

    # Descargar e instalar AutoFirma
    echo "[INFO] >>> Descargando e instalando AutoFirma..."
    wget https://github.com/davidjimeneztv/AutoFirma-ChromeOS/raw/main/AutoFirma_Linux_Debian.zip -O AutoFirma_Linux.zip
    unzip AutoFirma_Linux.zip
    rm AutoFirma_Linux.zip

    sudo dpkg -i AutoFirma*.deb
    rm AutoFirma*.deb

    echo "[RESULTADO] >>> AutoFirma se instaló correctamente."
    echo "[INFO] >>> Compruebe el menú de aplicaciones y compruebe que se instaló."
}

# Función para desinstalar AutoFirma y opcionalmente Firefox
desinstalar() {
    echo "[INFO] >>> Desinstalando AutoFirma de Chrome OS..."
    sudo apt-get remove libnspr4 libnss3 libnss3-tools default-jre autofirma
    echo "[RESULTADO] >>> AutoFirma se desinstaló correctamente."

    # Preguntar si se quiere desinstalar Firefox
    read -p "[PREGUNTA] >>> ¿Quieres desinstalar Mozilla Firefox? No seleccione esta opción si no tiene instalado Firefox (s/n): " desinstalar_firefox
    if [[ "$desinstalar_firefox" == "s" || "$desinstalar_firefox" == "S" ]]; then
        echo "[INFO] >>> Desinstalando Mozilla Firefox..."

        sudo rm /etc/apt/keyrings/packages.mozilla.org.asc
        sudo rm /etc/apt/sources.list.d/mozilla.list
        sudo rm /etc/apt/preferences.d/mozilla
        sudo apt-get remove --purge -y firefox firefox-esr activity-aware-firefox webext-ublock-origin-firefox libfirefox-marionette-perl
        sudo apt-get remove --purge -y firefox-esr-l10n-*

        echo "[RESULTADO] >>> Mozilla Firefox se desinstaló correctamente."
    fi

    sudo apt-get autoremove
}

# Verificar si se recibe -h para mostrar ayuda
if [ "$1" == "-h" ]; then
    mostrar_ayuda
fi

# Verificar si se ejecuta como root
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] >>> Por favor, ejecuta este script con privilegios de superadministrador. Ej: sudo bash $0"
    exit 0
fi

# Verificar los argumentos y ejecutar las funciones correspondientes
case $1 in
    -i)
        instalar
        ;;
    -d)
        desinstalar
        ;;
    *)
        mostrar_ayuda
        ;;
esac
