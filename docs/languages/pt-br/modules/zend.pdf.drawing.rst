.. _zend.pdf.drawing:

Desenhando
==========

.. _zend.pdf.drawing.geometry:

Geometria
---------

O *PDF* usa a mesma geometria do PostScript. A geometria começa no canto inferior esquerdo da página e, por
padrão, é medida em pontos (1/72 de polegada).

O tamanho da página pode ser recuperado de um objeto página:

.. code-block:: php
   :linenos:

   $width  = $pdfPage->getWidth();
   $height = $pdfPage->getHeight();

.. _zend.pdf.drawing.color:

Cores
-----

O *PDF* possui uma poderosa capacidade para a representação de cores. O módulo ``Zend_Pdf`` dá suporte à
Escala de Cinza, RGB e CMYK. Qualquer um deles pode ser usado em qualquer lugar onde um ``Zend_Pdf_Color`` for
requisitado. As classes ``Zend_Pdf_Color_GrayScale``, ``Zend_Pdf_Color_Rgb`` e ``Zend_Pdf_Color_Cmyk`` fornecem a
seguinte funcionalidade:

.. code-block:: php
   :linenos:

   // $grayLevel (float number). 0.0 (black) - 1.0 (white)
   $color1 = new Zend_Pdf_Color_GrayScale($grayLevel);

   // $r, $g, $b (float numbers). 0.0 (min intensity) - 1.0 (max intensity)
   $color2 = new Zend_Pdf_Color_Rgb($r, $g, $b);

   // $c, $m, $y, $k (float numbers). 0.0 (min intensity) - 1.0 (max intensity)
   $color3 = new Zend_Pdf_Color_Cmyk($c, $m, $y, $k);

O estilo de cores do *HTML* também é fornecido na classe ``Zend_Pdf_Color_Html``:

.. code-block:: php
   :linenos:

   $color1 = new Zend_Pdf_Color_Html('#3366FF');
   $color2 = new Zend_Pdf_Color_Html('silver');
   $color3 = new Zend_Pdf_Color_Html('forestgreen');

.. _zend.pdf.drawing.shape-drawing:

Desenhando Formas
-----------------

Todas as operações de desenho podem ser feitas no contexto de uma página *PDF*.

A classe ``Zend_Pdf_Page`` provê um conjunto de formas básicas para desenho:

.. code-block:: php
   :linenos:

   /**
    * Desenha uma linha de x1,y1 até x2,y2.
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @return Zend_Pdf_Page
    */
   public function drawLine($x1, $y1, $x2, $y2);

.. code-block:: php
   :linenos:

   /**
    * Desenha um retângulo.
    *
    * Tipos de preenchimento:
    * Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE - preenche o retângulo
    *                                             e o traço (padrão)
    * Zend_Pdf_Page::SHAPE_DRAW_STROKE          - traço do retângulo
    * Zend_Pdf_Page::SHAPE_DRAW_FILL            - preenche o retângulo
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param integer $fillType
    * @return Zend_Pdf_Page
    */
   public function drawRectangle($x1, $y1, $x2, $y2,
                       $fillType = Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE);

.. code-block:: php
   :linenos:

   /**
    * Desenha um retângulo arredondado.
    *
    * Tipos de preenchimento:
    * Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE - preenche o retângulo
    *                                             e o traço (padrão)
    * Zend_Pdf_Page::SHAPE_DRAW_STROKE          - traço do retângulo
    * Zend_Pdf_Page::SHAPE_DRAW_FILL            - preenche o retângulo
    *
    * radius é um inteiro que representa o raio dos quatro cantos, ou uma matriz
    * de quatro números inteiros que representam o raio a partir do superior
    * esquerdo, indo no sentido horário
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param integer|array $radius
    * @param integer $fillType
    * @return Zend_Pdf_Page
    */
   public function drawRoundedRectangle($x1, $y1, $x2, $y2, $radius,
                          $fillType = Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE);

.. code-block:: php
   :linenos:

   /**
    * Desenha um polígono.
    *
    * If $fillType is Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE or
    * Zend_Pdf_Page::SHAPE_DRAW_FILL, then polygon is automatically closed.
    * See detailed description of these methods in a PDF documentation
    * (section 4.4.2 Path painting Operators, Filling)
    *
    * @param array $x  - array of float (the X co-ordinates of the vertices)
    * @param array $y  - array of float (the Y co-ordinates of the vertices)
    * @param integer $fillType
    * @param integer $fillMethod
    * @return Zend_Pdf_Page
    */
   public function drawPolygon($x, $y,
                               $fillType =
                                   Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE,
                               $fillMethod =
                                   Zend_Pdf_Page::FILL_METHOD_NON_ZERO_WINDING);

