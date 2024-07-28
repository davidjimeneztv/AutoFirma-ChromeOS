#!/bin/bash

# Función para mostrar ayuda
mostrar_ayuda() {
    
    echo "Instalador de AutoFirma para Chrome OS (https://github.com/davidjimeneztv/AutoFirma-ChromeOS)"
    echo "---------------------------------------"
    echo "Para instalar AutoFirma, introduce 'sudo bash $0 -i'."
    echo "Para desinstalar AutoFirma, introduce 'sudo bash $0 -d'."
    echo "Para leer la ayuda, introduce 'sudo bash $0 -h
    exit 0
}

# Función para instalar AutoFirma y opcionalmente Firefox
instalar() {
    echo "Iniciando la instalación de AutoFirma..."

    sudo apt update
    sudo apt upgrade
    sudo apt install -y wget gnupg software-properties-common unzip libnspr4 libnss3 libnss3-tools default-jre

    # Preguntar si se quiere instalar Firefox
    read -p "¿Quieres instalar Mozilla Firefox junto con AutoFirma? Será necesario para firmar documentos de Sedes Electrónicas e identificarte en alguna de ellas. (s/n): " instalar_firefox
    if [[ "$instalar_firefox" == "s" || "$instalar_firefox" == "S" ]]; then
        echo "Instalando Mozilla Firefox..."
        
        sudo install -d -m 0755 /etc/apt/keyrings
        
        wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
        
        gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nLa huella digital coincide ("$0").\n"; else print "\nError de verificación: la huella digital ("$0") no coincide con la esperada.\n"}'
        
        echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
        
        echo '
        Package: *
        Pin: origin packages.mozilla.org
        Pin-Priority: 1000
        ' | sudo tee /etc/apt/preferences.d/mozilla
        
        sudo apt-get update && sudo apt-get install firefox
        sudo apt-get install firefox-l10n-es
    fi

    # Descargar e instalar AutoFirma
    echo "Descargando e instalando AutoFirma..."
    wget https:// -O AutoFirma_Linux.zip
    unzip AutoFirma_Linux.zip
    cd AutoFirma
    sudo ./AutoFirma_Install.run

    # Limpiar archivos descargados
    cd ..
    rm -rf AutoFirma AutoFirma_Linux.zip

    echo "Instalación completada."
}

# Función para desinstalar AutoFirma y opcionalmente Firefox
desinstalar() {
    echo "Iniciando la desinstalación de AutoFirma..."

    # Desinstalar AutoFirma
    echo "Desinstalando AutoFirma..."
    sudo /opt/AutoFirma/AutoFirma_Uninstall

    # Preguntar si se quiere desinstalar Firefox
    read -p "¿Quieres desinstalar Mozilla Firefox? (s/n): " desinstalar_firefox
    if [[ "$desinstalar_firefox" == "s" || "$desinstalar_firefox" == "S" ]]; then
        echo "Desinstalando Mozilla Firefox..."
        sudo apt remove -y firefox
        sudo apt autoremove -y
    fi

    echo "Desinstalación completada."
}

# Verificar si se recibe -h para mostrar ayuda
if [ "$1" == "-h" ]; then
    mostrar_ayuda
fi

# Verificar si se ejecuta como root
if [ "$EUID" -ne 0 ]; then
    echo "Por favor, ejecuta este script como root."
    mostrar_ayuda
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
