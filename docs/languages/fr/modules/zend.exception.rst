.. EN-Revision: none
.. _zend.exception.using:

Utiliser les exceptions
=======================

``Zend_Exception`` est la classe de base dont dérivent toutes les exceptions levées par les classes de Zend
Framework.

.. _zend.exception.using.example:

.. rubric:: Récupération d'une exception

Le code suivant montre comment attraper une exception levée par une classe de Zend Framework :

.. code-block:: php
   :linenos:

   try {
       Zend\Loader\Loader::loadClass('classnonexistante');
   } catch (Zend_Exception $e) {
       // Appeler Zend\Loader\Loader::loadClass() sur une classe non-existante
       // entraînera la levée d'une exception dans Zend_Loader
       echo "Récupère exception: " . get_class($e) . "\n";
       echo "Message: " . $e->getMessage() . "\n";
       // puis tout le code nécessaire pour récupérer l'erreur
   }

``Zend_Exception`` peut être comme une classe d'exception catch-all dans un bloc catch pour traquer toues les
exceptions levées par les classes de Zend Framework. Ceci peut être utile quand un programme n'arrive pas à
fonctionner en essayant d'attraper un type d'exception spécifique.

La documentation pour chaque composant de Zend Framework et de ses classes contient les informations plus
spécifiques sur les méthodes qui lèvent des exceptions, les circonstances de lancement de ces exceptions et
quelles types de classes d'exception peuvent être levées.


