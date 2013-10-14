.. EN-Revision: none
.. _zendpdf.drawing:

Dessiner
========

.. _zendpdf.drawing.geometry:

Géométrie
---------

Le format *PDF* utilise la même géométrie que le format PostScript. Elle démarre d'en bas à gauche et est
mesuré en points (1/72 inch soit 0,352778 mm).

La taille d'une page peut-être récupéré depuis un objet page :



   .. code-block:: php
      :linenos:

      $width  = $pdfPage->getWidth();
      $height = $pdfPage->getHeight();



.. _zendpdf.drawing.color:

Couleurs
--------

Le format *PDF* a d'excellentes capacités dans la représentation des couleurs. Le module ``ZendPdf`` supporte
les espaces de couleur : niveaux de gris, RGB et CMJN. Chacun d'entre eux peut-être utilisé à chaque fois qu'un
objet ``ZendPdf\Color`` est requis. Les classes ``ZendPdf_Color\GrayScale``, ``ZendPdf_Color\RGB`` et
``ZendPdf_Color\CMYK`` fournissent cette fonctionnalité :

.. code-block:: php
   :linenos:

   // $grayLevel (float). 0.0 (noir) - 1.0 (blanc)
   $color1 = new ZendPdf_Color\GrayScale($grayLevel);

   // $r, $g, $b (float).
   // 0.0 (intensité minimum) - 1.0 (intensité maximum)
   $color2 = new ZendPdf_Color\RGB($r, $g, $b);

   // $c, $m, $y, $k (float).
   // 0.0 (intensité minimum) - 1.0 (intensité maximum)
   $color3 = new ZendPdf_Color\CMYK($c, $m, $y, $k);

Les différentes couleurs HTML sont aussi fourni avec la classe ``ZendPdf_Color\Html``:

.. code-block:: php
   :linenos:

   $color1 = new ZendPdf_Color\Html('#3366FF');
   $color2 = new ZendPdf_Color\Html('silver');
   $color3 = new ZendPdf_Color\Html('forestgreen');

.. _zendpdf.drawing.shape-drawing:

Dessiner des formes
-------------------

Toutes les opérations de dessins peuvent être réalisées dans le contexte d'une page *PDF*.

