.. _zend.pdf.drawing:

Rysowanie
=========

.. _zend.pdf.drawing.geometry:

Geometria
---------

PDF używa takiej samej geometrii jak PostScript. Zaczyna z lewego dolnego rogu strony, a jednostka domyślnie jest
wyrażana w punktach (1/72 cala).

Rozmiar strony może być pobrany z obiektu strony:



   .. code-block:: php
      :linenos:

      $width  = $pdfPage->getWidth();
      $height = $pdfPage->getHeight();




.. _zend.pdf.drawing.color:

Kolory
------

PDF ma bardzo rozbudowane możliwości reprezentowania kolorów. Zend_Pdf wspiera palety Grey Scale, RGB oraz CMYK.
Każda z nich może być użyta wszędzie, gdzie jest wymagany obiekt *Zend_Pdf_Color*. Klasy
*Zend_Pdf_Color_GrayScale*, *Zend_Pdf_Color_Rgb* oraz *Zend_Pdf_Color_Cmyk* zapewniają taką funkcjonalność:

.. code-block:: php
   :linenos:

   // $grayLevel (liczba zmiennoprzecinkowa)
   // 0.0 (czarny) - 1.0 (biały)
   $color1 = new Zend_Pdf_Color_GrayScale($grayLevel);

   // $r, $g, $b (liczby zmiennoprzecinkowe)
   // 0.0 (minimalna intensywność) - 1.0 (maksymalna intensywność)
   $color2 = new Zend_Pdf_Color_Rgb($r, $g, $b);

   // $c, $m, $y, $k (liczby zmiennoprzecinkowe)
   // 0.0 (minimalna intensywność) - 1.0 (maksymalna intensywność)
   $color3 = new Zend_Pdf_Color_Cmyk($c, $m, $y, $k);


HTML style colors are also provided with *Zend_Pdf_Color_Html* class:

.. code-block:: php
   :linenos:

   $color1 = new Zend_Pdf_Color_Html('#3366FF');
   $color2 = new Zend_Pdf_Color_Html('silver');
   $color3 = new Zend_Pdf_Color_Html('forestgreen');


.. _zend.pdf.drawing.shape-drawing:

Rysowanie figur
---------------

Wszystkie operacje rysowania mogą być przeprowadzone w kontekście strony PDF.

Klasa *Zend_Pdf_Page* zapewnia zestaw podstawowych operacji rysowania:

.. code-block:: php
   :linenos:

   /**
    * Rysuje linię z punktu x1,y1 do x2,y2.
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    */
   public function drawLine($x1, $y1, $x2, $y2);


.. code-block:: php
   :linenos:

   /**
    * Rysuje prostokąt.
    *
    * Typy wypełnienia:
    * Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE - wypełnia i obramowuje
    *                                             prostokąt (domyślnie)
    * Zend_Pdf_Page::SHAPE_DRAW_STROKE          - obramowuje prostokąt
    * Zend_Pdf_Page::SHAPE_DRAW_FILL            - wypełnia prostokąt
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param integer $fillType
    */
   public function drawRectangle($x1, $y1, $x2, $y2,
                       $fillType = Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE);


.. code-block:: php
   :linenos:

   /**
    * Rysuje wielokąt.
    *
    * Jeśli $fillType ma wartość Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE
    * lub Zend_Pdf_Page::SHAPE_DRAW_FILL, wtedy wielokąt jest automatycznie
    * zamknięty. Zobacz szczegółową dokumentację tych metod w dokumentacji
    * PDF (sekcja 4.4.2 Path painting Operators, Filling)
    *
    * @param array $x  - array of float (the X co-ordinates of the vertices)
    * @param array $y  - array of float (the Y co-ordinates of the vertices)
    * @param integer $fillType
    * @param integer $fillMethod
    */
   public function drawPolygon($x, $y,
                               $fillType =
                                   Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE,
                               $fillMethod =
                                   Zend_Pdf_Page::FILL_METHOD_NON_ZERO_WINDING);