.. code-block:: php
   :linenos:

   /**
    * Draw a circle centered on x, y with a radius of radius.
    *
    * Angles are specified in radians
    *
    * Method signatures:
    * drawCircle($x, $y, $radius);
    * drawCircle($x, $y, $radius, $fillType);
    * drawCircle($x, $y, $radius, $startAngle, $endAngle);
    * drawCircle($x, $y, $radius, $startAngle, $endAngle, $fillType);
    *
    *
    * It's not a really circle, because PDF supports only cubic Bezier
    * curves. But very good approximation.
    * It differs from a real circle on a maximum 0.00026 radiuses (at PI/8,
    * 3*PI/8, 5*PI/8, 7*PI/8, 9*PI/8, 11*PI/8, 13*PI/8 and 15*PI/8 angles).
    * At 0, PI/4, PI/2, 3*PI/4, PI, 5*PI/4, 3*PI/2 and 7*PI/4 it's exactly
    * a tangent to a circle.
    *
    * @param float $x
    * @param float $y
    * @param float $radius
    * @param mixed $param4
    * @param mixed $param5
    * @param mixed $param6
    * @return Zend_Pdf_Page
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
    * Draw an ellipse inside the specified rectangle.
    *
    * Method signatures:
    * drawEllipse($x1, $y1, $x2, $y2);
    * drawEllipse($x1, $y1, $x2, $y2, $fillType);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle, $fillType);
    *
    * Angles are specified in radians
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param mixed $param5
    * @param mixed $param6
    * @param mixed $param7
    * @return Zend_Pdf_Page
    */
   public function drawEllipse($x1,
                               $y1,
                               $x2,
                               $y2,
                               $param5 = null,
                               $param6 = null,
                               $param7 = null);

.. _zend.pdf.drawing.text-drawing:

Desenhando Texto
----------------

As operações de desenho de texto também existem no contexto de uma página *PDF*. Você pode desenhar uma linha
de texto em qualquer posição da página ao fornecer as coordenadas x e y. A fonte e o tamanho da fonte atuais
são usadas para a operação de desenho (veja a descrição detalhada abaixo).

.. code-block:: php
   :linenos:

   /**
    * Draw a line of text at the specified position.
    *
    * @param string $text
    * @param float $x
    * @param float $y
    * @param string $charEncoding (optional) Character encoding of source
    *               text.Defaults to current locale.
    * @throws Zend_Pdf_Exception
    * @return Zend_Pdf_Page
    */
   public function drawText($text, $x, $y, $charEncoding = '');

.. _zend.pdf.drawing.text-drawing.example-1:

.. rubric:: Desenhar uma string na página

.. code-block:: php
   :linenos:

   ...
   $pdfPage->drawText('Olá mundo!', 72, 720);
   ...

Por padrão, as strings de texto são interpretadas usando o método de decodificação e caracteres local. Se
você tiver uma string que use um método de codificação diferente (como uma string UTF-8 sendo lida de um
arquivo no disco, ou uma string MacRoman obtida de um bando de dados legado), você pode a codificação na hora de
desenhar e a ``Zend_Pdf`` irá tratar a comunicação para você. Você pode fornecer as strings em qualquer
método de codificação suportada pela função *iconv()* do *PHP*:

.. _zend.pdf.drawing.text-drawing.example-2:

.. rubric:: Desenhar uma string codificada em UTF-8 em uma página

.. code-block:: php
   :linenos:

   ...
   // Read a UTF-8-encoded string from disk
   $unicodeString = fread($fp, 1024);

   // Draw the string on the page
   $pdfPage->drawText($unicodeString, 72, 720, 'UTF-8');
   ...

.. _zend.pdf.drawing.using-fonts:

Usando fontes
-------------

O método ``Zend_Pdf_Page::drawText()`` usa a fonte atual da página, que é configurada através do método
``Zend_Pdf_Page::setFont()``:

.. code-block:: php
   :linenos:

   /**
    * Set current font.
    *
    * @param Zend_Pdf_Resource_Font $font
    * @param float $fontSize
    * @return Zend_Pdf_Page
    */
   public function setFont(Zend_Pdf_Resource_Font $font, $fontSize);

