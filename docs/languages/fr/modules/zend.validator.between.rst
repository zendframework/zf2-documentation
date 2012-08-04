.. _zend.validate.set.between:

Between
=======

``Zend_Validate_Between`` permet de valider qu'une valeur soit bien comprise entre deux bornes.

.. note::

   **Zend_Validate_Between ne supporte que les nombres**

   Zend_Validate_Between ne supporte pas les chaines ou les dates.

.. _zend.validate.set.between.options:

Options gérées par Zend_Validate_Between
----------------------------------------

Les options suivantes sont reconnues par ``Zend_Validate_Between``:

- **inclusive**: Défini si les bornes sont inclusives dans la validation (min et max). Par défaut, ``TRUE``.

- **min**: Affecte la borne inférieure.

- **max**: Affecte la borne supérieure.

.. _zend.validate.set.between.basic:

Comportement par défaut de Zend_Validate_Between
------------------------------------------------

Par défaut ce validateur vérifie sur la valeur est entre ``min`` et ``max`` inclusivement pour les deux bornes.

.. code-block:: php
   :linenos:

   $valid  = new Zend_Validate_Between(array('min' => 0, 'max' => 10));
   $value  = 10;
   $result = $valid->isValid($value);
   // retourne true

Dans l'exemple ci-dessus, ``TRUE`` est retourné car par défaut les bornes supérieures et inférieures sont
inclusives. Toute valeur depuis '0' à '10' sont donc autorisées et reconnues. '-1' et '11' auraient retourné
``FALSE``.

.. _zend.validate.set.between.inclusively:

Validation exclusive sur les bornes
-----------------------------------

Il peut être nécessaire d'exclure les bornes dans la validation. Voyez l'exemple qui suit:

.. code-block:: php
   :linenos:

   $valid  = new Zend_Validate_Between(
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


