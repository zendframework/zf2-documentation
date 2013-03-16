.. EN-Revision: none
.. _zend.validator.set.identical:

Identical
=========

``Zend\Validate\Identical`` vous permet de valider si une valeur donnée est identique à une valeur préalablement
fournie.

.. _zend.validator.set.identical.options:

Options supportées par Zend\Validate\Identical
----------------------------------------------

Les options suivantes sont supportées par ``Zend\Validate\Identical``\  :

- **token**\  : spécifie la valeur qui servira à la validation de l'entrée.

.. _zend.validator.set.identical.basic:

Utilisation de base
-------------------

Pour valider si deux valeurs sont identiques, vous devez d'abord fournir la valeur d'origine. L'exemple montre la
validation de deux chaînes :

.. code-block:: php
   :linenos:

   $valid = new Zend\Validate\Identical('origin');
   if ($valid->isValid($value) {
       return true;
   }

La validation retournera ``TRUE`` seulement si les deux valeurs sont rigoureusement identiques. Dans notre exemple,
quand ``$value`` vaudra "origin".

Vous pouvez aussi fournir la valeur souhaitée plus tard en utilisant la méthode ``setToken()`` et ``getToken()``
pour récupérer la valeur actuellement paramétrée.

.. _zend.validator.set.identical.types:

Objets identiques
-----------------

Bien sûr ``Zend\Validate\Identical`` ne se limite pas à la validation de chaînes, mais aussi tout type de
variable comme un booléen, un entier, un flottant, un tableau et même les objets. Comme énoncé ci-dessus, les
valeurs fournies et à valider doivent être identiques.

.. code-block:: php
   :linenos:

   $valid = new Zend\Validate\Identical(123);
   if ($valid->isValid($input)) {
       // l'entrée est valide
   } else {
       // l'entrée est incorrecte
   }

.. note::

   **Comparaison de type**

   Il est important de noter que le type de la variable sert aussi lors de la validation. Ceci veut dire que la
   chaîne **"3"** n'est pas identique à l'entier **3**.

   Ceci est aussi valable pour les éléments de formulaires. Ce sont des objets ou des tableaux. Donc vous ne
   pouvez pas simplement comparer un champs texte qui contient un mot de passe avec une valeur textuelle provenant
   d'une autre source. L'élément de formualire lui-même est fourni en tant que tableau qui peut aussi contenir
   des informations additionnelles.

.. _zend.validator.set.identical.configuration:

Configuration
-------------

Comme tous les autres validateurs ``Zend\Validate\Identical`` supporte aussi des paramètres de configuration en
tant que paramètre d'entrée. Ceci veut dire que vous pouvez configurer ce validateur avec une objet
``Zend_Config``.

Mais ceci entraîne un changement dont vous devez tenir compte. Quand vous utilisez un tableau en tant qu'entrée
du constructeur, vous devez envelopper la valeur d'origine avec la clé ``token``, dans ce cas elle contiendra une
valeur unique.

.. code-block:: php
   :linenos:

   $valid = new Zend\Validate\Identical(array('token' => 123));
   if ($valid->isValid($input)) {
       // l'entrée est valide
   } else {
       // l'entrée est incorrecte
   }

L'exemple ci-dessus valide l'entier 123 car vous avez fourni la valeur en l'associant à la clé ``token``.

Mais, si vous devez valider un tableau qui contient un seul élément et que cet élément est nommé ``token``
alors vous devez l'envelopper comme dans l'example ci-dessous :

.. code-block:: php
   :linenos:

   $valid = new Zend\Validate\Identical(array('token' => array('token' => 123)));
   if ($valid->isValid($input)) {
       // l'entrée est valide
   } else {
       // l'entrée est incorrecte
   }


