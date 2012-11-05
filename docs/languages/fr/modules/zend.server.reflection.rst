.. EN-Revision: none
.. _zend.server.reflection:

Zend\Server\Reflection
======================

.. _zend.server.reflection.introduction:

Introduction
------------

``Zend\Server\Reflection`` fournit un mécanisme standard pour exécuter l'introspection de fonction et de classe
pour utiliser avec des classes serveur. Il est basé sur l'API de réflexion de *PHP* 5, et l'améliore pour
fournir des méthodes de recherche des types et des descriptions de paramètre et de valeur de retour, une liste
complète des prototypes de fonction et de méthode (c.-à-d., toutes les combinaisons d'appels valides possibles),
et des descriptions de fonction/méthode.

Typiquement, cette fonctionnalité sera seulement utilisée par les développeurs des classes serveur pour le
framework.

.. _zend.server.reflection.usage:

Utilisation
-----------

L'utilisation de base est simple :

.. code-block:: php
   :linenos:

   $class    = Zend\Server\Reflection::reflectClass('Ma_Classe');
   $function = Zend\Server\Reflection::reflectFunction('ma_fonction');

   // Récupère les prototypes
   $prototypes = $reflection->getPrototypes();

   // Parcoure chaque prototype pour une fonction
   foreach ($prototypes as $prototype) {

       // Récupère les prototypes des types de retour
       echo "Return type: ", $prototype->getReturnType(), "\n";

       // Récupère les paramètres
       $parameters = $prototype->getParameters();

       echo "Paramètres: \n";
       foreach ($parameters as $parameter) {
           // Récupère le type d'un paramètre
           echo "    ", $parameter->getType(), "\n";
       }
   }

   // Récupère l'espace de noms d'une classe, d'une fonction, ou d'une méthode.
   // Les espaces de noms peuvent être définis au moment de l'instanciation
   // (deuxième argument), ou en utilisant setNamespace()
   $reflection->getNamespace();

``reflectFunction()`` retourne un objet ``Zend\Server_Reflection\Function``. *reflectClass* retourne un objet
``Zend\Server_Reflection\Class``. Veuillez vous référer à la documentation d'API pour voir quelles méthodes
sont disponibles pour chacun.


