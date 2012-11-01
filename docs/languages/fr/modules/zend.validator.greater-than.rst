.. EN-Revision: none
.. _zend.validator.set.greaterthan:

GreaterThan
===========

``Zend\Validate\GreaterThan`` permet de valider qu'une valeur est plus grande qu'une autre (la borne).

.. note::

   **Zend\Validate\GreaterThan ne supporte que les nombres**

   Zend\Validate\GreaterThan ne fonctionnera pas avec les chaines ou les dates.

.. _zend.validator.set.greaterthan.options:

Options supportées par Zend\Validate\GreaterThan
------------------------------------------------

Les options suivantes sont supportées par ``Zend\Validate\GreaterThan``:

- **min**: Affecte la borne inférieure.

.. _zend.validator.set.greaterthan.basic:

Utilisation de base
-------------------

Voyez l'exemple ci-après.

.. code-block:: php
   :linenos:

   $valid  = new Zend\Validate\GreaterThan(array('min' => 10));
   $value  = 10;
   $return = $valid->isValid($value);
   // retourne true

L'exemple ci-dessus retourne ``TRUE`` pour toutes les valeurs égales ou supérieures à 10.


