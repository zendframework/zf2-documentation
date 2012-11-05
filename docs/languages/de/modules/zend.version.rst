.. EN-Revision: none
.. _zend.version.reading:

Die Version des Zend Frameworks erhalten
========================================

``Zend_Version`` bietet eine Klassenkonstante ``Zend\Version\Version::VERSION`` die einen String enthält, welcher die
Versionsnummer der eigenen Installation des Zend Frameworks enthält. ``Zend\Version\Version::VERSION`` kann zum Beispiel
"1.7.4" enthalten.

Die statische Methode ``Zend\Version\Version::compareVersion($version)`` basiert auf der *PHP* Funktion
`version_compare()`_. Die Methode gibt -1 zurück wenn die angegebene Version älter als die installierte Version
des Zend Frameworks ist, 0 wenn Sie identisch sind und +1 wenn die angegebene Version neuer als die Version des
Zend Frameworks ist.

.. _zend.version.reading.example:

.. rubric:: Beispiel der compareVersion() Methode

.. code-block:: php
   :linenos:

   // gibt -1, 0 oder 1 zurück
   $cmp = Zend\Version\Version::compareVersion('2.0.0');



.. _`version_compare()`: http://php.net/version_compare
