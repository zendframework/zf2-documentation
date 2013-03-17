.. EN-Revision: none
.. _zend.pdf.drawing:

Dibujo
======

.. _zend.pdf.drawing.geometry:

Geometría
---------

*PDF* utiliza la misma geometría que PostScript. Se inicia desde la parte inferior izquierda de la página y por
defecto se mide en puntos (1/72 de pulgada).

El tamaño de la página se puede recuperar desde un objeto página:



   .. code-block:: php
      :linenos:

      $width  = $pdfPage->getWidth();
      $height = $pdfPage->getHeight();



.. _zend.pdf.drawing.color:

Colores
-------

*PDF* tiene una poderosa capacidad de representación de colores. El módulo ``ZendPdf`` soporta la Escala de
Grises, y los espacios de color RGB y CMYK. Cualquiera de ellos puede ser usado en cualquier lugar, donde el objeto
``ZendPdf\Color`` sea requerido. Las clases ``ZendPdf_Color\GrayScale``, ``ZendPdf_Color\Rgb`` y
``ZendPdf_Color\Cmyk`` proporcionan esta funcionalidad:

.. code-block:: php
   :linenos:

   // $grayLevel (float number). 0.0 (black) - 1.0 (white)
   $color1 = new ZendPdf_Color\GrayScale($grayLevel);

   // $r, $g, $b (float numbers). 0.0 (min intensity) - 1.0 (max intensity)
   $color2 = new ZendPdf_Color\Rgb($r, $g, $b);

   // $c, $m, $y, $k (float numbers). 0.0 (min intensity) - 1.0 (max intensity)
   $color3 = new ZendPdf_Color\Cmyk($c, $m, $y, $k);

Los estilos de colores *HTML* también se proporcionan con la clase ``ZendPdf_Color\Html``:

.. code-block:: php
   :linenos:

   $color1 = new ZendPdf_Color\Html('#3366FF');
   $color2 = new ZendPdf_Color\Html('silver');
   $color3 = new ZendPdf_Color\Html('forestgreen');

.. _zend.pdf.drawing.shape-drawing:

Dibujo de Formas
----------------

Todas las operaciones de dibujo se puede hacer en un contexto de página *PDF*.

La clase ``ZendPdf\Page`` proporciona un conjunto de primitivas de dibujo:

.. code-block:: php
   :linenos:

   /**
    * Dibujar una línea desde x1,y1 hasta x2,y2.
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @return ZendPdf\Page
    */
   public function drawLine($x1, $y1, $x2, $y2);

.. code-block:: php
   :linenos:

   /**
    * Dibujar un rectángulo.
    *
    * Rellenar los tipos:
    * ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE - rellenar el rectángulo
    *                                             y delinearlo (por defecto)
    * ZendPdf\Page::SHAPE_DRAW_STROKE          - delinear el rectángulo
    * ZendPdf\Page::SHAPE_DRAW_FILL            - rellenar el rectángulo
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param integer $fillType
    * @return ZendPdf\Page
    */
   public function drawRectangle($x1, $y1, $x2, $y2,
                       $fillType = ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE);

.. code-block:: php
   :linenos:

   /**
    * Dibujar un polígono.
    *
    * Si $fillType es ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE o
    * ZendPdf\Page::SHAPE_DRAW_FILL, entonces el polígono se cierra automáticamente.
    * Véase la descripción detallada de estos métodos en la documentación de PDF
    * (sección 4.4.2 Path painting Operators, Filling)
    *
    * @param array $x  - array de float (la coordenada X de los vértices)
    * @param array $y  - array de float (la coordenada Y de los vértices)
    * @param integer $fillType
    * @param integer $fillMethod
    * @return ZendPdf\Page
    */
   public function drawPolygon($x, $y,
                               $fillType =
                                   ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE,
                               $fillMethod =
                                   ZendPdf\Page::FILL_METHOD_NON_ZERO_WINDING);

.. code-block:: php
   :linenos:

   /**
    * Dibujar un círculo centrado en X, y con un radio de radius.
    *
    * Los ángulos están especificados en radianes.
    *
    * Firmas del Método::
    * drawCircle($x, $y, $radius);
    * drawCircle($x, $y, $radius, $fillType);
    * drawCircle($x, $y, $radius, $startAngle, $endAngle);
    * drawCircle($x, $y, $radius, $startAngle, $endAngle, $fillType);
    *
    *
    * No es un círculo de verdad, porque PDF sólo admite curvas cúbicas de Bezier,
    * pero con muy buena aproximación.
    * Se distingue de un verdadero círculo en un máximo de 0.00026 radios (en PI/8,
    * 3*PI/8, 5*PI/8, 7*PI/8, 9*PI/8, 11*PI/8, 13*PI/8 y 15*PI/8 ángulos).
    * A 0, PI/4, PI/2, 3*PI/4, PI, 5*PI/4, 3*PI/2 y 7*PI/4 es exactamente
    * la tangente a un círculo.
    *
    * @param float $x
    * @param float $y
    * @param float $radius
    * @param mixed $param4
    * @param mixed $param5
    * @param mixed $param6
    * @return ZendPdf\Page
    */
   public function  drawCircle($x,
                               $y,
                               $radius,
                               $param4 = null,
                               $param5 = null,
                               $param6 = null);

