.. EN-Revision: none
.. _zend.pdf.drawing:

描画
==

.. _zend.pdf.drawing.geometry:

ジオメトリ
-----

*PDF* は PostScript と同じジオメトリを使用します。ページの左下隅を基準とし、
デフォルトではポイント数 (1 インチの 1/72) で場所を指定します。

ページの大きさはページオブジェクトから取得できます。



   .. code-block:: php
      :linenos:

      $width  = $pdfPage->getWidth();
      $height = $pdfPage->getHeight();



.. _zend.pdf.drawing.color:

色
-

*PDF* には、色を表現するためのさまざまな方法があります。 ``Zend_Pdf`` では、
グレイスケール、RGB および CMYK 色空間をサポートしています。 ``Zend_Pdf_Color``
オブジェクトが要求される箇所では、
これらのどれでも使用できます。それぞれの色空間に対応する機能を提供するのが
``Zend_Pdf_Color_GrayScale``\ 、 ``Zend_Pdf_Color_Rgb`` および ``Zend_Pdf_Color_Cmyk`` クラスです。

.. code-block:: php
   :linenos:

   // $grayLevel (float 型の数値)。0.0 (黒) - 1.0 (白)
   $color1 = new Zend_Pdf_Color_GrayScale($grayLevel);

   // $r, $g, $b (float 型の数値)。0.0 (最低の強度) - 1.0 (最大の強度)
   $color2 = new Zend_Pdf_Color_Rgb($r, $g, $b);

   // $c, $m, $y, $k (float 型の数値)。0.0 (最小の強度) - 1.0 (最大の強度)
   $color3 = new Zend_Pdf_Color_Cmyk($c, $m, $y, $k);

HTML 形式の色指定も ``Zend_Pdf_Color_Html`` クラスで使用できます。

.. code-block:: php
   :linenos:

   $color1 = new Zend_Pdf_Color_Html('#3366FF');
   $color2 = new Zend_Pdf_Color_Html('silver');
   $color3 = new Zend_Pdf_Color_Html('forestgreen');

.. _zend.pdf.drawing.shape-drawing:

図形の描画
-----

描画操作は、 *PDF* のページに対して行われます。

基本図形のセットが ``Zend_Pdf_Page`` クラスで提供されています。

.. code-block:: php
   :linenos:

   /**
    * x1,y1 から x2,y2 まで直線を描画します。
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
    * 矩形を描画します。
    *
    * 描画方法
    * Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE - 輪郭を描画して塗りつぶします (デフォルト)
    * Zend_Pdf_Page::SHAPE_DRAW_STROKE          - 輪郭を描画します
    * Zend_Pdf_Page::SHAPE_DRAW_FILL            - 矩形を塗りつぶします
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
    * Draw a rounded rectangle.
    *
    * Fill types:
    * Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE - fill rectangle and stroke (default)
    * Zend_Pdf_Page::SHAPE_DRAW_STROKE      - stroke rectangle
    * Zend_Pdf_Page::SHAPE_DRAW_FILL        - fill rectangle
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
    * @return Zend_Pdf_Page
    */
   public function drawRoundedRectangle($x1, $y1, $x2, $y2, $radius,
                          $fillType = Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE);

