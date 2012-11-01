.. EN-Revision: none
.. _zend.filter.set.stringtrim:

StringTrim
==========

Dieser Filter verändert einen angegebenen String so dass bestimmte Zeichen vom Anfang und vom Ende entfernt
werden.

.. _zend.filter.set.stringtrim.options:

Unterstützte Optionen für Zend\Filter\StringTrim
------------------------------------------------

Die folgenden Optionen werden für ``Zend\Filter\StringTrim`` unterstützt:

- **charlist**: Liste der Zeichen welche vom Anfang und vom Ende des Strings entfernt werden sollen. Wenn sie nicht
  gesetzt wird oder null ist, wird das Standardverhalten verwendet, welches nur Leerzeichen vom Beginn und vom Ende
  des Strings entfernt.

.. _zend.filter.set.stringtrim.basic:

Einfache Verwendung
-------------------

Ein einfaches Beispiel der Verwendung ist nachfolgend zu finden:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\StringTrim();

   print $filter->filter(' Das ist (mein) Inhalt: ');

Das obige Beispiel gibe 'Das ist (mein) Inhalt:' zurück. Es sollte beachtet werden dass alle Leerzeichen entfernt
wurden.

.. _zend.filter.set.stringtrim.types:

Standardverhalten für Zend\Filter\StringTrim
--------------------------------------------

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\StringTrim(':');
   // oder new Zend\Filter\StringTrim(array('charlist' => ':'));

   print $filter->filter(' Das ist (mein) Inhalt:');

Das obige Beispiel gibt 'Das ist (mein) Inhalt' zurück. Es sollte beachtet werden dass Leerzeichen und
Doppelpunkte entfernt werden. Man kann auch eine Instanz von ``Zend_Config`` oder ein Array mit einem 'charlist'
Schlüssel angeben. Un die gewünschte Liste der Zeichen nach der Instanzierung zu setzen kann die Methode
``setCharList()`` verwendet werden. ``getCharList()`` gibt die Werte zurück welche für die Zeichenliste gesetzt
sind.