.. code-block:: php
   :linenos:

   /**
    * Dibujar una elipse dentro del rectángulo especificado.
    *
    * Firmas del método:
    * drawEllipse($x1, $y1, $x2, $y2);
    * drawEllipse($x1, $y1, $x2, $y2, $fillType);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle, $fillType);
    *
    * Los ángulos se especifican en radianes
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param mixed $param5
    * @param mixed $param6
    * @param mixed $param7
    * @return ZendPdf\Page
    */
   public function drawEllipse($x1,
                               $y1,
                               $x2,
                               $y2,
                               $param5 = null,
                               $param6 = null,
                               $param7 = null);

.. _zend.pdf.drawing.text-drawing:

Dibujo de Texto
---------------

Las operaciones de dibujo de texto también existen en el contexto de una página *PDF*. Puede dibujar una sola
línea de texto en cualquier posición en la página mediante el suministro de las coordenadas X e Y de la base de
referencia. La fuente y tamaño actual de la letra se utilizan para operaciones de dibujo de texto (ver
descripción detallada más abajo).

.. code-block:: php
   :linenos:

   /**
    * Dibujar una línea de texto en una posición específica.
    *
    * @param string $text
    * @param float $x
    * @param float $y
    * @param string $charEncoding (opcional) Codificación de caracteres del texto
    * fuente. El valor por defecto es la codificación actual y local.
    * @throws ZendPdf\Exception
    * @return ZendPdf\Page
    */
   public function drawText($text, $x, $y, $charEncoding = '');

.. _zend.pdf.drawing.text-drawing.example-1:

.. rubric:: Dibujar un string en la página

.. code-block:: php
   :linenos:

   ...
   $pdfPage->drawText('Hello world!', 72, 720);
   ...

Por defecto, los strings de texto se interpretan usando el método de codificación de la localización actual. Si
tiene un string que utiliza un método de codificación diferente (como un string UTF-8 a leer desde un archivo en
disco, o un string MacRoman obtenido a partir del legado de una base de datos), puede indicar la codificación de
caracteres a llamar en tiempo de dibujo y ``ZendPdf`` se encargará de la conversión. Puede proporcionar la
fuente de cualquier método de codificación de strings soportados por la función de *PHP* *iconv()*:

.. _zend.pdf.drawing.text-drawing.example-2:

.. rubric:: Dibujar un string codificado en UTF-8 en la página

.. code-block:: php
   :linenos:

   ...
   // Leer del disco un string codificado en UTF-8
   $unicodeString = fread($fp, 1024);

   // Dibujar un string en la página
   $pdfPage->drawText($unicodeString, 72, 720, 'UTF-8');
   ...

.. _zend.pdf.drawing.using-fonts:

Uso de Fuentes
--------------

``ZendPdf\Page::drawText()`` utiliza la fuente y el tamaño actual de la fuente de la página, que se establece
con el método ``ZendPdf\Page::setFont()``:

.. code-block:: php
   :linenos:

   /**
    * Establecer la fuente actual.
    *
    * @param ZendPdf_Resource\Font $font
    * @param float $fontSize
    * @return ZendPdf\Page
    */
   public function setFont(ZendPdf_Resource\Font $font, $fontSize);

Los documentos *PDF* soportan fuentes PostScript Type 1 y TrueType, así como dos tipos especializados de *PDF*,
Type 3 y fuentes compuestas. También hay 14 fuentes estándar Tipo 1 incorporadas para cada visor *PDF*: Courier
(4 estilos), Helvetica (4 estilos), Times (4 estilos), Symbol y Zapf Dingbats.

``ZendPdf`` actualmente soporta el estándar de 14 fuentes *PDF*, así como sus propias fuentes personalizadas
TrueType. Los objetos Font se obtienen a través de una de los dos métodos de fábrica:
``ZendPdf\Font::fontWithName($fontName)`` para las 14 fuentes estándar *PDF* o
``ZendPdf\Font::fontWithPath($filePath)`` para fuentes personalizadas.