.. code-block:: php
   :linenos:

   /**
    * Rysuje okrąg o środku w punkcie $x, $y o promieniu $radius.
    *
    * Kąty są określane w radianach.
    *
    * Sygnatury metod:
    * drawCircle($x, $y, $radius);
    * drawCircle($x, $y, $radius, $fillType);
    * drawCircle($x, $y, $radius, $startAngle, $endAngle);
    * drawCircle($x, $y, $radius, $startAngle, $endAngle, $fillType);
    *
    *
    * Nie jest to do końca okrąg, ponieważ PDF obsługuje jedynie
    * kubiczne krzywe Beziera. Ale jest to bardzo dobre przybliżenie.
    * Różni się od realnego okręgu maksymalnie o 0.00026 promienia
    * (przy kątach PI/8, 3*PI/8, 5*PI/8, 7*PI/8, 9*PI/8, 11*PI/8,
    * 13*PI/8 oraz 15*PI/8). Przy kątach 0, PI/4, PI/2, 3*PI/4, PI,
    * 5*PI/4, 3*PI/2 oraz 7*PI/4 jest to dokładny okrąg.
    *
    * @param float $x
    * @param float $y
    * @param float $radius
    * @param mixed $param4
    * @param mixed $param5
    * @param mixed $param6
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
    * Rysuje elipsę wewnątrz określonego prostokąta.
    *
    * Sygnatury metod:
    * drawEllipse($x1, $y1, $x2, $y2);
    * drawEllipse($x1, $y1, $x2, $y2, $fillType);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle, $fillType);
    *
    * Kąty są określane w radianach
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param mixed $param5
    * @param mixed $param6
    * @param mixed $param7
    */
   public function drawEllipse($x1, $y1, $x2, $y2, $param5 = null, $param6 = null, $param7 = null);


.. _zend.pdf.drawing.text-drawing:

Wypisywanie tekstu
------------------

Operacje wypisywania tekstu także są przeprowadzone w kontekście strony PDF Możesz wypisać pojedynczą linię
tekstu w dowolnym miejscu na stronie podając współrzędne x oraz y linii bazowej. W operacjach wypisywania
tekstu używana jest czcionka o aktualnie ustawionym kroju oraz rozmiarze (zobacz poniżej szczegółowy opis).

.. code-block:: php
   :linenos:

   /**
    * Wypisuje linię tekstu w określonym miejscu.
    *
    * @param string $text
    * @param float $x
    * @param float $y
    * @param string $charEncoding (opcjonalny) Kodowanie znaków
    *               tekstu. Domyślnie według ustawień lokalizacji.
    * @throws Zend_Pdf_Exception
    */
   public function drawText($text, $x, $y, $charEncoding = '');


.. _zend.pdf.drawing.text-drawing.example-1:

.. rubric:: Wypisywanie tekstu na stronie

.. code-block:: php
   :linenos:

   ...
   $pdfPage->drawText('Hello world!', 72, 720);
   ...


Domyślnie, łańcuchy znaków są interpretowane przy użyciu metod kodowania znaków biężacych ustawień
lokalnych. Jeśli masz łańcuch znaków używający innych metod kodowania (na przykład dane jako łańcuch
znaków UTF-8 odczytany z pliku na dysku, lub łańcuch znaków MacRoman pobrany z bazy danych), możesz wskazać
kodowanie znaków podczas wypisywania tekstu i Zend_Pdf przeprowadzi dla ciebie konwersję. Możesz użyć
źródłowego łańcucha znaków w dowolnym kodowaniu obsługiwanym przez funkcję PHP *iconv()*:

.. _zend.pdf.drawing.text-drawing.example-2:

.. rubric:: Wypisywanie tekstu zakodowanego w UTF-8 na stronie

