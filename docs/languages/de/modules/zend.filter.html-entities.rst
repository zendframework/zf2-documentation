.. EN-Revision: none
.. _zend.filter.set.htmlentities:

HtmlEntities
============

Gibt den String ``$value`` zurück, wobei Zeichen in Ihre *HTML* Entity Äquivalente konvertiert werden wenn diese
existieren.

.. _zend.filter.set.htmlentities.options:

Unterstützte Optionen für Zend\Filter\HtmlEntities
--------------------------------------------------

Die folgenden Optionen werden für ``Zend\Filter\HtmlEntities`` unterstützt:

- **quotestyle**: Äquivalent zum Parameter **quote_style** der nativen *PHP* Funktion htmlentities. Er erlaubt es
  zu definieren wass mit 'einfachen' und "doppelten" Hochkomma passieren soll. Die folgenden Konstanten werden
  akzeptiert: ``ENT_COMPAT``, ``ENT_QUOTES`` ``ENT_NOQUOTES`` wobei ``ENT_COMPAT`` der Standardwert ist.

- **charset**: Äquivalent zum Parameter **charset** der nativen *PHP* Funktion htmlentities. Er definiert das
  Zeichenset welches beim Filtern verwendet werden soll. Anders als bei der nativen *PHP* Funktion ist der
  Standardwert 'UTF-8'. Siehe "http://php.net/htmlentities" für eine Liste der unterstützten Zeichensets.

  .. note::

     Diese Option kann auch über den Parameter ``$options``, als ``Zend_Config`` Objekt oder als Array gesetzt
     werden. Der Optionsschlüssel wird entweder als Zeichenset oder als Kodierung akzeptiert.

- **doublequote**: Äquivalent zum Parameter **double_encode** der nativen *PHP* Funktion htmlentities. Wenn er auf
  false gesetzt wird, werden existierende html entities nicht kodiert. Der Standardwert ist es alles zu
  konvertieren (true).

  .. note::

     Diese Option muss über den Parameter ``$options`` oder die Methode ``setDoubleEncode()`` gesetzt werden.

.. _zend.filter.set.htmlentities.basic:

Einfache Verwendung
-------------------

Siehe das folgende Beispiel für das Standardverhalten dieses Filters.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\HtmlEntities();

   print $filter->filter('<');

.. _zend.filter.set.htmlentities.quotestyle:

Hochkomma Stil
--------------

``Zend\Filter\HtmlEntities`` erlaubt es den verwendete Hochkomma Stil zu verändern. Dies kan nützlich sein wenn
man doppelte, einfache oder beide Typen von Hochkommas un-gefiltert lassen will. Siehe das folgende Beispiel:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\HtmlEntities(array('quotestyle' => ENT_QUOTES));

   $input  = "Ein 'einfaches' und " . '"doppeltes"';
   print $filter->filter($input);

Das obige Beispiel gibt **Ein 'einfaches' und "doppeltes"** zurück. Es ist zu beachten dass sowohl 'einfache' als
auch "doppelte" Hochkommas gefiltert werden.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\HtmlEntities(array('quotestyle' => ENT_COMPAT));

   $input  = "Ein 'einfaches' und " . '"doppeltes"';
   print $filter->filter($input);

Das obige Beispiel gibt **Ein 'einfaches' und "doppeltes"** zurück. Es ist zu beachten dass "doppelte" Hochkommas
gefiltert werden wärend 'einfache' Hochkommas nich verändert werden.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\HtmlEntities(array('quotestyle' => ENT_NOQUOTES));

   $input  = "Ein 'einfaches' und" . '"doppeltes"';
   print $filter->filter($input);

Das obige Beispiel gibt **Ein 'einfaches' und "doppeltes"** zurück. Es ist zu beachten dass "doppelte" oder
'einfache' Hochkommas verändert werden.

.. _zend.filter.set.htmlentities.:

Helfer Methoden
---------------

Um die Option ``quotestyle`` nach der Instanzierung zu erhalten oder zu ändern, können die zwei Methoden
``setQuoteStyle()`` und ``getQuoteStyle()`` verwendet werden. ``setQuoteStyle()`` akzeptiert einen ``$quoteStyle``
Parameter. Die folgenden Konstanten werden akzeptiert: ``ENT_COMPAT``, ``ENT_QUOTES``, ``ENT_NOQUOTES``

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\HtmlEntities();

   $filter->setQuoteStyle(ENT_QUOTES);
   print $filter->getQuoteStyle(ENT_QUOTES);

Um die Option ``charset`` nach der Instanzierung zu erhalten oder zu ändern, können die zwei Methoden
``setCharSet()`` und ``getCharSet()`` verwendet werden. ``setCharSet()`` akzeptiert einen ``$charSet`` Parameter.
Siehe "http://php.net/htmlentities" für eine Liste der unterstützten Zeichensets.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\HtmlEntities();

   $filter->setQuoteStyle(ENT_QUOTES);
   print $filter->getQuoteStyle(ENT_QUOTES);

Um die Option ``doublequote`` nach der Instanzierung zu erhalten oder zu ändern, können die zwei Methoden
``setDoubleQuote()`` und ``getDoubleQuote()`` verwendet werden. ``setDoubleQuote()`` akzeptiert einen boolschen
Parameter ``$doubleQuote``.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\HtmlEntities();

   $filter->setQuoteStyle(ENT_QUOTES);
   print $filter->getQuoteStyle(ENT_QUOTES);


