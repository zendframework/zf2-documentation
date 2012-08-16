.. EN-Revision: none
.. _zend.filter.set:

標準のフィルタクラス群
===========

Zend Framework には、すぐに使える標準のフィルタ群が同梱されています。

.. include:: zend.filter.alnum.rst
.. include:: zend.filter.alpha.rst
.. include:: zend.filter.base-name.rst
.. include:: zend.filter.boolean.rst
.. include:: zend.filter.callback.rst
.. include:: zend.filter.compress.rst
.. include:: zend.filter.decryption.rst
.. include:: zend.filter.digits.rst
.. include:: zend.filter.dir.rst
.. include:: zend.filter.encryption.rst
.. include:: zend.filter.html-entities.rst
.. include:: zend.filter.int.rst
.. include:: zend.filter.localized-to-normalized.rst
.. include:: zend.filter.normalized-to-localized.rst
.. include:: zend.filter.null.rst
.. include:: zend.filter.preg-replace.rst
.. include:: zend.filter.real-path.rst
.. include:: zend.filter.string-to-lower.rst
.. include:: zend.filter.string-to-upper.rst
.. include:: zend.filter.string-trim.rst
.. _zend.filter.set.stripnewlines:

StripNewlines
-------------

文字列 ``$value`` から一切の改行制御文字を取り除いたものを返します。

.. _zend.filter.set.striptags:

StripTags
---------

入力文字列からすべての *HTML* タグおよび *PHP* タグを取り除いた結果を返します。
ただし明示的に許可したタグは取り除きません。
どのタグを許可するかだけではなく、すべてのタグにおいてどの属性を許可するか、
特定のタグだけで許可する属性は何かなども指定できます。