.. _zend.pdf.drawing.using-fonts.example-1:

.. rubric:: Crear un tipo de letra normal

.. code-block:: php
   :linenos:

   ...
   // Crear una fuente nueva
   $font = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_HELVETICA);

   // Aplicar la fuente
   $pdfPage->setFont($font, 36);
   ...

Los nombres de las 14 constantes para el tipo de letra estándar de PDF se definen en la clase ``ZendPdf\Font``:

   - ``ZendPdf\Font::FONT_COURIER``

   - ``ZendPdf\Font::FONT_COURIER_BOLD``

   - ``ZendPdf\Font::FONT_COURIER_ITALIC``

   - ``ZendPdf\Font::FONT_COURIER_BOLD_ITALIC``

   - ``ZendPdf\Font::FONT_TIMES``

   - ``ZendPdf\Font::FONT_TIMES_BOLD``

   - ``ZendPdf\Font::FONT_TIMES_ITALIC``

   - ``ZendPdf\Font::FONT_TIMES_BOLD_ITALIC``

   - ``ZendPdf\Font::FONT_HELVETICA``

   - ``ZendPdf\Font::FONT_HELVETICA_BOLD``

   - ``ZendPdf\Font::FONT_HELVETICA_ITALIC``

   - ``ZendPdf\Font::FONT_HELVETICA_BOLD_ITALIC``

   - ``ZendPdf\Font::FONT_SYMBOL``

   - ``ZendPdf\Font::FONT_ZAPFDINGBATS``



También puede utilizar cualquier fuente individual TrueType (que generalmente tiene una extensión '.ttf') o bien
una fuente OpenType (con la extensión '.otf') si contiene esquemas TrueType. Actualmente no están soportadas,
pero está previsto para una versión futura archivos de fuentes .dfont de Mac OS X y de Microsoft TrueType
Collection(extensión '.ttc').

Para utilizar una fuente TrueType, debe proporcionar toda la ruta del archivo a la fuente del programa. Si la
fuente no se puede leer por alguna razón, o si no es una fuente TrueType, el método de fábrica arrojará una
excepción:

.. _zend.pdf.drawing.using-fonts.example-2:

.. rubric:: Crear una fuente TrueType

.. code-block:: php
   :linenos:

   ...
   // Crear una nueva fuente
   $goodDogCoolFont = ZendPdf\Font::fontWithPath('/path/to/GOODDC__.TTF');

   // Aplicar la fuente
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...

Por defecto, las fuentes personalizadas serán incorporados en el documento *PDF* resultante. Esto permite que los
destinatarios vean la página como está previsto, incluso si no tienen los tipos de letra apropiados instalados en
su sistema. Si le preocupa el tamaño del archivo, puede pedir que la fuente del programa no sea integrada pasando
una opción 'do not embed' ("no incluir") al método de fábrica:

.. _zend.pdf.drawing.using-fonts.example-3:

.. rubric:: Crear una fuente TrueType, pero no incluirla en el documento PDF

.. code-block:: php
   :linenos:

   ...
   // Crear una nueva fuente
   $goodDogCoolFont = ZendPdf\Font::fontWithPath('/path/to/GOODDC__.TTF',
                                                  ZendPdf\Font::EMBED_DONT_EMBED);

   // Aplicar la fuente
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...

Si el programa no es de fuentes incrustadas, pero el destinatario del archivo *PDF* tiene instalada la fuente en su
sistema, va a ver el documento como estaba previsto. Si no tiene la fuente correcta instalada, la aplicación del
visor de *PDF* hará todo lo posible para sintetizar un sustituto.

Algunas fuentes tienen normas específicas de concesión de licencias que les impiden ser tenidas en cuenta en
documentos *PDF*. Así que no son capturados con la "guardia baja" por la presente, si intenta utilizar una fuente
que no puede ser incorporada, el método de fábrica lanzará una excepción.

Puede seguir utilizando esas fuentes, pero debe pasar el flag de no incluir como se ha descripto anteriormente, o
simplemente puede suprimir la excepción:

.. _zend.pdf.drawing.using-fonts.example-4:

.. rubric:: No arrojar una excepción para las fuentes que no puedan ser incorporadas

.. code-block:: php
   :linenos:

   ...
   $font = ZendPdf\Font::fontWithPath(
              '/path/to/unEmbeddableFont.ttf',
              ZendPdf\Font::EMBED_SUPPRESS_EMBED_EXCEPTION
           );
   ...

