.. _zend.feed.custom-feed:

Classes personnalisées pour les flux et entrées
===============================================

Pour finir, vous pouvez étendre les classes de ``Zend_Feed`` si vous souhaitez créer votre propre format ou
implémenter des améliorations comme par exemple la gestion automatique des éléments situés dans un espace de
noms personnalisé.

Voici un exemple d'entrée Atom personnalisée qui gère son propre espace de noms *monen*. Notez aussi que la
classe se charge d'appeler la méthode ``registerNamespace()`` pour que l'utilisateur n'ait au final pas du tout à
se soucier des espaces de noms.

.. _zend.feed.custom-feed.example.extending:

.. rubric:: Étendre la classe représentant les entrées Atom pour ajouter la gestion d'un espace de noms personnalisé

.. code-block:: php
   :linenos:

   /**
    * La classe personnalisée connaît automatiquement l'URI du flux
    * (qui est optionnelle) et elle peut ajouter automatiquement
    * des espaces de noms supplémentaires.
    */
   class MonEntree extends Zend_Feed_Entry_Atom
   {

       public function __construct($uri = 'http://www.exemple.com/monflux/',
                                   $xml = null)
       {
           parent::__construct($uri, $xml);
           Zend_Feed::registerNamespace('monen',
                                        'http://www.exemple.com/monen/1.0');
       }

       public function __get($var)
       {
           switch ($var) {
               case 'maMiseAJour':
                   // On traduit maMiseAJour en monen:maj
                   return parent::__get('monen:maj');

               default:
                   return parent::__get($var);
               }
       }

       public function __set($var, $valeur)
       {
           switch ($var) {
               case 'maMiseAJour':
                   // On traduit maMiseAJour en monen:maj
                   parent::__set('monen:maj', $valeur);
                   break;

               default:
                   parent::__set($var, $valeur);
           }
       }

       public function __call($var, $unused)
       {
           switch ($var) {
               case 'maMiseAJour':
                   // On traduit maMiseAJour en monen:maMiseAJour.
                   return parent::__call('monen:maMiseAJour', $unused);

               default:
                   return parent::__call($var, $unused);
           }
       }
   }

Puis pour utiliser cette classe, instanciez-la directement et définissez la propriété *maMiseAJour*\  :

.. code-block:: php
   :linenos:

   $entree = new MonEntree();
   $entree->maMiseAJour = '2005-04-19T15:30';

   // appel de type méthode géré par __call
   $entree->maMiseAJour();

   // appel de type propriété géré par __get
   $entree->maMiseAJour;