.. code-block:: php
   :linenos:

   /**
    * 多角形を描画します。
    *
    * $fillType が Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE あるいは Zend_Pdf_Page::SHAPE_DRAW_FILL
    * の場合、多角形は自動的に閉じられます。このメソッドについての詳細は、
    * PDF のドキュメント (section 4.4.2 Path painting Operators, Filling)
    * を参照ください。
    *
    * @param array $x  - float の配列 (頂点の X 座標)
    * @param array $y  - float の配列 (頂点の Y 座標)
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
    * 中心が x, y で半径が radius の円を描画します。
    *
    * 角度はラジアンで指定します。
    *
    * Method signatures:
    * drawCircle($x, $y, $radius);
    * drawCircle($x, $y, $radius, $fillType);
    * drawCircle($x, $y, $radius, $startAngle, $endAngle);
    * drawCircle($x, $y, $radius, $startAngle, $endAngle, $fillType);
    *
    *
    * これは本当の円ではありません。PDF は 3 次ベジエ曲線しかサポートしていないからです。
    * とはいえ、本当の円にかなり近くなります。
    * 本当の円との誤差は、最大でも半径の 0.00026 倍にしかなりません
    * (角度が PI/8, 3*PI/8, 5*PI/8, 7*PI/8, 9*PI/8, 11*PI/8, 13*PI/8 そして 15*PI/8 の場合)。
    * 0, PI/4, PI/2, 3*PI/4, PI, 5*PI/4, 3*PI/2 そして 7*PI/4 の場合は、円の正確な接線となります。
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
    * 指定した矩形に内接する楕円を描画します。
    *
    * Method signatures:
    * drawEllipse($x1, $y1, $x2, $y2);
    * drawEllipse($x1, $y1, $x2, $y2, $fillType);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle, $fillType);
    *
    * 角度はラジアンで指定します。
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

テキストの描画
-------

テキストに対する描画操作も、 *PDF* のページに対して行われます。 ベースラインの x
座標および y 座標を指定することで、 ページ内の任意の場所にテキストを 1
行描画できます。
現在のフォントおよびフォントサイズを使用して、描画操作が行われます
(詳細は、以下を参照ください)。

.. code-block:: php
   :linenos:

   /**
    * 指定した位置にテキストを描画します。
    *
    * @param string $text
    * @param float $x
    * @param float $y
    * @param string $charEncoding (オプション) ソーステキストの文字エンコーディング。
    *   デフォルトは現在のロケールです。
    * @throws Zend_Pdf_Exception
    * @return Zend_Pdf_Page
    */
   public function drawText($text, $x, $y, $charEncoding = '');

.. _zend.pdf.drawing.text-drawing.example-1:

.. rubric:: ページ上への文字列の描画

.. code-block:: php
   :linenos:

   ...
   $pdfPage->drawText('Hello world!', 72, 720);
   ...

デフォルトでは、現在のロケールのエンコーディングによって
テキストの文字列が解釈されます。異なるエンコーディングを使用している場合
(例えば、ディスク上のファイルから UTF-8 の文字列を読み込んだり
レガシーなデータベースから MacRoman の文字列を取得したりなど) は、
描画の際に文字エンコーディングを指定できます。 そうすることで、 ``Zend_Pdf``
が変換処理を行います。 *PHP* の *iconv()*
関数がサポートしているエンコーディングなら、すべて入力として使用することが可能です。

.. _zend.pdf.drawing.text-drawing.example-2:

.. rubric:: UTF-8 でエンコードされた文字列をページに描画する

.. code-block:: php
   :linenos:

   ...
   // UTF-8 エンコードされた文字列をディスクから読み込みます
   $unicodeString = fread($fp, 1024);

   // 文字列をページ上に描画します
   $pdfPage->drawText($unicodeString, 72, 720, 'UTF-8');
   ...

.. _zend.pdf.drawing.using-fonts:

フォントの使用
-------

``Zend_Pdf_Page::drawText()`` は、
現在設定されているフォントおよびフォントサイズを使用します。 これは
``Zend_Pdf_Page::setFont()`` メソッドで設定できます。

.. code-block:: php
   :linenos:

   /**
    * 現在のフォントを設定します。
    *
    * @param Zend_Pdf_Resource_Font $font
    * @param float $fontSize
    * @return Zend_Pdf_Page
    */
   public function setFont(Zend_Pdf_Resource_Font $font, $fontSize);

*PDF* ドキュメントは、PostScript Type 1 フォントおよび TrueType フォントだけでなく、 *PDF*
用の特別な形式である Type 3 フォントや複合フォントもサポートしています。
すべての *PDF* ビューアには、以下の 14 種類の標準 Type 1
フォントが組み込まれています。 その内容は Courier (4 種類)、Helvetica (4 種類)、Times (4
種類)、Symbol そして Zapf Dingbats です。

