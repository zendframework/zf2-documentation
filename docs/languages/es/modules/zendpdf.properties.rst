.. EN-Revision: none
.. _zendpdf.info:

Información del Documento y Metadatos
=====================================

Un documento *PDF* puede incluir información general como el título del documento, autor, la creación y
modificación de fechas.

Históricamente, esta información se almacena usando una estructura especial de Información. Esta estructura
está disponible para lectura y la escritura como una array asociativo utilizando propiedades públicas
``properties`` de objetos ``ZendPdf``:

   .. code-block:: php
      :linenos:

      $pdf = ZendPdf\Pdf::load($pdfPath);

      echo $pdf->properties['Title'] . "\n";
      echo $pdf->properties['Author'] . "\n";

      $pdf->properties['Title'] = 'New Title.';
      $pdf->save($pdfPath);



Las siguientes claves están definidas por v1.4 *PDF* (Acrobat 5) estándar:

   - **Title**- string, opcional, el título del documento.

   - **Author**- string, opcional, el nombre de la persona que creó el documento.

   - **Subject**- string, opcional, el tema del documento.

   - **Keywords**- string, opcional, las palabras clave asociadas con el documento.

   - **Creator**- string, opcional, si el documento se convirtió desde otro formato a *PDF*, el nombre de la
     aplicación (por ejemplo, Adobe FrameMaker ®) que creó el documento original a partir del cual se
     convirtió.

   - **Producer**- string, opcional, si el documento se convirtió desde otro formato a *PDF*, el nombre de la
     aplicación (por ejemplo, Acrobat Distiller), que lo convirtió a *PDF*.

   - **CreationDate**- string, opcional, la fecha y la hora en que el documento fue creado, en la forma siguiente:
     "D:YYYYMMDDHHmmSSOHH'mm'", en la que:

        - **YYYY** es el año.

        - **MM** es el mes.

        - **DD** es el día (01–31).

        - **HH** es la hora (00–23).

        - **mm** es el minuto (00–59).

        - **SS** es el segundo (00–59).

        - **O** es la relación de la hora local a la hora universal (UT), identificado por uno de los caracteres
          +, -, o Z (véase más adelante).

        - **HH** seguido de ' es el valor absoluto de la posición de la UT en horas (00-23).

        - **mm** seguido de ' es el valor absoluto de la posición de la UT en minutos (00-59).

     El carácter apóstrofe (') después de HH mm es parte de la sintaxis. Todos los campos después del año son
     opcionales. (El prefijo D:, aunque también opcional, se recomienda fuertemente.) Los valores por defecto para
     MM y DD son 01, y todos los demás valores numéricos de los campos son cero por defecto. Un signo más (+)
     como el valor del campo O significa que la hora local es más tarde que la UT, un signo menos (-) que la hora
     local es anterior a la UT, y la letra Z que la hora local es igual a la UT. Si no se especifica la
     información UT, la relación del tiempo especificado para UT se considera desconocida. Ya sea que la zona
     horaria se conozca o no, el resto de la fecha debe estar especificada en la hora local.

     Por ejemplo, el 23 de diciembre de 1998, a las 7:52 PM, hora estándar del Pacífico de EE.UU., está
     representado por el string "D:199812231952-08'00'".

   - **ModDate**- string, opcional, la fecha y la hora en que el documento fue modificado mas recientemente, de la
     misma forma que **CreationDate**.

   - **Trapped**- booleano, opcional, indica si el documento ha sido modificado para incluir la captura de
     información.

        - **TRUE**- El documento ha sido capturado; no se necesitan más capturas.

        - **FALSE**- El documento aún no ha sido capturado; cualquier captura todavía debe ser hecha.

        - **NULL**- O bien se desconoce si el documento ha sido capturado o que lo ha sido en parte pero no
          completamente capturado, y alguna captura adicional puede ser necesaria.





Desde *PDF* v 1.6 los metadatos se pueden almacenar en el documento *XML* especial adjunto al *PDF* (XMP
-`Extensible Metadata Platform`_).

Este documento *XML* se pueden recuperar y adjuntar al *PDF* con los métodos ``ZendPdf\Pdf::getMetadata()`` y
``ZendPdf\Pdf::setMetadata($metadata)``:

   .. code-block:: php
      :linenos:

      $pdf = ZendPdf\Pdf::load($pdfPath);
      $metadata = $pdf->getMetadata();
      $metadataDOM = new DOMDocument();
      $metadataDOM->loadXML($metadata);

      $xpath = new DOMXPath($metadataDOM);
      $pdfPreffixNamespaceURI = $xpath->query('/rdf:RDF/rdf:Description')
                                      ->item(0)
                                      ->lookupNamespaceURI('pdf');
      $xpath->registerNamespace('pdf', $pdfPreffixNamespaceURI);

      $titleNode = $xpath->query('/rdf:RDF/rdf:Description/pdf:Title')->item(0);
      $title = $titleNode->nodeValue;
      ...

      $titleNode->nodeValue = 'New title';
      $pdf->setMetadata($metadataDOM->saveXML());
      $pdf->save($pdfPath);



Las propiedades comunes del documento se duplican en la estructura de Info y el documento Metadata (si se
presentan). Ahora es responsabilidad del usuario la aplicación para mantenerlos sincronizados.



.. _`Extensible Metadata Platform`: http://www.adobe.com/products/xmp/
