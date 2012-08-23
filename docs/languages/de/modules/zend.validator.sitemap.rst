.. EN-Revision: none
.. _zend.validator.sitemap:

Sitemap Prüfungen
=================

Die folgenden Prüfungen entsprechen dem `Sitemap XML Protokoll`_.

.. _zend.validator.sitemap.changefreq:

Sitemap_Changefreq
------------------

Prüft ob ein String gültig ist um Ihn als 'changefreq' Element in einem Sitemap *XML* Dokument zu verwenden.
Gültige Elemente sind: 'always', 'hourly', 'daily', 'weekly', 'monthly', 'yearly', oder 'never'.

Gibt ``TRUE`` zurück wenn und nur wenn der Wert ein String ist und mit einer der oben spezifizierten Frequenzen
übereinstimmt.

.. _zend.validator.sitemap.lastmod:

Sitemap_Lastmod
---------------

Prüft ob ein String gültig ist um Ihn als 'lastmod' Element in einem Sitemap *XML* Dokument zu verwenden. Das
lastmod Element sollte einen *W3C* Datumsstring enthalten, und optional Informationen über die Zeit enthalten.

Gibt ``TRUE`` zurück wenn, und nur wenn, der angegebene Wert ein String und in Bezug auf das Prokoll gültig ist.

.. _zend.validator.sitemap.lastmod.example:

.. rubric:: Sitemap Lastmod Prüfung

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

.. _zend.validator.sitemap.loc:

Sitemap_Loc
-----------

Prüft ob ein String für die Verwendung als 'loc' Element in einem Sitemap *XML* Dokument gültig ist. Er
verwendet intern ``Zend_Form::check()``. Mehr darüber kann man unter :ref:`URI Prüfung <zend.uri.validation>`
lesen.

.. _zend.validator.sitemap.priority:

Sitemap_Priority
----------------

Prüft ob ein Wert für die Verwendung als 'priority' Element in einem Sitemap *XML* Dokument gültig ist. Der Wert
sollte ein Dezimalwert zwischen 0.0 und 1.0 sein. Diese Prüfung akzeptiert sowohl nummerische Werte als auch
Stringwerte.

.. _zend.validator.sitemap.priority.example:

.. rubric:: Sitemap Priority Prüfung

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

.. _zend.validator.set.sitemap.options:

Unterstützte Optionen für Zend_Validate_Sitemap_*
-------------------------------------------------

Es gibt keine unterstützten Optionen für irgendeine der Sitemap Prüfungen.



.. _`Sitemap XML Protokoll`: http://www.sitemaps.org/protocol.php