Documentos *PDF* suportam as fontes PostScript Type 1 e TrueType, assim como dois tipos especiais do *PDF*, o Type
3 e as fontes compostas. Existem também 14 fontes padrão Type 1 inclusas em todos os visualizadores de *PDF*:
Courier (4 estilos), Helvetica (4 estilos), Times (4 estilos), Symbol, e Zapf Dingbats.

``Zend_Pdf`` atualmente dá suporte às 14 fontes *PDF* padrão, assim como às suas fontes personalizadas
TrueType. Objetos do tipo Font são obtidos via um dos dois métodos fábrica:
``Zend_Pdf_Font::fontWithName($fontName)`` para as 14 fontes padrão do *PDF* ou
``Zend_Pdf_Font::fontWithPath($filePath)`` para fontes personalizadas.

.. _zend.pdf.drawing.using-fonts.example-1:

.. rubric:: Criar uma fonte padrão

.. code-block:: php
   :linenos:

   ...
   // Create new font
   $font = Zend_Pdf_Font::fontWithName(Zend_Pdf_Font::FONT_HELVETICA);

   // Apply font
   $pdfPage->setFont($font, 36);
   ...

As constantes para as 14 fontes *PDF* padrão são definidas na classe ``Zend_Pdf_Font``:



   - Zend_Pdf_Font::FONT_COURIER

   - Zend_Pdf_Font::FONT_COURIER_BOLD

   - Zend_Pdf_Font::FONT_COURIER_ITALIC

   - Zend_Pdf_Font::FONT_COURIER_BOLD_ITALIC

   - Zend_Pdf_Font::FONT_TIMES

   - Zend_Pdf_Font::FONT_TIMES_BOLD

   - Zend_Pdf_Font::FONT_TIMES_ITALIC

   - Zend_Pdf_Font::FONT_TIMES_BOLD_ITALIC

   - Zend_Pdf_Font::FONT_HELVETICA

   - Zend_Pdf_Font::FONT_HELVETICA_BOLD

   - Zend_Pdf_Font::FONT_HELVETICA_ITALIC

   - Zend_Pdf_Font::FONT_HELVETICA_BOLD_ITALIC

   - Zend_Pdf_Font::FONT_SYMBOL

   - Zend_Pdf_Font::FONT_ZAPFDINGBATS



Você também pode usar qualquer fonte individual TrueType (que normalmente possui a extensão '.ttf') ou uma fonte
OpenType (de extensão '.otf') se ela contiver o mesmo contorno das TrueType. Atualmente sem suporte, mas
planejadas para um lançamento futuro são os arquivos .dfont do Mac OS X e os arquivos Microsoft TrueType
Collection (extensão '.ttc').

Para usar uma fonte TrueType, você deve fornecer o caminho completo para a fonte. Se a fonte não puder ser lida
por algum motivo, ou se ela não for uma fonte TrueType, o método fábrica irá lançar uma exceção:

.. _zend.pdf.drawing.using-fonts.example-2:

.. rubric:: Criar uma fonte TrueType

.. code-block:: php
   :linenos:

   ...
   // Create new font
   $goodDogCoolFont = Zend_Pdf_Font::fontWithPath('/path/to/GOODDC__.TTF');

   // Apply font
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...

Por padrão, fontes personalizadas serão embarcadas no documento *PDF* resultante. Isso permite que as pessoas que
receberem o arquivo poderão visualizá-lo corretamente, mesmo que não possuam as fontes apropriadas instaladas em
seus sistemas. Se você estiver preocupado com o tamanho do arquivo você pode solicitar que a fonte não seja
incluída através de uma opção 'não embarque' do método fábrica:

.. _zend.pdf.drawing.using-fonts.example-3:

.. rubric:: Criar uma fonte TrueType, mas não embarcá-la no documento PDF

.. code-block:: php
   :linenos:

   ...
   // Create new font
   $goodDogCoolFont = Zend_Pdf_Font::fontWithPath('/path/to/GOODDC__.TTF',
                                                  Zend_Pdf_Font::EMBED_DONT_EMBED);

   // Apply font
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...

Se o programa da fonte não for embarcado, mas o recebedor do arquivo *PDF* tiver a fonte instalada em seu sistema
ele irá ver o documento corretamente. Caso ele não possua a fonte correta instalada, o visualizador *PDF* fará o
melhor para sintetizar uma substituição.

