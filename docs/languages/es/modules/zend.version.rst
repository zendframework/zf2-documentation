.. EN-Revision: none
.. _zend.version.reading:

Obteniendo la versión de Zend Framework Version
===============================================

``Zend_Version`` proporciona una constante de clase ``Zend\Version\Version::VERSION`` que contiene una cadena que
identifica el número de version de la instalcíón de Zend Framework. ``Zend\Version\Version::VERSION`` puede contener por
ejemplo "1.7.4".

El método estático ``Zend\Version\Version::compareVersion($version)`` esta basada en la función `version_compare()`_ de
*PHP*. Este método devuelve -1 si la versíón especificada es mayor que la versión instalada de Zend Framework,
0 si son iguales y +1 si la versión especificada es más reciente que la la versión de la instalación de Zend
Framework.

.. _zend.version.reading.example:

.. rubric:: Ejemplo de uso del método compareVersion()

.. code-block:: php
   :linenos:

   // returns -1, 0 or 1
   $cmp = Zend\Version\Version::compareVersion('2.0.0');



.. _`version_compare()`: http://php.net/version_compare
