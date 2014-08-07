.. EN-Revision: none
.. _zend.validator.set.alnum:

Alnum
=====

``Zend\Validate\Alnum`` permet de valider des données contenant des caractères alphabétiques et des chiffres. Il
n'y a pas de limite de taille.

.. _zend.i18n.validator.alnum.options:

Options supportées par Zend\Validate\Alnum
------------------------------------------

Les options suivantes sont supportées par ``Zend\Validate\Alnum``\  :

- **allowWhiteSpace**\  : Si le caractère d'espace doit être accepté ou non. Par défaut ``FALSE``.

.. _zend.validator.set.alnum.basic:

Utilisation de base
-------------------

Voici un exemple :

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\Alnum();
   if ($validator->isValid('Abcd12')) {
       // value ne contient que des caractères autorisés
   } else {
       // false
   }

.. _zend.validator.set.alnum.whitespace:

Utiliser les espaces
--------------------

Par défaut les caractères espaces ne sont pas acceptés car il ne font pas partie de l'alphabet. Cependant il
existe un moyen de les accepter en entrée, ceci permet de valider des phrases complètes.

Pour autoriser les espaces blancs vous devez passer l'option ``allowWhiteSpace``. Ceci peut se faire à la
création de l'objet ou ensuite au moyen des méthodes ``setAllowWhiteSpace()`` et ``getAllowWhiteSpace()``.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\Alnum(array('allowWhiteSpace' => true));
   if ($validator->isValid('Abcd and 12')) {
       // value ne contient que des caractères autorisés
   } else {
       // false
   }

.. _zend.validator.set.alnum.languages:

Utiliser des langues différentes
--------------------------------

En utilisant ``Zend\Validate\Alnum``, la langue que l'utilisateur précise dans son navigateur sera utilisée pour
autoriser ou non certains caractères. Ainsi si l'utilisateur règle son navigateur sur **de** pour de l'allemand,
alors les caractères comme **ä**, **ö** et **ü** seront eux aussi autorisés.

Les caractères autorisés dépendent donc complètement de la langue utilisée.

Il existe actuellement 3 langues qui ne sont pas supportées pour ce validateur. Il s'agit du **coréen**, du
**japonais** et du **chinois** car ces langues utilisent un alphabet dans lequel un seul caractère est fabriqué
à base de multiples caractères.

Dans le cas où vous utilisez ces langues, seule l'alphabet anglais sera utilisé pour la validation.


