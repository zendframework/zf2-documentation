.. _zend.validate.sitemap:

サイトマップ・バリデータ
============

以下のバリデータは、 `サイトマップ XML プロトコル`_ に従います。

.. _zend.validate.sitemap.changefreq:

Sitemap_Changefreq
------------------

文字列がサイトマップ *XML* 文書で 'changefreq' 要素として
使用できるかどうか検証します。 有効値は、 'always', 'hourly', 'daily', 'weekly', 'monthly',
'yearly' または 'never' です。

値が文字列で、上記で指定される頻度のうちの1つと等しい場合に限り、 ``TRUE``\
を返します。

.. _zend.validate.sitemap.lastmod:

Sitemap_Lastmod
---------------

文字列がサイトマップ *XML* 文書で 'lastmod' 要素として
使用できるかどうか検証します。 lastmod要素は *W3C*
日付文字列を含まなければなりません。
そして、任意で時間についての情報を無効にします。

値が文字列で、プロトコルに従って妥当な場合に限り、 ``TRUE``\ を返します。

.. _zend.validate.sitemap.lastmod.example:

.. rubric:: サイトマップ Lastmod バリデータ

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Sitemap_Lastmod();

   $validator->isValid('1999-11-11T22:23:52-02:00'); // true
   $validator->isValid('2008-05-12T00:42:52+02:00'); // true
   $validator->isValid('1999-11-11'); // true
   $validator->isValid('2008-05-12'); // true

   $validator->isValid('1999-11-11t22:23:52-02:00'); // false
   $validator->isValid('2008-05-12T00:42:60+02:00'); // false
   $validator->isValid('1999-13-11'); // false
   $validator->isValid('2008-05-32'); // false
   $validator->isValid('yesterday'); // false

.. _zend.validate.sitemap.loc:

Sitemap_Loc
-----------

文字列がサイトマップ *XML* 文書で 'loc' 要素として 使用できるかどうか検証します。
これは内部的に ``Zend_Form::check()``\ を使います。 詳しくは :ref:`URI の検証
<zend.uri.validation>`\ を読んでください。

.. _zend.validate.sitemap.priority:

Sitemap_Priority
----------------

文字列がサイトマップ *XML* 文書で 'priority' 要素として
使用できるかどうか検証します。 値は、0.0と1.0の間の小数でなければなりません。
このバリデータは、数値と文字列値の両方を受け入れます。

.. _zend.validate.sitemap.priority.example:

.. rubric:: サイトマップ 優先度 バリデータ

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Sitemap_Priority();

   $validator->isValid('0.1'); // true
   $validator->isValid('0.789'); // true
   $validator->isValid(0.8); // true
   $validator->isValid(1.0); // true

   $validator->isValid('1.1'); // false
   $validator->isValid('-0.4'); // false
   $validator->isValid(1.00001); // false
   $validator->isValid(0xFF); // false
   $validator->isValid('foo'); // false

.. _zend.validate.set.sitemap.options:

Zend_Validate_Sitemap_* でサポートされるオプション
-------------------------------------

サイトマップ・バリデータのいずれもサポートするオプションはありません。



.. _`サイトマップ XML プロトコル`: http://www.sitemaps.org/protocol.php
