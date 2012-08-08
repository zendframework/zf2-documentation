.. EN-Revision: none
.. _zend.paginator.advanced:

Utilisation avancée
===================

.. _zend.paginator.advanced.adapters:

Adaptateurs de source de données personnalisée
----------------------------------------------

À partir d'un moment, vous pourriez avoir besoin de parcourir un type de données qui n'est pas couvert par les
adaptateurs fournis par défaut. Dans ce cas, vous devrez écrire vos propres adaptateurs.

Pour faire ceci, vous devez implémenter ``Zend_Paginator_Adapter_Interface``. Il existe deux méthodes requises :

- ``count()``

- ``getItems($offset, $itemCountPerPage)``

De plus, vous voudrez peut-être implémenter un constructeur qui prend votre source de données comme paramètre
et le stocke comme propriété protégée ou privée. La manière suivant laquelle vous allez spécifiquement faire
ceci, vous incombe.

Si vous avez déjà utilisé l'interface SPL `Countable`_, vous êtes familier avec ``count()``. Utilisé avec
``Zend_Paginator``, il s'agit du nombre total d'éléments dans la collection de données. De plus, l'instance
``Zend_Paginator`` fournit une méthode ``countAllItems()`` qui proxie vers la méthode ``count()`` de
l'adaptateur.

La méthode ``getItems()`` est seulement légèrement plus compliquée. Pour ceci, les paramètres sont un point de
départ et un nombre d'éléments à afficher par page. Vous devez retourner la portion appropriée de données.
Pour un tableau, il s'agirait :



   .. code-block:: php
      :linenos:

      return array_slice($this->_array, $offset, $itemCountPerPage);



Regardez les adaptateurs fournis par défaut (ils implémentent tous ``Zend_Paginator_Adapter_Interface``) pour
avoir une idée de la manière d'implémenter votre propre adaptateur.

.. _zend.paginator.advanced.scrolling-styles:

Styles de défilement personnalisés
----------------------------------

Créer votre propre style de défilement requiert que vous implémentiez
``Zend_Paginator_ScrollingStyle_Interface``, qui définit une seule méthode, ``getPages()``. Et plus
spécifiquement :



   .. code-block:: php
      :linenos:

      public function getPages(Zend_Paginator $paginator, $pageRange = null);