Algumas fontes possuem regras de licença específicas que evitam que elas sejam embarcadas em documentos *PDF*.
Então, para que você não seja pego de surpresa por isso, se você tentar usar uma fonte que não pode ser
embarcada, o método fábrica irá lançar uma exceção.

Você ainda pode usar estas fontes, mas deve passar a opção 'não embarque' como foi descrito acima, ou então
você pode simplesmente suprimir a exceção:

.. _zend.pdf.drawing.using-fonts.example-4:

.. rubric:: Não lançar uma exceção para fontes que não podem ser embarcadas

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithPath(
              '/path/to/unEmbeddableFont.ttf',
              Zend_Pdf_Font::EMBED_SUPPRESS_EMBED_EXCEPTION
           );
   ...

Esta técnica de supressão é preferível se você permitir que o usuário final escolha sua própria fonte.
Fontes que podem ser embarcadas no documento *PDF* vão ser; aquelas que não puderem, não serão.

Programas de fonte podem ser um tanto grandes, alguns alcançam dezenas de megabytes. Por padrão, todas as fontes
embarcadas são comprimidas usando o esquema de compressão Flate, resultando, em média, em uma economia de
espaço de 50%. Se, por alguma razão, você não quer comprimir o programa da fonte, você pode desabilitar isso
através de uma opção:

.. _zend.pdf.drawing.using-fonts.example-5:

.. rubric:: Não comprimir uma fonte embarcada

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithPath('/path/to/someReallyBigFont.ttf',
                                       Zend_Pdf_Font::EMBED_DONT_COMPRESS);
   ...

Finalmente, quando necessário, você pode combinar as opções de embarque usando o operador binário OR:

.. _zend.pdf.drawing.using-fonts.example-6:

.. rubric:: Combinando opções de embarque de fonte

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithPath(
               $someUserSelectedFontPath,
               (Zend_Pdf_Font::EMBED_SUPPRESS_EMBED_EXCEPTION |
               Zend_Pdf_Font::EMBED_DONT_COMPRESS));
   ...

.. _zend.pdf.drawing.standard-fonts-limitations:

Standard PDF fonts limitations
------------------------------

Standard *PDF* fonts use several single byte encodings internally (see `PDF Reference, Sixth Edition, version 1.7`_
Appendix D for details). They are generally equal to Latin1 character set (except Symbol and ZapfDingbats fonts).

``Zend_Pdf`` uses CP1252 (WinLatin1) for drawing text with standard fonts.

Text still can be provided in any other encoding, which must be specified if it differs from a current locale. Only
WinLatin1 characters will be actually drawn.

.. _zend.pdf.drawing.using-fonts.example-7:

.. rubric:: Combining font embedding options

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithName(Zend_Pdf_Font::FONT_COURIER);
   $pdfPage->setFont($font, 36)
           ->drawText('Euro sign - €', 72, 720, 'UTF-8')
           ->drawText('Text with umlauts - à è ì', 72, 650, 'UTF-8');
   ...

.. _zend.pdf.drawing.extracting-fonts:

Extracting fonts
----------------

``Zend_Pdf`` module provides a possibility to extract fonts from loaded documents.

It may be useful for incremental document updates. Without this functionality you have to attach and possibly embed
font into a document each time you want to update it.

``Zend_Pdf`` and ``Zend_Pdf_Page`` objects provide special methods to extract all fonts mentioned within a document
or a page:

.. _zend.pdf.drawing.extracting-fonts.example-1:

.. rubric:: Extracting fonts from a loaded document

.. code-block:: php
   :linenos:

   ...
   $pdf = Zend_Pdf::load($documentPath);
   ...
   // Get all document fonts
   $fontList = $pdf->extractFonts();
   $pdf->pages[] = ($page = $pdf->newPage(Zend_Pdf_Page::SIZE_A4));
   $yPosition = 700;
   foreach ($fontList as $font) {
       $page->setFont($font, 15);
       $fontName = $font->getFontName(Zend_Pdf_Font::NAME_POSTSCRIPT,
                                      'en',
                                      'UTF-8');
       $page->drawText($fontName . ': The quick brown fox jumps over the lazy dog',
                       100,
                       $yPosition,
                       'UTF-8');
       $yPosition -= 30;
   }
   ...
   // Get fonts referenced within the first document page
   $firstPage = reset($pdf->pages);
   $firstPageFonts = $firstPage->extractFonts();
   ...

