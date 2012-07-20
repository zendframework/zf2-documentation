.. _zend.mail.character-sets:

Character Sets
==============

*Zend_Mail* controleert niet of de berichtdelen de juiste karakterset hebben. Wanneer *Zend_Mail* word
geïnstantieerd mag er een charset voor het bericht zelf worden opgegeven. De standaard waarde is iso8859-1. De
toepassing moet er zich van vrijwaren dat alle aan het bericht toegevoegde delen in de juiste charset zijn
gecodeerd. Je een andere charset opgeven voor elk nieuw deel dat aan het bericht wordt toegevoegd.

.. note::

   Character sets zijn alleen toepasbaar op berichtdelen in tekstformaat.


