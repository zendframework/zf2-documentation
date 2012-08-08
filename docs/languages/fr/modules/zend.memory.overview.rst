.. EN-Revision: none
.. _zend.memory.overview:

Présentation
============

.. _zend.memory.introduction:

Introduction
------------

Le composant ``Zend_Memory`` est destiné à gérer des données dans un environnement où la mémoire est
limitée.

Les objets mémoire (conteneurs de mémoire) sont produits par le manager de mémoire sur demande et mis en
cache/chargés d'une manière transparente quand c'est nécessaire.

Par exemple, si la création ou le chargement d'un objet entraîne une utilisation de mémoire totale excédant la
limite que vous spécifiez, certains objets gérés sont copiés en cache à l'extérieur de la mémoire. De cette
façon, la mémoire totale utilisée par les objets gérés n'excède pas la limite que vous devez mettre en
application.

Le manager de mémoire utilise les :ref:`backends Zend_Cache <zend.cache.backends>` comme fournisseurs de stockage.

.. _zend.memory.introduction.example-1:

.. rubric:: Utiliser le composant Zend_Memory

``Zend_Memory::factory()`` instancie l'objet de management de la mémoire avec les options spécifiques du backend.

.. code-block:: php
   :linenos:

   $backendOptions = array(
       'cache_dir' => './tmp/'
       // Dossier où les blocks de mémoire peuvent être stockés
   );

   $memoryManager = Zend_Memory::factory('File', $backendOptions);

   $loadedFiles = array();

   for ($count = 0; $count < 10000; $count++) {
       $f = fopen($fileNames[$count], 'rb');
       $data = fread($f, filesize($fileNames[$count]));
       $fclose($f);

       $loadedFiles[] = $memoryManager->create($data);
   }

   echo $loadedFiles[$index1]->value;

   $loadedFiles[$index2]->value = $newValue;

   $loadedFiles[$index3]->value[$charIndex] = '_';

.. _zend.memory.theory-of-operation:

Aspect théorique
----------------

``Zend_Memory`` travaille avec les concepts suivants :

   - Manager de mémoire

   - Conteneur de mémoire

   - Objet de mémoire verrouillé

   - Objet de mémoire mobile



.. _zend.memory.theory-of-operation.manager:

Manager de mémoire
^^^^^^^^^^^^^^^^^^

Le manager de mémoire produit des objets de mémoire (verrouillé ou mobile) sur demande de l'utilisateur et les
retourne encapsulé dans un objet conteneur de mémoire.

.. _zend.memory.theory-of-operation.container:

Conteneur de mémoire
^^^^^^^^^^^^^^^^^^^^

Le conteneur de mémoire a un attribut *value* virtuel ou réel de type chaîne de caractères. Cet attribut
contient la valeur de donnée indiquée au moment de la création de l'objet mémoire.

Vous pouvez exploiter cet attribut *value* comme une propriété d'objet :

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);

      echo $memObject->value;

      $memObject->value = $newValue;

      $memObject->value[$index] = '_';

      echo ord($memObject->value[$index1]);

      $memObject->value = substr($memObject->value, $start, $length);



.. note::

   Si vous utilisez une version de *PHP* inférieure à 5.2, utilisez la méthode :ref:`getRef()
   <zend.memory.memory-objects.api.getRef>` au lieu d'accéder directement à la valeur de la propriété.

.. _zend.memory.theory-of-operation.locked:

Objet de mémoire verrouillé
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les objets de mémoire verrouillés sont toujours stockés dans la mémoire. Les données stockées dans la
mémoire verrouillée ne sont jamais mis en cache.

.. _zend.memory.theory-of-operation.movable:

Objet de mémoire mobile
^^^^^^^^^^^^^^^^^^^^^^^

Les objets de mémoire mobiles sont mis en cache et chargés de manière transparente de/vers le cache par
``Zend_Memory`` si c'est nécessaire.

Le manager de mémoire ne met pas en cache des objets ayant une taille plus petite que le minimum spécifié dans
un soucis de performances. Voir :ref:` <zend.memory.memory-manager.settings.min-size>` pour plus de détails.