現在 ``Zend_Pdf`` は、標準の 14 種類の *PDF* フォントだけでなく 独自の TrueType
フォントもサポートしています。フォントオブジェクトを取得するには、 2
種類のファクトリーメソッドのいずれかを使用します。使用するメソッドは、 標準の
14 種類の *PDF* フォントの場合は ``Zend_Pdf_Font::fontWithName($fontName)``\ 、
独自のフォントの場合は ``Zend_Pdf_Font::fontWithPath($filePath)`` です。

.. _zend.pdf.drawing.using-fonts.example-1:

.. rubric:: 標準フォントの作成

.. code-block:: php
   :linenos:

   ...
   // 新しいフォントを作成します。
   $font = Zend_Pdf_Font::fontWithName(Zend_Pdf_Font::FONT_HELVETICA);

   // フォントを適用します。
   $pdfPage->setFont($font, 36);
   ...

14 種類の標準フォント名を表す定数は、 ``Zend_Pdf_Font`` クラスで定義されています。

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



任意の TrueType フォント (通常は '.ttf' という拡張子です) も使用できますし、 TrueType
アウトラインを含む OpenType フォント (拡張子は '.otf')
を使用することも可能です。現在はまだサポートしていませんが、将来は Mac OS X の
.dfont ファイルや Microsoft TrueType Collection (拡張子 '.ttc')
ファイルもサポートする予定です。

TrueType
フォントを使用するには、フォントへのフルパスを指定しなければなりません。
何らかの理由でフォントが読み込めなかった場合、あるいはそれが TrueType
フォントでなかった場合は、ファクトリーメソッドが例外をスローします。

.. _zend.pdf.drawing.using-fonts.example-2:

.. rubric:: TrueType フォントの作成

.. code-block:: php
   :linenos:

   ...
   // 新しいフォントを作成します
   $goodDogCoolFont = Zend_Pdf_Font::fontWithPath('/path/to/GOODDC__.TTF');

   // フォントを適用します
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...

デフォルトでは、独自のフォントは *PDF* ドキュメントに埋め込まれます。
そのため、閲覧者のシステムにそのフォントがインストールされていなくても、
ページをきちんと閲覧できるようになります。ファイルの大きさが気になる場合は、
ファクトリーメソッドのオプションで「フォントを埋め込まない」ことを指定できます。

.. _zend.pdf.drawing.using-fonts.example-3:

.. rubric:: TrueType を作成するが、PDF ドキュメントには埋め込まない

.. code-block:: php
   :linenos:

   ...
   // 新しいフォントを作成します
   $goodDogCoolFont = Zend_Pdf_Font::fontWithPath('/path/to/GOODDC__.TTF',
                                                  Zend_Pdf_Font::EMBED_DONT_EMBED);

   // フォントを適用します
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...

*PDF* ファイルにフォントが埋め込まれていないけれども
閲覧者のシステムにはそのフォントがインストールされている場合は、ドキュメントは通常通りに閲覧できます。
もし適切なフォントがインストールされていないは、 *PDF*
閲覧アプリケーションが適切な代替フォントを選択します。

中には、 *PDF*
ドキュメントへの埋め込みを禁止するようなライセンスを使用しているフォントもあります。
これをあなどってはいけません。もし埋め込めないフォントを利用しようとすると、
ファクトリーメソッドは例外をスローします。

このようなフォントを使用することも可能ですが、そのためには、
上で説明した「埋め込まない」フラグを使用するか、あるいは例外を抑制しなければなりません。

.. _zend.pdf.drawing.using-fonts.example-4:

.. rubric:: 埋め込みが禁止されているフォントで、例外をスローさせないようにする

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithPath(
              '/path/to/unEmbeddableFont.ttf',
              Zend_Pdf_Font::EMBED_SUPPRESS_EMBED_EXCEPTION
           );
   ...

