.. EN-Revision: none
.. _zend.filter.set.alpha:

Alpha
=====

``Zend\I18n\Filter\Alpha`` ist ein Filter der den String ``$value`` zurückgibt, wobei er alle Zeichen entfernt die
keine alphanummerischen Zeichen sind. Dieser Filter enthält eine Option welche Leerzeichen erlaubt.

.. _zend.i18n.filter.alpha.options:

Unterstützte Optionen für Zend\I18n\Filter\Alpha
------------------------------------------------

Die folgenden Optionen werden für ``Zend\I18n\Filter\Alpha`` unterstützt:

- **allowwhitespace**: Wenn diese Option gesetzt wird dann werden Leerzeichen erlaubt. Andernfalls werden Sie
  unterdrückt. Standardmäßig sind Leerzeichen nicht erlaubt.

.. _zend.filter.set.alpha.basic:

Einfache Verwendung
-------------------

Ein einfaches Beispiel der Verwendung ist anbei:

.. code-block:: php
   :linenos:

   $filter = new Zend\I18n\Filter\Alpha();

   print $filter->filter('Das ist (mein) Inhalt: 123');

Das obige Beispiel gibt 'DasistmeinInhalt' zurück. Es sollte beachtet werden dass Leerzeichen und Klammern
entfernt werden.

.. note::

   ``Zend\I18n\Filter\Alpha`` arbeitet mit den meisten Sprachen; trotzdem gibt es drei Ausnahmen: Chinesisch, Japanisch
   und Koreanisch. Bei diesen Sprachen wird das englische Alphabeth verwenden. Die Sprache wird durch die
   Verwendung von ``Zend_Locale`` erkannt.

.. _zend.filter.set.alpha.whitespace:

Leerzeichen erlauben
--------------------

``Zend\I18n\Filter\Alpha`` kann auch Leerzeichen erlauben. Dies kann nützlich sein wenn man spezielle Zeichen von einem
Statz entfernen will. Siehe das folgende Beispiel:

.. code-block:: php
   :linenos:

   $filter = new Zend\I18n\Filter\Alpha(array('allowwhitespace' => true));

   print $filter->filter('Das ist (mein) Inhalt: 123');

Das oben stehende Beispiel gibt 'Das ist mein Inhalt ' zurück. Es ist zu beachten das alle Klammern, Doppelpunkte
und Zahlen entfernt werden wärend die Leerzeichen bleiben.

Um ``allowWhiteSpace`` nach der Instanziierung zu ändern kann die Methode ``setAllowWhiteSpace()`` verwendet
werden.

Um den aktuellen Wert von ``allowWhiteSpace`` zu erhalten kann die Methode ``getAllowWhiteSpace()`` verwendet
werden.


