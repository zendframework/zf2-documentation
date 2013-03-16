.. EN-Revision: none
.. _zend.validator.set.lessthan:

LessThan
========

``Zend\Validate\LessThan`` permet de valider qu'une donnée est bien inférieure à une borne. C'est l'opposé de
``Zend\Validate\GreaterThan``.

.. note::

   **Zend\Validate\LessThan ne supporte que les chiffres**

   ``Zend\Validate\LessThan`` ne fonctionnera pas avec les chaînes et les dates.

.. _zend.validator.set.lessthan.options:

Options gérées par Zend\Validate\LessThan
-----------------------------------------

Les options suivantes sont supportées par ``Zend\Validate\LessThan``:

- **max**: Affecte la borne supérieure.

.. _zend.validator.set.lessthan.basic:

Utilisation de base
-------------------

Voyez l'exemple ci-après.

.. code-block:: php
   :linenos:

   $valid  = new Zend\Validate\LessThan(array('max' => 10));
   $value  = 10;
   $return = $valid->isValid($value);
   // retourne true

L'exemple ci-dessus retourne ``TRUE`` pour toutes les valeurs égales ou inférieures à 10.