.. code-block:: php
   :linenos:

   ...
   // Odczytaj z dysku tekst zakodowany w UTF-8.
   $unicodeString = fread($fp, 1024);

   // Wypisz tekst na stronie
   $pdfPage->drawText($unicodeString, 72, 720, 'UTF-8');
   ...


.. _zend.pdf.drawing.using-fonts:

Użycie czcionek
---------------

Metoda *Zend_Pdf_Page::drawText()* używa bieżącego kroju oraz rozmiaru czcionki dla strony, które ustawia się
za pomocą metody *Zend_Pdf_Page::setFont()*:

.. code-block:: php
   :linenos:

   /**
    * Ustawia bieżącą czcionkę.
    *
    * @param Zend_Pdf_Resource_Font $font
    * @param float $fontSize
    */
   public function setFont(Zend_Pdf_Resource_Font $font, $fontSize);


Dokumenty PDF obsługują czionki PostScript Type 1 oraz TrueType, tak samo dobrze jak dwa wyspecjalizowane typy
PDF, Type 3 oraz czcionki złożone Type 0. Jest także 14 standardowych czcionek Type 1 wbudowanych w każdą
przeglądarkę PDF: Courier (4 style), Helvetica (4 style), Times (4 style), Symbol, and Zapf Dingbats.

Zend_Pdf obecnie obsługuje 14 standardowych czcionek PDF tak samo dobrze jak twoje własne czcionki TrueType.
Obiekty czcionek są obsługiwane za pomocą jednej z dwóch metod fabryk: *Zend_Pdf_Font::fontWithName($fontName)*
dla 14 standardowych czcionek PDF lub *Zend_Pdf_Font::fontWithPath($filePath)* dla własnych czcionek.

.. _zend.pdf.drawing.using-fonts.example-1:

.. rubric:: Tworzenie standardowej czcionki

.. code-block:: php
   :linenos:

   ...
   // Utwórz nową czcionkę
   $font = Zend_Pdf_Font::fontWithName(Zend_Pdf_Font::FONT_HELVETICA);

   // Ustaw czcionkę
   $pdfPage->setFont($font, 36);
   ...


Stałe dla nazwa 14 standardowych czcionek PDF są zdefiniowane w klasie *Zend_Pdf_Font*:

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



Możesz także użyć dowolnej czcionki TrueType (która najcześciej ma rozszerzenie '.ttf') lub czcionki OpenType
(rozszerzenie '.otf') jeśli zawiera czcionke zrobioną według wytycznych TrueType. Obecnie nieobsługiwane, ale
planowane w przyszłych wersjach są pliki czcionek Mac OS X .dfont oraz pliki Microsoft TrueType Collection
(rozszerzenie '.ttc').

Aby użyć czcionki TrueType, musisz podać pełną ścieżke do pliku czcionki. Jeśli z jakiegoś powodu nie
może on być odczytany, lub nie jest to czcionka TrueType, metoda fabryki wyrzuci wyjątek:

.. _zend.pdf.drawing.using-fonts.example-2:

.. rubric:: Tworzenie czcionki TrueType

.. code-block:: php
   :linenos:

   ...
   // Utwórz nową czcionkę
   $goodDogCoolFont = Zend_Pdf_Font::fontWithPath('/path/to/GOODDC__.TTF');

   // Ustaw czcionkę
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...


Domyślnie własne czcionki będą osadzone w wynikowym dokumencie PDF. To pozwala odbiorcom oglądać stronę
taką, jaka była zamierzona, nawet gdy nie mają zainstalowanych w systemie potrzebnych czcionek. Jeśli ważny
jest dla ciebie rozmiar pliku, możesz zażądać, aby plik czcionki nie był osadzony przekazując opcję 'nie
osadzaj' do metody fabryki:

.. _zend.pdf.drawing.using-fonts.example-3:

.. rubric:: Tworzenie czcionki TrueType, ale bez osadzania jej w dokumencie PDF.

