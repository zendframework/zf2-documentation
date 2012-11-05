.. EN-Revision: none
.. _zend.json.basics:

Podstawowe użycie
=================

Użycie *Zend_Json* sprowadza się do dwóch dostępnych statycznych metod: *Zend\Json\Json::encode()* oraz
*Zend\Json\Json::decode()*.

.. code-block:: php
   :linenos:

   // Odkoduj wartość:
   $phpNative = Zend\Json\Json::decode($encodedValue);

   // Zakoduj wartość:
   $json = Zend\Json\Json::encode($phpNative);