Esta técnica de supresión se prefiere si va a permitir a un usuario final a elegir sus propios tipos de letra.
Las fuentes que puedan ser embebidas en el documento *PDF*, lo harán, aquellos que no puedan, no.

Los de programas de fuentes pueden ser bastante grandes, algunas llegan a decenas de megabytes. Por defecto, todas
las fuentes incorporadas son comprimidas utilizando el esquema de compresión Flate, lo que resulta en un ahorro de
espacio del 50% en promedio. Si, por alguna razón, no desea comprimir la fuente del programa, se puede desactivar
con una opción:

.. _zend.pdf.drawing.using-fonts.example-5:

.. rubric:: No comprimir una fuente incrustada

.. code-block:: php
   :linenos:

   ...
   $font = ZendPdf\Font::fontWithPath('/path/to/someReallyBigFont.ttf',
                                       ZendPdf\Font::EMBED_DONT_COMPRESS);
   ...

Por último, en caso necesario, puede combinar las opciones de la integración mediante el operador binario OR:

.. _zend.pdf.drawing.using-fonts.example-6:

.. rubric:: La combinación de opciones de la incrustación de fuentes

.. code-block:: php
   :linenos:

   ...
   $font = ZendPdf\Font::fontWithPath(
               $someUserSelectedFontPath,
               (ZendPdf\Font::EMBED_SUPPRESS_EMBED_EXCEPTION |
               ZendPdf\Font::EMBED_DONT_COMPRESS));
   ...

.. _zend.pdf.drawing.standard-fonts-limitations:

Limitaciones de las fuentes PDF estándar
----------------------------------------

Las fuentes estándar *PDF* utilizan internamente varias codificaciones de un solo byte (véase `PDF Reference,
Sixth Edition, version 1.7`_ Apéndice D para más detalles). Son, en general, igual al conjunto de caracteres
Latin1 (excepto las fuentes ZapfDingbats y Symbol).

``ZendPdf`` usa CP1252 (WinLatin1) para dibujar el texto con las fuentes estándar.

El texto todavía se puede proporcionar en cualquier otra codificación, que debe ser especificada si ésta es
distinto de una fuente local actual. Realmente, sólo se dibujarán caracteres WinLatin1.

.. _zend.pdf.drawing.using-fonts.example-7:

.. rubric:: Combinación de opciones de la incrustación de fuentes

.. code-block:: php
   :linenos:

   ...
   $font = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_COURIER);
   $pdfPage->setFont($font, 36)
           ->drawText('Euro sign - €', 72, 720, 'UTF-8')
           ->drawText('Text with umlauts - à è ì', 72, 650, 'UTF-8');
   ...

.. _zend.pdf.drawing.extracting-fonts:

Extracción de las fuentes
-------------------------

El módulo ``ZendPdf`` proporciona una posibilidad de extraer las fuentes de los documentos cargados.

Puede ser útil para las actualizaciones incrementales de un documento. Sin esta funcionalidad tiene que agregar y
posiblemente, incrustar una fuente en un documento cada vez que desee actualizarlo.

Los objetos ``ZendPdf`` y ``ZendPdf\Page`` proporcionan métodos especiales para extraer todas las fuentes
mencionadas en un documento o una página:

.. _zend.pdf.drawing.extracting-fonts.example-1:

.. rubric:: Extracción de las fuentes de un documento cargado

.. code-block:: php
   :linenos:

   ...
   $pdf = ZendPdf\Pdf::load($documentPath);
   ...
   // Obtener todas las fuentes del documento
   $fontList = $pdf->extractFonts();
   $pdf->pages[] = ($page = $pdf->newPage(ZendPdf\Page::SIZE_A4));
   $yPosition = 700;
   foreach ($fontList as $font) {
       $page->setFont($font, 15);
       $fontName = $font->getFontName(ZendPdf\Font::NAME_POSTSCRIPT,
                                      'en',
                                      'UTF-8');
       $page->drawText($fontName . ': The quick brown fox jumps over the lazy dog',
                       100,
                       $yPosition,
                       'UTF-8');
       $yPosition -= 30;
   }
   ...
   // Obtener las fuentes referenciadas dentro de la primera página del documento
   $firstPage = reset($pdf->pages);
   $firstPageFonts = $firstPage->extractFonts();
   ...

.. _zend.pdf.drawing.extracting-fonts.example-2:

.. rubric:: Extracción de la fuente de un documento cargado especificando el nombre de la fuente

