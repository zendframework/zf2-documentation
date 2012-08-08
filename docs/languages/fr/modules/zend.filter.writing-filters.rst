.. EN-Revision: none
.. _zend.filter.writing_filters:

Écriture de filtres
===================

``Zend_Filter`` fournit un ensemble de filtres usuels. Cependant, les développeurs auront souvent besoin d'écrire
des filtres personnalisés pour leurs besoins propres. L'écriture de filtre personnalisés est rendue plus facile
via l'implémentation de ``Zend_Filter_Interface``.

``Zend_Filter_Interface`` définit une méthode unique, ``filter()``, qui peut être implémentée dans les classes
créées. Un objet qui implémente cette interface peut être ajouté à une chaîne de filtrage via
``Zend_Filter::addFilter()``.

L'exemple suivant démontre comment écrire un filtre personnalisé :

   .. code-block:: php
      :linenos:

      class MonFiltre implements Zend_Filter_Interface
      {
          public function filter($valeur)
          {
              // application de transformations sur $valeur
              // pour parvenir à $valeurFiltree

              return $valeurFiltree;
          }
      }



Pour ajouter une instance du filtre défini ci-dessus à une chaîne de filtrage :

   .. code-block:: php
      :linenos:

      $filtreChaine = new Zend_Filter();
      $filtreChaine->addFilter(new MonFiltre());