La classe ``ZendPdf\Page`` fournit les outils de dessins :



   .. code-block:: php
      :linenos:

      /**
       * Dessine une ligne de x1,y1 à x2,y2.
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
    * Draw a rounded rectangle.
    *
    * Fill types:
    * ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE - fill rectangle
                                                  and stroke (default)
    * ZendPdf\Page::SHAPE_DRAW_STROKE      - stroke rectangle
    * ZendPdf\Page::SHAPE_DRAW_FILL        - fill rectangle
    *
    * radius is an integer representing radius of the four corners, or an array
    * of four integers representing the radius starting at top left, going
    * clockwise
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param integer|array $radius
    * @param integer $fillType
    * @return ZendPdf\Page
    */
   public function drawRoundedRectangle($x1, $y1, $x2, $y2, $radius,
                          $fillType = ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE);



   .. code-block:: php
      :linenos:

      /**
       * Dessine un rectangle.
       *
       * Type de remplissage:
       * ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE
       * - remplit le rectangle et dessine le contour (par défaut)
       * ZendPdf\Page::SHAPE_DRAW_STROKE
       * - trace uniquement le contour du rectangle
       * ZendPdf\Page::SHAPE_DRAW_FILL
       * - remplit le rectangle
       *
       * @param float $x1
       * @param float $y1
       * @param float $x2
       * @param float $y2
       * @return ZendPdf\Page
       * @param integer $fillType
       * @return ZendPdf\Page
       */
      public function drawRectangle(
          $x1, $y1, $x2, $y2, $fillType = ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE);





   .. code-block:: php
      :linenos:

      /**
       * Dessine un polygone.
       *
       * Si $fillType est ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE
       * ou ZendPdf\Page::SHAPE_DRAW_FILL,
       * le polygone est automatiquement fermé.
       * Regardez la description détaillée de ces méthodes dans la
       * documentation du format PDF
       * (section 4.4.2 Path painting Operators, Filling)
       *
       * @param array $x  - tableau de float (les coordonnés X des sommets)
       * @param array $y  - tableau de float (les coordonnés Y des sommets)
       * @param integer $fillType
       * @param integer $fillMethod
       * @return ZendPdf\Page
       */
      public function drawPolygon(
          $x, $y,
          $fillType = ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE,
          $fillMethod = ZendPdf\Page::FILL_METHOD_NON_ZERO_WINDING);





   .. code-block:: php
      :linenos:

      /**
       * Dessine un cercle avec comme centre  x, y et comme rayon radius.
       *
       * Les angles sont en radian
       *
       * Signatures des méthodes:
       * drawCircle($x, $y, $radius);
       * drawCircle($x, $y, $radius, $fillType);
       * drawCircle($x, $y, $radius, $startAngle, $endAngle);
       * drawCircle($x, $y, $radius, $startAngle, $endAngle, $fillType);
       *
       *
       * Ce n'est pas réellement un cercle, car le format supporte
       * uniquement des courbe de Bezier cubique.
       * Mais c'est une très bonne approximation.
       * La différence avec un vrai cercle est de au maximum 0.00026 radians
       * (avec les angles PI/8, 3*PI/8, 5*PI/8, 7*PI/8, 9*PI/8, 11*PI/8,
       * 13*PI/8 et 15*PI/8).
       * Avec les angles 0, PI/4, PI/2, 3*PI/4, PI, 5*PI/4, 3*PI/2 et 7*PI/4
       * c'est exactement la tangente d'un cercle.
       *
       * @param float $x
       * @param float $y
       * @param float $radius
       * @param mixed $param4
       * @param mixed $param5
       * @param mixed $param6
       * @return ZendPdf\Page
       */
      public function drawCircle(
          $x, $y, $radius, $param4 = null, $param5 = null, $param6 = null);





   .. code-block:: php
      :linenos:

      /**
       * Dessine une ellipse dans le rectangle spécifié.
       *
       * Signatures des méthodes:
       * drawEllipse($x1, $y1, $x2, $y2);
       * drawEllipse($x1, $y1, $x2, $y2, $fillType);
       * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle);
       * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle, $fillType);
       *
       * Les angles sont en radians
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
      public function drawEllipse(
          $x1, $y1, $x2, $y2, $param5 = null, $param6 = null, $param7 = null);



.. _zendpdf.drawing.text-drawing:

Dessiner du texte
-----------------

Les opérations de dessins existent bien sûr dans le contexte d'une page *PDF*. Vous pouvez dessiner une seule
ligne de texte à n'importe quelle endroit dans la page en fournissant les coordonnées x et y de la ligne de base.
La police courant ainsi que sa taille seront utilisées pour le dessin (voir la description ci-dessous).



   .. code-block:: php
      :linenos:

      /**
       * Dessine une ligne de texte à la position x,y.
       *
       * @param string $text
       * @param float $x
       * @param float $y
       * @param string $charEncoding (optionnel) encodage des caractères du texte.
       * Par défaut le réglage système est utilisé.
       * @throws ZendPdf\Exception
       * @return ZendPdf\Page
       */
      public function drawText($text, $x, $y, $charEncoding = '');



.. _zendpdf.drawing.text-drawing.example-1:

.. rubric:: Dessiner une ligne dans la page

.. code-block:: php
   :linenos:

   ...
   $pdfPage->drawText('Bonjour le monde!', 72, 720);
   ...

Par défaut, les chaînes de texte sont interprétées en utilisant l'encodage du système. Si vous avez une
chaîne qui utilise un encodage différent (comme les chaînes UTF-8 lues depuis une fichier sur le disque, ou une
chaîne MacRoman obtenue depuis une base de données), vous pouvez indiquer l'encodage au moment du dessin et
ZendPdf gérera la conversion pour vous. Vous pouvez fournir des chaînes dans n'importe quel encodage supporté
par la fonction *iconv()* de *PHP*:

.. _zendpdf.drawing.text-drawing.example-2:

.. rubric:: Dessiner une chaîne UTF-8 sur une page

.. code-block:: php
   :linenos:

   ...
   // Lit une chaîne UTF-8 à partir du disque
   $unicodeString = fread($fp, 1024);

   // Dessine une chaîne dans la page
   $pdfPage->drawText($unicodeString, 72, 720, 'UTF-8');
   ...

.. _zendpdf.drawing.using-fonts:

Utiliser des polices de caractères
----------------------------------

``ZendPdf\Page::drawText()`` utilise la police courante ainsi que sa taille, qui sont définies avec la méthode
``ZendPdf\Page::setFont()``:



   .. code-block:: php
      :linenos:

      /**
       * Choisit la police courante.
       *
       * @param ZendPdf_Resource\Font $font
       * @param float $fontSize
       * @return ZendPdf\Page
       */
      public function setFont(ZendPdf_Resource\Font $font, $fontSize);



