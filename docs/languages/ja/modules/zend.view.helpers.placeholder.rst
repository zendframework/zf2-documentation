.. EN-Revision: none
.. _zend.view.helpers.initial.placeholder:

Placeholder ヘルパー
================

``Placeholder`` ビューヘルパーは、
ビュースクリプトとビューのインスタンスとの間でコンテンツを永続化させます。
それ以外の便利な機能としては次のようなものがあります。
たとえばコンテンツの集約、ビュースクリプトの内容をキャプチャして後で再利用、
コンテンツの前後へのテキストの追加
(そして集約したコンテンツ間のセパレータの追加) などです。

.. _zend.view.helpers.initial.placeholder.usage:

.. rubric:: プレースホルダの基本的な使用法

プレースホルダの基本的な使用法は、ビューのデータを永続化させることです。
``Placeholder`` ヘルパーを起動する際にプレースホルダ名を指定し、
ヘルパーはプレースホルダコンテナオブジェクトを返します。
これを処理するなり、単純に echo するなりして使用できます。

.. code-block:: php
   :linenos:

   <?php $this->placeholder('foo')->set("Some text for later") ?>

   <?php
       echo $this->placeholder('foo');
       // 出力は "Some text for later" となります
   ?>

.. _zend.view.helpers.initial.placeholder.aggregation:

.. rubric:: プレースホルダによるコンテンツの集約

プレースホルダによるコンテンツの集約も、時には便利です。
たとえば、ビュースクリプトで変数の配列を保持し、
後で表示するためのメッセージを取得しておくと、
それをどのようにレンダリングするかを後で決めることができます。

``Placeholder`` ビューヘルパーは、 ``ArrayObject`` を継承したコンテナを使用します。
これは、配列をより高機能に操作できるものです。
さらに、コンテナに格納された内容をフォーマットするために
さまざまなメソッドが用意されています。

- ``setPrefix($prefix)`` は、 コンテンツの先頭に付加するテキストを設定します。
  ``getPrefix()`` を使用すると、 その時点での設定内容を取得できます。

- ``setPostfix($prefix)`` は、 コンテンツの末尾に付加するテキストを設定します。
  ``getPostfix()`` を使用すると、 その時点での設定内容を取得できます。

- ``setSeparator($prefix)`` は、 各コンテンツの間に挿入するテキストを設定します。
  ``getSeparator()`` を使用すると、 その時点での設定内容を取得できます。

- ``setIndent($prefix)`` は、 コンテンツの字下げ幅を設定します。
  整数値を渡すと、渡された数のスペースを使用します。
  文字列を渡すと、その文字列を使用します。 ``getIndent()`` を使用すると、
  その時点での設定内容を取得できます。

.. code-block:: php
   :linenos:

   <!-- 最初のビュースクリプト -->
   <?php $this->placeholder('foo')->exchangeArray($this->data) ?>

.. code-block:: php
   :linenos:

   <!-- 後で使用するビュースクリプト -->
   <?php
   $this->placeholder('foo')->setPrefix("<ul>\n    <li>")
                            ->setSeparator("</li><li>\n")
                            ->setIndent(4)
                            ->setPostfix("</li></ul>\n");
   ?>

   <?php
       echo $this->placeholder('foo');
       // 順序なしリストをきれいに字下げして出力します
   ?>

``Placeholder`` コンテナオブジェクトは ``ArrayObject`` を継承しているので、
単純にコンテナに格納するのではなく
そのコンテナの特定のキーにコンテンツを格納するのも簡単です。
キーへのアクセスは、オブジェクトのプロパティか配列のキーのいずれでも可能です。

.. code-block:: php
   :linenos:

   <?php $this->placeholder('foo')->bar = $this->data ?>
   <?php echo $this->placeholder('foo')->bar ?>

   <?php
   $foo = $this->placeholder('foo');
   echo $foo['bar'];
   ?>

.. _zend.view.helpers.initial.placeholder.capture:

.. rubric:: プレースホルダによるコンテンツのキャプチャ

時には、プレースホルダの中身を
テンプレートに渡しやすいようビュースクリプトで保持することもあるでしょう。
``Placeholder`` ビューヘルパーは、
任意のコンテンツをキャプチャして後でレンダリングできます。 そのために使用する
*API* は次のようなものです。

- ``captureStart($type, $key)`` は、 コンテンツのキャプチャを開始します。

  ``$type`` は、 ``Placeholder`` の定数 ``APPEND`` あるいは ``SET`` のいずれかとなります。
  ``APPEND`` を指定すると、キャプチャされたコンテンツが
  プレースホルダ内の現在のコンテンツの末尾に追加されます。 ``SET`` の場合は、
  キャプチャされたコンテンツをそれ単体でプレースホルダの値として使用します
  (それまでに登録されていたコンテンツを上書きします)。 デフォルトの ``$type`` は
  ``APPEND`` です。

  ``$key`` には、コンテンツのキャプチャ先として
  プレースホルダのコンテナの特定のキーを指定できます。

  ``captureStart()`` は、 ``captureEnd()``
  がコールされるまで他のキャプチャをロックします。
  同一のプレースホルダコンテナでキャプチャをネストすることはできません。
  しようとすると例外が発生します。

- ``captureEnd()`` は、 コンテンツのキャプチャを終了して、 ``captureStart()``
  がコールされたときの指定に応じてそれをコンテナに格納します。

.. code-block:: php
   :linenos:

   <!-- デフォルトのキャプチャは追記モードです -->
   <?php $this->placeholder('foo')->captureStart();
   foreach ($this->data as $datum): ?>
   <div class="foo">
       <h2><?php echo $datum->title ?></h2>
       <p><?php echo $datum->content ?></p>
   </div>
   <?php endforeach; ?>
   <?php $this->placeholder('foo')->captureEnd() ?>

   <?php echo $this->placeholder('foo') ?>

.. code-block:: php
   :linenos:

   <!-- 特定のキーにキャプチャします -->
   <?php $this->placeholder('foo')->captureStart('SET', 'data');
   foreach ($this->data as $datum): ?>
   <div class="foo">
       <h2><?php echo $datum->title ?></h2>
       <p><?php echo $datum->content ?></p>
   </div>
    <?php endforeach; ?>
   <?php $this->placeholder('foo')->captureEnd() ?>

   <?php echo $this->placeholder('foo')->data ?>

.. _zend.view.helpers.initial.placeholder.implementations:

プレースホルダの具象実装
------------

Zend Framework には、"具体的な"
プレースホルダの実装が標準でいくつか含まれています。
これらはみな一般的に用いられるもので、doctype やページのタイトル、<head>
の要素群などを扱います。 どのプレースホルダについても、
引数なしでコールするとその要素自身を返します。

各要素のドキュメントは、以下のリンク先で個別に扱います。

- :ref:`Doctype <zend.view.helpers.initial.doctype>`

- :ref:`HeadLink <zend.view.helpers.initial.headlink>`

- :ref:`HeadMeta <zend.view.helpers.initial.headmeta>`

- :ref:`HeadScript <zend.view.helpers.initial.headscript>`

- :ref:`HeadStyle <zend.view.helpers.initial.headstyle>`

- :ref:`HeadTitle <zend.view.helpers.initial.headtitle>`

- :ref:`InlineScript <zend.view.helpers.initial.inlinescript>`


