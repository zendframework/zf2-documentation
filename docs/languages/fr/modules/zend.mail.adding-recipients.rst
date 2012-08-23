.. EN-Revision: none
.. _zend.mail.adding-recipients:

Ajouter des destinataires
=========================

Des destinataires peuvent être ajouter de trois façons :

- ``addTo()``: Ajoute un destinataire à l'émail grâce à un en-tête "To"

- ``addCc()``: Ajoute un destinataire à l'émail grâce à un en-tête "Cc"

- ``addBcc()``: Ajoute un destinataire non-visible dans les en-têtes de l'émail

``getRecipients()`` récupère la liste des destinataires. ``clearRecipients()`` efface la liste.

.. note::

   **Paramètres additionnels**

   ``addTo()`` et ``addCc()`` acceptent un second paramètre optionnel, qui est utilisé comme un nom de
   destinataire humainement lisible. Le guillemet double est changé en simple guillemet et les crochets en
   parenthèses dans le paramètre.

.. note::

   **Utilisation optionnelle**

   Ces trois méthodes peuvent aussi accepter un tableau d'adresses émails plutôt que de les ajouter une par une.
   Dans le cas de ``addTo()`` et ``addCc()``, il peut s'agir de tableaux associatifs où la clé est un nom de
   destinataire humainement lisible.