Les documents *PDF* supportent PostScript Type 1 et les polices TrueType, mais également deux types spécifiques
*PDF*, Type3 et les polices composites. Il y a aussi 14 polices Type 1 standard intégré dans tout lecteur de
*PDF*: Courier (4 styles), Helvetica (4 styles), Times (4 styles), Symbol, et Zapf Dingbats.

ZendPdf supporte actuellement les 14 polices standard mais également vos propres police TrueType. Les objets de
police obtenus via une des deux fabriques méthodes : ``ZendPdf\Font::fontWithName($fontName)`` pour les 14
polices *PDF* standard ou ``ZendPdf\Font::fontWithPath($filePath)`` pour les polices personnalisées.

.. _zendpdf.drawing.using-fonts.example-1:

.. rubric:: Créer une police standard

.. code-block:: php
   :linenos:

   ...
   // Crée une nouvelle police
   $font = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_HELVETICA);

   // Applique la police
   $pdfPage->setFont($font, 36);
   ...

Les constantes pour les 14 polices standard sont définis dans la classe ``ZendPdf\Font``:

   - ZendPdf\Font::FONT_COURIER

   - ZendPdf\Font::FONT_COURIER_BOLD

   - ZendPdf\Font::FONT_COURIER_ITALIC

   - ZendPdf\Font::FONT_COURIER_BOLD_ITALIC

   - ZendPdf\Font::FONT_TIMES

   - ZendPdf\Font::FONT_TIMES_BOLD

   - ZendPdf\Font::FONT_TIMES_ITALIC

   - ZendPdf\Font::FONT_TIMES_BOLD_ITALIC

   - ZendPdf\Font::FONT_HELVETICA

   - ZendPdf\Font::FONT_HELVETICA_BOLD

   - ZendPdf\Font::FONT_HELVETICA_ITALIC

   - ZendPdf\Font::FONT_HELVETICA_BOLD_ITALIC

   - ZendPdf\Font::FONT_SYMBOL

   - ZendPdf\Font::FONT_ZAPFDINGBATS



Vous pouvez aussi prendre n'importe quelle police TrueType (extension habituelle ".ttf") ou OpenType (".otf") si
elles ont une silhouette TrueType. Pour l'instant non supportée, les polices Mac Os X ".dfont" et les collections
TrueType Microsoft (".ttc") seront intégrées dans une version future.

Pour utiliser une police TrueType, vous devez fournir le chemin de fichier complet vers cette police. Si la police
ne peut pas être lue pour une quelconque raison, ou si ce n'est pas une police TrueType, la méthode lèvera une
exception :

.. _zendpdf.drawing.using-fonts.example-2:

.. rubric:: Créer une police TrueType

.. code-block:: php
   :linenos:

   ...
   // Crée la nouvelle police
   $goodDogCoolFont = ZendPdf\Font::fontWithPath('/chemin/vers/GOODDC__.TTF');

   // Applique cette police
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...

Par défaut, les polices personnalisées seront incorporées dans le document *PDF* résultant. Cela permet aux
destinataires de voir la page comme prévu, même s'ils ne font pas installer les polices appropriées sur leur
système. En cas de problème avec la taille du fichier généré, vous pouvez demander que la police ne soit pas
incorporé en passant l'option 'ne pas inclure' à la méthode de création :

.. _zendpdf.drawing.using-fonts.example-3:

.. rubric:: Créer une police TrueType sans l'incorporer dans le document PDF

.. code-block:: php
   :linenos:

   ...
   // Crée la nouvelle police
   $goodDogCoolFont =
       ZendPdf\Font::fontWithPath('/chemin/vers/GOODDC__.TTF',
                                   ZendPdf\Font::EMBED_DONT_EMBED);

   // Applique cette police
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...

Si les polices ne sont pas incorporées mais que le destinataire du fichier *PDF* a ces polices installées sur son
système, il verra le document comme prévu. Si la police correcte n'est pas installée, l'application de
visualisation du *PDF* fera de son mieux pour synthétiser une police de remplacement.

Quelques polices ont les règles de licence très spécifiques qui les empêchent d'être incorporées dans des
documents *PDF*. Donc vous devez faire attention, si vous essayez d'utiliser une police qui ne peut pas être
incorporée, la méthode de création lèvera une exception.

Vous pouvez toujours utiliser ces polices, mais vous devez passer le paramètre 'ne pas inclure' comme décrit
ci-dessous, ou vous pouvez simplement bloquer l'exception :

.. _zendpdf.drawing.using-fonts.example-4:

.. rubric:: Ne pas lever d'exception pour les polices ne pouvant être incorporées

.. code-block:: php
   :linenos:

   ...
   $font =
       ZendPdf\Font::fontWithPath('/chemin/vers/PoliceNonIncorporable.ttf',
                                   ZendPdf\Font::EMBED_SUPPRESS_EMBED_EXCEPTION);
   ...

Cette technique de suppression est préférée si vous permettez aux utilisateurs de choisir leurs propres polices.
Les polices qui peuvent être incorporées dans le document *PDF* le seront ; les autres ne le seront pas.

Les fichiers de police peuvent être assez grands, certains peuvent atteindre des dizaines de méga-octets. Par
défaut, toutes les polices incorporées sont comprimées en utilisant le schéma de compression Flate, ayant pour
résultat un gain d'espace de 50% en moyenne. Si, pour une quelconque raison, vous ne voulez pas comprimer la
police, vous pouvez le neutraliser avec une option :

.. _zendpdf.drawing.using-fonts.example-5:

.. rubric:: Ne pas compresser une police incorporée

.. code-block:: php
   :linenos:

   ...
   $font =
       ZendPdf\Font::fontWithPath('/chemin/vers/PoliceDeGrandeTaille.ttf',
                                   ZendPdf\Font::EMBED_DONT_COMPRESS);
   ...

En conclusion, si nécessaire, vous pouvez combiner les options d'incorporation en employant l'opérateur binaire
OR :

.. _zendpdf.drawing.using-fonts.example-6:

.. rubric:: Combiner les options de polices incorporées

.. code-block:: php
   :linenos:

   ...
   $font = ZendPdf\Font::fontWithPath(
       $cheminVersPoliceQuelconque,
       (ZendPdf\Font::EMBED_SUPPRESS_EMBED_EXCEPTION |
        ZendPdf\Font::EMBED_DONT_COMPRESS));
   ...

.. _zendpdf.drawing.standard-fonts-limitations:

Limitations des polices standard PDF
------------------------------------

Les polices standard *PDF* emploient en interne plusieurs encodages sur un seul octet (voir `PDF Reference, Sixth
Edition, version 1.7`_- Annexe D pour plus de détails). Elles sont généralement avec un jeu de caractère de
type Latin1(excepté les polices Symbol and ZapfDingbats).

``ZendPdf`` utilise l'encodage CP1252 (WinLatin1) pour tracer les textes avec les polices standard.

Le texte peut encore être fourni dans n'importe quel autre encodage, qui doit être spécifié s'il diffère de
celui en cours. Seulement les caractères WinLatin1 seront tracés réellement.

.. _zendpdf.drawing.using-fonts.example-7:

.. rubric:: Combiner les options de polices embarqués

.. code-block:: php
   :linenos:

   ...
   $font = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_COURIER);
   $pdfPage->setFont($font, 36)
           ->drawText('Euro sign - €', 72, 720, 'UTF-8')
           ->drawText('Text with umlauts - à è ì', 72, 650, 'UTF-8');
   ...

.. _zendpdf.drawing.extracting-fonts:

Extraction des polices
----------------------

Depuis la version 1.5, ``ZendPdf`` fournit la possibilité d'extraire les polices des documents chargés.

Ceci peut être utile lors des mises à jour de document avec ajout de texte. Sans cette fonctionnalité vous devez
attacher et probablement intégrer la police dans le document chaque fois que vous voulez le mettre à jour.

Les objets ``ZendPdf`` et ``ZendPdf\Page`` fournissent une méthode spéciale pour extraire toutes les polices
mentionnés à l'intérieur d'un document ou d'une page :

.. _zendpdf.drawing.extracting-fonts.example-1:

.. rubric:: Extraction de polices à partir d'un document chargé

.. code-block:: php
   :linenos:

   ...
   $pdf = ZendPdf\Pdf::load($cheminVersDocument);
   ...
   // Récupère toutes les polices du document
   $listePolice = $pdf->extractFonts();
   $pdf->pages[] = ($page = $pdf->newPage(ZendPdf\Page::SIZE_A4));
   $yPosition = 700;
   foreach ($listePolice as $police) {
       $page->setFont($police, 15);
       $page->drawText(
           $police->getFontName(ZendPdf\Font::NAME_POSTSCRIPT, 'fr', 'UTF-8')
         . ': Le renard brun rapide saute par-dessus le chien paresseux',
           100,
           $yPosition,
           'UTF-8');
       $yPosition -= 30;
   }
   ...
   // Récupère toutes les polices référencées dans la première page du document
   $firstPage = reset($pdf->pages);
   $firstPageFonts = $firstPage->extractFonts();
   ...

