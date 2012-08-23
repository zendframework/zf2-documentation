.. EN-Revision: none
.. _zend.version.reading:

Získání informací o verzi Zend Frameworku
=========================================

Hodnotou konstanty *Zend_Version::VERSION* je řetězec označující aktuální číslo verze, např. "0.9.0beta".

Statická metoda *Zend_Version::compareVersion($version)* pracuje s funkcí `version_compare()`_. Tato metoda
vrací -1 v případě, že parametr *$version* udává starší verzi, než je aktuální verze Zend Frameworku, 0
pokud je verze stejná a +1 v případě, že parametr *$version* označuje novější verzi Zend Frameworku.

.. _zend.version.reading.example:

.. rubric:: Příklad využití metody compareVersion()

.. code-block:: php
   :linenos:

   <?php

   // vrací -1, 0, nebo 1
   $cmp = Zend_Version::compareVersion('1.0.0');

   ?>


.. _`version_compare()`: http://php.net/version_compare