.. code-block:: php
   :linenos:

   ...
   // Utwórz nową czcionkę
   $goodDogCoolFont = Zend_Pdf_Font::fontWithPath('/path/to/GOODDC__.TTF',
                                                  Zend_Pdf_Font::EMBED_DONT_EMBED);

   // Ustaw czcionkę
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...


Jeśli plik czcionki nie jest osadzony, ale odbiorca pliku PDF posiada taką czcionkę zainstalowaną w swoim
systemie, zobaczy on dokument w sposób identyczny z zamierzonym. Jeśli nie ma zainstalowanej odpowiedniej
czcionki, przeglądarka PDF użyje najlepszej aby zastąpić czcionkę.

Niektóre czcionki mają bardzo specyficzne zasady licencjonowania, które uniemożliwiają osadzenie ich w
dokumentach PDF. Także nie złamiesz tych zasad, ponieważ gdy spróbujesz użyć czcionkę, która nie może być
osadzona metoda fabryki wyrzuci wyjątek.

Możesz wciąż użyć tych czcionek, ale musisz przekazać odpowiedni parametr w celu nieosadzenia czcionki, lub w
prosty sposób zignorować wyjątek:

.. _zend.pdf.drawing.using-fonts.example-4:

.. rubric:: Nie wyrzucanie wyjątku dla czcionek które nie mogą być osadzone.

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithPath(
               '/path/to/unEmbeddableFont.ttf',
               Zend_Pdf_Font::EMBED_SUPPRESS_EMBED_EXCEPTION
           );
   ...


Ta technika zignorowania wyjątku jest przydatna, gdy pozwalasz użytkownikowi końcowemu wybierać własne
czcionki. Czcionki, ktore mogą być osadzone, będą osadzone w dokumencie PDF; te które nie mogą, nie będą.

Pliki czcionek mogą być duże, czasem osiągająć dziesiątki megabajtów. Domyślnie wszystkie osadzane
czcionki są kompresowane przy użyciu schematu kompresji Flate, co powoduje zaoszczędzenie średnio 50% miejsca.
Jeśli z jakiegoś powodu nie chcesz kompresować plików czcionek, możesz to zablokować opcją:

.. _zend.pdf.drawing.using-fonts.example-5:

.. rubric:: Nie kompresowanie osadzonych czcionek.

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithPath('/path/to/someReallyBigFont.ttf',
                                       Zend_Pdf_Font::EMBED_DONT_COMPRESS);
   ...


Ostatecznie, jeśli potrzebujesz, możesz łączyć opcje osadzania czcionek używając bitowego operatora LUB:

.. _zend.pdf.drawing.using-fonts.example-6:

.. rubric:: Łączenie opcji osadzania czcionki.

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithPath(
               $someUserSelectedFontPath,
               (Zend_Pdf_Font::EMBED_SUPPRESS_EMBED_EXCEPTION |
               Zend_Pdf_Font::EMBED_DONT_COMPRESS));
   ...


.. _zend.pdf.drawing.extracting-fonts:

Począwszy od 1.5, wyciąganie czcionek.
--------------------------------------

Moduł *Zend_Pdf* zapewnia możliwość wyciągania czcionek z załadowanych dokumentów.

Może być to użyteczne przy inkrementalnych aktualizacjach dokumentów. Bez tej funkcjonalności musiałbyś
dołączać czcionkę do dokumentu za każdym razem gdy go aktualizujesz.

Obiekty *Zend_Pdf* oraz *Zend_Pdf_Page* zapewniają specjalne metody do wyciągania czcionek użytych w dokumencie
lub stronie:

.. _zend.pdf.drawing.extracting-fonts.example-1:

.. rubric:: Wyciąganie czcionek z załadowanego dokumentu.