.. code-block:: php
   :linenos:

   ...
   $pdf = new ZendPdf\Pdf();
   ...
   $pdf->pages[] = ($page = $pdf->newPage(ZendPdf\Page::SIZE_A4));

   $font = ZendPdf\Font::fontWithPath($fontPath);
   $page->setFont($font, $fontSize);
   $page->drawText($text, $x, $y);
   ...
   // Este nombre de fuente debe ser almacenado en algún lugar...
   $fontName = $font->getFontName(ZendPdf\Font::NAME_POSTSCRIPT,
                                  'en',
                                  'UTF-8');
   ...
   $pdf->save($docPath);
   ...

.. code-block:: php
   :linenos:

   ...
   $pdf = ZendPdf\Pdf::load($docPath);
   ...
   $pdf->pages[] = ($page = $pdf->newPage(ZendPdf\Page::SIZE_A4));

   /* $srcPage->extractFont($fontName) también se puede usar aquí */
   $font = $pdf->extractFont($fontName);

   $page->setFont($font, $fontSize);
   $page->drawText($text, $x, $y);
   ...
   $pdf->save($docPath, true /* modo de actualización incremental */);
   ...

Las fuentes extraídas pueden ser utilizadas en el lugar de cualquier otra fuente con las siguientes limitaciones:

   - La fuente extraída puede ser usada sólo en el contexto del documento del que se ha extraído.

   - Posiblemente, el programa no extraiga realmente la fuente incrustada. Así que las fuentes extraídas no
     pueden proporcionar métricas correctas y la fuente original tiene que ser utilizada para los cálculos de
     ancho de texto:

        .. code-block:: php
           :linenos:

           ...
           $font = $pdf->extractFont($fontName);
           $originalFont = ZendPdf\Font::fontWithPath($fontPath);

           $page->setFont($font /* usar la fuente extraída para dibujar */, $fontSize);
           $xPosition = $x;
           for ($charIndex = 0; $charIndex < strlen($text); $charIndex++) {
               $page->drawText($text[$charIndex], xPosition, $y);

               // Usar la fuente original para calcular el ancho del texto
               $width = $originalFont->widthForGlyph(
                            $originalFont->glyphNumberForCharacter($text[$charIndex])
                        );
               $xPosition += $width/$originalFont->getUnitsPerEm()*$fontSize;
           }
           ...





.. _zend.pdf.drawing.image-drawing:

Dibujo de Imágenes
------------------

La clase ``ZendPdf\Page`` proporciona el método drawImage() para dibujar la imagen:

.. code-block:: php
   :linenos:

   /**
    * Dibujar una imagen en una posición específica de la página.
    *
    * @param ZendPdf_Resource\Image $image
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @return ZendPdf\Page
    */
   public function drawImage(ZendPdf_Resource\Image $image, $x1, $y1, $x2, $y2);

Los objetos imagen deben ser creados con el método ``ZendPdf\Image::imageWithPath($filePath)`` (imágenes JPG,
PNG y TIFF ahora son soportadas):

.. _zend.pdf.drawing.image-drawing.example-1:

.. rubric:: Dibujar una imagen

.. code-block:: php
   :linenos:

   ...
   // Cargar la imagen
   $image = ZendPdf\Image::imageWithPath('my_image.jpg');

   $pdfPage->drawImage($image, 100, 100, 400, 300);
   ...

**Importante! el soporte a JPEG requiere que se configure la extensión PHP GD.** **Importante! el soporte a PNG
requiere que se configure la extensión ZLIB para trabajar con imágenes canal Alfa.**

Consulte la documentación de *PHP* para obtener información detallada
(`http://www.php.net/manual/en/ref.image.php`_). (`http://www.php.net/manual/en/ref.zlib.php`_).

.. _zend.pdf.drawing.line-drawing-style:

Estilo de Dibujo de Líneas
--------------------------

El estilo del dibujo de líneas está definido por el ancho de línea, el color de línea y el patrón del tipo de
línea. Todo esto parámetros pueden ser asignados por los métodos de la clase ``ZendPdf\Page``:

.. code-block:: php
   :linenos:

   /** Establecer el color de la línea. */
   public function setLineColor(ZendPdf\Color $color);

   /** Establecer el ancho de la línea. */
   public function setLineWidth(float $width);

   /**
    * Establecer el patrón de líneas de guiones.
    *
    * El patrón es una array de números de punto flotante:
    *     array(on_length, off_length, on_length, off_length, ...)
    * La fase está desplazada lateralmente desde el comienzo de la línea.
    *
    * @param array $pattern
    * @param array $phase
    * @return ZendPdf\Page
    */
   public function setLineDashingPattern($pattern, $phase = 0);

.. _zend.pdf.drawing.fill-style:

Estilo Relleno
--------------

