.. _zend.filter.set.boolean:

Boolean
=======

Dieser Filter ändert eine gegebene Eingabe auf einen ``BOOLEAN`` Wert. Das ist oft nützlich wenn man mit
Datenbanken arbeitet oder wenn Formularwerte bearbeitet werden.

.. _zend.filter.set.boolean.default:

Standardverhalten von Zend_Filter_Boolean
-----------------------------------------

Standardmäßig arbeitet dieser Filter indem er Eingabe auf ``BOOLEAN`` Werte castet; in anderen Worte, er arbeitet
in ähnlicher Weise wie der Aufruf von ``(boolean) $value``.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Boolean();
   $value  = '';
   $result = $filter->filter($value);
   // gibt false zurück

Dies bedeuetet dass ``Zend_Filter_Boolean`` ohne die Angabe einer Konfiguration alle Eingabetypen akteptiert und
ein ``BOOLEAN`` zurückgibt wie man es durch Typcasting zu ``BOOLEAN`` erhält.

.. _zend.filter.set.boolean.types:

Das Verhalten von Zend_Filter_Boolean ändern
--------------------------------------------

Manchmal ist das Casten mit ``(boolean)`` nicht ausreichend. ``Zend_Filter_Boolean`` erlaubt es spezifische Typen
zu konfigurieren welche konvertiert werden, und jene die ignoriert werden.

Die folgenden Typen können behandelt werden:

- **boolean**: Gibt einen boolschen Wert so wie er ist zurück.

- **integer**: Konvertiert den Integerwert **0** zu ``FALSE``.

- **float**: Konvertiert den Gleitkommawert **0.0** zu ``FALSE``.

- **string**: Konvertiert einen leeren String **''** zu ``FALSE``.

- **zero**: Konvertiert einen String der ein einzelnes Null Zeichen (**'0'**) enthält zu ``FALSE``.

- **empty_array**: Konvertiert ein leeres **array** zu ``FALSE``.

- **null**: Konvertiert den Wert ``NULL`` zu ``FALSE``.

- **php**: Konvertiert Werte so wie diese mit *PHP* zu ``BOOLEAN`` konvertiert werden.

- **false_string**: Konvertiert einen String der das Wort "false" enthält zu einem boolschen ``FALSE``.

- **yes**: Konvertiert einen lokalisierten String welcher das Wort "nein" enthält zu ``FALSE``.

- **all**: Konvertiert alle obigen Typen zu ``BOOLEAN``.

Alle anderen angegebenen Werte geben standardmäßig ``TRUE`` zurück.

Es gibt verschiedene Wege um auszuwählen welche der oben stehenden Typen gefiltert werden. Man kann ein oder
mehrere Typen angeben und Sie hinzufügen, man kann ein Array angeben, man kann die Konstanten verwenden, oder man
kann einen textuellen String angeben. Siehe die folgenden Beispiele:

.. code-block:: php
   :linenos:

   // Konvertiert 0 zu false
   $filter = new Zend_Filter_Boolean(Zend_Filter_Boolean::INTEGER);

   // Konvertiert 0 und '0' zu false
   $filter = new Zend_Filter_Boolean(
       Zend_Filter_Boolean::INTEGER + Zend_Filter_Boolean::ZERO
   );

   // Konvertiert 0 und '0' zu false
   $filter = new Zend_Filter_Boolean(array(
       'type' => array(
           Zend_Filter_Boolean::INTEGER,
           Zend_Filter_Boolean::ZERO,
       ),
   ));

   // Konvertiert 0 und '0' zu false
   $filter = new Zend_Filter_Boolean(array(
       'type' => array(
           'integer',
           'zero',
       ),
   ));

Man kann auch eine Instanz von ``Zend_Config`` angeben um die gewünschten Typen zu setzen. Um Typen nach der
Instanzierung zu setzen kann die Methode ``setType()`` verwendet werden.