.. code-block:: php
   :linenos:

   ...
   $pdf = Zend_Pdf::load($documentPath);
   ...
   // Pobieramy wszystkie czcionki z dokumentu
   $fontList = $pdf->extractFonts();
   $pdf->pages[] = ($page = $pdf->newPage(Zend_Pdf_Page::SIZE_A4));
   $yPosition = 700;
   foreach ($fontList as $font) {
       $page->setFont($font, 15);
       $page->drawText(
           $font->getFontName(Zend_Pdf_Font::NAME_POSTSCRIPT, 'en', 'UTF-8') .
           ': The quick brown fox jumps over the lazy dog', 100, $yPosition, 'UTF-8');
       $yPosition -= 30;
   }
   ...
   // Pobieramy czcionki z pierwszej strony dokumentu
   $firstPage = reset($pdf->pages);
   $firstPageFonts = $firstPage->extractFonts();
   ...


.. _zend.pdf.drawing.extracting-fonts.example-2:

.. rubric:: Wyciąganie czcionki z załadowanego dokumentu określając jej nazwę.

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
   // Nazwa tej czcionki powinna zostać gdzieś zapisana
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


Wyciągnięte czcionki mogą być użyte w miejscu dowolnej innej czcionki z następującymi ograniczeniami:

   - Wyciągnieta czcionka może być użyta tylko w kontekście dokumentu z którego została wyciągnięta.

   - Osadzona czcionka nie jest wyciągnięta. Wyciągnięta czcionka nie może być użyta do obliczenia
     poprawnych rozmiarów więc do tych obliczeń powinna być użyta oryginalna czcionka.

        .. code-block:: php
           :linenos:

           ...
           $font = $pdf->extractFont($fontName);
           $originalFont = Zend_Pdf_Font::fontWithPath($fontPath);

           $page->setFont($font /* używamy wyciągniętej czcionki do rysowania */, $fontSize);
           $xPosition = $x;
           for ($charIndex = 0; $charIndex < strlen($text); $charIndex++) {
               $page->drawText($text[$charIndex], xPosition, $y);

               // Używamy oryginalnej czcionki do obliczenia szerokości tekstu
               $width = $originalFont->widthForGlyph(
                            $originalFont->glyphNumberForCharacter($text[$charIndex])
                        );
               $xPosition += $width/$originalFont->getUnitsPerEm()*$fontSize;
           }
           ...






.. _zend.pdf.drawing.image-drawing:

Wstawianie obrazów
------------------

Klasa *Zend_Pdf_Page*\ zapewnia metodę drawImage() do wstawiania obrazów:

.. code-block:: php
   :linenos:

   /**
    * Wstawia obraz w określonym miejscu na stronie.
    *
    * @param Zend_Pdf_Resource_Image $image
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    */
   public function drawImage(Zend_Pdf_Resource_Image $image, $x1, $y1, $x2, $y2);


Obiekty obrazów powinny być tworzone za pomocą metody *Zend_Pdf_Image::imageWithPath($filePath)* (obecnie
obsługiwane są obrazy JPG, PNG oraz TIFF):

.. _zend.pdf.drawing.image-drawing.example-1:

.. rubric:: Wstawianie obrazów

.. code-block:: php
   :linenos:

   ...
   // łądujemy obraz
   $image = Zend_Pdf_Image::imageWithPath('my_image.jpg');

   $pdfPage->drawImage($image, 100, 100, 400, 300);
   ...


**Ważne! Obsługa JPEG wymaga rozszerzenia PHP GD.** **Ważne! Obsługa PNG wymaga rozszerzenia ZLIB
skonfigurowanego do obsługi obrazów z kanałem Alpha.**

Sprawdź dokumentację PHP aby znaleźć bardziej szczegółowe informacje.
(`http://www.php.net/manual/en/ref.image.php`_). (`http://www.php.net/manual/en/ref.zlib.php`_).

.. _zend.pdf.drawing.line-drawing-style:

Styl rysowania linii
--------------------

Styl rysowania linii jest zdefiniowany przez grubość, kolor linii oraz ozdobny wzór linii. Wszystkie te
parametry mogą być zdefiniowane za pomocą metod klasy *Zend_Pdf_Page*:

