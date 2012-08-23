.. EN-Revision: none
.. _zend.debug.dumping:

Variabelen dumpen
=================

Informatie over een uitdrukking wordt door de statische methode *Zend_Debug::dump()* weergegeven of terug gegeven.
Deze simpele manier van debuggen wordt veel gebruikt, omdat het makkelijk is om te gebruiken, geen initialisatie,
speciale programma's of debug omgevingen nodig heeft.

.. _zend.debug.dumping.example:

.. rubric:: Voorbeeld van de dump() methode

.. code-block:: php
   :linenos:

   <?php

   Zend_Debug::dump($var, $label=null, $echo=true);
De *$var* parameter specificeerd de uitdrukking of variable waarover de *Zend_Debug::dump()* methode informatie
geeft.

De *$label* parameter is een string die vooraan toegevoegd wordt aan de informatie van *Zend_Debug::dump()*. Het
kan bijvoorbeeld handig zijn om labels te gebruiken als je informatie dumpt van meerdere variabelen.

De boolean *$echo* parameter bepaalt of de informatie van *Zend_Debug::dump()* moet worden weergegeven. De
teruggeef waarde van deze methode bevat altijd de informatie, het maakt hiervoor niet uit wat de waarde is van
*$echo*.

Het is misschien handig om te weten dat intern de *Zend_Debug::dump()* methode, de PHP functie `var_dump()`_
omhulst. Als er wordt gedetecteerd dat het om een web presentatie gaat, dan wordt de waarde van *var_dump()*
automatisch door `htmlspecialchars()`_ gehaald en door de (x)HTML *<pre>* tags omhulst.

.. tip::

   **Debuggen met Zend_Log**

   Het gebruiken van *Zend_Debug::dump()* is goed voor ad hoc debuggen tijdens software ontwikkeling. Je kunt snel
   code om een variabele te dumpen toevoegen en dan daarna verwijderen.

   Bekijk ook de :ref:`Zend_Log <zend.log.overview>` component als je een meer permanente debug code schrijft. Als
   voorbeeld, kan je het *DEBUG* logboek level gebruiken en de logboek schrijver gebruiken voor de string die
   teruggegeven wordt door *Zend_Debug::dump()*.



.. _`var_dump()`: http://php.net/var_dump
.. _`htmlspecialchars()`: http://php.net/htmlspecialchars