.. _zend.filter.set.boolean.localized:

Lokalisierte Boolsche Werte
---------------------------

Wie vorher erwähnt erkennt ``Zend_Filter_Boolean`` auch die lokalisierten Strings für "Ja" und "Nein". Das
bedeutet das man den Kunden in einem Formular nach "Ja" oder "Nein" in seiner eigenen Sprache fragen kann und
``Zend_Filter_Boolean`` die Antworten zu richtigen boolschen Werten konvertieren wird.

Um das gewünschte Gebietsschema zu setzen kann man entweder die Option ``locale`` verwenden oder die Methode
``setLocale()`` verwenden.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Boolean(array(
       'type'   => Zend_Filter_Boolean::ALL,
       'locale' => 'de',
   ));

   // Gibt false zurück
   echo $filter->filter('nein');

   $filter->setLocale('en');

   // Gibt true zurück
   $filter->filter('yes');

.. _zend.filter.set.boolean.casting:

Casten ausschalten
------------------

Machmal ist es nützlich nur ``TRUE`` oder ``FALSE`` zu erkennen und alle anderen Werte ohne Änderung
zurückzugeben. ``Zend_Filter_Boolean`` erlaubt dies indem die Option ``casting`` auf ``FALSE`` gesetzt wird.

In diesem Fall arbeitet ``Zend_Filter_Boolean`` wie in der folgenden Tabelle beschrieben, die zeigt welche Werte
``TRUE`` oder ``FALSE`` zurückgeben. Alle anderen angegebenen Werte werden ohne Änderung zurückgegeben wenn
``casting`` auf ``FALSE`` gesetzt wird.

.. _zend.filter.set.boolean.casting.table:

.. table:: Verwendung ohne Casten

   +---------------------------------+-------------------------------------------------+------------------------------------------------+
   |Typ                              |True                                             |False                                           |
   +=================================+=================================================+================================================+
   |Zend_Filter_Boolean::BOOLEAN     |TRUE                                             |FALSE                                           |
   +---------------------------------+-------------------------------------------------+------------------------------------------------+
   |Zend_Filter_Boolean::INTEGER     |0                                                |1                                               |
   +---------------------------------+-------------------------------------------------+------------------------------------------------+
   |Zend_Filter_Boolean::FLOAT       |0.0                                              |1.0                                             |
   +---------------------------------+-------------------------------------------------+------------------------------------------------+
   |Zend_Filter_Boolean::STRING      |""                                               |                                                |
   +---------------------------------+-------------------------------------------------+------------------------------------------------+
   |Zend_Filter_Boolean::ZERO        |"0"                                              |"1"                                             |
   +---------------------------------+-------------------------------------------------+------------------------------------------------+
   |Zend_Filter_Boolean::EMPTY_ARRAY |array()                                          |                                                |
   +---------------------------------+-------------------------------------------------+------------------------------------------------+
   |Zend_Filter_Boolean::NULL        |NULL                                             |                                                |
   +---------------------------------+-------------------------------------------------+------------------------------------------------+
   |Zend_Filter_Boolean::FALSE_STRING|"false" (unabhängig von der Schreibweise)        |"true" (unabhängig von der Schreibweise)        |
   +---------------------------------+-------------------------------------------------+------------------------------------------------+
   |Zend_Filter_Boolean::YES         |localized "yes" (unabhängig von der Schreibweise)|localized "no" (unabhängig von der Schreibweise)|
   +---------------------------------+-------------------------------------------------+------------------------------------------------+

Das folgende Beispiel zeigt das Verhalten wenn die Option ``casting`` verändert wird:

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Boolean(array(
       'type'    => Zend_Filter_Boolean::ALL,
       'casting' => false,
   ));

   // Gibt false zurück
   echo $filter->filter(0);

   // Gibt true zurück
   echo $filter->filter(1);

   // Gibt den Wert zurück
   echo $filter->filter(2);