.. code-block:: php
   :linenos:

   /** Ustaw kolor linii. */
   public function setLineColor(Zend_Pdf_Color $color);

   /** Ustaw grubość linii. */
   public function setLineWidth(float $width);

   /**
    * Ustawia ozdobny wzór linii.
    *
    * Wzór jest tablicą liczb zmiennoprzecinkowych:
    *     array(dlugosc_on, dlugosc_off, dlugosc_on, dlugosc_off, ...)
    * Faza jest przesunięciem od początku linii.
    *
    * @param array $pattern
    * @param array $phase
    */
   public function setLineDashingPattern($pattern, $phase = 0);


.. _zend.pdf.drawing.fill-style:

Styl wypełnienia
----------------

Metody *Zend_Pdf_Page::drawRectangle()*, *Zend_Pdf_Page::drawPolygon()*, *Zend_Pdf_Page::drawCircle()* oraz
*Zend_Pdf_Page::drawEllipse()* przyjmują argument *$fillType* jako opcjonalny parametr. Może on mieć wartość:

- Zend_Pdf_Page::SHAPE_DRAW_STROKE - obrysowuje figurę

- Zend_Pdf_Page::SHAPE_DRAW_FILL - tylko wypełnia

- Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE - obrysowuje i wypełnia (domyślnie)

Metoda *Zend_Pdf_Page::drawPolygon()* przyjmuje także dodatkowy parametr *$fillMethod*:

- Zend_Pdf_Page::FILL_METHOD_NON_ZERO_WINDING (domyślnie)

  :t:`Dokumentacja PDF`  opisuje tą zasadę w ten sposób:
  | Zasada nonzero winding number określa whether a given point is inside a path by conceptually drawing a ray
  from
  that point to infinity in any direction and then examining the places where a segment of the path crosses the
  ray. Starting with a count of 0, the rule adds 1 each time a path segment crosses the ray from left to right and
  subtracts 1 each time a segment crosses from right to left. After counting all the crossings, if the result is 0
  then the point is outside the path; otherwise it is inside. Nota: Opisana właśnie metoda nie określa what to
  do if a path segment coincides with or is tangent to the chosen ray. Since the direction of the ray is arbitrary,
  the rule simply chooses a ray that does not encounter such problem intersections. For simple convex paths, the
  nonzero winding number rule defines the inside and outside as one would intuitively expect. The more interesting
  cases are those involving complex or self-intersecting paths like the ones shown in Figure 4.10 (w dokumentacji
  PDF). For a path consisting of a five-pointed star, drawn with five connected straight line segments intersecting
  each other, the rule considers the inside to be the entire area enclosed by the star, including the pentagon in
  the center. For a path composed of two concentric circles, the areas enclosed by both circles are considered to
  be inside, provided that both are drawn in the same direction. If the circles are drawn in opposite directions,
  only the "doughnut" shape between them is inside, according to the rule; the "doughnut hole" is outside.



- Zend_Pdf_Page::FILL_METHOD_EVEN_ODD

  :t:`Dokumentacja PDF`  opisuje tą zasadę w ten sposób:
  | An alternative to the nonzero winding number rule is the even-odd rule. This rule determines the "insideness"
  of
  a point by drawing a ray from that point in any direction and simply counting the number of path segments that
  cross the ray, regardless of direction. If this number is odd, the point is inside; if even, the point is
  outside. This yields the same results as the nonzero winding number rule for paths with simple shapes, but
  produces different results for more complex shapes. Figure 4.11 (w dokumentacji PDF) shows the effects of
  applying the even-odd rule to complex paths. For the five-pointed star, the rule considers the triangular points
  to be inside the path, but not the pentagon in the center. For the two concentric circles, only the "doughnut"
  shape between the two circles is considered inside, regardless of the directions in which the circles are drawn.



.. _zend.pdf.drawing.rotations:

