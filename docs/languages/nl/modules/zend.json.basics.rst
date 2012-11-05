.. EN-Revision: none
.. _zend.json.basics:

Basisgebruik
============

Het gebruik van *Zend_Json* impliceert het gebruik van de volgende twee publiek beschikbare methodes:
*Zend\Json\Json::encode()* en *Zend\Json\Json::decode()*.

   .. code-block:: php
      :linenos:

      <?php
      // Een waarde verkrijgen:
      $phpNative = Zend\Json\Json::decode($encodedValue);

      // Encodering om het terug naar de klant te sturen:
      $json = Zend\Json\Json::encode($phpNative);
      ?>



