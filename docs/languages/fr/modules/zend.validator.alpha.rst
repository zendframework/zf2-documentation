.. _zend.validate.set.alpha:

Alpha
=====

``Zend_Validate_Alpha`` permet de valider qu'une donnée ne contient que des caractères alphabétiques. Il n'y a
pas de limite de taille. Ce validateur fonctionne comme le validateur ``Zend_Validate_Alnum`` à l'exception qu'il
n'accepte pas les chiffres.

.. _zend.validate.set.alpha.options:

Options suportées par Zend_Validate_Alpha
-----------------------------------------

Les options suivantes sont supportées par ``Zend_Validate_Alpha``:

- **allowWhiteSpace**: Si les caractères d'espace sont autorisés ou pas. Par défaut ``FALSE``

.. _zend.validate.set.alpha.basic:

Utilisation de base
-------------------

Voici un exemple de base:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Alpha();
   if ($validator->isValid('Abcd')) {
       // value ne contient que des caractères autorisés
   } else {
       // false
   }

.. _zend.validate.set.alpha.whitespace:

Utiliser les espaces
--------------------

Par défaut les caractères espaces ne sont pas acceptés car il ne font pas partie de l'alphabet. Cependant il
existe un moyen de les accepter en entrée, ceci permet de valider des phrases complètes.

Pour autoriser les espaces blancs vous devez passer l'option ``allowWhiteSpace``. Ceci peut se faire à la
création de l'objet ou après au moyen des méthodes ``setAllowWhiteSpace()`` et ``getAllowWhiteSpace()``.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Alpha(array('allowWhiteSpace' => true));
   if ($validator->isValid('Abcd and efg')) {
       // value ne contient que des caractères autorisés
   } else {
       // false
   }

.. _zend.validate.set.alpha.languages:

Utiliser des langues différentes
--------------------------------

En utilisant ``Zend_Validate_Alpha``, la langue que l'utilisateur précise dans son navigateur sera utilisée pour
autoriser ou non certains caractères. Ainsi si l'utilisateur règle son navigateur sur **de** pour de l'allemand,
alors les caractères comme **ä**, **ö** et **ü** seront eux aussi autorisés.

Les caractères autorisés dépendent donc complètement de la langue utilisée.

Il existe actuellement 3 langues qui ne sont pas supportées pour ce validateur. Il s'agit de **coréen**,
**japonais** et **chinois** car ces langues utilisent un alphabet dans lequel un seul caractère est fabriqué à
base de multiples caractères.

Dans le cas où vous utilisez ces langues, seule l'alphabet anglais sera utilisé pour la validation.


