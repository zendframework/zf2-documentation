.. EN-Revision: none
.. _zend.validator.set.hex:

Hex
===

``Zend\Validate\Hex`` permet de valider qu'un nombre ne contienne bien que des caractères hexadécimaux. Ce sont
les caractères de **0 à 9** et de **A à F** insensibles à la casse. Il n'existe pas de limite de longueur de la
chaîne à valider.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\Hex();
   if ($validator->isValid('123ABC')) {
       // value ne contient que des caractères hex
   } else {
       // false
   }

.. note::

   **Caractères invalides**

   Tous les autres caractères retourneront false, même l'espace et le point. Les zéros unicode ou les chiffres
   d'autres encodages que latin seront considérés comme invalides.

.. _zend.validator.set.hex.options:

Options supportées par Zend\Validate\Hex
----------------------------------------

Il n'y a pas d'options additionnelles supportées par ``Zend\Validate\Hex``:


