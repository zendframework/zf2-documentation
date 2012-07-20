.. _zend.validate.set.hostname:

Hostname
========

``Zend_Validate_Hostname`` erlaubt die Prüfung von Hostnamen mit einem Set von bekannten Spezifikationen. Es ist
möglich drei verschiedene Typen von Hostnamen zu Prüfen: einen *DNS* Hostnamen (z.b. ``domain.com``), IP Adressen
(z.B. 1.2.3.4), und lokale Hostnamen (z.B. localhost). Standarmäßig werden nur *DNS* Hostnamen geprüft.

.. _zend.validate.set.hostname.options:

Unterstützte Optionen für Zend_Validate_Hostname
------------------------------------------------

Die folgenden Optionen werden für ``Zend_Validate_Hostname`` unterstützt:

- **allow**: Definiert die Art des Hostnamens welche verwendet werden darf. Siehe :ref:`Hostname Typen
  <zend.validate.set.hostname.types>` für Details.

- **idn**: Definiert ob *IDN* Domains erlaubt sind oder nicht. Diese Option ist standardmäßig ``TRUE``.

- **ip**: Erlaubt es eine eigene IP Prüfung zu definieren. Diese Option ist standardmäßig eine neue Instanz von
  ``Zend_Validate_Ip``.

- **tld**: Definiert ob *TLD*\ s geprüft werden. Diese Option ist standardmäßig ``TRUE``.

.. _zend.validate.set.hostname.basic:

Normale Verwendung
------------------

**Normale Verwendung**

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Hostname();
   if ($validator->isValid($hostname)) {
       // Hostname scheint gültig zu sein
   } else {
       // Hostname ist ungülig; Gründe dafür ausdrucken
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

Das prüft den Hostnamen ``$hostname`` und wird einen Fehler über ``getMessages()`` mit einer nützlichen
Fehlermeldung auswerfen.

.. _zend.validate.set.hostname.types:

Verschiedene Typen von Hostnamen prüfen
---------------------------------------

Es kann gewünscht sein auch IP Adressen, lokale Hostnamen, oder eine Kombination aller drei erlaubten Typen zu
prüfen. Das kann gemacht werden durch die Übergabe eines Parameters an ``Zend_Validate_Hostname`` wenn dieser
initialisiert wird. Der Parameter sollte ein Integer sein, welcher die Typen von Hostnamen auswählt die erlaubt
sind. Hierfür können die ``Zend_Validate_Hostname`` Konstanten verwendet werden.

Die ``Zend_Validate_Hostname`` Konstanten sind: ``ALLOW_DNS`` um nur *DNS* Hostnamen zu erlauben, ``ALLOW_IP`` um
IP Adressen zu erlauben, ``ALLOW_LOCAL`` um lokale Hostnamen zu erlauben, und ``ALLOW_ALL`` um alle drei Typen zu
erlauben. Um nur IP Adressen zu prüfen kann das folgende Beispiel verwendet werden:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Hostname(Zend_Validate_Hostname::ALLOW_IP);
   if ($validator->isValid($hostname)) {
       // Hostname scheint gültig zu sein
   } else {
       // Hostname ist ungülig; Gründe dafür ausdrucken
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

Genau wie die Verwendung von ``ALLOW_ALL`` alle Typen von Hostnamen akzeptiert, können diese Typen kombiniert
werden um Kombinationen zu erlauben. Um zum Beispiel *DNS* und lokale Hostnamen zu akzeptieren muß das
``Zend_Validate_Hostname`` Objekt wie folgt initialisiert werden:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Hostname(Zend_Validate_Hostname::ALLOW_DNS |
                                           Zend_Validate_Hostname::ALLOW_IP);

.. _zend.validate.set.hostname.idn:

Internationale Domain Namen prüfen
----------------------------------

Einige Länder Code Top Level Domains (ccTLDs), wie 'de' (Deutschland), unterstützen internationale Zeichen in
Domain Namen. Diese sind als Internationale Domain Namen (*IDN*) bekannt. Diese Domains können mit
``Zend_Validate_Hostname`` geprüft werden, mit Hilfe von erweiterten Zeichen die im Prüfprozess verwendet werden.

.. note::

   **IDN Domains**

   Bis jetzt unterstützen mehr als 50 ccTLDs *IDN* Domains.

Eine *IDN* Domain zu prüfen ist genauso einfach wie die Verwendung des standard Hostnamen Prüfers da *IDN*
Prüfung standardmäßig eingeschaltet ist. Wenn *IDN* Prüfung ausgeschaltet werden soll, kann das entweder durch
die Übergabe eines Parameters im ``Zend_Validate_Hostname`` Constructor, oder über die ``setValidateIdn()``
Methode gemacht werden.

Die *IDN* Prüfung kann ausgeschaltet werden durch die Übergabe eines zweiten Parameters an den
``Zend_Validate_Hostname`` Constructor auf die folgende Art und Weise.

.. code-block:: php
   :linenos:

   $validator =
       new Zend_Validate_Hostname(
           array(
               'allow' => Zend_Validate_Hostname::ALLOW_DNS,
               'idn'   => false
           )
       );

Alternativ kann entweder ``TRUE`` oder ``FALSE`` an ``setValidateIdn()`` übergeben werden, um die *IDN* Prüfung
ein- oder auszuschalten. Wenn ein *IDN* Hostname geprüft wird, der aktuell nicht unterstützt wird, ist sicher das
die Prüfung fehlschlagen wird wenn er irgendwelche internationalen Zeichen hat. Wo keine ccTLD Datei in
``Zend/Validate/Hostname`` existiert, welche die zusätzlichen Zeichen definiert, wird eine normale Hostnamen
Prüfung durchgeführt.

.. note::

   **IDN Prüfung**

   Es sollte beachtet werden das *IDN*\ s nur geprüft werden wenn es erlaubt ist *DNS* Hostnamen zu prüfen.

.. _zend.validate.set.hostname.tld:

Top Level Domains prüfen
------------------------

Normalerweise wird ein Hostname gegen eine Liste von bekannten *TLD*\ s geprüft. Wenn diese Funktionalität nicht
benötigt wird kann das, auf die gleiche Art und Weise wie die *IDN* Unterstützung, ausgeschaltet werden Die *TLD*
Prüfung kann ausgeschaltet werden indem ein dritter Parameter an den ``Zend_Validate_Hostname`` Constructor
übergeben wird. Im folgenden Beispiel wird die *IDN* Prüfung durch den zweiten Parameter unterstützt.

.. code-block:: php
   :linenos:

   $validator =
       new Zend_Validate_Hostname(
           array(
               'allow' => Zend_Validate_Hostname::ALLOW_DNS,
               'idn'   => true,
               'tld'   => false
           )
       );

Alternativ kann entweder ``TRUE`` oder ``FALSE`` übergeben an ``setValidateTld()`` übergeben werden um die *TLD*
Prüfung ein- oder auszuschalten.

.. note::

   **TLD Prüfung**

   Es sollte beachtet werden das *TLD*\ s nur geprüft werden wenn es erlaubt ist *DNS* Hostnamen zu prüfen.