.. _zend.pdf.drawing.extracting-fonts.example-2:

.. rubric:: Extracting font from a loaded document by specifying font name

.. code-block:: php
   :linenos:

   ...
   $pdf = new Zend_Pdf();
   ...
   $pdf->pages[] = ($page = $pdf->newPage(Zend_Pdf_Page::SIZE_A4));

   $font = Zend_Pdf_Font::fontWithPath($fontPath);
   $page->setFont($font, $fontSize);
   $page->drawText($text, $x, $y);
   ...
   // This font name should be stored somewhere...
   $fontName = $font->getFontName(Zend_Pdf_Font::NAME_POSTSCRIPT,
                                  'en',
                                  'UTF-8');
   ...
   $pdf->save($docPath);
   ...

.. code-block:: php
   :linenos:

   ...
   $pdf = Zend_Pdf::load($docPath);
   ...
   $pdf->pages[] = ($page = $pdf->newPage(Zend_Pdf_Page::SIZE_A4));

   /* $srcPage->extractFont($fontName) can also be used here */
   $font = $pdf->extractFont($fontName);

   $page->setFont($font, $fontSize);
   $page->drawText($text, $x, $y);
   ...
   $pdf->save($docPath, true /* incremental update mode */);
   ...

Extracted fonts can be used in the place of any other font with the following limitations:



   - Extracted font can be used only in the context of the document from which it was extracted.

   - Possibly embedded font program is actually not extracted. So extracted font can't provide correct font metrics
     and original font has to be used for text width calculations:

     .. code-block:: php
        :linenos:

        ...
        $font = $pdf->extractFont($fontName);
        $originalFont = Zend_Pdf_Font::fontWithPath($fontPath);

        $page->setFont($font /* use extracted font for drawing */, $fontSize);
        $xPosition = $x;
        for ($charIndex = 0; $charIndex < strlen($text); $charIndex++) {
            $page->drawText($text[$charIndex], xPosition, $y);

            // Use original font for text width calculation
            $width = $originalFont->widthForGlyph(
                         $originalFont->glyphNumberForCharacter($text[$charIndex])
                     );
            $xPosition += $width/$originalFont->getUnitsPerEm()*$fontSize;
        }
        ...



.. _zend.pdf.drawing.image-drawing:

Desenhando Imagens
------------------

A classe ``Zend_Pdf_Page`` fornece o método drawImage() para o desenho de imagens:

.. code-block:: php
   :linenos:

   /**
    * Draw an image at the specified position on the page.
    *
    * @param Zend_Pdf_Resource_Image $image
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @return Zend_Pdf_Page
    */
   public function drawImage(Zend_Pdf_Resource_Image $image, $x1, $y1, $x2, $y2);

Objetos de imagem devem ser criados com o método ``Zend_Pdf_Image::imageWithPath($filePath)`` (imagens JPG, PNG e
TIFF são suportadas agora):

.. _zend.pdf.drawing.image-drawing.example-1:

.. rubric:: Desenhando imagens

.. code-block:: php
   :linenos:

   ...
   // load image
   $image = Zend_Pdf_Image::imageWithPath('my_image.jpg');

   $pdfPage->drawImage($image, 100, 100, 400, 300);
   ...

**Importante! O suporte a JPEG requer que a extensão PHP GD esteja configurada.** **Importante! O suporte a PNG
requer que extensão ZLIB esteja configurada para trabalhar com imagens com canal Alpha.**

Consulte a documentação do *PHP* para informações detalhadas (`http://www.php.net/manual/en/ref.image.php`_).
(`http://www.php.net/manual/en/ref.zlib.php`_).

.. _zend.pdf.drawing.line-drawing-style:

Estilo de desenho de linhas
---------------------------

O desenho de linhas é definido pela largura, cor e padrão de traços. Todos estes parâmetros podem ser
atribuídos pelos seguintes métodos da classe ``Zend_Pdf_Page``:

.. code-block:: php
   :linenos:

   /** Set line color. */
   public function setLineColor(Zend_Pdf_Color $color);

   /** Set line width. */
   public function setLineWidth(float $width);

   /**
    * Set line dashing pattern.
    *
    * Pattern is an array of floats:
    *     array(on_length, off_length, on_length, off_length, ...)
    * Phase is shift from the beginning of line.
    *
    * @param array $pattern
    * @param array $phase
    * @return Zend_Pdf_Page
    */
   public function setLineDashingPattern($pattern, $phase = 0);

