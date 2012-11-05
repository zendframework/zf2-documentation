.. EN-Revision: none
.. _zend.view.helpers.initial.doctype:

Doctype ヘルパー
============

正しい形式の *HTML* ドキュメントおよび *XHTML* ドキュメントには、 ``DOCTYPE``
宣言が必要です。 覚えておくことが難しいというだけではなく、
これらは特定の要素のレンダリング方法 (たとえば、 **<script>** や **<style>**
要素における CDATA のエスケープ方法) に影響を与えます。

``Doctype`` ヘルパーは、以下のいずれかの形式を指定します。

- ``XHTML11``

- ``XHTML1_STRICT``

- ``XHTML1_TRANSITIONAL``

- ``XHTML1_FRAMESET``

- ``XHTML_BASIC1``

- ``HTML4_STRICT``

- ``HTML4_LOOSE``

- ``HTML4_FRAMESET``

- ``HTML5``

整形式なものであれば、独自の doctype を追加できます。

``Doctype`` ヘルパーは、 :ref:`Placeholder ヘルパー <zend.view.helpers.initial.placeholder>`
の具象実装です。

.. _zend.view.helpers.initial.doctype.basicusage:

.. rubric:: Doctype ヘルパーの基本的な使用法

doctype は、いつでも指定できます。 しかし、doctype
によって出力を切りかえるヘルパーを使用する場合は まず doctype
を設定してからでないと動作しません。もっともシンプルな使用法は、
レイアウトスクリプトの先頭で指定と出力を同時に行うことでしょう。

.. code-block:: php
   :linenos:

   $doctypeHelper = new Zend\View_Helper\Doctype();
   $doctypeHelper->doctype('XHTML1_STRICT');

そして、それをレイアウトスクリプトの先頭で表示します。

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>

.. _zend.view.helpers.initial.doctype.retrieving:

.. rubric:: Doctype の取得

doctype を知りたくなったら、オブジェクトの ``getDoctype()`` をコールします。
このオブジェクトは、ヘルパーを起動した際に取得できるものです。 invoking the helper.

.. code-block:: php
   :linenos:

   $doctype = $view->doctype()->getDoctype();
   ?>
一般的な使用法としては、doctype が *XHTML*
か否かを調べるということがあります。それ用のメソッドとしては ``isXhtml()``
があります。

.. code-block:: php
   :linenos:

   if ($view->doctype()->isXhtml()) {
       // 何かをします
   }

You can also check if the doctype represents an *HTML5* document

.. code-block:: php
   :linenos:

   if ($view->doctype()->isHtml5()) {
       // do something differently
   }


