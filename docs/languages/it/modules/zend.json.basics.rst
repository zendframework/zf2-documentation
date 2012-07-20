.. _zend.json.basics:

Utilizzo base
=============

L'utilizzo di *Zend_Json* implica l'uso dei due metodi pubblici e statici disponibili: *Zend_Json::encode()* e
*Zend_Json::decode()*.

.. code-block::
   :linenos:
   <?php
   // Ottiene un valore
   $phpNative = Zend_Json::decode($encodedValue);

   // Codifica il valore e lo restituisce al client
   $json = Zend_Json::encode($phpNative);


