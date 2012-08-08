.. EN-Revision: none
.. _zend.validator.set.notempty:

NotEmpty
========

Ce validateur permet de déterminer si une valeur est non vide. C'est utile lorsque vous travaillez avec des
formulaires ou des entrées utilisateur, là où vous pouvez l'utiliser pour savoir si des éléments requis ont
été saisis.

.. _zend.validator.set.notempty.options:

Options supportées par Zend_Validate_NotEmpty
---------------------------------------------

Les options suivantes sont supportées par ``Zend_Validate_NotEmpty``\  :

- **type**\  : paramètre le type de validation qui sera réalisée. Pour plus de détails, reportez vous à
  :ref:`cette section <zend.validator.set.notempty.types>`.

.. _zend.validator.set.notempty.default:

Comportement par défaut de Zend_Validate_NotEmpty
-------------------------------------------------

Par défaut, ce validateur fonctionne différement de la fonction *PHP* ``empty()``. En particulier, ce validateur
va évaluer l'entier **0** et la chaine '**0**' comme vides.

.. code-block:: php
   :linenos:

   $valid = new Zend_Validate_NotEmpty();
   $value  = '';
   $result = $valid->isValid($value);
   // retourne false

.. note::

   **Le comportement par défaut diffère de PHP**

   Sans configuration ajoutée, ``Zend_Validate_NotEmpty`` diffère de *PHP*.

.. _zend.validator.set.notempty.types:

Changer le comportement de Zend_Validate_NotEmpty
-------------------------------------------------

Certains projets ont des opinions différentes sur ce qui peut être considéré comme 'vide'. Une chaine seulement
composée d'espaces blancs pourrait être considérée comme vide, ou **0** pourrait être considéré comme
non-vide (surtout dans les séquences logiques booléennes). Pour correspondre aux différents besoins,
``Zend_Validate_NotEmpty`` vous permet de configurer les types que vous considérez comme vides.

Les types suivants sont gérés :

- **booléen**\  : Retourne ``FALSE`` lorsque la valeur booléenne est ``FALSE``.

- **entier**\  : Retourne ``FALSE`` lorsque l'entier **0** est passé. Par défaut cette validation n'est pas
  activée et retourne ``TRUE`` pour toute valeur d'entier.

- **flottant**\  : Retourne ``FALSE`` lorsque le flottant **0.0** est passé. Par défaut cette validation n'est
  pas activée et retourne ``TRUE`` pour toute valeur de flottant.

- **chaine**\  : Retourne ``FALSE`` lorsque la chaine vide **''** est passée.

- **zero**\  : Retourne ``FALSE`` lorsque le seul caractère zéro (**'0'**) est passé.

- **tableau_vide**\  : Retourne ``FALSE`` lorsqu'un tableau vide **array()** est passé.

- **null**\  : Retourne ``FALSE`` lorsqu'une valeur ``NULL`` est passée.

- **php**\  : Retourne ``FALSE`` lorsque la fonction *PHP* ``empty()`` retournerait ``TRUE``.

- **espace**\  : Retourne ``FALSE`` lorsqu'une chaine ne contenant que des caractères espace est passée.

- **tout**\  : Retourne ``FALSE`` pour tous les types gérés cités ci-dessus.

Toute autre valeur passée retourne ``TRUE`` par défaut.

Il existe différentes manières de selectionner les types ci-dessus. Vous pouvez en spécifier un ou plusieurs,
sous forme de tableau ou de constantes ou encore de chaines. Voyez les exemples ci-après :

.. code-block:: php
   :linenos:

   // Retourne false pour 0
   $validator = new Zend_Validate_NotEmpty(Zend_Validate_NotEmpty::INTEGER);

   // Retourne false pour 0 ou '0'
   $validator = new Zend_Validate_NotEmpty(
       Zend_Validate_NotEmpty::INTEGER + Zend_NotEmpty::ZERO
   );

   // Retourne false pour 0 ou '0'
   $validator = new Zend_Validate_NotEmpty(array(
       Zend_Validate_NotEmpty::INTEGER,
       Zend_Validate_NotEmpty::ZERO
   ));

   // Retourne false pour 0 ou '0'
   $validator = new Zend_Validate_NotEmpty(array(
       'integer',
       'zero',
   ));

Il est aussi possible de passer un objet ``Zend_Config`` afin de préciser les types à utiliser. Après
instantiation, ``setType()`` peut être utilisée.


