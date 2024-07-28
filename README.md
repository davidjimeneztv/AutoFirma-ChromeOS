# Instalador de AutoFirma para Chrome OS

Este script permite instalar y desinstalar AutoFirma, Mozilla Firefox y sus dependencias en Chrome OS.
Es necesario contar con Mozilla Firefox para firmar desde sitios webs o autenticarse en páginas de la administración española.

Si no va a firmar documentos ni autenticarse en sitios web de la administración, puede omitir la instalación de Mozilla Firefox y funcionará exclusivamente AutoFirma para firmar documentos PDF locales.

Los documentos PDF locales que desee firmar, deberán estar en "Archivos de Linux" junto con su certificado digital con el que desea realizar la firma.
Puede ver más detalle sobre como realizar la firma o autenticación en el siguiente tutorial: [LINK]

## Requisitos

- Chrome OS con Entorno de desarrollo Linux activo (penguin).
- Conexión a internet para descargar los paquetes necesarios.
- Al menos 1,5GB para disponer de todos los paquetes.
- Certificado digital válido.

## Instrucciones de Instalación

1. Descarga el script `instaladorAutoFirma.sh` desde Releases y guardalo en "Archivos de Linux" en el explorador de Chrome OS, después, dale permisos de ejecución desde la terminal:
    ```bash
    chmod +x instaladorAutoFirma.sh
    ```

2. Ejecuta el script con permisos de superusuario en la terminal para instalar AutoFirma, Mozilla Firefox y sus dependencias a medida que vaya avanzando el instalador:
    ```bash
    sudo bash instaladorAutoFirma.sh -instalar
    ```

## Instrucciones de Desinstalación

1. Para desinstalar AutoFirma, Mozilla Firefox y todas las dependencias instaladas, ejecuta el siguiente comando con permisos de superusuario en la terminal:
    ```bash
    sudo bash instaladorAutoFirma.sh -desinstalar
    ```

## Notas

- Se debe utilizar permisos de administrador en todo momento (sudo).
- Asegúrate de tener una conexión a internet estable durante el proceso de instalación y desinstalación.
- Debes contar con al menos 1,5GB de espacio para evitar errores por falta de almacenamiento a la hora de instalar AutoFirma, Mozilla Firefox y/o sus dependencias.
- Si encuentras algún problema durante la instalación o desinstalación, revisa los mensajes de error en la terminal para obtener más información, si no eres capaz de solucionarlo, abreme una "Issue" con el error que te aparece y te ayudo a resolverlo.

---

¡Espero que este instalador te sea útil!

Saludos,
David
