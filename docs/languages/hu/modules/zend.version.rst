.. _zend.version.reading:

A verzió lekérdezése
====================

A ``Zend_Version`` egy osztályállandót nyújt a ``Zend_Version::VERSION`` képében, mely a Zend Framework
telepítés verziószámát megadó karakterláncot tartalmaz, pl. „1.7.4”.

``Zend_Version::compareVersion($version)`` statikus tagfüggvény a *PHP* `version_compare()`_ függvényén
alapszik. Vissztérési értéke −1, ha a megadott verzió régebbi, mint a telepített Zend Framework verziója,
0, ha megegyeznek, és +1, ha újabb.

.. _zend.version.reading.example:

.. rubric:: Példa a compareVersion() tagfüggvény használatára

.. code-block:: php
   :linenos:

   // -1-gyel, 0-val vagy +1-gyel tér vissza
   $cmp = Zend_Version::compareVersion('2.0.0');



.. _`version_compare()`: http://php.net/version_compare