.. _zendpdf.drawing.extracting-fonts.example-2:

.. rubric:: Extraction d'une police à partir d'un document chargé en spécifiant le nom de police

.. code-block:: php
   :linenos:

   ...
   $pdf = new ZendPdf\Pdf();
   ...
   $pdf->pages[] = ($page = $pdf->newPage(ZendPdf\Page::SIZE_A4));

   $police = ZendPdf\Font::fontWithPath($cheminVersPolices);
   $page->setFont($police, $taillePolice);
   $page->drawText($texte, $x, $y);
   ...
   // Ce nom de police peut être stocké quelquepart...
   $fontName = $font->getFontName(ZendPdf\Font::NAME_POSTSCRIPT, 'fr', 'UTF-8');
   ...
   $pdf->save($cheminVersDocument);
   ...

.. code-block:: php
   :linenos:

   ...
   $pdf = ZendPdf\Pdf::load($cheminVersDocument);
   ...
   $pdf->pages[] = ($page = $pdf->newPage(ZendPdf\Page::SIZE_A4));

   $police = $pdf->extractFont($nomPolice);
   /* $pageSource->extractFont($nomPolice) peut aussi être utilisé ici */
   $page->setFont($police, $taillePolice);
   $page->drawText($texte, $x, $y);
   ...
   $pdf->save($cheminVersDocument, true /* mise à jour de type incrémental */);
   ...

Les polices extraites peuvent être utilisées à la place de n'importe quelle autre police avec les limitations
suivantes :

   - La police extraite peut être employée seulement dans le cadre du document à partir duquel elle a été
     extraite.

   - Les possibles programmes de polices incorporées ne sont pas extraits réellement. La police ainsi extraite ne
     peut pas fournir la métrique correcte de police et la police originale doit être utilisée pour les calculs
     de largeur des textes :

        .. code-block:: php
           :linenos:

           ...
           $police = $pdf->extractFont($fontName);
           $policeOriginal = ZendPdf\Font::fontWithPath($cheminVersPolices);

           /* utilisation d'une police extraite */
           $page->setFont($police, $taillePolice);
           $xPosition = $x;
           for ($charIndex = 0; $charIndex < strlen($text); $charIndex++) {
               $page->drawText($text[$charIndex], $xPosition, $y);

               // Use original font for text width calculation
               $width = $originalFont->widthForGlyph(
                           $originalFont->glyphNumberForCharacter($text[$charIndex])
                        );
               $xPosition += $width / $originalFont->getUnitsPerEm() * $taillePolice;
           }
           ...





.. _zendpdf.drawing.image-drawing:

Insertion d'images
------------------

La classe ``ZendPdf\Page`` fournis la méthode ``drawImage()`` pour dessiner une image :



   .. code-block:: php
      :linenos:

      /**
       * Insère une image à la position spécifiée dans la page
       *
       * @param ZendPdf_Resource\Image $image
       * @param float $x1
       * @param float $y1
       * @param float $x2
       * @param float $y2
       * @return ZendPdf\Page
       */
      public function drawImage(ZendPdf_Resource\Image $image, $x1, $y1, $x2, $y2);



Les objets Image peuvent être créés avec la méthode ``ZendPdf\Image::imageWithPath($filePath)`` (les images
JPG, PNG et TIFF sont maintenant supportées) :

.. _zendpdf.drawing.image-drawing.example-1:

.. rubric:: Insertion d'images

.. code-block:: php
   :linenos:

   ...
   //Charger une image
   $image = ZendPdf\Image::imageWithPath('mon_image.jpg');

   $pdfPage->drawImage($image, 100, 100, 400, 300);
   ...

**Important ! Le support JPEG nécessite que l'extension PHP GD soit installé.** **Important ! Le support PNG
nécessite que l'extension ZLIB soit configuré pour accepter les images avec canaux Alpha.**

Lisez la documentation de *PHP* pour plus d'informations (`http://www.php.net/manual/fr/ref.image.php`_ et
`http://www.php.net/manual/fr/ref.zlib.php`_).

.. _zendpdf.drawing.line-drawing-style:

Style de lignes
---------------