利用者にフォントを選択させる場合などは、この抑制方法を使用することをお勧めします。
*PDF* ドキュメントに埋め込めるフォントなら埋め込むでしょうし、
埋め込めないフォントは埋め込まないでしょう。

フォントのサイズは比較的大きく、中には 10 メガバイトに達するものもあります。
デフォルトでは埋め込みフォントは Flate 圧縮され、平均して 50%
ほどサイズを節約できます。
何らかの理由でフォントを圧縮したくない場合は、以下のオプションで圧縮を無効にできます。

.. _zend.pdf.drawing.using-fonts.example-5:

.. rubric:: 埋め込みフォントを圧縮しない

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithPath('/path/to/someReallyBigFont.ttf',
                                       Zend_Pdf_Font::EMBED_DONT_COMPRESS);
   ...

最後に、必要に応じていくつかの埋め込みオプションをビット OR
演算子で連結することもできます。

.. _zend.pdf.drawing.using-fonts.example-6:

.. rubric:: フォントの埋め込みオプションを組み合わせる

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithPath(
               $someUserSelectedFontPath,
               (Zend_Pdf_Font::EMBED_SUPPRESS_EMBED_EXCEPTION |
               Zend_Pdf_Font::EMBED_DONT_COMPRESS));
   ...

.. _zend.pdf.drawing.standard-fonts-limitations:

標準 PDF フォントの制限
--------------

標準 *PDF* フォントは、いくつかのシングルバイトエンコーディング (詳細は `PDF
Reference, Sixth Edition, version 1.7`_ の Appendix D を参照ください)
を内部的に使用しています。 これらは、ほぼ Latin1 文字セットと同じものです (Symbol
フォントと ZapfDingbats フォントは例外です)。

``Zend_Pdf`` は、標準フォントでのテキストの描画時に CP1252 (WinLatin1) を使用します。

他のエンコーディングでもテキストは描画できますが、
現在のロケールと異なる場合はそれを指定する必要があります。
実際に描画されるのは WinLatin1 の文字のみです。

.. _zend.pdf.drawing.using-fonts.example-7:

.. rubric:: フォント埋め込みオプションの使用

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithName(Zend_Pdf_Font::FONT_COURIER);
   $pdfPage->setFont($font, 36)
           ->drawText('Euro sign - €', 72, 720, 'UTF-8')
           ->drawText('Text with umlauts - à è ì', 72, 650, 'UTF-8');
   ...

.. _zend.pdf.drawing.extracting-fonts:

フォントの抽出
-------

``Zend_Pdf``
モジュールを使用すると、読み込んだドキュメントからフォントを抽出できるようになります。

これは、ドキュメントをインクリメンタルに更新する際に便利です。
この機能がなければ、ドキュメントを更新するたびにフォントをアタッチしたり
ドキュメントに埋め込んだりしなければならなくなります。

``Zend_Pdf`` オブジェクトおよび ``Zend_Pdf_Page`` オブジェクトには、
ドキュメントやページ内のすべてのフォントを抽出するためのメソッドが用意されています。

.. _zend.pdf.drawing.extracting-fonts.example-1:

.. rubric:: 読み込んだドキュメントからのフォントの抽出

.. code-block:: php
   :linenos:

   ...
   $pdf = Zend_Pdf::load($documentPath);
   ...
   // ドキュメントのすべてのフォントを取得します
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
   // ドキュメントの最初のページで用いられているフォントを取得します
   $firstPage = reset($pdf->pages);
   $firstPageFonts = $firstPage->extractFonts();
   ...

.. _zend.pdf.drawing.extracting-fonts.example-2:

.. rubric:: フォント名の指定による、読み込んだドキュメントからのフォントの抽出

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
   // フォント名をどこかに保存しておきます...
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

   /* $srcPage->extractFont($fontName) としてもかまいません */
   $font = $pdf->extractFont($fontName);

   $page->setFont($font, $fontSize);
   $page->drawText($text, $x, $y);
   ...
   $pdf->save($docPath, true /* インクリメンタル更新モード */);
   ...

