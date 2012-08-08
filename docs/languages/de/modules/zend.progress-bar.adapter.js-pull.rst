.. EN-Revision: none
.. _zend.progressbar.adapter.jspull:

Zend_ProgressBar_Adapter_JsPull
===============================

``Zend_ProgressBar_Adapter_JsPull`` ist das Gegenteil von jsPush, da es ein Holen für neue Updates benötigt,
statt die Updates zum Browser zu schicken. Generell sollte man den Adapter mit der Persistenz Option auf
``Zend_ProgressBar`` verwenden. Bei der Benachrichtigung sendet der Adapter einen *JSON* String zum Browser, der
exakt wie der JSON String aussieht der vom jsPush Adapter gesendet wird. Der einzige Unterschied ist, das er einen
zusätzlichen Parameter ``finished`` enthält, der entweder ``FALSE`` ist, wenn ``update()`` aufgerufen wurde, oder
``TRUE`` wenn ``finish()`` aufgerufen wurde.

Die Adapteroptionen kann man entweder über die ``set*()`` Methoden oder durch die Übergabe eines Arrays oder
einer Instanz von ``Zend_Config`` mit den Optionen als ersten Parameter an den Constructor setzen. Die vorhandenen
Optionen sind:

- ``exitAfterSend``: Beendet die aktuelle Anfrage nachdem die Daten an den Browser gesendet wurden. Der
  Standardwert ist ``TRUE``.


