.. EN-Revision: none
.. _zend.filter.set.stringtoupper:

StringToUpper
=============

Este filtro convierte cualquier entrada en Mayúculas

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_StringToUpper();

   print $filter->filter('Sample');
   // returns "SAMPLE"

Like the ``StringToLower`` filter, this filter handles only characters from the actual locale of your server. Using
different character sets works the same as with ``StringToLower``. Al igual que ``StringToLower``, este filtro solo
se encarga de los caracteres localización en su servidor. Utilizando diferentes conjuntos de caracteres funciona
igual que con ``StringToLower``.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_StringToUpper(array('encoding' => 'UTF-8'));

   // or do this afterwards
   $filter->setEncoding('ISO-8859-1');