Obracanie
---------

Strony PDF mogą być obracane zanim zostaną wykonane jakiekolwiek operacje rysowania. Może być to zrobione za
pomocą metody *Zend_Pdf_Page::rotate()*:

.. code-block:: php
   :linenos:

   /**
    * Obraca stronę dookoła punktu ($x, $y) o określony kąt (w radianach).
    *
    * @param float $angle
    */
   public function rotate($x, $y, $angle);


.. _zend.pdf.drawing.save-restore:

Zapisywanie/odczytywanie stanu grafiki
--------------------------------------

W dowolnej chwili stan grafiki (bieżąca czcionka, rozmiar czcionki, kolor linii, kolor wypełnienia, styl linii,
obrót strony, obszar przycinania) może być zapisany a potem przywrócony. Operacja zapisu zapisuje dane na stos
stanu grafiki, operacja przywrócenia przywraca je ze stosu.

Są dwie metody w klasie *Zend_Pdf_Page* do tych operacji:

.. code-block:: php
   :linenos:

   /**
    * Zapisuje stan grafiki danej strony.
    * Zapisuje obecny styl, pozycję, obszar przycinania
    * oraz ewetualny obrót/translację/skalowanie
    * które są zastosowane.
    */
   public function saveGS();

   /**
    * Przywraca stan grafiki który był zapisany
    * ostatnim wywołaniem metody saveGS().
    */
   public function restoreGS();


.. _zend.pdf.drawing.clipping:

Przycięcie obszaru rysowania
----------------------------

PDF oraz moduł Zend_Pdf obsługują przycięcie obszaru rysowania. Obecny przycięty obszar ogranicza obszar
strony, na który wpływają operacje rysowania. Na początku jest to cała strona.

Klasa *Zend_Pdf_Page* zapewnia zestaw metod dla operacji przycinania.

.. code-block:: php
   :linenos:

   /**
    * Przycięcie obszaru za pomocą prostokąta.
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    */
   public function clipRectangle($x1, $y1, $x2, $y2);


.. code-block:: php
   :linenos:

   /**
    * Przycięcie obszaru za pomocą wielokąta.
    *
    * @param array $x  - tablica wartości zmiennoprzecinkowych (współrzędne X)
    * @param array $y  - tablica wartości zmiennoprzecinkowych (współrzędne Y)
    * @param integer $fillMethod
    */
   public function clipPolygon($x,
                               $y,
                               $fillMethod =
                                    Zend_Pdf_Page::FILL_METHOD_NON_ZERO_WINDING);


.. code-block:: php
   :linenos:

   /**
    * Przycięcie obszaru za pomocą okręgu.
    *
    * @param float $x
    * @param float $y
    * @param float $radius
    * @param float $startAngle
    * @param float $endAngle
    */
   public function clipCircle($x,
                              $y,
                              $radius,
                              $startAngle = null,
                              $endAngle = null);


.. code-block:: php
   :linenos:

   /**
    * Przycięcie obszaru za pomocą elipsy.
    *
    * Sygnatury metod:
    * drawEllipse($x1, $y1, $x2, $y2);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle);
    *
    * @todo obsłużyć przypadki gdy $x2-$x1 == 0 lub $y2-$y1 == 0
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param float $startAngle
    * @param float $endAngle
    */
   public function clipEllipse($x1,
                               $y1,
                               $x2,
                               $y2,
                               $startAngle = null,
                               $endAngle = null);


.. _zend.pdf.drawing.styles:

Style
-----

Klasa *Zend_Pdf_Style* zapewnia funkcjonalność styli.

Styles mogą być użyte w celu przechowania zestawu parametrów stanu grafiki i następnie zastosowania go na
stronie PDF za pomocą jednej operacji:

