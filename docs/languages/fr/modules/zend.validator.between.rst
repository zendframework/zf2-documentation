.. EN-Revision: none
.. _zend.validator.set.between:

Between
=======

``Zend\Validate\Between`` permet de valider qu'une valeur soit bien comprise entre deux bornes.

.. note::

   **Zend\Validate\Between ne supporte que les nombres**

   Zend\Validate\Between ne supporte pas les chaines ou les dates.

.. _zend.validator.set.between.options:

Options gérées par Zend\Validate\Between
----------------------------------------

Les options suivantes sont reconnues par ``Zend\Validate\Between``:

- **inclusive**: Défini si les bornes sont inclusives dans la validation (min et max). Par défaut, ``TRUE``.

- **min**: Affecte la borne inférieure.

- **max**: Affecte la borne supérieure.

.. _zend.validator.set.between.basic:

Comportement par défaut de Zend\Validate\Between
------------------------------------------------

Par défaut ce validateur vérifie sur la valeur est entre ``min`` et ``max`` inclusivement pour les deux bornes.

.. code-block:: php
   :linenos:

   $valid  = new Zend\Validate\Between(array('min' => 0, 'max' => 10));
   $value  = 10;
   $result = $valid->isValid($value);
   // retourne true

Dans l'exemple ci-dessus, ``TRUE`` est retourné car par défaut les bornes supérieures et inférieures sont
inclusives. Toute valeur depuis '0' à '10' sont donc autorisées et reconnues. '-1' et '11' auraient retourné
``FALSE``.

.. _zend.validator.set.between.inclusively:

Validation exclusive sur les bornes
-----------------------------------

Il peut être nécessaire d'exclure les bornes dans la validation. Voyez l'exemple qui suit:

.. code-block:: php
   :linenos:

   $valid  = new Zend\Validate\Between(
       array(
           'min' => 0,
           'max' => 10,
           'inclusive' => false
       )
   );
   $value  = 10;
   $result = $valid->isValid($value);
   // retourne false

L'exemple ci-dessus fait en sorte que '0' et '10' retournent ``FALSE``.


