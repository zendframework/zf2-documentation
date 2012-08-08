.. EN-Revision: none
.. _zend.validator.set.int:

Int
===

``Zend_Validate_Int`` valide une valeur envers un entier. Les entiers localisés sont aussi gérés.

.. _zend.validator.set.int.options:

Options supportées par Zend_Validate_Int
----------------------------------------

Les options suivantes sont supportées par ``Zend_Validate_Int``:

- **locale**: Affecte la locale à utiliser lors de la validation.

.. _zend.validator.set.int.basic:

Validation simple d'entiers
---------------------------

La manière la plus simple de valider un entier est d'utiliser les paramètres systèmes. Lorsqu'aucune option
n'est passée, la locale de l'environnement sera utilisée:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Int();

   $validator->isValid(1234);   // retourne true
   $validator->isValid(1234.5); // retourne false
   $validator->isValid('1,234'); // retourne true

Dans l'exemple ci-dessus l'environnement est supposé réglé sur la locale "en". Comme vous le voyez, le
regroupement de chiffres est supporté (troisième exemple).

.. _zend.validator.set.int.localized:

Validation d'entiers localisés
------------------------------

Il est parfois nécessaire de valider des entiers localisés. Les entiers sont souvent écrits de manière
différente en fonction des pays/régions. Par exemple en anglais vous pouvez écrire "1234" ou "1,234", ce sont
tous les deux des entiers mais le regroupement des chiffres est optionnel. En allemand, vous écririez "1.234" et
en français "1 234".

``Zend_Validate_Int`` peut valider de telles notations. Il est limité à la locale utilisée et valide le
séparateur utilisé en fonction de la locale. Voyez le code ci-après:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Int(array('locale' => 'de'));

   $validator->isValid(1234); // retourne true
   $validator->isValid("1,234"); // retourne false
   $validator->isValid("1.234"); // retourne true

Comme vous le voyez, avec une locale, l'entrée est validée en fonction de la locale. En utilisant l'anglais, vous
récupérez ``FALSE`` lorsque la locale force une notation différente.

La locale peut être affectée/récupérée après la création du validateur au moyen des méthodes
``setLocale()`` et ``getLocale()``.


