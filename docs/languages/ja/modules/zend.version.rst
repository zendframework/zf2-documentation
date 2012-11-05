.. EN-Revision: none
.. _zend.version.reading:

Zend Framework のバージョンの取得
========================

``Zend_Version`` が提供するクラス定数 ``Zend\Version\Version::VERSION`` には、
インストールされている Zend Framework のバージョン番号を表す文字列が含まれます。
``Zend\Version\Version::VERSION`` は、たとえば "1.7.4" のようになります。

静的メソッド ``Zend\Version\Version::compareVersion($version)`` は、 *PHP* の関数 `version_compare()`_
に基づいたものです。このメソッドは、指定したバージョンが Zend Framework
のバージョンより古い場合に -1、 同じ場合に 0、そして指定したバージョンのほうが
Zend Framework のバージョンより新しい場合に +1 を返します。

.. _zend.version.reading.example:

.. rubric:: compareVersion() メソッドの例

.. code-block:: php
   :linenos:

   // -1、0 あるいは 1 を返します
   $cmp = Zend\Version\Version::compareVersion('2.0.0');

The static method ``Zend\Version\Version::getLatest()`` provides the version number of the last stable release available
for download on the site `Zend Framework`_.

.. _zend.version.latest.example:

.. rubric:: getLatest() メソッドの例

.. code-block:: php
   :linenos:

   // 1.11.0 またはそれ以降のバージョンを返します
   echo Zend\Version\Version::getLatest();



.. _`version_compare()`: http://php.net/version_compare
.. _`Zend Framework`: http://framework.zend.com/download/latest
