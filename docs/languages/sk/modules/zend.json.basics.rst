.. EN-Revision: none
.. _zend.json.basics:

Základné použtie
================

Používanie *Zend_Json* vyžaduje použitie týchto dvoch metód: *Zend\Json\Json::encode()* a *Zend\Json\Json::decode()*.

.. code-block:: php
   :linenos:

   <?php
   // Získanie hodnoty:
   $phpNative = Zend\Json\Json::decode($encodedValue);

   // Zakódovanie pre ďalšie použitie na klientovi:
   $json = Zend\Json\Json::encode($phpNative);
   ?>

