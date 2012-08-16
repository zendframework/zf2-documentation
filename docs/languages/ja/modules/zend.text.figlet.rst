.. EN-Revision: none
.. _zend.text.figlet:

Zend_Text_Figlet
================

``Zend_Text_Figlet`` は、いわゆる FIGlet テキストを作成するためのコンポーネントです。
FIGlet テキストとは、 *ASCII* アートで表した文字列のことです。 FIGlet では、FLT (FigLet
Font) と呼ばれる特殊なフォント形式を使用します。 デフォルトで ``Zend_Text_Figlet``
に同梱されているフォントは標準フォント 1 つだけですが、 `http://www.figlet.org`_
からその他のフォントをダウンロードできます。

.. note::

   **圧縮されたフォント**

   ``Zend_Text_Figlet`` は gzip で圧縮されたフォントに対応しています。 つまり、 *.flf*
   ファイルを gzip した状態で使えるということです。 ``Zend_Text_Figlet``
   でこれを使用するには、gzip したフォントの拡張子が *.gz* でなければなりません。
   さらに、gzip されたフォントを使用するには *PHP* の GZIP
   拡張モジュールを有効にする必要があります。

.. note::

   **エンコーディング**

   ``Zend_Text_Figlet`` は、デフォルトでは文字列が UTF-8
   でエンコードされていることを想定しています。それ以外の場合は、 ``render()``
   メソッドの 2 番目のパラメータで文字エンコーディングを指定します。

FIGlet 用のさまざまなオプションを指定できます。 ``Zend_Text_Figlet``
のインスタンスを作成する際に、 配列あるいは ``Zend_Config``
のインスタンスで指定します。



   - *font*- レンダリングに使用するフォント。
     未定義の場合は組み込みのフォントを使用します。

   - *outputWidth*- 出力文字列の最大幅。 折り返しや幅揃えに使用します。
     あまりに小さい値を指定してしまうと、
     予期せぬ結果となってしまうので注意しましょう。 デフォルトは 80 です。

   - *handleParagraphs*- 改行の処理方法を示す boolean 値。 ``TRUE``
     を指定すると、単一の改行文字を無視してひとつの空白文字として扱います。
     ほんとうに改行させたい場合は、改行文字を 2 つ続けます。 デフォルトは ``FALSE``
     です。

   - *justification*-``Zend_Text_Figlet::JUSTIFICATION_*`` のいずれかの値。 ``JUSTIFICATION_LEFT``\ 、
     ``JUSTIFICATION_CENTER`` そして ``JUSTIFICATION_RIGHT`` があります。 デフォルトの桁揃えは
     *rightToLeft* の値によって決まります。

   - *rightToLeft*- テキストを記述する方向。 ``Zend_Text_Figlet::DIRECTION_LEFT_TO_RIGHT`` あるいは
     ``Zend_Text_Figlet::DIRECTION_RIGHT_TO_LEFT``
     となります。デフォルトでは、フォントファイルの設定を使用します。 justification
     が定義されていない場合は、
     右から左にテキストを書くときには自動的に右揃えとなります。

   - *smushMode*- 整数値。 各文字の並べ方を定義します。 ``Zend_Text_Figlet::SM_*``
     の複数の値の和を指定できます。 SM_EQUAL, SM_LOWLINE, SM_HIERARCHY, SM_PAIR, SM_BIGX,
     SM_HARDBLANK, SM_KERN そして SM_SMUSH といったモードがあります。値 0 は、
     「すべてを無効にする」ではなく「SM_KERN を適用する」
     という意味になります。無効にするには -1 を指定します。
     それぞれのモードがどんなものなのかについての説明が `ここ`_ にあります。
     デフォルトでは、フォントファイルの設定を使用します。
     通常、このオプションを使用するのは、
     フォントデザイナが新しいフォントを作成する際に
     レイアウトを確かめるといった場合のみです。



.. _zend.text.figlet.example.using:

.. rubric:: Zend_Text_Figlet の使用法

この例は、 ``Zend_Text_Figlet`` の基本的な使用法を説明するためにシンプルな FIGlet
テキストを作成するものです。

.. code-block:: php
   :linenos:

   require_once 'Zend/Text/Figlet.php';
   $figlet = new Zend_Text_Figlet();
   echo $figlet->render('Zend');

等幅フォントを使用すると、この結果は次のようになります。

.. code-block:: text
   :linenos:

     ______    ______    _  __   ______
    |__  //   |  ___||  | \| || |  __ \\
      / //    | ||__    |  ' || | |  \ ||
     / //__   | ||___   | .  || | |__/ ||
    /_____||  |_____||  |_|\_|| |_____//
    `-----`'  `-----`   `-` -`'  -----`



.. _`http://www.figlet.org`: http://www.figlet.org/fontdb.cgi
.. _`ここ`: http://www.jave.de/figlet/figfont.txt
