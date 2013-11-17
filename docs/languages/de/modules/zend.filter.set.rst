.. EN-Revision: none
.. _zend.filter.set:

Standard Filter Klassen
=======================

Zend Framework kommt mit einem Standardset von Filtern, welche bereits zur Verwendung fertig sind.

.. include:: zend.i18n.filter.alnum.rst
.. include:: zend.i18n.alpha.alnum.rst
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

Gibt den String ``$value`` ohne Zeilenumbruch Zeichen zurück.

.. _zend.filter.set.striptags:

StripTags
---------

Dieser Filter gibt den Eingabestring zurück, wobei alle *HTML* und *PHP* Tags von Ihm entfernt werden ausser
diesen die explizit erlaubt sind. Zusätzlich zur Möglichkeit zu definieren welche Tags erlaubt sind können
Entwickler definieren welche Attribute über alle erlaubten Tags erlaubt sind und auch nur für spezielle Tags.