Le style de ligne est définit par l'épaisseur, la couleur et le style de tiret. Tout ces paramètres peuvent
être assignés par les méthodes de la classe ``ZendPdf\Page``:



   .. code-block:: php
      :linenos:

      /** Choisit la couleur de ligne. */
      public function setLineColor(ZendPdf\Color $color);

      /** Choisit l'épaisseur de ligne. */
      public function setLineWidth(float $width);

      /**
       * Choisit le modèle de tiret.
       *
       * modele est un tableau de floats: array(longueur_visible,
       * longueur_invisible, longueur_visible, longueur_invisible,
       * ...)
       * phase est le décalage à partir du début de la ligne.
       *
       * @param array $modele
       * @param array $phase
       * @return ZendPdf\Page
       */
      public function setLineDashingPattern($pattern, $phase = 0);



.. _zendpdf.drawing.fill-style:

Style de remplissage
--------------------

Les méthodes ``ZendPdf\Page::drawRectangle()``, ``ZendPdf\Page::drawPoligon()``, ``ZendPdf\Page::drawCircle()``
et ``ZendPdf\Page::drawEllipse()`` prennent en argument optionnel le type de remplissage: ``$fillType``. Il peut
être :

- ZendPdf\Page::SHAPE_DRAW_STROKE - trace le contour de la forme

- ZendPdf\Page::SHAPE_DRAW_FILL - remplit uniquement la forme

- ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE - remplissage et contour (par défaut)

La méthode ``ZendPdf\Page::drawPoligon()`` prend aussi paramètre supplémentaire ``$fillMethod``:

- $fillMethod = ZendPdf\Page::FILL_METHOD_NON_ZERO_WINDING (par défaut)

  La :t:`référence du format PDF`  décrit la règle comme ceci :
  | The nonzero winding number rule determines whether a given point is inside a path by conceptually drawing a ray
  from that point to infinity in any direction and then examining the places where a segment of the path crosses
  the ray. Starting with a count of 0, the rule adds 1 each time a path segment crosses the ray from left to right
  and subtracts 1 each time a segment crosses from right to left. After counting all the crossings, if the result
  is 0 then the point is outside the path; otherwise it is inside. Note: The method just described does not specify
  what to do if a path segment coincides with or is tangent to the chosen ray. Since the direction of the ray is
  arbitrary, the rule simply chooses a ray that does not encounter such problem intersections. For simple convex
  paths, the nonzero winding number rule defines the inside and outside as one would intuitively expect. The more
  interesting cases are those involving complex or self-intersecting paths like the ones shown in Figure 4.10 (in a
  *PDF* Reference). For a path consisting of a five-pointed star, drawn with five connected straight line segments
  intersecting each other, the rule considers the inside to be the entire area enclosed by the star, including the
  pentagon in the center. For a path composed of two concentric circles, the areas enclosed by both circles are
  considered to be inside, provided that both are drawn in the same direction. If the circles are drawn in opposite
  directions, only the "doughnut" shape between them is inside, according to the rule; the "doughnut hole" is
  outside.



- ZendPdf\Page::FILL_METHOD_EVEN_ODD

  La :t:`référence du format PDF`  décrit la règle comme ceci :
  | An alternative to the nonzero winding number rule is the even-odd rule. This rule determines the "insideness"
  of
  a point by drawing a ray from that point in any direction and simply counting the number of path segments that
  cross the ray, regardless of direction. If this number is odd, the point is inside; if even, the point is
  outside. This yields the same results as the nonzero winding number rule for paths with simple shapes, but
  produces different results for more complex shapes. Figure 4.11 (in a *PDF* Reference) shows the effects of
  applying the even-odd rule to complex paths. For the five-pointed star, the rule considers the triangular points
  to be inside the path, but not the pentagon in the center. For the two concentric circles, only the "doughnut"
  shape between the two circles is considered inside, regardless of the directions in which the circles are drawn.



.. _zendpdf.drawing.linear-transformations:

Transformations linéaires
-------------------------

.. _zendpdf.drawing.linear-transformations.rotations:

Rotations
^^^^^^^^^

La page *PDF* page peut être tourné avant d'appliquer toute opération de dessin. Ceci peut être fait avec la
méthode ``ZendPdf\Page::rotate()``:

.. code-block:: php
   :linenos:

   /**
    * Rotation de la page
    *
    * @param float $x  - la coordonnée X du point de rotation
    * @param float $y  - la coordonnée X du point de rotation
    * @param float $angle - angle de rotation
    * @return ZendPdf\Page
    */
   public function rotate($x, $y, $angle);

.. _zendpdf.drawing.linear-transformations.scale:

A partir de Zend Framework 1.8, mise à l'échelle
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La mise à l'échelle est fournie par la méthode ``ZendPdf\Page::scale()``:

