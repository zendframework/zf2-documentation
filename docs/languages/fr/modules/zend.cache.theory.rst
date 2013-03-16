.. EN-Revision: none
.. _zend.cache.theory:

Aspect théorique
================

Il y a trois concepts clés dans ``Zend_Cache``. Le premier est l'identifiant unique (une chaîne) qui est utilisé
pour identifier les enregistrements de cache. Le second est la directive **"lifeTime"** vue dans les exemples ;
elle définit combien de temps la ressource de cache est considérée comme à jour. Le troisième est l'exécution
conditionnelle, ainsi chaque partie de votre code peut être évitée entièrement, pour améliorer methodname
performances. La fonction principale du frontend (``Zend\Cache\Core::get()``) est toujours faite pour retourner
``FALSE`` en cas de cache manquant, si cela donne du sens à la nature d'un frontend. Cela permet aux utilisateurs
d'entourer des parties de code qu'ils veulent mettre en cache (et éviter) dans une instruction **if(){ ... }** où
la condition est une méthode ``Zend_Cache``. A la fin de ces blocs, vous devez sauvegarder ce que vous avez
généré (par exemple ``Zend\Cache\Core::save()``).

.. note::

   Le design de l'exécution conditionnelle de votre code généré n'est pas forcément dans des frontends
   (**Function**, par exemple) quand toute la logique est implémentée à l'intérieur du frontend.

.. note::

   Le "Cache hit" est un terme pour une condition quand l'enregistrement de cache est trouvé, valide, et à jour
   (en d'autres mots, qu'il n'a pas encore expiré). Le "Cache miss" est tout le reste. Lorsque un "Cache miss"
   survient, vous devez générer vos données (comme vous le feriez normalement) et les mettre en cache. Lorsque
   vous avez un "Cache hit", le backend récupère pour vous et de façon transparente, les enregistrements.

.. _zend.cache.factory:

La méthode de fabrique de Zend_Cache
------------------------------------

Une bonne manière de construire une instance utilisable d'un frontend ``Zend_Cache`` est donnée dans l'exemple
suivant :

.. code-block:: php
   :linenos:

   // Nous choisissons un backend (par exemple 'File' ou 'Sqlite')
   $backendName = '[...]';

   // Nous choisissons un frontend (par exemple: 'Core', 'Output',
   // 'Page'...)
   $frontendName = '[...]';

   // Nous définissons un tableau d'options pour le frontend choisit
   $frontendOptions = array([...]);

   // Nous définissons un tableau d'options pour le backend choisit
   $backendOptions = array([...]);

   // Nous créons la bonne instance
   // Bien sur, les deux derniers arguments sont optionnels
   $cache = Zend\Cache\Cache::factory($frontendName,
                                $backendName,
                                $frontendOptions,
                                $backendOptions);

Dans les exemples suivants, nous nous assurerons que la variable ``$cache`` utilise une instance de frontend
valide, et que vous comprenez comment passer des paramètres à vos backends.

.. note::

   Utilisez toujours ``Zend\Cache\Cache::factory()`` pour obtenir des instances de frontend. Instancier des frontends et
   des backends par vous-même ne fonctionnera pas comme prévu.

.. _zend.cache.tags:

Baliser les enregistrements
---------------------------

Les balises sont un moyen de catégoriser les enregistrements de cache. Quand vous sauvegardez un cache avec la
méthode ``save()`` vous pouvez définir un tableau de balises qui s'appliqueront à cet enregistrement. Ensuite
vous serez en mesure de nettoyer tous les enregistrements de cache identifiés par une balise (ou plusieurs)
donnée :

.. code-block:: php
   :linenos:

   $cache->save($grande_donnees,
                'monIDUnique',
                array('tagA', 'tagB', 'tagC'));

.. note::

   Notez que la méthode ``save()`` accepte un quatrième paramètre optionnel : ``$specificLifetime`` (si
   différent de ``FALSE``, il affecte un "lifeTime" spécifique pour cet enregistrement de cache particulier).

.. _zend.cache.clean:

Nettoyer le cache
-----------------

Pour supprimer / invalider un identifiant de cache particulier, vous pouvez utiliser la méthode ``remove()``\
 :

.. code-block:: php
   :linenos:

   $cache->remove('idAEffacer');

Pour effacer / invalider plusieurs identifiants de caches en une seule opération, vous pouvez utiliser la
méthode ``clean()``. Par exemple, pour supprimer tous les caches :

.. code-block:: php
   :linenos:

   // nettoie tous les enregistrements
   $cache->clean(Zend\Cache\Cache::CLEANING_MODE_ALL);

   // nettoie uniquement les caches obsolètes
   $cache->clean(Zend\Cache\Cache::CLEANING_MODE_OLD);

Si vous voulez effacer les caches correspondant aux balises "tagA" et "tagC" :

.. code-block:: php
   :linenos:

   $cache->clean(Zend\Cache\Cache::CLEANING_MODE_MATCHING_TAG,
                 array('tagA', 'tagC'));

Si vous voulez effacer les caches ne correspondant pas aux balises "tagA" et "tagC" :

.. code-block:: php
   :linenos:

   $cache->clean(Zend\Cache\Cache::CLEANING_MODE_NOT_MATCHING_TAG,
                 array('tagA', 'tagC'));

Si vous voulez effacer les caches correspondant aux balises "tagA" ou "tagC" :

.. code-block:: php
   :linenos:

   $cache->clean(Zend\Cache\Cache::CLEANING_MODE_MATCHING_ANY_TAG,
                 array('tagA', 'tagC'));

Les modes disponibles de nettoyage sont ``CLEANING_MODE_ALL``, ``CLEANING_MODE_OLD``,
``CLEANING_MODE_MATCHING_TAG``, ``CLEANING_MODE_NOT_MATCHING_TAG`` et ``CLEANING_MODE_MATCHING_ANY_TAG``. Les
derniers, comme leur nom l'indique, sont à combiner avec un tableau de balises pour réaliser les opérations de
nettoyage.


