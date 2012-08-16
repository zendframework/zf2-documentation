.. EN-Revision: none
.. _zend.validator.set.date:

Date
====

``Zend_Validate_Date`` permet de valider qu'une donnée est bien une date. Le validateur gère la localisation.

.. _zend.validator.set.date.options:

Options supportées par Zend_Validate_Date
-----------------------------------------

Les options suivantes sont supportées par ``Zend_Validate_Date``:

- **format**: affecte le format utilisé pour écrire la date.

- **locale**: affecte la locale utilisée lors de la validation.

.. _zend.validator.set.date.basic:

Validation de dates par défaut
------------------------------

La manière la plus simple de valider une date est d'utiliser le format par défaut du système. Ce format est
utilisé lorsqu'aucune locale et aucun format particulier n'est précisé. Voyez l'exemple ci-après:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Date();

   $validator->isValid('2000-10-10');   // retourne true
   $validator->isValid('10.10.2000'); // retourne false

Le format par défaut de ``Zend_Validate_Date`` est 'yyyy-MM-dd'.

.. _zend.validator.set.date.localized:

Validation de dates localisées
------------------------------

``Zend_Validate_Date`` peut aussi valider les dates dans un format localisé donné. En utilisant l'option
``locale`` vous pouvez définir la locale utilisée pour valider le format de la date.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Date(array('locale' => 'de'));

   $validator->isValid('10.Feb.2010'); // retourne true
   $validator->isValid('10.May.2010'); // retourne false

L'option ``locale`` affecte le format par défaut de la date. Dans l'exemple ci-dessus il s'agit de 'dd.MM.yyyy'
qui est le format pour une locale 'de'.

.. _zend.validator.set.date.formats:

Formats de dates personnalisés
------------------------------

``Zend_Validate_Date`` supporte des formats de date personnalisés. Utilisez l'option ``format`` pour cela.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Date(array('format' => 'yyyy'));

   $validator->isValid('2010'); // retourne true
   $validator->isValid('May');  // retourne false

Vous pouvez combiner ``format`` et ``locale``. Dans ce cas vous pouvez utiliser des noms de mois ou de jours
localisés.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Date(array('format' => 'yyyy MMMM', 'locale' => 'de'));

   $validator->isValid('2010 Dezember'); // retourne true
   $validator->isValid('2010 June');     // retourne false


