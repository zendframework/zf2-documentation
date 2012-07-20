.. _zend.filter.set.pregreplace:

PregReplace
===========

``Zend_Filter_PregReplace`` führt eine Suche durch indem es Reguläre Ausdrücke verwendet und alle gefundenen
Elemente ersetzt.

Die Option ``match`` muss angegeben werden um das Pattern zu Setzen nach dem gesucht wird. Es kann ein String, für
ein einzelnes Pattern sein, oder ein Array von Strings für mehrere Pattern.

Um das Pattern zu Setzen das als Ersatz verwendet wird, muss die Option ``replace`` verwendet werden. Es kann ein
String, für ein einzelnes Pattern sein, oder ein Array von Strings für mehrere Pattern.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_PregReplace(array('match' => '/bob/',
                                               'replace' => 'john'));
   $input  = 'Hy bob!';

   $filter->filter($input);
   // Gibt 'Hy john!' zurück

Man kann ``getMatchPattern()`` und ``setMatchPattern()`` verwenden um die Suchpattern im Nachhinein zu Setzen. Um
das Ersatzpattern zu Setzen können ``getReplacement()`` und ``setReplacement()`` verwendet werden.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_PregReplace();
   $filter->setMatchPattern(array('bob', 'Hy'))
          ->setReplacement(array('john', 'Bye'));
   $input  = 'Hy bob!";

   $filter->filter($input);
   // Gibt 'Bye john!' zurück

Für eine komplexere Verwendung sollte man einen Blick in *PHP*'s `Kapitel für PCRE Pattern`_ werfen.



.. _`Kapitel für PCRE Pattern`: http://www.php.net/manual/en/reference.pcre.pattern.modifiers.php
