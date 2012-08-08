.. EN-Revision: none
.. _zend.mail.character-sets:

Set dei caratteri
=================

*Zend_Mail* non esegue alcun controllo sulla correttezza dei set di caratteri delle parti dell'e-mail. Quando si
crea un'istanza di *Zend_Mail* è possibile specificare un set di caratteri per l'e-mail. Il valore predefinito è
*iso-8859-1*. L'applicazione deve verificare che tutte le parti aggiunte all'oggetto e-mail siano codificate nel
set di caratteri corretto. In fase di creazione di una nuova parte dell'e-mail è possibile indicare un set di
caratteri differente per ogni parte.

.. note::

   **Solo per il formato testo**

   Il set di caratteri è applicabile esclusivamente alle parti del messaggio in formato testuale.


