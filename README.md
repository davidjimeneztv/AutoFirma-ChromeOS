## 💻 **Instalación de AutoFirma en Chromebook/Chrome OS**

### **Descripción**

Este repositorio proporciona una guía detallada y el instalador que te permite instalar y configurar la aplicación AutoFirma en un Chromebook o un dispositivo que utilice Chrome OS/Chrome OS Flex. AutoFirma es una herramienta esencial para la firma electrónica de documentos a día de hoy, ya que permite realizar multitud de trámites en las administraciones públicas, organismos y ayuntamientos de forma rápida y sin desplazamientos. Una aplicación esencial en sistemas de escritorio.

### **Requisitos Previos**

* **Chromebook o dispositivo con Chrome OS:** Asegúrate de tener un Chromebook o un dispositivo que ejecute Chrome OS.
* **Acceso a internet:** Necesitarás conexión a internet para descargar los archivos necesarios.
* **Habilidades básicas de línea de comandos:** Algunos comandos de terminal serán utilizados durante el proceso de instalación. Te proporcionaré comandos e instrucciones para que los introduzcas en la terminal incluso si no tienes conocimiento sobre terminales de línea de comandos.

### **INSTALACIÓN DE AUTOFIRMA:**

1. **Activar el entorno de desarrollo de Linux:**
   * Accede a la Configuración de tu dispositivo Chrome > Información de ChromeOS > Desarrolladores: Activar entorno de desarrollo Linux. Si no aparece esta opción, es posible que tu dispositivo no sea compatible o tu administrador no permita activarlo (en el caso de dispositivos Chrome gestionados para empresas o instituciones educativas).
   * Pulsamos sobre Configurar para iniciar el asistente de instalación del entorno de desarrollo Linux.
   * Debemos especificar un usuario para Linux, puedes establecer el que quieras excepto "root".
   * Debemos revisar que el tamaño recomendado de Linux sea superior a 1,5GB que es lo mínimo necesario para ejecutar AutoFirma y Mozilla Firefox en Chrome.

2. **Descarga y Ejecución del Instalador:**
   * Descargamos la versión más reciente del archivo `instaladorAutoFirma.sh` pulsando [aquí](https://github.com/davidjimeneztv/AutoFirma-ChromeOS/releases/latest), después, guárdalo en "Archivos de Linux" para que sea accesible desde la terminal.
   * Abre la terminal de Chrome o utiliza la que se ha debido de abrir al finalizar la instalación.
   * Dentro de la terminal, escribe lo siguiente y pulsa la tecla "Enter":
     ```bash
     sudo bash instaladorAutoFirma.sh -i
     ```
     Comenzará la actualización del chromebook y la instalación de las dependencias.
3. **Instalación de Mozilla Firefox:**
   * Cuando se pregunte si deseas instalar Mozilla Firefox, debes escribir S para instalarlo o N para no instalarlo. Recomiendo que lo instales ya que no todas las Sedes Electrónicas te permitirán acceder con Google Chrome, además, ahorrará mucho tiempo al firmar documentos ya que detectará automáticamente el certificado dentro de Firefox sin tener que seleccionarlo en múltiples ocasiones.
4. **Verificar instalación:**
   * Una vez instalado, encontrarás en el menú de aplicaciones una carpeta llamada "Aplicaciones de Linux" donde encontrarás AutoFirma y Mozilla Firefox si decidiste instalarlo.
   * Ejecuta tanto AutoFirma como Mozilla (si está instalado) y comprueba que funciona correctamente.

### **OTROS COMANDOS (DESINSTALAR y AYUDA):**

* **Desinstalar AutoFirma:**
  Para desinstalar AutoFirma, introduce el siguiente comando en la terminal:
  ```bash
  sudo bash instaladorAutoFirma.sh -d
  ```
* **Obtener ayuda:**
  Este comando te permitirá obtener una lista con los comandos disponibles del instalador.
  ```bash
  sudo bash instaladorAutoFirma.sh -h
  ```

### **Solución de Problemas y recursos**

* **Problemas comunes:**
  * **Permisos:** Asegurate de que tu dispositivo no está administrado por un instituto/colegio o una empresa. Los administradores de estos equipos pueden bloquear la instalación de apps o la activación del Entorno de desarrollo Linux.
  * **Nombre del archivo**: En el comando se te indica que introduzcas `sudo bash instaladorAutoFirma.sh ...` pero si has cambiado el nombre del archivo al descargarlo, deberás cambiarlo también en el comando.

* **Video tutorial:** [https://www.youtube.com/watch?v=eGFjd9IpgJI](https://www.youtube.com/watch?v=eGFjd9IpgJI)

## Selección del certificado en caso de no instalar Mozilla Firefox
Para seleccionar el certificado, debe de disponer de su archivo (.pfx, .p12, ...) dentro de "Archivos de Linux" para que AutoFirma lo pueda leer.

Una vez se le solicite seleccionar su certificado, tendrá que cambiar el almacén de certificados a "Archivo local".
![image](https://github.com/user-attachments/assets/2bcbae63-cb7b-4449-8809-a6f4049c02f4)

Una vez seleccione el certificado digital que debe estar en "Archivos de Linux", aparecerá su certificado.
Saludos,
David