.. _zend.pdf.drawing.fill-style:

Estilo de preenchimento
-----------------------

Os métodos ``Zend_Pdf_Page::drawRectangle()``, ``Zend_Pdf_Page::drawPolygon()``, ``Zend_Pdf_Page::drawCircle()`` e
``Zend_Pdf_Page::drawEllipse()`` usam o argumento ``$fillType`` como um parâmetro opcional. Ele pode ser:

- Zend_Pdf_Page::SHAPE_DRAW_STROKE - pincelamento

- Zend_Pdf_Page::SHAPE_DRAW_FILL - apenas preenchimento

- Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE - preenchimento e pincelamento (comportamento padrão)

Os métodos ``Zend_Pdf_Page::drawPolygon()`` também recebem um parâmetro adicional ``$fillMethod``:

- Zend_Pdf_Page::FILL_METHOD_NON_ZERO_WINDING (comportamento padrão)

  A :t:`referência do PDF`  descreve esta regra como:
  | A regra "nonzero winding number" determina se um dado ponto está dentro de um caminho por conceitualmente
  desenhar um raio a partir desse ponto até o infinito em qualquer direção e, em seguida, analisar os lugares
  onde um segmento do caminho atravessa o raio. Começando a contagem do 0, a regra acrescenta 1 cada vez que um
  segmento cruza o raio da esquerda para a direita e subtrai 1 cada vez que um segmento cruza da direita para a
  esquerda. Após a contagem de todos os cruzamentos, se o resultado for 0 então o ponto está fora do caminho; de
  outra forma está dentro. Nota: O método descrito não especifica o que fazer se um caminho segmento coincide ou
  é tangente ao escolhido raio. Uma vez que a direção do raio é arbitrária, a regra simplesmente escolhe um
  raio que não encontra tais problemas de interseção. Para simples caminhos convexos, a regra "nonzero winding
  number" define o interior e o exterior como esperado intuitivamente. Os casos mais interessantes são os envolvem
  caminhos complexos ou com auto-intersecção, como os que são apresentados na Figura 4.10 (na Referência do
  *PDF*). Para um caminho que consiste em uma estrela de cinco pontas, desenhada com cinco linhas retas conectadas
  se inter-seccionando, a regra considera como sendo o interior toda a área delimitada pela estrela, incluindo o
  pentágono no centro. Para um caminho composto de dois círculos concêntricos, as áreas delimitadas por ambos
  os círculos são consideradas como sendo o interior, desde que ambos os círculos sejam desenhados na mesma
  direção. Se os círculos forem desenhados em direções opostas, apenas a forma da "rosquinha" entre eles está
  no interior, de acordo com a regra; o "buraco da rosquinha" está no exterior.



- Zend_Pdf_Page::FILL_METHOD_EVEN_ODD

  A :t:`referência do PDF`  descreve esta regra como:
  | Uma alternativa à regra "nonzero winding number" é a regra "even-odd". Esta regra determina a
  "interiorização" de um ponto através do desenho de um raio daquele ponto em qualquer direção e simplesmente
  contando a quantidade de segmentos de caminhos que cruzam o raio, independentemente da direção. Se a quantidade
  for ímpar, o ponto está no interior; se for par está no exterior. Isto gera os mesmos resultados da regra
  "nonzero winding number" para caminhos com formas simples, mas produz resultados diferentes para os mais de forma
  mais complexa. A Figura 4.11 (na Referência do *PDF*) mostra os efeitos da aplicação da regra "even-odd" para
  caminhos complexos. Para a estrela de cinco pontas, a regra considera os pontos triangulares como estando no
  interior do caminho, mas não o pentágono no centro. Para os dois círculos concêntricos, apenas a forma da
  "rosquinha" entre os círculos é considerada como interior, independentemente das direções em que eles foram
  desenhados.



.. _zend.pdf.drawing.linear-transformations:

Transformações Lineares
-----------------------

.. _zend.pdf.drawing.linear-transformations.rotations:

Rotações
^^^^^^^^

A página *PDF* pode ser rotacionada antes do uso de qualquer operação de desenho. Isso pode ser feito pelo
método ``Zend_Pdf_Page::rotate()``:

