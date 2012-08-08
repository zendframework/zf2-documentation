.. EN-Revision: none
.. _zend.validator.set.digits:

Digits
======

``Zend_Validate_Digit`` valide si une donnée contient des chiffres.

.. _zend.validator.set.digits.options:

Options supportées par Zend_Validate_Digits
-------------------------------------------

Aucun option n'est gérée par ``Zend_Validate_Digits``

.. _zend.validator.set.digits.basic:

Valider des chiffres
--------------------

Pour valider si une donnée ne contient que des chiffres et pas d'autre caractère, appelez simplement le
validateur comme montré dans l'exemple suivant:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Digits();

   $validator->isValid("1234567890"); // retourne true
   $validator->isValid(1234);         // retourne true
   $validator->isValid('1a234');      // retourne false

.. note::

   **Valider des nombres**

   Si vous voulez valider des nombres ou des valeurs numériques, faites attention car ce validateur ne valide que
   les chiffres. Ceci signifie que les signes comme les séparateurs des milliers ou les virgules ne seront pas
   pris en compte et le validateur échouera. Voyez pour ces cas ``Zend_Validate_Int`` ou ``Zend_Validate_Float``.


