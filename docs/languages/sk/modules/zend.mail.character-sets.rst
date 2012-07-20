.. _zend.mail.character-sets:

Znakové sady
=============

Trieda *Zend_Mail* nekontroluje správne nastavenie znakovej sady v jednotlivých častiach e-mailu. Pri
vytváraní inštancie *Zend_Mail* je možné nastaviť inú znakovú sadu ako *iso-8859-1*, ktorá je ako
východzia. Každá časť, ktorá je pridaná k vytvorenému objektu musí mať správne nastavenú znakovú sadu.
Pre každú časť MIME e-mailu je možné nastaviť inú znakovú sadu.

.. note::

   **Iba pre textový obsah**

   Nastavenie znakovej sady je platné iba pre časti ktoré sú textové.


