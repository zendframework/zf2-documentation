.. _zend.mail.adding-recipients:

Empfänger hinzufügen
====================

Empfänger können über drei Wege hinzugefügt werden:

- ``addTo()``: fügt der Mail einen Empfänger in der "To" Kopfzeile hinzu

- ``addCc()``: fügt der Mail einen Empfänger in der "Cc" Kopfzeile hinzu

- ``addBcc()``: fügt der Mail einen Empfänger hinzu, der in den Kopfzeilen nicht sichtbar ist

``getRecipients()`` bietet eine Liste von Empfängern. ``clearRecipients()`` löscht die Liste.

.. note::

   **Zusätzliche Parameter**

   ``addTo()`` und ``addCc()`` akzeptieren einen zweiten, optionalen Parameter, der für einen visuell lesbaren
   Namen des Empfängers in der Kopfzeile verwendet wird. Im Parameter werden doppelte Anführungszeichen auf
   einfache und runde Klammern zu eckigen getauscht.

.. note::

   **Optionale Verwendung**

   Alle drei Methoden akzeptieren auch ein Array von Email Adressen das hinzugefügt werden kann, statt jeweils nur
   einer einzelnen. Im Fall von ``addTo()`` und ``addCc()``, kann dies ein assoziatives Array sein, wobei der
   Schlüssel ein menschlich lesbarer Name für den Empfänger ist.


