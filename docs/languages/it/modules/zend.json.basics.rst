.. EN-Revision: none
.. _zend.json.basics:

Utilizzo base
=============

L'utilizzo di *Zend_Json* implica l'uso dei due metodi pubblici e statici disponibili: *Zend\Json\Json::encode()* e
*Zend\Json\Json::decode()*.

.. code-block:: php
   :linenos:

   <?php
   // Ottiene un valore
   $phpNative = Zend\Json\Json::decode($encodedValue);

   // Codifica il valore e lo restituisce al client
   $json = Zend\Json\Json::encode($phpNative);


