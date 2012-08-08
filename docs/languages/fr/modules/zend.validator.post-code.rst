.. EN-Revision: none
.. _zend.validator.set.post_code:

PostCode
========

``Zend_Validate_PostCode`` vous permet de déterminer si une valeur donnée est un code postal valide. Les codes
postaux siont spécifiques aux villes et dans quelques cas spéciaux sont nommés des codes *ZIP*.

``Zend_Validate_PostCode`` reconnait plus de 160 différents formats de codes postaux. Pour sélectionner le format
correct, il existe deux manières. Vous pouvez soit utiliser une locale complète, soit paramétrer votre propre
format manuellement.

Utiliser la locale est la méthode la plus commode puisque Zend Framework connait les formats des codes postaux
assoicés à chaque locale  cependant, vous devez utiliser une locale complète (c'est-à-dire contenant aussi le
spécificateur de région) dans ce cas. Par exemple, la locale "fr" est une bien une locale mais ne peut pas être
utilisée avec ``Zend_Validate_PostCode`` puisqu'elle ne contient pas la région ; "fr_FR" sera, cependant, une
locale valide puisqu'elle spécifie une région ("FR", pour France).

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_PostCode('fr_FR');

Quand vous ne paramétrez pas de locale vous-même, alors ``Zend_Validate_PostCode`` utilisera la locale de
l'application, ou, s'il n'y en a pas, la locale retournée par ``Zend_Locale``.

.. code-block:: php
   :linenos:

   // locale de l'application définie dans le bootstrap
   $locale = new Zend_Locale('fr_FR');
   Zend_Registry::set('Zend_Locale', $locale);
   $validator = new Zend_Validate_PostCode();

Vous pouvez changer la locale plus tard en appelant ``setLocale()``. Et bien sûr vous pouvez récupérer la locale
courante avec ``getLocale()``.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_PostCode('fr_FR');
   $validator->setLocale('en_GB');

Les formats de codes postaux sont simplement des chaînes d'expressions régulières. Quand le format de code
postal international, qui est utilisé en paramétrant la locale, ne correspond pas à vos besoins, alors vous
pouvez alors paramétrer manuellement un format en appelant ``setFormat()``.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_PostCode('fr_FR');
   $validator->setFormat('FR-\d{5}');

.. note::

   **Conventions pour les formats personnalisés**

   Lors de l'utilisation de formats personnalisés, vous devez omettre les balises de début (``'/^'``) et de fin
   (``'$/'``). Elles sont ajoutés automatiquement.

   Vous devez faire attention au fait que les valeurs de code postal sont toujours validées de manière stricte.
   Ce qui veut dire qu'ils doivent être écrits seuls sans caractère additionnel qui ne serait pas couvert par le
   format.

.. _zend.validator.set.post_code.constructor:

Options du constructeur
-----------------------

Le plus basiquement possible, vous fournissez soit un objet ``Zend_Locale``, soit une chaîne représentant une
locale complète au constructeur de ``Zend_Validate_PostCode``.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_PostCode('fr_FR');
   $validator = new Zend_Validate_PostCode($locale);

De plus, vous pouve zfournir un tableau ou un objet ``Zend_Config`` au constructeur. Quand vous faîtes ceci, vous
devez inclure soit la clé "locale" ou "format" ;celles-ci seront utilisées pour paramétrer les valeurs
appropriées dans l'objet validateur.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_PostCode(array(
       'locale' => 'fr_FR',
       'format' => 'FR-\d+'
   ));

.. _zend.validator.set.post_code.options:

Options supportées par Zend_Validate_PostCode
---------------------------------------------

Les options suivantes sont supportées par ``Zend_Validate_PostCode``\  :

- **format**\  : spécifie le format de code postal qui sera utilisé pour la validation.

- **locale**\  : spécifie la locale à partir de laquelle le code postal sera récupéré.