.. code-block:: php
   :linenos:

   /**
    * Mise à l'échelle
    *
    * @param float $xScale - X dimension scale factor
    * @param float $yScale - Y dimension scale factor
    * @return ZendPdf\Page
    */
   public function scale($xScale, $yScale);

.. _zendpdf.drawing.linear-transformations.translate:

A partir de Zend Framework 1.8, décalage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Le décalage du système de coordonnées est réalisé par la méthode ``ZendPdf\Page::translate()``:

.. code-block:: php
   :linenos:

   /**
    * Décalage du système de coordonnées
    *
    * @param float $xShift - coordonnées X du décalage
    * @param float $yShift - coordonnées Y du décalage
    * @return ZendPdf\Page
    */
   public function translate($xShift, $yShift);

.. _zendpdf.drawing.linear-transformations.skew:

A partir de Zend Framework 1.8, mise en biais
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La mise en biais de la page peut être réalisé par la méthode ``ZendPdf\Page::skew()``:

.. code-block:: php
   :linenos:

   /**
    * Mise en biais du système de coordonnées
    *
    * @param float $x  - the X co-ordinate of axis skew point
    * @param float $y  - the Y co-ordinate of axis skew point
    * @param float $xAngle - X axis skew angle
    * @param float $yAngle - Y axis skew angle
    * @return ZendPdf\Page
    */
   public function skew($x, $y, $xAngle, $yAngle);

.. _zendpdf.drawing.save-restore:

Sauvegarder et restaurer l'état graphique
-----------------------------------------

L'état graphique (police courante, taille de caractère, couleur de ligne, couleur de remplissage, style de ligne,
sens de la page, zone de dessin) peut-être sauvegarder à tout moment. L'opération de sauvegarde empile le
contexte dans une pile de contexte graphique, l'opération de restauration récupère le contexte depuis la pile.

Il y a deux méthodes dans la classe ``ZendPdf\Page`` pour réaliser ces opérations :



   .. code-block:: php
      :linenos:

      /**
       * Sauvegarde l'état graphique de la page.
       * Cela prend un instantané des styles courants, des zones de dessins
       * et de toutes les rotations/translations/changements de taille appliqués.
       *
       * @return ZendPdf\Page
       */
      public function saveGS();

      /**
       * Restaure le dernier état graphique sauvegarder avec saveGS().
       *
       * @return ZendPdf\Page
       */
      public function restoreGS();



.. _zendpdf.drawing.clipping:

Zone de dessin
--------------

Le format *PDF* et le module ZendPdf supporte le découpage de la zone de dessin. La zone de dessin courante
limite la zone de la page affectée par l'utilisation des opérateurs de dessins. Initialement c'est toute la page.

La classe ``ZendPdf\Page`` fournit des méthodes pour les opérations de découpage.



   .. code-block:: php
      :linenos:

      /**
       * Découpe la zone courante avec un rectangle.
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
       * Découpe la zone courante avec un polygone.
       *
       * @param array $x  - tableau de float (les coordonnées X des sommets)
       * @param array $y  - tableau de float (les coordonnées Y des sommets)
       * @param integer $fillMethod
       * @return ZendPdf\Page
       */
      public function clipPolygon(
          $x, $y, $fillMethod = ZendPdf\Page::FILL_METHOD_NON_ZERO_WINDING);





   .. code-block:: php
      :linenos:

      /**
       * Découpe la zone courante avec un cercle.
       *
       * @param float $x
       * @param float $y
       * @param float $radius
       * @param float $startAngle
       * @param float $endAngle
       * @return ZendPdf\Page
       */
      public function clipCircle(
          $x, $y, $radius, $startAngle = null, $endAngle = null);





   .. code-block:: php
      :linenos:

      /**
       * Découpe la zone courante avec une ellipse.
       *
       * Signatures des méthodes:
       * drawEllipse($x1, $y1, $x2, $y2);
       * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle);
       *
       * @todo s'occuper des cas spéciaux avec $x2-$x1 == 0 ou $y2-$y1 == 0
       *
       * @param float $x1
       * @param float $y1
       * @param float $x2
       * @param float $y2
       * @param float $startAngle
       * @param float $endAngle
       * @return ZendPdf\Page
       */
      public function clipEllipse(
          $x1, $y1, $x2, $y2, $startAngle = null, $endAngle = null);



.. _zendpdf.drawing.styles:

Styles
------

La classe ``ZendPdf\Style`` fournit les fonctionnalités de style.

