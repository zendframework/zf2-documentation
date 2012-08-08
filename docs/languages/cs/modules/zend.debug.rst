.. EN-Revision: none
.. _zend.debug.dumping:

Ladění proměnných
=================

Statická metoda *Zend_Debug::dump()* vypisuje nebo vrací informaci o určitém výrazu. Tento způsob ladění
kódu se používá běžně, protože není třeba používat žádné speciální nástroje nebo prostředí pro
ladění.

.. _zend.debug.dumping.example:

.. rubric:: Příklad použití metody dump()

.. code-block:: php
   :linenos:

   <?php

   Zend_Debug::dump($var, $label=null, $echo=true)

   ?>
Parametr *$var* přijímá výraz nebo proměnnou, jejíž obsah bude vypsán metodou *Zend_Debug::dump()*.

Parametr *$label* obsahuje řetězec, který bude rovněž vypsán metodou *Zend_Debug::dump()*. Může být velmi
užitečný v případě, kdy jsou vypisovány informace o více proměnných najednou.

Parametr *$echo* obsahuje boolean hodnotu (true/false) a určuje, zda má být výstup metody *Zend_Debug::dump()*
vypsán. Jestliže je hodnota *true* (defaultně), obsah je vypsán. Bez ohledu na hodnotu parametru *$echo*, vždy
je vrácen nějaký obsah.

Může být užitečné vědět, že metoda *Zend_Debug::dump()* interně používá funkci `var_dump()`_. Metoda
navíc zjišťuje, zda bude výstup vypsán ve webové prezentaci. Pokud ano, pak je výstup metody *var_dump()*
escapován funkcí `htmlspecialchars()`_ a obalen elementy (X)HTML *<pre>*.

.. tip::

   **Ladění pomocí Zend_Log**

   Používání metody *Zend_Debug::dump()* je velmi dobré pro jednoduché ladění během vývoje. Jednoduše
   můžete přidat kód, který vypíše hodnotu proměnné a pak jej zase rychle odstranit.

   Je možné také používat knihovnu :ref:`Zend_Log <zend.log.overview>` pro dlouhodobé ladění kódu. Např.
   můžete používat *DEBUG* log level a výsledek metody *Zend_Debug::dump()* zapisovat do logu.



.. _`var_dump()`: http://php.net/var_dump
.. _`htmlspecialchars()`: http://php.net/htmlspecialchars
