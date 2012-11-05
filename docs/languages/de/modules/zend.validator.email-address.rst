.. EN-Revision: none
.. _zend.validator.set.email_address:

Email Adresse
=============

``Zend\Validate\EmailAddress`` erlaubt die Prüfung von Email Adressen. Der Prüfer teilt zuerst die Email Adresse
in lokalen Teil @ hostname und versucht diese mit bekannten Spezifikationen für Email Adressen und Hostnamen zu
prüfen.

.. _zend.validator.set.email_address.basic:

Normale Verwendung
------------------

Ein Beispiel einer normalen Benutzung ist anbei:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress();
   if ($validator->isValid($email)) {
       // Email Adresse scheint gültig zu sein
   } else {
       // Email Adresse ist ungültig, drucke die Gründe hierfür
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

Das prüft die Email Adresse ``$email`` und gibt bei einem Fehler über ``getMessages()`` eine nützliche
Fehlermeldung aus.

.. _zend.validator.set.email_address.options:

Optionen für die Prüfung von Email Adressen
-------------------------------------------

``Zend\Validate\EmailAddress`` unterstützt verschiedene Optionen welche entweder bei der Initiierung, durch
Übergeben eines Arrays mit den betreffenden Optionen, gesetzt werden können, oder im Nachhinein, durch Verwendung
von ``setOptions()``. Die folgenden Optionen werden unterstützt:

- **allow**: Definiert welche Typen von Domain Namen akzeptiert werden. Diese Option wird in Verbindung mit der
  hostname Option verwendet um die Hostname Prüfung zu setzen. Für weitere Informationen über mögliche Werte
  dieser Option sehen Sie bitte unter :ref:`Hostname <zend.validator.set.hostname>` und mögliche ``ALLOW``\ *
  Konstanten. Der Standardwert dieser Option ist ``ALLOW_DNS``.

- **deep**: Definiert ob die MX Records des Server durch eine tiefe Prüfung verifiziert werden sollen. Wenn diese
  Option auf ``TRUE`` gesetzt wird, dann werden zusätzlich zum MX Record auch die A, A6 und ``AAAA`` Records
  verwendet um zu prüfen ob der Server Emails akzeptiert. Der Standardwert dieser Option ist ``FALSE``.

- **domain**: Definiert ob der Domain Teil geprüft werden soll. Wenn diese Option auf ``FALSE`` gesetzt wird, dann
  wird nur der lokale Teil der Email Adresse geprüft. In diesem Fall wird die Hostname Prüfung nicht aufgerufen.
  Der Standardwert dieser Option ist ``TRUE``.

- **hostname**: Setzt die Hostname Prüfung mit welcher der Domain Teil der Email Adresse geprüft wird.

- **mx**: Definiert ob der MX Record vom Server erkannt werden soll. Wenn diese Option auf ``TRUE`` definiert wird,
  dann wird der MX Record verwendet um zu prüfen ob der Server Emails akzeptiert. Der Standardwert dieser Option
  ist ``FALSE``.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress();
   $validator->setOptions(array('domain' => false));

.. _zend.validator.set.email_address.complexlocal:

Komplexe lokale Abschnitte
--------------------------

``Zend\Validate\EmailAdress`` prüft jede gültige Email Adresse mit RFC2822. Gültige Email Adressen sind zum
Beispiel **bob@domain.com**, **bob+jones@domain.us**, **"bob@jones"@domain.com** und **"bob jones"@domain.com**.

Einige Email Formate werden aktuell nicht geprüft (z.B. Zeilenumbruch Zeichen oder ein "\\" Zeichen in einer Email
Adresse).

.. _zend.validator.set.email_address.purelocal:

Nur den lokalen Teil prüfen
---------------------------

Wenn man will das ``Zend\Validate\EmailAddress`` nur den lokalen Teil der Email Adresse prüfen soll, und die
Prüfung des Hostnamens ausschalten will, kann man die ``domain`` Option auf ``FALSE`` setzen. Das zwingt
``Zend\Validate\EmailAddress`` den Hostname Teil der Email Adresse nicht zu prüfen.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress();
   $validator->setOptions(array('domain' => FALSE));

.. _zend.validator.set.email_address.hostnametype:

Prüfen von unterschiedlichen Typen von Hostnamen
------------------------------------------------

Der Teil des Hostnamens einer Email Adresse wird mit :ref:`Zend\Validate\Host <zend.validator.set.hostname>`
geprüft. Standardmäßig werden nur DNS Hostnamen in der Form ``domain.com`` akzeptiert, aber wenn es gewünscht
ist, können auch IP Adressen und lokale Hostnamen auch akzeptiert werden.

Um das zu tun, muß eine ``Zend\Validate\EmailAddress`` Instanz erstellt werden der ein Parameter übergeben wird,
um den Typ des Hostnamens anzugeben der akzeptiert werden soll. Mehr Details sind in ``Zend\Validate\Hostname``
inkludiert, zusammen mit einem Beispiel, wie DNS und lokale Hostnamen, akzeptiert werden wie im Beispiel das anbei
steht:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress(
                       Zend\Validate\Hostname::ALLOW_DNS |
                       Zend\Validate\Hostname::ALLOW_LOCAL);
   if ($validator->isValid($email)) {
       // Email Adresse scheint gültig zu sein
   } else {
       // Email ist ungültig; Gründe ausdrucken
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

.. _zend.validator.set.email_address.checkacceptance:

Prüfen ob der Hostname aktuell Emails akzeptiert
------------------------------------------------

Nur weil eine Email Adresse im richtigen Format ist, heißt das notwendigerweise nicht das die Email Adresse
aktuell auch existiert. Um dieses Problem zu lösen, kann MX Prüfung verwendet werden um zu prüfen ob ein MX
(Email) Eintrag im DNS Eintrag für den Hostnamen der Email existiert. Das zeigt ob der Hostname Emails akzeptiert,
sagt aber nicht aus, ob die genaue Email Adresse selbst gültig ist.

Die MX Prüfung ist standardmäßig nicht eingeschaltet. Um die MX Prüfung einzuschalten kann ein zweiter
Parameter an den ``Zend\Validate\EmailAddress`` Konstruktor übergeben werden.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress(
       array(
           'allow' => Zend\Validate\Hostname::ALLOW_DNS,
           'mx'    => true
       )
   );

.. note::

   **Die MX Prüfung unter Windows**

   In Windows Umgebungen ist die MX Prüfung nicht vorhanden wenn *PHP* 5.3 oder höher verwendet wird. Unter *PHP*
   5.3 wird die MX Prüfung nicht verwendet, selbst wenn diese in den Optionen aktiviert wurde.

Alternativ kann entweder ``TRUE`` oder ``FALSE`` an ``setValidateMx()`` übergeben werden um die MX Prüfung ein-
oder auszuschalten.

Durch das einschalten dieser Option werden Netzwerk Funktionen verwendet um zu Prüfen ob ein MX Eintrag am
Hostnamen der Email Adresse existiert, welche geprüft werden soll. Vorsicht davor, das hierbei das eigene Skript
langsamer wird.

Manchmal gibt die Prüfung auf MX Records ``FALSE`` zurück, selbst wenn Emails akzeptiert werden. Der Hintergrund
dieses Verhaltens ist, das der Server Emails akzeptieren kann, selbst wenn er keinen MX Record anbietet. In diesem
Fall kann er A, A6 oder ``AAAA`` Records anbieten. Um es ``Zend\Validate\EmailAddress`` zu erlauben auch auf diese
anderen Records zu prüfen, muss man die tiefe MX Prüfung einschalten. Das kann man durch Setzen der ``deep``
Option bei der Initialisierung, oder durch Verwendung von ``setOptions()`` tun.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress(
       array(
           'allow' => Zend\Validate\Hostname::ALLOW_DNS,
           'mx'    => true,
           'deep'  => true
       )
   );

.. warning::

   **Performance Warnung**

   Man sollte darauf achten das die Aktivierung der MX Prüfung das Skript langsamer machen wird, weil es Netzwerk
   Funktionen verwendet. Die Aktivierung der tiefen Prüfung macht das Skript sogar noch langsamer da es im
   angegebenen Server nach 3 zusätzlichen Typen sucht.

.. note::

   **Disallowed IP addresses**

   Man sollte beachten das die MX Prüfung nur für externe Server akzeptiert wird. Wenn die tiefe MX Prüfung
   aktiviert wird, dann werden IP Adressen wie ``192.168.*`` oder ``169.254.*`` nicht akzeptiert.

.. _zend.validator.set.email_address.validateidn:

Internationale Domain Namen prüfen
----------------------------------

``Zend\Validate\EmailAddress`` prüft auch internationale Zeichen prüfen, die in einigen Domains existieren. Dies
ist als Unterstützung für Internationale Domain Namen (IDN) bekannt. Standardmäßig ist das eingeschaltet. Das
kann aber ausgeschaltet werden indem eine Einstellung geändert wird über das interne ``Zend\Validate\Hostname``
Objekt das innerhalb von ``Zend\Validate\EmailAddress`` existiert.

.. code-block:: php
   :linenos:

   $validator->getHostnameValidator->setValidateIdn(false);

Weitere Informationen über die Verwendung von ``setValidateIdn()`` gibt es in der ``Zend\Validate\Hostname``
Dokumentation.

Es sollte darauf geachtet werden das IDNs nur geprüft werden wenn erlaubt ist DNS Hostnamen zu prüfen.

.. _zend.validator.set.email_address.validatetld:

Top Level Domains prüfen
------------------------

Standardmäßig wird ein Hostname mit einer List von bekannten TLDs geprüft. Das ist standardmäßig aktiviert,
kann aber ausgeschaltet werden indem die Einstellung über das interne ``Zend\Validate\Hostname`` geändert wird,
das innerhalb von ``Zend\Validate\EmailAddress`` existiert.

.. code-block:: php
   :linenos:

   $validator->getHostnameValidator->setValidateTld(false);

Mehr Informationen über die Verwendung von ``setValidateTld()`` gibt es in der ``Zend\Validate\Hostname``
Dokumentation.

Es sollte darauf geachtet werden das TLDs nur geprüft werden wenn es auch erlaubt ist DNS Hostnamen zu prüfen.

.. _zend.validator.set.email_address.setmessage:

Setzen von Meldungen
--------------------

``Zend\Validate\EmailAddress`` verwendet auch ``Zend\Validate\Hostname`` um den Teil des Hostnamens einer
angegebenen Email Adresse zu prüfen. Ab Zend Framework 1.10 kann man Meldungen für ``Zend\Validate\Hostname``
auch von innerhalb ``Zend\Validate\EmailAddress`` setzen.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress();
   $validator->setMessages(array(
       Zend\Validate\Hostname::UNKNOWN_TLD => 'Ich kenne die TLD nicht')
   );

Vor Zend Framework 1.10 musste man die Meldungen einem eigenen ``Zend\Validate\Hostname`` hinzufügen, und dann
diese Prüfung in ``Zend\Validate\EmailAddress`` setzen um die eigenen Meldungen zurückzubekommen.


