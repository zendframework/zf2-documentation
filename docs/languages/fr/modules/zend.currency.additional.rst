.. _zend.currency.additional:

Informations complémentaires pour Zend_Currency
===============================================

.. _zend.currency.additional.informations:

Informations sur les monnaies
-----------------------------

Il peut être utilie de récupérer des données concernant une monnaie. ``Zend_Currency`` propose différentes
méthodes dans ce but dont voici une liste:

- **getCurrencyList()**: Retourne un tableau listant toutes les monnaies utilisées dans une région donnée. La
  locale par défaut est utilisée si aucune information de région n'est fournie.

- **getLocale()**: Retourne la locale utilisée actuellement pour la monnaie.

- **getName()**: Retourne le nom complet de la monnaie actuelle. Si aucun nom complet n'est trouvé,
  l'abbréviation sera retournée.

- **getRegionList()**: Retourne un tableau de toutes les régions où est utilisée la monnaie actuelle. Toutes les
  régions sont listées si aucune monnaie n'a été donnée.

- **getService()**: Retourne l'objet de service d'échange de la monnaie courante.

- **getShortName()**: Retourne l'abbréviation de la monnaie courante.

- **getSymbol()**: Retourne le symbole de la monnaie. Si aucun symbole n'existe, l'abbréviation de la monnaie sera
  retournée.

- **getValue()**: Retourne la valeur affectée à la monnaie en cours.

Voyons quelques exemples:

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency();

   var_dump($currency->getValue());
   // retourne 0

   var_dump($currency->getRegionList());
   // retourne un tableau représentant toutes les régions dans lesquelles USD est utilisé

   var_dump($currency->getRegionList('EUR'));
   // retourne un tableau avec toutes les régions utilisant l'EUR

   var_dump($currency->getName());
   // pourrait retourner 'US Dollar'

   var_dump($currency->getName('EUR'));
   // Retourne 'Euro'

Comme vous le voyez, beaucoup de méthodes prennent des paramètres supplémentaires pour surcharger l'objet actuel
et le faire travailler sur une autre monnaie que celle stockée en interne.

.. _zend.currency.additional.cache:

Optimisation des performances des monnaies
------------------------------------------

Les performances de ``Zend_Currency`` peuvent être optimisées au moyen de ``Zend_Cache``. La méthode statique
``Zend_Currency::setCache($cache)`` prend une options : un adaptateur ``Zend_Cache``. S'il est utilisé, les
données de localisation utilisées au sein de ``Zend_Currency`` seront mises en cache. Aussi, il y a des méthodes
statiques pour manipuler le cache : ``getCache()``, ``hasCache()``, ``clearCache()`` et ``removeCache()``.

.. _zend.currency.usage.cache.example:

.. rubric:: Mettre les monnaies en cache

.. code-block:: php
   :linenos:

   // Création d'un objet de cache
   $cache = Zend_Cache::factory('Core',
                                'File',
                                array('lifetime' => 120,
                                      'automatic_serialization' => true),
                                array('cache_dir'
                                          => dirname(__FILE__) . '/_files/'));
   Zend_Currency::setCache($cache);


