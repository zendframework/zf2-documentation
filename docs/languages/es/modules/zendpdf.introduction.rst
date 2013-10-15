.. EN-Revision: none
.. _zendpdf.introduction:

Introducción
============

El componente ``ZendPdf`` es un motor para manipular documentos *PDF* (Portable Document Format). Puede cargar,
crear, modificar y guardar documentos. Por lo tanto, puede ayudar a cualquier aplicación *PHP* a crear
dinámicamente documentos *PDF* modificando los documentos existentes o generar unos nuevos desde cero.
``ZendPdf`` ofrece las siguientes características:

   - Crear un documento nuevo o cargar uno existente. [#]_

   - Recuperar una determinada revisión del documento.

   - Manipular páginas desde dentro de un documento. Cambiar el orden de las páginas, añadir nuevas páginas,
     eliminar páginas de un documento.

   - Diferentes primitivas de dibujo (líneas, rectángulos, polígonos, círculos, elipses y sectores).

   - Dibujo de texto utilizando alguno de las 14 fuentes estándar (incorporadas) o sus propias fuentes
     personalizadas TrueType.

   - Rotaciones.

   - Dibujo de imágenes. [#]_

   - Actualización incremental de archivos *PDF*.





.. [#] La carga de documentos *PDF* V1.4 (Acrobat 5) ahora está soportada.
.. [#] Están soportados los formatos de imagen JPG, PNG [hasta 8bit por channel+Alpha] y TIFF.