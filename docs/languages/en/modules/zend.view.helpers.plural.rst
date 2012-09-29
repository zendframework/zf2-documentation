.. _zend.view.helpers.initial.plural:

Plural Helper
=============

The ``Plural`` view helper is used to render a specific string according to a number. This feature is similar in use to the i18n plural translation helper, excepting that this one is used when you do not need translation.

.. _zend.view.helpers.initial.partial.usage:

.. rubric:: Basic Usage of Plural

To use it, simply pass the singular string, then the plural string, and finally the number that will determine which string to choose.

.. code-block:: php
   :linenos:

   <?php 
       echo $this->plural('one car', 'two cars', 1); // prints 'one car'
   	   echo $this->plural('one car', 'two cars', 2); // prints 'two cars'


