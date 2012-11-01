.. EN-Revision: none
.. _migration.18:

Zend Framework 1.8
==================

以前のバージョンから Zend Framework 1.8 またはそれ以降に更新する際は、
下記の移行上の注意点に注意すべきです。

.. _migration.18.zend.controller:

Zend_Controller
---------------

.. _migration.18.zend.controller.router:

標準のルートの変更
^^^^^^^^^

新しい標準ルートでは翻訳セグメントが使用できるようになったため、
ルートのセグメントの先頭にある '**@**' は特殊文字と解釈されるようになりました。
この文字を静的セグメント内で使用するには、前にもうひとつ '**@**'
をつけてエスケープする必要があります。 また、'**:**' も同様です。

.. _migration.18.zend.locale:

Zend_Locale
-----------

.. _migration.18.zend.locale.defaultcaching:

デフォルトのキャッシュ処理
^^^^^^^^^^^^^

Zend Framework 1.8 以降、デフォルトのキャッシュ処理が追加されました。
このように変更された理由は、大半のユーザが、
パフォーマンスに問題を抱えていたにもかかわらずキャッシュを有効にしていなかったからです。
キャッシュを使用しない場合に I18n コアがボトルネックになることから、 ``Zend_Locale``
にキャッシュが設定されていない場合に
デフォルトのキャッシュ機能を追加することにしたのです。

パフォーマンスを落とすことがわかっていたとしても、
あえてキャッシュを無効にしたい場合もあるでしょう。
そのような場合にキャッシュを無効にするには ``disableCache()``
メソッドを使用します。

.. _migration.18.zend.locale.defaultcaching.example:

.. rubric:: デフォルトのキャッシュ処理の無効化

.. code-block:: php
   :linenos:

   Zend\Locale\Locale::disableCache(true);


