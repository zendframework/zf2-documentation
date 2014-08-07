.. EN-Revision: none
.. _zend.filter.set.alnum:

Alnum
=====

``Zend\I18n\Filter\Alnum`` ist ein Filter welche nur alphabetische Zeichen und Ziffern zurückgibt. Alle anderen Zeichen
werden unterdrückt.

.. _zend.i18n.filter.alnum.options:

Unterstützte Optionen für Zend\I18n\Filter\Alnum
------------------------------------------------

Die folgenden Optionen werden für ``Zend\I18n\Filter\Alnum`` unterstützt:

- **allowwhitespace**: Wenn diese Option gesetzt wird dann sind Leerzeichen erlaubt. Andernfalls werden Sie
  unterdrückt. Standardmäßig sind Leerzeichen nicht erlaubt.

.. _zend.filter.set.alnum.basic:

Grundsätzliche Verwendung
-------------------------

Das folgende Beispiel zeigt das Standardverhalten dieses Filters.

.. code-block:: php
   :linenos:

   $filter = new Zend\I18n\Filter\Alnum();
   $return = $filter->filter('This is (my) content: 123');
   // Gibt 'Thisismycontent123' zurück

Das oben stehende Beispiel gibt 'Thisismycontent123' zurück. Wie man sehen kann werden alle Leerzeichen und auch
die Klammern gefiltert.

.. note::

   ``Zend\I18n\Filter\Alnum`` arbeitet auf fast allen Sprachen. Aber aktuell gibt es drei Ausnahmen: Chinesisch,
   Japanisch und Koreanisch. In diesen Sprachen wird statt dessen das englische Alphabeth statt den Zeichen dieser
   Sprache verwendet. Die Sprache selbst wird durch Verwendung von ``Zend_Locale`` erkannt.

.. _zend.filter.set.alnum.whitespace:

Leerzeichen erlauben
--------------------

``Zend\I18n\Filter\Alnum`` kann auch Leerzeichen erlauben. Das kann nützlich sein wenn man spezielle Zeichen von einem
Text entfernen will. Siehe das folgende Beispiel:

.. code-block:: php
   :linenos:

   $filter = new Zend\I18n\Filter\Alnum(array('allowwhitespace' => true));
   $return = $filter->filter('This is (my) content: 123');
   // Gibt 'This is my content 123' zurück

Das obige Beispiel gibt 'This is my content 123' zurück. Wie man sieht werden nur die Klammern gefiltert wobei die
Leerzeichen nicht angefasst werden.

Am ``allowWhiteSpace`` im Nachhinein zu ändern kann man ``setAllowWhiteSpace`` und ``getAllowWhiteSpace``
verwenden.