フォントの抽出はどこででもできますが、次のような制限があります。

   - 抽出したフォントは、そのフォントの抽出元と同じドキュメント内でしか使用できません。

   - 埋め込まれたフォントプログラムは実際には抽出されません。
     つまり、抽出されたフォントは元のフォントメトリクス
     (テキストの幅の計算に使用するもの) と同じものになりません。

        .. code-block:: php
           :linenos:

           ...
           $font = $pdf->extractFont($fontName);
           $originalFont = Zend_Pdf_Font::fontWithPath($fontPath);

           $page->setFont($font /* 描画用に抽出したフォント */, $fontSize);
           $xPosition = $x;
           for ($charIndex = 0; $charIndex < strlen($text); $charIndex++) {
               $page->drawText($text[$charIndex], xPosition, $y);

               // テキストの幅の計算には元のフォントを使用します
               $width = $originalFont->widthForGlyph(
                            $originalFont->glyphNumberForCharacter($text[$charIndex])
                        );
               $xPosition += $width/$originalFont->getUnitsPerEm()*$fontSize;
           }
           ...





.. _zend.pdf.drawing.image-drawing:

画像の描画
-----

``Zend_Pdf_Page`` クラスの drawImage() メソッドで、 画像の描画を行います。

.. code-block:: php
   :linenos:

   /**
    * ページ内の指定した位置に画像を描画します。
    *
    * @param Zend_Pdf_Resource_Image $image
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @return Zend_Pdf_Page
    */
   public function drawImage(Zend_Pdf_Resource_Image $image, $x1, $y1, $x2, $y2);

画像オブジェクトは、 ``Zend_Pdf_Image::imageWithPath($filePath)``
メソッドで作成しなければなりません (現在は JPG、PNG および TIFF
画像をサポートしています)。

.. _zend.pdf.drawing.image-drawing.example-1:

.. rubric:: 画像の描画

.. code-block:: php
   :linenos:

   ...
   // 画像を読み込みます
   $image = Zend_Pdf_Image::imageWithPath('my_image.jpg');

   $pdfPage->drawImage($image, 100, 100, 400, 300);
   ...

**重要! JPEG のサポートには PHP の GD 拡張モジュールを必要とします。** **重要! PNG
でアルファチャネルを使用した画像を扱うには、ZLIB
拡張モジュールを必要とします。**

詳細な情報は、 *PHP* のドキュメント (`http://www.php.net/manual/ja/ref.image.php`_),
(`http://www.php.net/manual/ja/ref.zlib.php`_) を参照ください。

.. _zend.pdf.drawing.line-drawing-style:

直線の描画スタイル
---------

直線の描画スタイルは、線幅と線の色、そして破線のパターンで定義されます。
これらはすべて、 ``Zend_Pdf_Page`` クラスのメソッドで設定します。

.. code-block:: php
   :linenos:

   /** 線の色を設定します。*/
   public function setLineColor(Zend_Pdf_Color $color);

   /** 線の幅を設定します。*/
   public function setLineWidth(float $width);

   /**
    * 破線のパターンを設定します。
    *
    * pattern は float の配列です:
    *     array(on_length, off_length, on_length, off_length, ...)
    * phase は線の開始位置から移動する距離です。
    *
    * @param array $pattern
    * @param array $phase
    * @return Zend_Pdf_Page
    */
   public function setLineDashingPattern($pattern, $phase = 0);

.. _zend.pdf.drawing.fill-style:

塗りつぶしのスタイル
----------

``Zend_Pdf_Page::drawRectangle()``\ 、 ``Zend_Pdf_Page::drawPolygon()``\ 、 ``Zend_Pdf_Page::drawCircle()``
および ``Zend_Pdf_Page::drawEllipse()`` メソッドは、オプションのパラメータとして
``$fillType`` を受け取ります。これは以下のいずれかの値となります。

- Zend_Pdf_Page::SHAPE_DRAW_STROKE - 図形の輪郭を描画します

- Zend_Pdf_Page::SHAPE_DRAW_FILL - 図形を塗りつぶすだけです

- Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE - 輪郭を描画し、塗りつぶします
  (デフォルトの挙動です)

``Zend_Pdf_Page::drawPolygon()`` メソッドには、さらにパラメータ ``$fillMethod``
を指定できます。

- Zend_Pdf_Page::FILL_METHOD_NON_ZERO_WINDING (デフォルトの挙動)

  :t:`PDF リファレンス`  によると、これは以下のように定義されています。
  | nonzero winding number ルールは、ある点がパスの内側にあるかどうかを
  判断するため、その点からどこかの方向に放射線を引いて
  その線がパスを構成する線と交わる場所を調べます。 0
  からカウントをはじめ、放射線の左から右にパスの線が横切った場合に
  +1、放射線の右から左に横切った場合に -1 します。
  すべての交点について調べた後、もし結果が 0 ならその点はパスの外側です。 0
  でなければ内側です。 注意:
  この方式では、放射線とパスの線が同一になった場合や
  放射線がパスの線の接線となった場合のことを指定していません。
  放射線は任意の方向に伸ばせるので、このような状況にならないような放射線が選ばれます。
  単純な凸状のパスの場合、この方式で判断した内側・外側は、
  直感的に予想できるのと同じ結果になります。
  ただ、パスを構成する線自身が交わっているなどの複雑なパスの場合は、
  興味深い結果となります。この例を、(*PDF* リファレンスの) 図 4.10 に示します。 5
  本の直線を互いに交差させて作成した星型の場合、このルールでは
  星型で囲まれるすべての部分をパスの内側として扱います。真ん中の
  五角形も内側となります。2 つの同心円からなるパスの場合、 2
  つの円が同じ方向に描画された際には両方の円に囲まれている部分が
  内側となります。2 つの円が反対方向に描画された際には、2 つの円からなる
  「ドーナツ型」の部分が内側となります。このルールの場合は、
  「ドーナツの穴」の部分は外側という扱いになります。



- Zend_Pdf_Const::FILLMETHOD_EVENODD

  :t:`PDF リファレンス`  によると、これは以下のように定義されています。
  | nonzero winding number ルールに対するもうひとつのルールが even-odd ルールです。
  このルールでは、ある点が「内側である」かどうかを判断する材料として、
  その点からどこかの方向に放射線を引いてその線がパスを構成する線と何回交わるか
  ということを用います。交わる回数が奇数だった場合、その点は内側です。
  交わる回数が偶数だった場合、その点は外側です。単純なパスの場合は、 これは
  nonzero winding number ルールと同じ結果になります。
  しかし、複雑な図形の場合は異なる結果となります。 複雑なパスに対して even-odd
  ルールを適用した場合の例を (*PDF* リファレンスの) 図 4.11
  に示します。このルールの場合、5 本の交差する直線からなる星型では、
  三角形の部分のみが内側として扱われます。真ん中の五角形は、内側とはみなされません。
  2 つの同心円の場合、2
  つの円からなる「ドーナツ型」の部分のみが内側として扱われます。
  これは、円の描画された方向に依存しません。



.. _zend.pdf.drawing.linear-transformations:

線形変換
----

.. _zend.pdf.drawing.linear-transformations.rotations:

回転
^^

描画操作を適用する前に、 *PDF* のページを回転させることができます。 それには
``Zend_Pdf_Page::rotate()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   /**
    * ページを回転します。
    *
    * @param float $x  - 回転の中心の X 座標
    * @param float $y  - 回転の中心の Y 座標
    * @param float $angle - 回転角度
    * @return Zend_Pdf_Page
    */
   public function rotate($x, $y, $angle);

.. _zend.pdf.drawing.linear-transformations.scale:

ZF 1.8 以降で使用できる拡大/縮小
^^^^^^^^^^^^^^^^^^^^

倍率の変更は ``Zend_Pdf_Page::scale()`` メソッドで行います。

