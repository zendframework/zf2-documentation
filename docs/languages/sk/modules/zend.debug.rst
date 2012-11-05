.. EN-Revision: none
.. _zend.debug.dumping:

Zobrazovanie obsahu premenených
===============================

Statická metóda *Zend\Debug\Debug::dump()* vypíše, alebo vráti informáciu o výraze. Tento spôsob ladenia je
bežný, lebo je jednoducho použiteľný a nepotrebuje inicializáciu, špeciálne nástroje, alebo ladiace
prostredie.

.. _zend.debug.dumping.example:

.. rubric:: Príklad metódy dump()

.. code-block:: php
   :linenos:

   <?php

   Zend\Debug\Debug::dump($var, $label=null, $echo=true)

   ?>
Argument *$var* obsahuje výraz, premennú o ktorej chceme zistiť informácie pomocou metódy *Zend\Debug\Debug::dump()*

Argument *$label* je reťazec ktorý bude pridaný pre výstup *Zend\Debug\Debug::dump()*. Môže to byť užitočné
keď sa zobrazuje viac premenných na jednej obrazovke.

Argument *$echo* určuje či výstup z *Zend\Debug\Debug::dump()* bude vypísaný, alebo nie. Ak je *true* výstup bude
vypísaný. Návratová hodnota vždy obsahuje výstup a nezáleží na hodnote argumentu *$echo*.

Môže byť užitočné vedieť ako funguje metóda *Zend\Debug\Debug::dump()* vnútorne. Je to obalenie PHP funkcie
`var_dump()`_. Ak je výstup detekovaný ako web, potom je výstup z *var_dump()* escapovaný pomocou
`htmlspecialchars()`_ a obalený (X)HTML značkou *<pre>*.

.. tip::

   **Ladenie s Zend_Log**

   Použitie *Zend\Debug\Debug::dump()* je najlepšie pre okamžité použitie počas vývoja aplikácie. Pridanie a
   odobratie kódu pre zobrazenie premennej, alebo výrazu je rýchle.

   Vhodné je zvážiť použitie :ref:`Zend_Log <zend.log.overview>` pre písanie trvalejšieho kódu pre ladenie.
   Napríklad je možné použiť úroveň zaznamenávania *DEBUG* a zapisovať do súboru, ..., výstup vrátený
   metódou *Zend\Debug\Debug::dump()*.



.. _`var_dump()`: http://php.net/var_dump
.. _`htmlspecialchars()`: http://php.net/htmlspecialchars
