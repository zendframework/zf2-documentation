.. _zend.exception.basic:

Utilisation classique
=====================

``Zend_Exception`` est le classe de base concernant toutes les exceptions envoyées par Zend Framework. Cette
classe étend la classe PHP ``Exception``.

.. _zend.exception.catchall.example:

.. rubric:: Attraper toutes les exceptions du Zend Framework

.. code-block:: php
   :linenos:

   try {
       // votre code
   } catch (Zend_Exception $e) {
       // faire quelque chose
   }

.. _zend.exception.catchcomponent.example:

.. rubric:: Attraper les exceptions envoyées par un composant spécifique de Zend Framework

.. code-block:: php
   :linenos:

   try {
       // Votre code
   } catch (Zend_Db_Exception $e) {
       // faire quelque chose
   }