Cette méthode doit calculer des bornes inférieures et supérieures des numéros de page dans la plage des pages
dites "local" (c'est-à-dire qui sont proches de la page courante).

A moins que votre style étende un autre style de défilement (voir ``Zend_Paginator_ScrollingStyle_Elastic`` par
exemple), votre style personnalisé devra inévitablement se terminer par quelque chose de similaire à ceci :



   .. code-block:: php
      :linenos:

      return $paginator->getPagesInRange($lowerBound, $upperBound);



Il n'y a rien de spécial au sujet de cet appel ; c'est simplement une méthode pratique pour vérifier la
validité de la limite inférieure et supérieure et pour renvoyer un tableau de ces bornes au paginateur.

Quand vous êtes prêt à utiliser votre style de défilement, vous devez informer ``Zend_Paginator`` dans quel
dossier le chercher, en réalisant ceci :



   .. code-block:: php
      :linenos:

      $prefix = 'Mon_Paginator_StyleDefilement';
      $path   = 'Mon/Paginator/StyleDefilement/';
      Zend_Paginator::addScrollingStylePrefixPath($prefix, $path);



.. _zend.paginator.advanced.caching:

Fonctionnalité de mise en cache
-------------------------------

``Zend_Paginator`` peut mettre en cache les données qu'il a déjà fourni, empêchant ainsi l'adaptateur de les
rechercher chaque fois qu'ils sont demandés. Pour informer le paginateur de mettre en cache automatiquement les
données issues de l'adaptateur, fournissez simplement une instance de ``Zend_Cache_Core`` à sa méthode
``setCache()``:



   .. code-block:: php
      :linenos:

      $paginator = Zend_Paginator::factory($someData);
      $fO = array('lifetime' => 3600, 'automatic_serialization' => true);
      $bO = array('cache_dir'=>'/tmp');
      $cache = Zend_cache::factory('Core', 'File', $fO, $bO);
      Zend_Paginator::setCache($cache);



Tant que Zend_Paginator possède une instance de Zend_Cache_Core, les données seront mises en cache. Parfois vous
ne voudrez pas mettre en cache les données même si vous avez déjà fourni un instance de cache. Vous pourrez
alors utiliser la méthode ``setCacheEnable()``:



   .. code-block:: php
      :linenos:

      $paginator = Zend_Paginator::factory($someData);
      // $cache est une instance de Zend_Cache_Core
      Zend_Paginator::setCache($cache);
      // ... plus loin dans le script
      $paginator->setCacheEnable(false);
      // le cache est maintenant désactivé



Quand un cache est paramétré, les données y sont automatiquement stockées et extraites. Il peut alors être
utile de vider le cache manuellement. Vous pouvez réaliser ceci en appelant ``clearPageItemCache($pageNumber)``.
Si vous ne passer aucun paramètre, le cache entier sera vidé. Vous pouvez fournir optionnellement un paramètre
représentant le numéro de page à enlever du cache :



   .. code-block:: php
      :linenos:

      $paginator = Zend_Paginator::factory($someData);
      Zend_Paginator::setCache($cache);
      $items = $paginator->getCurrentItems();
      // la page 1 est maintenant en cache
      $page3Items = $paginator->getItemsByPage(3);
      // la page 3 est maintenant en cache

      // effacer le cache associé à la page 3
      $paginator->clearPageItemCache(3);

      // effacer tout le cache
      $paginator->clearPageItemCache();



Changer le nombre d'éléments par page videra tout le cache comme s'il était devenu invalide :



   .. code-block:: php
      :linenos:

      $paginator = Zend_Paginator::factory($someData);
      Zend_Paginator::setCache($cache);
      // récupérer des éléments
      $items = $paginator->getCurrentItems();

      // toutes les données vont être effacées du cache :
      $paginator->setItemCountPerPage(2);



Il est aussi possible de voir les données en cache et de les appeler directement grâce à la méthode
``getPageItemCache()``:



   .. code-block:: php
      :linenos:

      $paginator = Zend_Paginator::factory($someData);
      $paginator->setItemCountPerPage(3);
      Zend_Paginator::setCache($cache);

      // récupérer des éléments
      $items = $paginator->getCurrentItems();
      $otherItems = $paginator->getItemsPerPage(4);

      // voir ces éléments sous la forme d'un tableau à 2-dimensions :
      var_dump($paginator->getPageItemCache());



.. _zend.paginator.advanced.aggregator:

Zend_Paginator_AdapterAggregate Interface
-----------------------------------------

Depending on your application you might want to paginate objects, whose internal data-structure is equal to
existing adapters, but you don't want to break up your encapsulation to allow access to this data. In other cases
an object might be in a "has-an adapter" relationship, rather than the "is-an adapter" relationsship that
``Zend_Paginator_Adapter_Abstract`` promotes. For this cases you can use the ``Zend_Paginator_AdapterAggregate``
interface that behaves much like the ``IteratorAggregate`` interface of the PHP SPL extension.



   .. code-block:: php
      :linenos:

      interface Zend_Paginator_AdapterAggregate
      {
          /**
           * Return a fully configured Paginator Adapter from this method.
           *
           * @return Zend_Paginator_Adapter_Abstract
           */
          public function getPaginatorAdapter();
      }



The interface is fairly small and only expects you to return an instance of ``Zend_Paginator_Adapter_Abstract``. An
Adapter Aggregate instance is then recognized by both *Zend_Paginator::factory* and the constructor of
Zend_Paginator and handled accordingly.



.. _`Countable`: http://www.php.net/~helly/php/ext/spl/interfaceCountable.html
