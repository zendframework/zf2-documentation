.. _zend.json.basics:

Podstawowe użycie
=================

Użycie *Zend_Json* sprowadza się do dwóch dostępnych statycznych metod: *Zend_Json::encode()* oraz
*Zend_Json::decode()*.

.. code-block:: php
   :linenos:

   // Odkoduj wartość:
   $phpNative = Zend_Json::decode($encodedValue);

   // Zakoduj wartość:
   $json = Zend_Json::encode($phpNative);