Les styles peuvent être utilisés pour stocker des paramètre d'état graphique et de les appliquer à une page
*PDF* en une seule opération :



   .. code-block:: php
      :linenos:

      /**
       * Choisit le style à utiliser pour les futures opérations
       * de dessin sur cette page
       *
       * @param ZendPdf\Style $style
       * @return ZendPdf\Page
       */
      public function setStyle(ZendPdf\Style $style);

      /**
       * Renvoie le style appliqué à la page.
       *
       * @return ZendPdf\Style|null
       */
      public function getStyle();



La classe ``ZendPdf\Style`` fournit des méthodes pour choisir ou récupérer différents paramètres de l'état
graphique :



   .. code-block:: php
      :linenos:

      /**
       * Choisit la couleur de ligne.
       *
       * @param ZendPdf\Color $color
       * @return ZendPdf\Page
       */
      public function setLineColor(ZendPdf\Color $color);





   .. code-block:: php
      :linenos:

      /**
       * Récupère la couleur de ligne.
       *
       * @return ZendPdf\Color|null
       * @return ZendPdf\Page
       */
      public function getLineColor();





   .. code-block:: php
      :linenos:

      /**
       * Choisit l'épaisseur de ligne.
       *
       * @param float $width
       * @return ZendPdf\Page
       */
      public function setLineWidth($width);





   .. code-block:: php
      :linenos:

      /**
       * Récupère l'épaisseur de ligne.
       *
       * @return float
       * @return ZendPdf\Page
       */
      public function getLineWidth($width);





   .. code-block:: php
      :linenos:

      /**
       * Choisit le style de tiret
       *
       * @param array $pattern
       * @param float $phase
       * @return ZendPdf\Page
       */
      public function setLineDashingPattern($pattern, $phase = 0);





   .. code-block:: php
      :linenos:

      /**
       * Récupère le style de tiret
       *
       * @return array
       */
      public function getLineDashingPattern();





   .. code-block:: php
      :linenos:

      /**
       * Récupère le modèle de tiret
       *
       * @return float
       */
      public function getLineDashingPhase();





   .. code-block:: php
      :linenos:

      /**
       * Choisit la couleur de remplissage.
       *
       * @param ZendPdf\Color $color
       * @return ZendPdf\Page
       */
      public function setFillColor(ZendPdf\Color $color);





   .. code-block:: php
      :linenos:

      /**
       * Récupère la couleur de remplissage.
       *
       * @return ZendPdf\Color|null
       */
      public function getFillColor();





   .. code-block:: php
      :linenos:

      /**
       * Choisit la police.
       *
       * @param ZendPdf\Font $font
       * @param ZendPdf_Resource\Font $font
       * @param float $fontSize
       */
      public function setFont(ZendPdf_Resource\Font $font, $fontSize);





   .. code-block:: php
      :linenos:

      /**
       * Modifie la taille de police.
       *
       * @param float $fontSize
       * @return ZendPdf\Page
       */
      public function setFontSize($fontSize);





   .. code-block:: php
      :linenos:

      /**
       * Récupère la police courante
       *
       * @return ZendPdf_Resource\Font $font
       */
      public function getFont();





   .. code-block:: php
      :linenos:

      /**
       * Récupère la taille de la police
       *
       * @return float $fontSize
       */
      public function getFontSize();



.. _zendpdf.drawing.alpha:

Transparence
------------

Le module ``ZendPdf`` supporte la gestion de la transparence.

La transparence peut être paramétré en utilisant la méthode ``ZendPdf\Page::setAlpha()``:

   .. code-block:: php
      :linenos:

      /**
       * Règle la transparence
       *
       * $alpha == 0  - transparent
       * $alpha == 1  - opaque
       *
       * Transparency modes, supported by PDF:
       * Normal (default), Multiply, Screen, Overlay, Darken,
       * Lighten, ColorDodge, ColorBurn, HardLight,
       * SoftLight, Difference, Exclusion
       *
       * @param float $alpha
       * @param string $mode
       * @throws ZendPdf\Exception
       * @return ZendPdf\Page
       */
      public function setAlpha($alpha, $mode = 'Normal');





.. _`PDF Reference, Sixth Edition, version 1.7`: http://www.adobe.com/devnet/acrobat/pdfs/pdf_reference_1-7.pdf
.. _`http://www.php.net/manual/fr/ref.image.php`: http://www.php.net/manual/fr/ref.image.php
.. _`http://www.php.net/manual/fr/ref.zlib.php`: http://www.php.net/manual/fr/ref.zlib.php
