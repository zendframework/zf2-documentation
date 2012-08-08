.. EN-Revision: none
.. _zend.debug.dumping:

変数の出力
=====

静的メソッド ``Zend_Debug::dump()`` は、 式の内容を表示したり返したりします。
簡単に使用することができ、事前準備や特別なツール、
デバッグ用環境などが不要なので、
この単純なデバッグ手法は、一般的によく用いられています。

.. _zend.debug.dumping.example:

.. rubric:: dump() メソッドの例

.. code-block:: php
   :linenos:

   Zend_Debug::dump($var, $label = null, $echo = true);

引数 ``$var`` で指定した式や変数についての情報を ``Zend_Debug::dump()``
メソッドが出力します。

引数 ``$label`` は、 ``Zend_Debug::dump()`` の出力の前に出力される文字列です。
これは、たとえば複数の変数の内容を出力する際に便利です。

論理型の ``$echo`` で、 ``Zend::dump()`` の結果を echo するかどうかを指定します。 ``TRUE``
の場合は出力が echo されます。 ``$echo`` の設定にかかわらず、
出力結果は常にメソッドの返り値となります。

``Zend_Debug::dump()`` メソッドが、PHP の関数 `var_dump()`_
をラップしたものであることを理解すると有益でしょう。
出力ストリームがウェブに渡された場合、 ``var_dump()`` の出力は `htmlspecialchars()`_
でエスケープされ、(X)HTML の ``<pre>`` タグで囲まれます。

.. tip::

   **Zend_Log を使用したデバッグ**

   ``Zend_Debug::dump()`` は、ソフトウェアの開発中の
   ちょっとしたデバッグには最適です。
   変数の中身を見るメソッドを追加したり削除したりするのが手っ取り早くできます。

   その場限りのコードではなくずっと使用し続けるデバッグコードを書くのなら、
   :ref:`Zend_Log <zend.log.overview>` の使用を検討してください。たとえば、ログレベルを
   ``DEBUG`` にして :ref:`ストリーム・ログライター <zend.log.writers.stream>` を使用すると、
   ``Zend_Debug::dump()`` が返す文字列を出力できます。



.. _`var_dump()`: http://php.net/var_dump
.. _`htmlspecialchars()`: http://php.net/htmlspecialchars