.. code-block:: php
   :linenos:

   /**
    * Rotate the page.
    *
    * @param float $x  - the X co-ordinate of rotation point
    * @param float $y  - the Y co-ordinate of rotation point
    * @param float $angle - rotation angle
    * @return Zend_Pdf_Page
    */
   public function rotate($x, $y, $angle);

.. _zend.pdf.drawing.linear-transformations.scale:

Starting from ZF 1.8, scaling
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Scaling transformation is provided by ``Zend_Pdf_Page::scale()`` method:

.. code-block:: php
   :linenos:

   /**
    * Scale coordination system.
    *
    * @param float $xScale - X dimention scale factor
    * @param float $yScale - Y dimention scale factor
    * @return Zend_Pdf_Page
    */
   public function scale($xScale, $yScale);

.. _zend.pdf.drawing.linear-transformations.translate:

Starting from ZF 1.8, translating
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Coordinate system shifting is performed by ``Zend_Pdf_Page::translate()`` method:

.. code-block:: php
   :linenos:

   /**
    * Translate coordination system.
    *
    * @param float $xShift - X coordinate shift
    * @param float $yShift - Y coordinate shift
    * @return Zend_Pdf_Page
    */
   public function translate($xShift, $yShift);

.. _zend.pdf.drawing.linear-transformations.skew:

Starting from ZF 1.8, skewing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Page skewing can be done using ``Zend_Pdf_Page::skew()`` method:

.. code-block:: php
   :linenos:

   /**
    * Translate coordination system.
    *
    * @param float $x  - the X co-ordinate of axis skew point
    * @param float $y  - the Y co-ordinate of axis skew point
    * @param float $xAngle - X axis skew angle
    * @param float $yAngle - Y axis skew angle
    * @return Zend_Pdf_Page
    */
   public function skew($x, $y, $xAngle, $yAngle);

.. _zend.pdf.drawing.save-restore:

Salvar/restaurar estados gráficos
---------------------------------

A qualquer hora os estados gráficos de uma página (fonte atual, tamanho da fonte, cor das linhas, cor de
preenchimento, estilo de linha, rotação da página, e área de corte) podem ser salvos e então restaurados.
Operações "Salvar" colocam os dados em uma pilha, as restaurações recuperam os estados da pilha.

Existem dois métodos na classe ``Zend_Pdf_Page`` para essas operações:

.. code-block:: php
   :linenos:

   /**
    * Save the graphics state of this page.
    * This takes a snapshot of the currently applied style, position,
    * clipping area and any rotation/translation/scaling that has been
    * applied.
    *
    * @return Zend_Pdf_Page
    */
   public function saveGS();

   /**
    * Restore the graphics state that was saved with the last call to
    * saveGS().
    *
    * @return Zend_Pdf_Page
    */
   public function restoreGS();

.. _zend.pdf.drawing.clipping:

Recorte de área de desenho
--------------------------

O *PDF* e o módulo ``Zend_Pdf`` dão suporte ao recorte de áreas de desenho. O recorte da área atual limita as
regiões da página que serão afetadas por operações de pintura. Inicialmente é a página toda.

A classe ``Zend_Pdf_Page`` fornece um conjunto de métodos para operações de recorte.

.. code-block:: php
   :linenos:

   /**
    * Intersect current clipping area with a rectangle.
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @return Zend_Pdf_Page
    */
   public function clipRectangle($x1, $y1, $x2, $y2);

.. code-block:: php
   :linenos:

   /**
    * Intersect current clipping area with a polygon.
    *
    * @param array $x  - array of float (the X co-ordinates of the vertices)
    * @param array $y  - array of float (the Y co-ordinates of the vertices)
    * @param integer $fillMethod
    * @return Zend_Pdf_Page
    */
   public function clipPolygon($x,
                               $y,
                               $fillMethod =
                                   Zend_Pdf_Page::FILL_METHOD_NON_ZERO_WINDING);

.. code-block:: php
   :linenos:

   /**
    * Intersect current clipping area with a circle.
    *
    * @param float $x
    * @param float $y
    * @param float $radius
    * @param float $startAngle
    * @param float $endAngle
    * @return Zend_Pdf_Page
    */
   public function clipCircle($x,
                              $y,
                              $radius,
                              $startAngle = null,
                              $endAngle = null);