.. code-block:: php
   :linenos:

   /**
    * Ustawia styl dla przyszłych operacji rysowania na tej stronie
    *
    * @param Zend_Pdf_Style $style
    */
   public function setStyle(Zend_Pdf_Style $style);

   /**
    * Zwraca styl zastosowany dla strony.
    *
    * @return Zend_Pdf_Style|null
    */
   public function getStyle();


Klasa *Zend_Pdf_Style* zapewnia zestaw metod do ustawiania oraz pobierania różnych parametrów stanu grafiki:

.. code-block:: php
   :linenos:

   /**
    * Ustawia kolor linii.
    *
    * @param Zend_Pdf_Color $color
    */
   public function setLineColor(Zend_Pdf_Color $color);


.. code-block:: php
   :linenos:

   /**
    * Pobiera kolor linii.
    *
    * @return Zend_Pdf_Color|null
    */
   public function getLineColor();


.. code-block:: php
   :linenos:

   /**
    * Ustawia grubość linii.
    *
    * @param float $width
    */
   public function setLineWidth($width);


.. code-block:: php
   :linenos:

   /**
    * Pobiera grubość linii.
    *
    * @return float
    */
   public function getLineWidth();


.. code-block:: php
   :linenos:

   /**
    * Ustawia ozdobny wzór linii
    *
    * @param array $pattern
    * @param float $phase
    */
   public function setLineDashingPattern($pattern, $phase = 0);


.. code-block:: php
   :linenos:

   /**
    * Pobiera ozdobny wzór linii
    *
    * @return array
    */
   public function getLineDashingPattern();


.. code-block:: php
   :linenos:

   /**
    * Pobiera okres ozdobnej fazy.
    *
    * @return float
    */
   public function getLineDashingPhase();


.. code-block:: php
   :linenos:

   /**
    * Ustawia kolor wypełnienia.
    *
    * @param Zend_Pdf_Color $color
    */
   public function setFillColor(Zend_Pdf_Color $color);


.. code-block:: php
   :linenos:

   /**
    * Pobiera kolor wypełnienia.
    *
    * @return Zend_Pdf_Color|null
    */
   public function getFillColor();


.. code-block:: php
   :linenos:

   /**
    * Ustawia bieżącą czcionkę.
    *
    * @param Zend_Pdf_Resource_Font $font
    * @param float $fontSize
    */
   public function setFont(Zend_Pdf_Resource_Font $font, $fontSize);


.. code-block:: php
   :linenos:

   /**
    * Zmienia rozmiar bieżącej czcionki
    *
    * @param float $fontSize
    */
   public function setFontSize($fontSize);


.. code-block:: php
   :linenos:

   /**
    * Pobiera bieżącą czcionkę.
    *
    * @return Zend_Pdf_Resource_Font $font
    */
   public function getFont();


.. code-block:: php
   :linenos:

   /**
    * Pobiera rozmiar bieżącej czcionki
    *
    * @return float $fontSize
    */
   public function getFontSize();


.. _zend.pdf.drawing.alpha:

Przezroczystość
---------------

Moduł *Zend_Pdf* pozwala na obsługę przezroczystości.

Przezroczystość może być ustawiona za pomocą metody *Zend_Pdf_Page::setAlpha()*:

   .. code-block:: php
      :linenos:

      /**
       * Ustawia przezroczystość
       *
       * $alpha == 0  - przezroczysty
       * $alpha == 1  - nieprzezroczysty
       *
       * Tryby przezroczystości obsługiwane przez PDF:
       * Normal (default), Multiply, Screen, Overlay, Darken,
       * Lighten, ColorDodge, ColorBurn, HardLight,
       * SoftLight, Difference, Exclusion
       *
       * @param float $alpha
       * @param string $mode
       * @throws Zend_Pdf_Exception
       */
      public function setAlpha($alpha, $mode = 'Normal');






.. _`http://www.php.net/manual/en/ref.image.php`: http://www.php.net/manual/en/ref.image.php
.. _`http://www.php.net/manual/en/ref.zlib.php`: http://www.php.net/manual/en/ref.zlib.php