Los métodos ``ZendPdf\Page::drawRectangle()``, ``ZendPdf\Page::drawPolygon()``, ``ZendPdf\Page::drawCircle()``
y ``ZendPdf\Page::drawEllipse()`` toman el argumento ``$fillType`` como un parámetro opcional. Puede ser:

- ``ZendPdf\Page::SHAPE_DRAW_STROKE``- forma del trazo

- ``ZendPdf\Page::SHAPE_DRAW_FILL``- sólo llenar la forma

- ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE - llenar y trazar (comportamiento por defecto)

El método ``ZendPdf\Page::drawPolygon()`` también tiene un parámetro adicional ``$fillMethod``:

- ZendPdf\Page::FILL_METHOD_NON_ZERO_WINDING (comportamiento por defecto)

  :t:`PDF reference`  esta norma se describe como sigue:
  | La tortuosa regla del número distinto de cero determina si un punto está dentro de un camino de un rayo
  conceptual dibujado a partir de ese punto hasta el infinito en cualquier dirección y luego de examinar los
  lugares en los que un segmento de la ruta atraviesa el rayo. A partir de la cuenta de 0, la norma agrega 1 cada
  vez que un segmento de ruta atraviesa el rayo de izquierda a derecha y resta 1 cada vez que un segmento cruza de
  derecha a izquierda. Después de contar todos los cruces, si el resultado es 0, entonces el punto está fuera del
  camino; otra cosa es el interior. Nota: El método que acabamos de describir no especifica qué hacer si un
  segmento de ruta coincide con o es tangente al rayo elegido. Dado que la dirección de los rayos es arbitraria,
  la regla simplemente elige un rayo que no encuentre problemas con las intersecciones. Por simples caminos
  convexos, la regla del tortuoso número distinto de cero define el dentro y afuera como uno lo espera
  intuitivamente. Los casos más interesantes son aquellos que involucran la complejidad o las rutas
  auto-intersectadas como las que se muestran en la Figura 4.10 (en un *PDF* de referencia). Para un camino que
  consiste en una estrella de cinco puntas, dibujado con cinco segmentos conectados de líneas rectas
  intersectándose entre sí, la regla considera que el interior será toda el área delimitada por la estrella,
  incluido el pentágono en el centro. Para un camino compuesto por dos círculos concéntricos, las áreas de
  ambos círculos cerrados se consideran que están adentro, siempre que ambas se hayan dibujado en la misma
  dirección. Si los círculos son dibujados en direcciones opuestas, sólo la forma de "doughnut" (rosquilla)
  formada entre ellos es el interior, de acuerdo a la norma, el "agujero de la rosquilla" está afuera.



- ZendPdf\Page::FILL_METHOD_EVEN_ODD

  :t:`PDF reference`  describe esta norma como sigue:
  | Una alternativa al tortuoso número distinto de cero es la regla par-impar. Esta norma determina la
  "interioridad" de un punto por el dibujo de un rayo desde ese punto en cualquier dirección y simplemente
  contando el número de segmentos de ruta que atraviesan los rayos, independientemente de la dirección. Si este
  número es impar, el punto está adentro, si es par, el punto está afuera. Esto produce los mismos resultados
  que la regla del tortuoso número distinto de cero para caminos con formas simples, pero produce resultados
  diferentes para formas más complejas. La Figura 4.11 (en un *PDF* de referencia) muestra los efectos de la
  aplicación de la regla par-impar a las rutas complejss. Para la estrella de cinco puntas, la regla considera que
  los puntos del triángulo están dentro de la ruta, pero no el pentágono en el centro. Para los dos círculos
  concéntricos, sólo la forma de la "rosquilla" entre los dos círculo está considerada adentro,
  independientemente de las direcciones en las que se dibujen los círculos.



.. _zend.pdf.drawing.linear-transformations:

Transformaciones Lineales
-------------------------

.. _zend.pdf.drawing.linear-transformations.rotations:

Rotaciones
^^^^^^^^^^

La página *PDF* se puede rotar antes de aplicar cualquier operación de dibujo. Se puede hacer con el método
``ZendPdf\Page::rotate()``:

.. code-block:: php
   :linenos:

   /**
    * Rotar la página.
    *
    * @param float $x  - la coordenada X del punto de rotación
    * @param float $y  - la coordenada Y del punto de rotación
    * @param float $angle - ángulo de rotación
    * @return ZendPdf\Page
    */
   public function rotate($x, $y, $angle);

.. _zend.pdf.drawing.linear-transformations.scale:

A partir de Zend Framework 1.8, el escalado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La escala de transformación es proporcionada por el método: ``ZendPdf\Page::scale()``:

