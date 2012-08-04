.. _zend.validate.set.isbn:

Isbn
====

``Zend_Validate_Isbn`` permet de valider des valeurs *ISBN-10* ou *ISBN-13*.

.. _zend.validate.set.isbn.options:

Options supportées par Zend_Validate_Isbn
-----------------------------------------

Les options suivantes sont supportées par ``Zend_Validate_Isbn``\  :

- **separator**\  : définit le séparateur autorisé pour la valeur *ISBN*. Par défaut, il s'agit d'une chaîne
  vide.

- **type**\  : définit le type des valeurs *ISBN* autorisées. Par défaut, il s'agit de
  ``Zend_Validate_Isbn::AUTO``. Pour plus de détails reportez vous à :ref:`cette section
  <zend.validate.set.isbn.type-explicit>`.

.. _zend.validate.set.isbn.basic:

Utilisation classique
---------------------

Voici un exemple banal :

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Isbn();
   if ($validator->isValid($isbn)) {
       // isbn valide
   } else {
       // isbn non valide
   }

Ceci valide tout *ISBN-10* et *ISBN-13* sans séparateur.

.. _zend.validate.set.isbn.type-explicit:

Configurer un type de validation ISBN explicite
-----------------------------------------------

Voici comment effectuer une restriction de type de l'*ISBN*\  :

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Isbn();
   $validator->setType(Zend_Validate_Isbn::ISBN13);
   // OU
   $validator = new Zend_Validate_Isbn(array(
       'type' => Zend_Validate_Isbn::ISBN13,
   ));

   if ($validator->isValid($isbn)) {
       // ISBN-13 valide
   } else {
       // ISBN-13 invalide
   }

Seules les valeurs de *ISBN-13* sont validées ci-dessus.

Les types valides sont :

- ``Zend_Validate_Isbn::AUTO`` (défaut)

- ``Zend_Validate_Isbn::ISBN10``

- ``Zend_Validate_Isbn::ISBN13``

.. _zend.validate.set.isbn.separator:

Spécifier une restriction de séparateur
---------------------------------------

Voici un exemple de restriction de séparateur :

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Isbn();
   $validator->setSeparator('-');
   // OU
   $validator = new Zend_Validate_Isbn(array(
       'separator' => '-',
   ));

   if ($validator->isValid($isbn)) {
       // ISBN valide avec séparateur
   } else {
       // ISBN invalide avec séparateur
   }

.. note::

   **Valeurs sans séparateur**

   La valeur ``FALSE`` est retournée si ``$isbn`` ne contient pas de séparateur **ou** si le séparateur n'est
   pas valide.

Séparateurs valides :

- "" (vide) (défaut)

- "-" (tiret)

- " " (espace)