.. code-block:: php
   :linenos:

   /**
    * Intersect current clipping area with an ellipse.
    *
    * Method signatures:
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
    * @return Zend_Pdf_Page
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

A classe ``Zend_Pdf_Style`` fornece funcionalidades de estilo.

Estilos podem ser usados para o armazenamento de um conjunto de parâmetros do estado gráfico e aplicá-los à uma
página *PDF* com uma operação:

.. code-block:: php
   :linenos:

   /**
    * Set the style to use for future drawing operations on this page
    *
    * @param Zend_Pdf_Style $style
    * @return Zend_Pdf_Page
    */
   public function setStyle(Zend_Pdf_Style $style);

   /**
    * Return the style, applied to the page.
    *
    * @return Zend_Pdf_Style|null
    */
   public function getStyle();

A classe ``Zend_Pdf_Style`` fornece um conjunto de métodos para configurar ou recuperar diferentes parâmetros do
estado gráfico:

.. code-block:: php
   :linenos:

   /**
    * Set line color.
    *
    * @param Zend_Pdf_Color $color
    * @return Zend_Pdf_Page
    */
   public function setLineColor(Zend_Pdf_Color $color);

.. code-block:: php
   :linenos:

   /**
    * Get line color.
    *
    * @return Zend_Pdf_Color|null
    */
   public function getLineColor();

.. code-block:: php
   :linenos:

   /**
    * Set line width.
    *
    * @param float $width
    * @return Zend_Pdf_Page
    */
   public function setLineWidth($width);

.. code-block:: php
   :linenos:

   /**
    * Get line width.
    *
    * @return float
    */
   public function getLineWidth();

.. code-block:: php
   :linenos:

   /**
    * Set line dashing pattern
    *
    * @param array $pattern
    * @param float $phase
    * @return Zend_Pdf_Page
    */
   public function setLineDashingPattern($pattern, $phase = 0);

.. code-block:: php
   :linenos:

   /**
    * Get line dashing pattern
    *
    * @return array
    */
   public function getLineDashingPattern();

.. code-block:: php
   :linenos:

   /**
    * Get line dashing phase
    *
    * @return float
    */
   public function getLineDashingPhase();

.. code-block:: php
   :linenos:

   /**
    * Set fill color.
    *
    * @param Zend_Pdf_Color $color
    * @return Zend_Pdf_Page
    */
   public function setFillColor(Zend_Pdf_Color $color);

.. code-block:: php
   :linenos:

   /**
    * Get fill color.
    *
    * @return Zend_Pdf_Color|null
    */
   public function getFillColor();

.. code-block:: php
   :linenos:

   /**
    * Set current font.
    *
    * @param Zend_Pdf_Resource_Font $font
    * @param float $fontSize
    * @return Zend_Pdf_Page
    */
   public function setFont(Zend_Pdf_Resource_Font $font, $fontSize);

.. code-block:: php
   :linenos:

   /**
    * Modify current font size
    *
    * @param float $fontSize
    * @return Zend_Pdf_Page
    */
   public function setFontSize($fontSize);

.. code-block:: php
   :linenos:

   /**
    * Get current font.
    *
    * @return Zend_Pdf_Resource_Font $font
    */
   public function getFont();

.. code-block:: php
   :linenos:

   /**
    * Get current font size
    *
    * @return float $fontSize
    */
   public function getFontSize();

.. _zend.pdf.drawing.alpha:

Transparency
------------

``Zend_Pdf`` module supports transparency handling.

Transparency may be set using ``Zend_Pdf_Page::setAlpha()`` method:

.. code-block:: php
   :linenos:

   /**
    * Set the transparency
    *
    * $alpha == 0  - transparent
    * $alpha == 1  - opaque
    *
    * Transparency modes, supported by PDF:
    * Normal (default), Multiply, Screen, Overlay, Darken, Lighten,
    * ColorDodge, ColorBurn, HardLight, SoftLight, Difference, Exclusion
    *
    * @param float $alpha
    * @param string $mode
    * @throws Zend_Pdf_Exception
    * @return Zend_Pdf_Page
    */
   public function setAlpha($alpha, $mode = 'Normal');



.. _`PDF Reference, Sixth Edition, version 1.7`: http://www.adobe.com/devnet/acrobat/pdfs/pdf_reference_1-7.pdf
.. _`http://www.php.net/manual/en/ref.image.php`: http://www.php.net/manual/en/ref.image.php
.. _`http://www.php.net/manual/en/ref.zlib.php`: http://www.php.net/manual/en/ref.zlib.php
