.. EN-Revision: none
.. _zend.mail.encoding:

Kódovanie
=========

Telo textových a HTML správ je obvykle zakódované pomocou "quotedprintable" kódovania. Všetky prílohy sú
zakódované pomocou "base64" kódovania. Pri volaní metódy *addAttachment()* je možné nastavené iné
kódovanie. Kódovanie je možné nastaviť aj v objekte pre MIME-časť. 7Bit a 8Bit kódovanie v súčastnosti
nie je implementované a dáta sú ďalej predané bez zmeny.

*Zend\Mail_Transport\Smtp* zakóduje riadky, ktoré začínajú jednou, alebo dvomi bodkami a teda takýto e-mail
nebude narušovať SMTP protokol.


