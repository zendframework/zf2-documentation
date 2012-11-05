.. EN-Revision: none
.. _zend.json.basics:

Základní použití
================

Použití *Zend_Json* zahrnuje dvě public static metody: *Zend\Json\Json::encode()* a *Zend\Json\Json::decode()*.

.. code-block:: php
   :linenos:

   <?php
   // Získání hodnoty:
   $phpNative = Zend\Json\Json::decode($encodedValue);

   // Zakódování hodnoty pro vrácení klientovi:
   $json = Zend\Json\Json::encode($phpNative);


