.. EN-Revision: none
.. _zend.validator.set.float:

Float
=====

``Zend\Validate\Float`` permet de valider si une donnée contient une valeur flottante. Les entrées localisées
sont supportées.

.. _zend.i18n.validator.float.options:

Options supportées par Zend\Validate\Float
------------------------------------------

Les options suivantes sont supportées par ``Zend\Validate\Float``:

- **locale**: Affecte la locale utilisée lors de la validation.

.. _zend.validator.set.float.basic:

Validation float simple
-----------------------

Au plus simple, vous utiliserez les paramètres systèmes, c'est à dire la locale correspondant à
l'environnement:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\Float();

   $validator->isValid(1234.5);   // retourne true
   $validator->isValid('10a01'); // retourne false
   $validator->isValid('1,234.5'); // retourne true

Dans l'exemple ci-dessus, nous supposons un environnement à locale "en".

.. _zend.validator.set.float.localized:

Validation float localisée
--------------------------

Il peut être parfois nécessaire de prendre en compte la locale pour valider une valeur flottante. Les flottants
sont souvent écrits de manière différente en fonction de la locale/région. Par exemple en anglais on écrirait
"1.5", mais en allemand "1,5" et dans d'autres langues le regroupement de chiffres pourrait être utilisé.

``Zend\Validate\Float`` peut valider de telles notations. Il est alors limité à la locale utilisée. Voyez les
exemples ci-après:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\Float(array('locale' => 'de'));

   $validator->isValid(1234.5); // retourne true
   $validator->isValid("1 234,5"); // retourne false
   $validator->isValid("1.234"); // retourne true

Comme vous le voyez, en utilisant une locale, l'entrée est validée en fonction de celle-ci. Avec une locale
différente vous auriez obtenu des résultats éventuellement différents.

La locale peut être affectée/récupérée après la création de l'objet de validation au moyen des méthodes
``setLocale()`` et ``getLocale()``.