.. code-block:: php
   :linenos:

   /**
    * Establecer la escala al sistema de coordenadas.
    *
    * @param float $xScale - factor de escala de la dimensión X
    * @param float $yScale - factor de escala de la dimensión Y
    * @return ZendPdf\Page
    */
   public function scale($xScale, $yScale);

.. _zend.pdf.drawing.linear-transformations.translate:

A partir de Zend Framework 1.8, traducir
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El desplazamiento del sistema de coordenadas es realizado por el método ``ZendPdf\Page::translate()``:

.. code-block:: php
   :linenos:

   /**
    * Traducir sistema de coordenadas.
    *
    * @param float $xShift - desplazamiento de la coordenada X
    * @param float $yShift - desplazamiento de la coordenada Y
    * @return ZendPdf\Page
    */
   public function translate($xShift, $yShift);

.. _zend.pdf.drawing.linear-transformations.skew:

A partir de Zend Framework 1.8, el sesgo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El sesgo de una página se puede hacer utilizando el método ``ZendPdf\Page::skew()``:

.. code-block:: php
   :linenos:

   /**
    * Traducir sistema de coordenadas.
    *
    * @param float $x  - la coordenada X del eje del punto de sesgo
    * @param float $y  - la coordenada Y del eje del punto de sesgo
    * @param float $xAngle - ángulo de sesgo en el eje X
    * @param float $yAngle - ángulo de sesgo en el eje Y
    * @return ZendPdf\Page
    */
   public function skew($x, $y, $xAngle, $yAngle);

.. _zend.pdf.drawing.save-restore:

Guardar/Restaurar el estado de los gráficos
-------------------------------------------

En cualquier momento el estado de la página de gráficos (fuente actual, tamaño de la fuente, color de línea,
color de relleno, estilo de línea, rotación de la página, clip del área) se pueden guardar y restaurarlos
luego. Guardar la operación pone los datos a un estado de pila de gráficos, la operación de restauración se
recupera a partir de ahí.

Existen dos métodos en la clase ``ZendPdf\Page`` para estas operaciones:

.. code-block:: php
   :linenos:

   /**
    * Salva el estado de los gráficos de esta página.
    * Esta toma una instantánea del estilo aplicado actualmente, posición,
    * área de recorte y cualquier rotación/traducción/escalado que ha sido
    * aplicada.
    *
    * @return ZendPdf\Page
    */
   public function saveGS();

   /**
    * Restablecer los gráficos que se guardaron con la última llamada a
    * saveGS().
    *
    * @return ZendPdf\Page
    */
   public function restoreGS();

.. _zend.pdf.drawing.clipping:

Señalar el área de recorte
--------------------------

*PDF* y el módulo ``ZendPdf`` dan soporte de recorte a la zona de dibujo. La zona actual de Clip límita las
regiones de la página de los operadores afectados por la pintura. En principio, es la página entera.

La clase ``ZendPdf\Page`` proporciona un conjunto de métodos para las operaciones de recorte.

.. code-block:: php
   :linenos:

   /**
    * Intersectar el área actual de recorte con un rectángulo.
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @return ZendPdf\Page
    */
   public function clipRectangle($x1, $y1, $x2, $y2);

.. code-block:: php
   :linenos:

   /**
    * Intersectar el área actual de recorte con un polígono.
    *
    * @param array $x  - array de float (la coordenada X de los vértices)
    * @param array $y  - array de float (la coordenada Y de los vértices)
    * @param integer $fillMethod
    * @return ZendPdf\Page
    */
   public function clipPolygon($x,
                               $y,
                               $fillMethod =
                                   ZendPdf\Page::FILL_METHOD_NON_ZERO_WINDING);

.. code-block:: php
   :linenos:

   /**
    * Intersectar el área actual de recorte con un círculo.
    *
    * @param float $x
    * @param float $y
    * @param float $radius
    * @param float $startAngle
    * @param float $endAngle
    * @return ZendPdf\Page
    */
   public function clipCircle($x,
                              $y,
                              $radius,
                              $startAngle = null,
                              $endAngle = null);

.. code-block:: php
   :linenos:

   /**
    * Intersectar el área actual de recorte con una elipse.
    *
    * Firmas del método:
    * drawEllipse($x1, $y1, $x2, $y2);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle);
    *
    * @todo process special cases with $x2-$x1 == 0 or $y2-$y1 == 0
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param float $startAngle
    * @param float $endAngle
    * @return ZendPdf\Page
    */
   public function clipEllipse($x1,
                               $y1,
                               $x2,
                               $y2,
                               $startAngle = null,
                               $endAngle = null);

.. _zend.pdf.drawing.styles:

