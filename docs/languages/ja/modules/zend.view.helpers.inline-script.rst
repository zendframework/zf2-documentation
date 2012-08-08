.. EN-Revision: none
.. _zend.view.helpers.initial.inlinescript:

InlineScript ヘルパー
=================

*HTML* の **<script>** 要素を使用して、
クライアントサイトのスクリプトをインラインで指定したり
外部のリソースからスクリプトのコードを読み込んだりします。 ``InlineScript``
ヘルパーは、この両方の方式に対応しています。 これは :ref:`HeadScript
<zend.view.helpers.initial.headscript>`
から派生したものであり、このヘルパーで使えるメソッドはすべて使用可能です。
ただ、 ``headScript()`` メソッドのかわりに ``inlineScript()`` メソッドを使用します。

.. note::

   **HTML Body スクリプトでの InlineScript の使用法**

   ``InlineScript`` は、スクリプトを *HTML* の **body**
   部に埋め込みたいときに使用します。
   スクリプトをドキュメントの最後のほうに配置するようにすると、
   ページの表示速度が向上します。特に、
   サードパーティのアクセス解析用スクリプトを使用する場合などにこの効果が顕著にあらわれます。

   JS ライブラリの中には、 *HTML* の **head**
   で読み込まなければならないものもあります。そのような場合は :ref:`HeadScript
   <zend.view.helpers.initial.headscript>` を使用します。


