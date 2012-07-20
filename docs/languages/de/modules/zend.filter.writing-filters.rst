.. _zend.filter.writing_filters:

Filter schreiben
================

``Zend_Filter`` bietet ein Set von normalerweise benötigten Filtern, aber Entwickler müssen oft Ihre eigenen
Filter für deren eigene spezielle Verwendung schreiben. Die Arbeit des Schreibens eines eigenen Filters ist
möglich durch die Implementierung von ``Zend_Filter_Interface``.

``Zend_Filter_Interface`` definiert eine einzige Methode, ``filter()``, die von Benutzerdefinierten Klassen
implementiert werden kann. Ein Objekt das dieses Interface implementiert kann in eine Filterkette mit
``Zend_Filter::addFilter()`` hinzugefügt werden.

Das folgende Beispiel demonstriert wie ein eigener Filter geschrieben wird:

.. code-block:: php
   :linenos:

   class MyFilter implements Zend_Filter_Interface
   {
       public function filter($value)
       {
           // einige Transformationen über $value durchführen
           // um $valueFiltered zu erhalten

           return $valueFiltered;
       }
   }

Um eine Instanz des Filters der oben definiert wurde in eine Filterkette hinzuzufügen:

.. code-block:: php
   :linenos:

   $filterChain = new Zend_Filter();
   $filterChain->addFilter(new MyFilter());