Estilos
-------

La clase ``ZendPdf\Style`` proporciona la funcionalidad de los estilos.

Los estilos se pueden utilizar para almacenar un conjunto de parámetros de estado del gráfico y aplicarlo a un
página *PDF* por una operación:

.. code-block:: php
   :linenos:

   /**
    * Establecer el estilo a utilizar para futuras operaciones de dibujo sobre esta página
    *
    * @param ZendPdf\Style $style
    * @return ZendPdf\Page
    */
   public function setStyle(ZendPdf\Style $style);

   /**
    * Regresar el estilo aplicado a la página.
    *
    * @return ZendPdf\Style|null
    */
   public function getStyle();

La clase ``ZendPdf\Style`` proporciona un conjunto de métodos para obtener o configurar diferentes parámetros de
estado de los gráficos:

.. code-block:: php
   :linenos:

   /**
    * Establecer el color de la línea.
    *
    * @param ZendPdf\Color $color
    * @return ZendPdf\Page
    */
   public function setLineColor(ZendPdf\Color $color);

.. code-block:: php
   :linenos:

   /**
    * Obtener el color de la línea.
    *
    * @return ZendPdf\Color|null
    */
   public function getLineColor();

.. code-block:: php
   :linenos:

   /**
    * Establecer el ancho de la línea.
    *
    * @param float $width
    * @return ZendPdf\Page
    */
   public function setLineWidth($width);

.. code-block:: php
   :linenos:

   /**
    * Obtener el ancho de la línea.
    *
    * @return float
    */
   public function getLineWidth();

.. code-block:: php
   :linenos:

   /**
    * Establecer el patrón de la línea de guiones
    *
    * @param array $pattern
    * @param float $phase
    * @return ZendPdf\Page
    */
   public function setLineDashingPattern($pattern, $phase = 0);

.. code-block:: php
   :linenos:

   /**
    * Obtener el patrón de la línea de guiones
    *
    * @return array
    */
   public function getLineDashingPattern();

.. code-block:: php
   :linenos:

   /**
    * Obtener la fase de la línea de guiones
    *
    * @return float
    */
   public function getLineDashingPhase();

.. code-block:: php
   :linenos:

   /**
    * Establecer el color de relleno.
    *
    * @param ZendPdf\Color $color
    * @return ZendPdf\Page
    */
   public function setFillColor(ZendPdf\Color $color);

.. code-block:: php
   :linenos:

   /**
    * Obtener el color de relleno.
    *
    * @return ZendPdf\Color|null
    */
   public function getFillColor();

.. code-block:: php
   :linenos:

   /**
    * Establecer la fuente actual.
    *
    * @param ZendPdf_Resource\Font $font
    * @param float $fontSize
    * @return ZendPdf\Page
    */
   public function setFont(ZendPdf_Resource\Font $font, $fontSize);

.. code-block:: php
   :linenos:

   /**
    * Modificar el tamaño de la fuente actual.
    *
    * @param float $fontSize
    * @return ZendPdf\Page
    */
   public function setFontSize($fontSize);

.. code-block:: php
   :linenos:

   /**
    * Obtener la fuente actual.
    *
    * @return ZendPdf_Resource\Font $font
    */
   public function getFont();

.. code-block:: php
   :linenos:

   /**
    * Obtener el tamaño de la fuente actual.
    *
    * @return float $fontSize
    */
   public function getFontSize();

.. _zend.pdf.drawing.alpha:

Transparencia
-------------

El módulo ``ZendPdf`` soporta el manejo de la transparencia.

La transparencia puede ser el método ``ZendPdf\Page::setAlpha()``:

   .. code-block:: php
      :linenos:

      /**
       * Establecer la transparencia.
       *
       * $alpha == 0  - transparente
       * $alpha == 1  - opaco
       *
       * Modos de transparencia soportados por PDF:
       * Normal (por defecto), Multiply, Screen, Overlay, Darken, Lighten,
       * ColorDodge, ColorBurn, HardLight, SoftLight, Difference, Exclusion
       *
       * @param float $alpha
       * @param string $mode
       * @throws ZendPdf\Exception
       * @return ZendPdf\Page
       */
      public function setAlpha($alpha, $mode = 'Normal');





.. _`PDF Reference, Sixth Edition, version 1.7`: http://www.adobe.com/devnet/acrobat/pdfs/pdf_reference_1-7.pdf
.. _`http://www.php.net/manual/en/ref.image.php`: http://www.php.net/manual/en/ref.image.php
.. _`http://www.php.net/manual/en/ref.zlib.php`: http://www.php.net/manual/en/ref.zlib.php
