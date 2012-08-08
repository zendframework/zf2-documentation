.. EN-Revision: none
.. _zend.validator.set.in_array:

InArray
=======

``Zend_Validate_InArray`` vous permet de valider qu'une entrée est bien présente dans un tableau. Ceci fonctionne
aussi avec des tableaux multidimensionnels.

.. _zend.validator.set.in_array.options:

Options supportées par Zend_Validate_InArray
--------------------------------------------

Les options suivantes sont supportées par ``Zend_Validate_InArray``\  :

- **haystack**\  : spécifie le tableau pour la validation.

- **recursive**\  : définit si la validation doit être recursive. Cette option vaut ``FALSE`` par défaut.

- **strict**\  : définit si la validation doit être strict (même type). Cette option vaut ``FALSE`` par
  défaut.

.. _zend.validator.set.in_array.basic:

Validation tableau simple
-------------------------

Passez simplement un tableau dans lequel rechercher une valeur:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_InArray(array('key' => 'value',
                                                'otherkey' => 'othervalue'));
   if ($validator->isValid('value')) {
       // value trouvée
   } else {
       // value non trouvée
   }

C'est le comportement exact de la fonction PHP ``in_array()``.

.. note::

   Par défaut la validation est non stricte et ne valide pas les multiples dimensions.

Bien sûr vous pouvez fournir le tableau à valider plus tard en utilisant la méthode ``setHaystack()``. La
méthode ``getHaystack()`` retourne le tableau actuellement fourni.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_InArray();
   $validator->setHaystack(array('key' => 'value', 'otherkey' => 'othervalue'));

   if ($validator->isValid('value')) {
       // valeur trouvée
   } else {
       // valeur non trouvée
   }

.. _zend.validator.set.in_array.strict:

Validation tableau stricte
--------------------------

Il est possible d'effectuer une validation stricte des données dans le tableau. Par défaut, il n'y aura aucune
différence entre l'entier **0** et la chaine **"0"**. La validation stricte fera cette différence.

Pour spécifier une validation stricte à l'instanciation de l'objet, agissez comme suit :

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_InArray(
       array(
           'haystack' => array('key' => 'value', 'otherkey' => 'othervalue'),
           'strict'   => true
       )
   );

   if ($validator->isValid('value')) {
       // valeur trouvée
   } else {
       // valeur non trouvée
   }

La clé **haystack** contient le tableau dans lequel valider. En mettant la clé **strict** à ``TRUE``, la
validation sera stricte (valeur et type).

Bien sûr vous pouvez la méthode ``setStrict()`` pour changer ce réglage et la méthode ``getStrict()`` vous
retournera le réglage en cours.

.. note::

   Notez que par défaut, **strict** a la valeur ``FALSE``.

.. _zend.validator.set.in_array.recursive:

Validation de tableaux récursifs
--------------------------------

En plus de la validation type *PHP* ``in_array()``, ce validateur peut aussi être utilisé pour valider des
tableaux à plusieurs dimensions.

Pour cela, utilisez l'option **recursive**.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_InArray(
       array(
           'haystack' => array(
               'firstDimension' => array('key' => 'value',
                                         'otherkey' => 'othervalue'),
               'secondDimension' => array('some' => 'real',
                                          'different' => 'key')),
           'recursive' => true
       )
   );

   if ($validator->isValid('value')) {
       // value trouvée
   } else {
       // value non trouvée
   }

Votre tableau sera parcouru récursivement à la recherche de votre valeur. De plus vous pouvez utiliser la
méthode ``setRecursive()`` pour paramétrer cette option plus tard et la méthode ``getRecursive()`` pour la
retrouver.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_InArray(
       array(
           'firstDimension' => array('key' => 'value',
                                     'otherkey' => 'othervalue'),
           'secondDimension' => array('some' => 'real',
                                      'different' => 'key')
       )
   );
   $validator->setRecursive(true);

   if ($validator->isValid('value')) {
       // valeur trouvée
   } else {
       // valeur non trouvée
   }

.. note::

   **Réglage par défaut pour la récursivité**

   Par défaut, la récursivité n'est pas activée.

.. note::

   **Options pour la "haystack"**

   Lorsque vous utilisez les clés ``haystack``, ``strict`` ou ``recursive`` à l'intérieur de votre pile, vous
   devez alors envelopper la clé ``haystack``.


