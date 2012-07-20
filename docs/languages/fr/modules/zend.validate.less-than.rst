.. _zend.validate.set.lessthan:

LessThan
========

``Zend_Validate_LessThan`` permet de valider qu'une donnée est bien inférieure à une borne. C'est l'opposé de
``Zend_Validate_GreaterThan``.

.. note::

   **Zend_Validate_LessThan ne supporte que les chiffres**

   ``Zend_Validate_LessThan`` ne fonctionnera pas avec les chaines et les dates.

.. _zend.validate.set.lessthan.options:

Options gérées par Zend_Validate_LessThan
-----------------------------------------

Les options suivantes sont supportées par ``Zend_Validate_LessThan``:

- **max**: Affecte la borne supérieure.

.. _zend.validate.set.lessthan.basic:

Utilisation de base
-------------------

Voyez l'exemple ci-après.

.. code-block:: php
   :linenos:

   $valid  = new Zend_Validate_LessThan(array('max' => 10));
   $value  = 10;
   $return = $valid->isValid($value);
   // retourne true

L'exemple ci-dessus retourne ``TRUE`` pour toutes les valeurs égales ou inférieures à 10.