.. code-block:: php
   :linenos:

   /**
    * 座標系の拡大/縮小
    *
    * @param float $xScale - X 方向の倍率
    * @param float $yScale - Y 方向の倍率
    * @return Zend_Pdf_Page
    */
   public function scale($xScale, $yScale);

.. _zend.pdf.drawing.linear-transformations.translate:

ZF 1.8 以降で使用できる移動
^^^^^^^^^^^^^^^^^

座標系の移動は ``Zend_Pdf_Page::translate()`` メソッドで行います。

.. code-block:: php
   :linenos:

   /**
    * 座標系の移動
    *
    * @param float $xShift - X 方向の移動
    * @param float $yShift - Y 方向の移動
    * @return Zend_Pdf_Page
    */
   public function translate($xShift, $yShift);

.. _zend.pdf.drawing.linear-transformations.skew:

ZF 1.8 以降で使用できる傾斜
^^^^^^^^^^^^^^^^^

ページを傾けるには ``Zend_Pdf_Page::skew()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   /**
    * 座標系の変換
    *
    * @param float $x  - 傾斜点の X 座標
    * @param float $y  - 傾斜点の Y 座標
    * @param float $xAngle - X 軸の傾斜角度
    * @param float $yAngle - Y 軸の傾斜角度
    * @return Zend_Pdf_Page
    */
   public function skew($x, $y, $xAngle, $yAngle);

.. _zend.pdf.drawing.save-restore:

グラフィックの状態の保存/復元
---------------

好きな時点でのグラフィックの状態
(現在のフォント、フォントサイズ、線の色、塗りつぶしの色、線の形式、
ページの回転、クリップ領域) を保存/復元できます。
保存操作はグラフィックの状態をスタックに保存し、復元の際にはそこから取り出されます。

``Zend_Pdf_Page`` クラスには、これらの操作を行うための 2 つのメソッドがあります。

.. code-block:: php
   :linenos:

   /**
    * このページのグラフィックの状態を保存します。
    * 現在適用されているスタイル・位置・クリップ領域および
    * 回転/移動/拡大縮小などを情報を保存します。
    *
    * @return Zend_Pdf_Page
    */
   public function saveGS();

   /**
    * 直近の saveGS() で保存されたグラフィックの状態を復元します。
    *
    * @return Zend_Pdf_Page
    */
   public function restoreGS();

.. _zend.pdf.drawing.clipping:

描画領域のクリッピング
-----------

*PDF* および ``Zend_Pdf`` モジュールは、描画領域のクリッピングに対応しています。
描画演算子が影響を及ぼす範囲を、このクリップ領域内に制限します。
クリップ領域の初期値は、ページ全体です。

``Zend_Pdf_Page`` クラスでは、
クリッピングに関連するいくつかのメソッドを提供しています。

.. code-block:: php
   :linenos:

   /**
    * 矩形のクリップ領域を設定します。
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
    * 多角形のクリップ領域を設定します。
    *
    * @param array $x  - float の配列 (頂点の X 座標)
    * @param array $y  - float の配列 (頂点の Y 座標)
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
    * 円形のクリップ領域を設定します。
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
    * 楕円のクリップ領域を設定します。
    *
    * メソッドの書式
    * drawEllipse($x1, $y1, $x2, $y2);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle);
    *
    * @todo $x2-$x1 == 0 や $y2-$y1 == 0 のような特別な場合への対応
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

スタイル
----

``Zend_Pdf_Style`` クラスがスタイルに関する機能を提供します。

スタイルは、グラフィックの状態に関する複数の設定を保存し、 *PDF* のページに 1
回の操作でそれを適用するために使用されます。

.. code-block:: php
   :linenos:

   /**
    * このページの描画操作で使用する予定のスタイルを設定します。
    *
    * @param Zend_Pdf_Style $style
    * @return Zend_Pdf_Page
    */
   public function setStyle(Zend_Pdf_Style $style);

   /**
    * スタイルを返し、それをページに適用します。
    *
    * @return Zend_Pdf_Style|null
    */
   public function getStyle();

