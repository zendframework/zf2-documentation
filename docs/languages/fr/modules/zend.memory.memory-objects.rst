.. EN-Revision: none
.. _zend.memory.memory-objects:

Objet mémoire
=============

.. _zend.memory.memory-objects.movable:

Mobile
------

Créer des objets mémoires mobiles en utilisant la méthode ``create([$data])`` du manager de mémoire :

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);



"Mobile" signifie que de tels objets peuvent être mis en cache et déchargés de la mémoire et chargés ensuite
quand le code de l'application accède à l'objet.

.. _zend.memory.memory-objects.locked:

Verrouillé
----------

Créer des objets mémoires verrouillés en utilisant la méthode ``createLocked([$data])`` du manager de mémoire
:

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->createLocked($data);



"Verrouillé" signifie que de tels objets ne sont jamais mis en cache et déchargés de la mémoire.

Les objets verrouillés fournissent la même interface que des objets mobiles
(``Zend\Memory_Container\Interface``). Donc l'objet verrouillé peut être utilisé en n'importe quel endroit à la
place des objets mobiles.

Il est utile si une application ou un développeur peut décider, que quelques objets ne devraient jamais être mis
en cache, en se basant sur des considérations de performance.

L'accès aux objets verrouillés est plus rapide, parce que le manager de mémoire ne doit pas suivre à la trace
des changements pour ces objets.

La classe d'objets verrouillés (``Zend\Memory_Container\Locked``) garantit pratiquement la même performance qu'en
travaillant avec une variable de type chaîne de caractères. La couche supérieure est un simple référence pour
récupérer la propriété de classe.

.. _zend.memory.memory-objects.value:

Propriété "value" du manager de mémoire
---------------------------------------

Utilisez la propriété "*value*" du conteneur de mémoire (mobile ou verrouillé) pour travailler avec les
données des objets mémoire :

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);

      echo $memObject->value;

      $memObject->value = $newValue;

      $memObject->value[$index] = '_';

      echo ord($memObject->value[$index1]);

      $memObject->value = substr($memObject->value, $start, $length);



Une autre manière d'accéder aux données d'objet mémoire est d'utiliser la méthode :ref:`getRef()
<zend.memory.memory-objects.api.getRef>`. Cette méthode **doit** être utilisée pour les versions de *PHP*
inférieure à 5.2. Il devrait aussi être utilisé dans quelques autres cas pour des raisons de performance.

.. _zend.memory.memory-objects.api:

Interface du conteneur de mémoire
---------------------------------

Le conteneur de mémoire fournit les méthodes suivantes :

.. _zend.memory.memory-objects.api.getRef:

La méthode getRef()
^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function &getRef();

La méthode ``getRef()`` retourne la référence vers une valeur d'objet.

Des objets mobiles sont chargés du cache à ce moment si l'objet n'est pas déjà dans la mémoire. Si l'objet est
chargé du cache, cela pourrait entraîner la mise en cache d'autres objets si la limite de mémoire était
dépassée en ayant tous les objets en mémoire.

La méthode ``getRef()`` **doit** être utilisée pour accéder aux données d'objet mémoire si la version de
*PHP* est inférieure à 5.2

Suivre à la trace les changements de ces données nécessitent des ressources supplémentaires. La méthode
``getRef()`` retourne une référence à une chaîne, qui est changé directement par l'utilisateur de
l'application. Ainsi, c'est une bonne idée d'utiliser la méthode ``getRef()`` pour le traitement des données :

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);

      $value = &$memObject->getRef();

      for ($count = 0; $count < strlen($value); $count++) {
          $char = $value[$count];
          ...
      }



.. _zend.memory.memory-objects.api.touch:

La méthode touch()
^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function touch();

La méthode ``touch()`` devrait être employée en commun avec ``getRef()``. Elle signale que la valeur d'objet a
été changé :

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);
      ...

      $value = &$memObject->getRef();

      for ($count = 0; $count < strlen($value); $count++) {
          ...
          if ($condition) {
              $value[$count] = $char;
          }
          ...
      }

      $memObject->touch();



.. _zend.memory.memory-objects.api.lock:

La méthode lock()
^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function lock();

La méthode ``lock()`` verrouille l'objet en mémoire. Elle devrait être utilisé pour empêcher la mise en cache
des objets que vous choisissez. Normalement, ce n'est pas nécessaire, parce que le manager de mémoire utilise un
algorithme intelligent pour choisir des candidats à la mise en cache. Mais si vous savez exactement, qu'à cette
endroit du code certains objets ne devraient pas être mis en cache, vous pouvez les verrouiller.

Le verrouillage d'objets dans la mémoire garantit aussi que la référence retournée par la méthode ``getRef()``
est valable jusqu'à ce que vous déverrouiller l'objet :

   .. code-block:: php
      :linenos:

      $memObject1 = $memoryManager->create($data1);
      $memObject2 = $memoryManager->create($data2);
      ...

      $memObject1->lock();
      $memObject2->lock();

      $value1 = &$memObject1->getRef();
      $value2 = &$memObject2->getRef();

      for ($count = 0; $count < strlen($value2); $count++) {
          $value1 .= $value2[$count];
      }

      $memObject1->touch();
      $memObject1->unlock();
      $memObject2->unlock();



.. _zend.memory.memory-objects.api.unlock:

La méthode unlock()
^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function unlock();

La méthode ``unlock()`` déverrouille l'objet quand il n'est plus nécessaire de maintenir verrouillé. Voir
l'exemple ci-dessus.

.. _zend.memory.memory-objects.api.isLocked:

La méthode isLocked()
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function isLocked();

La méthode ``isLocked()`` peut être utilisée pour vérifier si l'objet est verrouillé. Il retourne ``TRUE`` si
l'objet est verrouillé, ou ``FALSE`` s'il n'est pas verrouillé. C'est toujours ``TRUE`` pour les objets
"verrouillés" et peut être ``TRUE`` ou ``FALSE`` pour des objets "mobiles".


