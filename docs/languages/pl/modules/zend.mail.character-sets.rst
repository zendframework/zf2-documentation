.. EN-Revision: none
.. _zend.mail.character-sets:

Zestawy znaków
==============

*Zend_Mail* nie sprawdza poprawności zestawu znaków poszczególnych części wiadomości. Kiedy tworzymy
instancję *Zend_Mail*, możemy wybrać zestaw znaków dla wiadomości. Domyślny to *iso-8859-1*. Aplikacja musi
zadbać o to, aby wszystkie części dodane do obiektu wiadomości miały zawartośc zakodowaną w prawidłowym
zestawie znaków. Kiedy tworzymy nową część wiadomości, możemy użyć innego zestawu znaków dla każdej z
części.

.. note::

   **Tylko w formacie tekstowym**

   Zestawy znaków mają jedynie zastosowanie dla części wiadomości które są w formacie tekstowym.