``Zend_Pdf_Style`` クラスでは、
さまざまなグラフィックの状態を設定あるいは取得するためのメソッドが提供されています。

.. code-block:: php
   :linenos:

   /**
    * 線の色を設定します。
    *
    * @param Zend_Pdf_Color $color
    * @return Zend_Pdf_Page
    */
   public function setLineColor(Zend_Pdf_Color $color);

.. code-block:: php
   :linenos:

   /**
    * 線の色を取得します。
    *
    * @return Zend_Pdf_Color|null
    */
   public function getLineColor();

.. code-block:: php
   :linenos:

   /**
    * 線の幅を設定します。
    *
    * @param float $width
    * @return Zend_Pdf_Page
    */
   public function setLineWidth($width);

.. code-block:: php
   :linenos:

   /**
    * 線の幅を取得します。
    *
    * @return float
    */
   public function getLineWidth();

.. code-block:: php
   :linenos:

   /**
    * 破線のパターンを設定します。
    *
    * @param array $pattern
    * @param float $phase
    * @return Zend_Pdf_Page
    */
   public function setLineDashingPattern($pattern, $phase = 0);

.. code-block:: php
   :linenos:

   /**
    * 破線のパターンを取得します。
    *
    * @return array
    */
   public function getLineDashingPattern();

.. code-block:: php
   :linenos:

   /**
    * 破線の位相を取得します。
    *
    * @return float
    */
   public function getLineDashingPhase();

.. code-block:: php
   :linenos:

   /**
    * 塗りつぶし色を設定します。
    *
    * @param Zend_Pdf_Color $color
    * @return Zend_Pdf_Page
    */
   public function setFillColor(Zend_Pdf_Color $color);

.. code-block:: php
   :linenos:

   /**
    * 塗りつぶし色を取得します。
    *
    * @return Zend_Pdf_Color|null
    */
   public function getFillColor();

.. code-block:: php
   :linenos:

   /**
    * 現在のフォントを設定します。
    *
    * @param Zend_Pdf_Resource_Font $font
    * @param float $fontSize
    * @return Zend_Pdf_Page
    */
   public function setFont(Zend_Pdf_Resource_Font $font, $fontSize);

.. code-block:: php
   :linenos:

   /**
    * 現在のフォントサイズを変更します。
    *
    * @param float $fontSize
    * @return Zend_Pdf_Page
    */
   public function setFontSize($fontSize);

.. code-block:: php
   :linenos:

   /**
    * 現在のフォントを取得します。
    *
    * @return Zend_Pdf_Resource_Font $font
    */
   public function getFont();

.. code-block:: php
   :linenos:

   /**
    * 現在のフォントサイズを取得します。
    *
    * @return float $fontSize
    */
   public function getFontSize();

.. _zend.pdf.drawing.alpha:

透明度
---

``Zend_Pdf`` モジュールは、透明度の処理に対応しています。

透明度を設定するには ``Zend_Pdf_Page::setAlpha()`` メソッドを使用します。

   .. code-block:: php
      :linenos:

      /**
       * 透明度を設定します
       *
       * $alpha == 0  - 透明
       * $alpha == 1  - 不透明
       *
       * PDF でサポートするモードは次のとおりです
       * Normal (デフォルト), Multiply, Screen, Overlay, Darken, Lighten,
       * ColorDodge, ColorBurn, HardLight, SoftLight, Difference, Exclusion
       *
       * @param float $alpha
       * @param string $mode
       * @throws Zend_Pdf_Exception
       * @return Zend_Pdf_Page
       */
      public function setAlpha($alpha, $mode = 'Normal');





.. _`PDF Reference, Sixth Edition, version 1.7`: http://www.adobe.com/devnet/acrobat/pdfs/pdf_reference_1-7.pdf
.. _`http://www.php.net/manual/ja/ref.image.php`: http://www.php.net/manual/ja/ref.image.php
.. _`http://www.php.net/manual/ja/ref.zlib.php`: http://www.php.net/manual/ja/ref.zlib.php
