.. _zend.memory.memory-manager:

Manager de mémoire
==================

.. _zend.memory.memory-manager.creation:

Créer un manager de mémoire
---------------------------

Vous pouvez créer un nouveau manager de mémoire (objet ``Zend_Memory_Manager``) en utilisant la méthode
``Zend_Memory::factory($backendName [, $backendOprions])``.

Le premier argument ``$backendName`` est le nom d'un type de backend supporté par ``Zend_Cache``

Le second argument ``$backendOptions`` est un tableau optionnel indiquant les options du backend.

.. code-block:: php
   :linenos:

   $backendOptions = array(
       'cache_dir' => './tmp/'
       // Dossier où les blocks de mémoire peuvent être stockés
   );

   $memoryManager = Zend_Memory::factory('File', $backendOptions);

Zend_Memory utilise les :ref:`backends Zend_Cache <zend.cache.backends>` comme fournisseurs de stockage.

Vous pouvez de plus utiliser le nom spécial '*None*' en tant que nom de backend supplémentaire de Zend_Cache.

   .. code-block:: php
      :linenos:

      $memoryManager = Zend_Memory::factory('None');



Si vous utilisez "*None*", alors le manager de mémoire ne mettra pas en cache les blocks de mémoire. Ceci est
intéressant si vous savez que la mémoire n'est pas limitée ou la taille complète des objets n'atteint jamais la
limite de mémoire.

Le backend "*None*" ne nécessite aucune option.

.. _zend.memory.memory-manager.objects-management:

Manager les objets mémoire
--------------------------

Cette section décrit la création et la destruction d'objet de mémoire, et les réglages du manager de mémoire.

.. _zend.memory.memory-manager.objects-management.movable:

Créer des objets mobiles
^^^^^^^^^^^^^^^^^^^^^^^^

Créer des objets mobiles (objets qui peuvent être mis en cache) en utilisant la méthode
``Zend_Memory_Manager::create([$data])``:

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);



L'argument ``$data`` est optionnel et utilisé pour initialiser la valeur de l'objet. Si l'argument ``$data`` est
omis, la valeur est une chaîne vide.

.. _zend.memory.memory-manager.objects-management.locked:

Créer des objets verrouillés
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Créer des objets verrouillés (objets qui ne doivent pas être mis en cache) en utilisant la méthode
``Zend_Memory_Manager::createLocked([$data])``:

   .. code-block::
      :linenos:

      $memObject = $memoryManager->createLocked($data);



L'argument ``$data`` est optionnel et utilisé pour initialiser la valeur de l'objet. Si l'argument ``$data`` est
omis, la valeur est une chaîne vide.

.. _zend.memory.memory-manager.objects-management.destruction:

Détruire des objets
^^^^^^^^^^^^^^^^^^^

Les objets mémoire sont automatiquement détruits et effacés de la mémoire quand ils sont hors de portée :

   .. code-block:: php
      :linenos:

      function foo()
      {
          global $memoryManager, $memList;

          ...

          $memObject1 = $memoryManager->create($data1);
          $memObject2 = $memoryManager->create($data2);
          $memObject3 = $memoryManager->create($data3);

          ...

          $memList[] = $memObject3;

          ...

          unset($memObject2); // $memObject2 est détruit ici

          ...
          // $memObject1 est détruit ici
          // mais $memObject3 est toujours référencé par $memList
          // et n'est pas détruit
      }



Ceci s'applique aux objets mobiles et verrouillés.

.. _zend.memory.memory-manager.settings:

Régler le manager de mémoire
----------------------------

.. _zend.memory.memory-manager.settings.memory-limit:

Mémoire limite
^^^^^^^^^^^^^^

La mémoire limite est le nombre d'octets autorisés à être utilisés par des objets mobiles chargés.

Si le chargement ou la création d'un objet entraîne l'utilisation de mémoire excédant cette limite, alors le
manager met en cache un certain nombre d'objet.

Vous pouvez récupérer et régler la mémoire limite en utilisant les méthodes ``getMemoryLimit()`` et
``setMemoryLimit($newLimit)``:

   .. code-block:: php
      :linenos:

      $oldLimit = $memoryManager->getMemoryLimit();
      // Récupére la mémoire limite en octets
      $memoryManager->setMemoryLimit($newLimit);
      // Règle la mémoire limite en octets



Une valeur négative pour limite de mémoire équivaut à "pas de limite".

La valeur par défaut est deux-tiers de la valeur de "*memory_limit*" dans le php.ini ou "no limit" (-1) si
"*memory_limit*" n'est pas réglé dans le php.ini.

.. _zend.memory.memory-manager.settings.min-size:

MinSize (taille minimum)
^^^^^^^^^^^^^^^^^^^^^^^^

*MinSize* est la taille minimale des objets de mémoire, qui peuvent être mis en cache par le manager de mémoire.
Le manager ne met pas en cache des objets plus petits que cette valeur. Ceci réduit le nombre d'opérations de
mise de cache/chargement

Vous pouvez récupérer et régler la taille minimale en utilisant les méthodes ``getMinSize()`` et
``setMinSize($newSize)``:

   .. code-block::
      :linenos:

      $oldMinSize = $memoryManager->getMinSize();
      // Récupère la taille minimale en octets
      $memoryManager->setMinSize($newSize);
      // Règle la taille minimale en octets



La taille minimum par défaut est 16KB (16384 octets).


