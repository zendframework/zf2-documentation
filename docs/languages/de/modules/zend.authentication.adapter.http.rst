.. EN-Revision: none
.. _zend.authentication.adapter.http:

HTTP Authentication Adapter
===========================

.. _zend.authentication.adapter.http.introduction:

Einführung
----------

``Zend\Auth\Adapter\Http`` bietet die am meisten entsprechende Implementation von `RFC-2617`_, `Basis`_ und
`Digest`_ *HTTP* Authentifizierung. Digest Authentifizierung ist eine Methode der *HTTP* Authentifikation welche
die Basis Authentifizierung erweitert indem ein Weg angeboten wird um sich zu Authentifizieren ohne dass das
Passwort im Klartext über das Netzwerk geschickt werden muß.

**Hauptsächliche Features:**

- Unterstützt sowohl Basis als auch Digest Authentifizierung.

- Enthält Aufrufe für alle unterstützten Schemas, damit Klienten mit jedem unterstützten Schema arbeiten
  können.

- Bietet Proxy Authentifizierung.

- Enthält Unterstützung für die Authentifizierung gegenüber Textdateien und bietet ein Interface für die
  Authentifizierung gegenüber anderen Quellen, wie z.B. Datenbanken.

Es gibt ein paar nennenswerte Features von *RFC-2617* die bis jetzt nicht implementiert wurden:

- Einstweilige Verfolgung, welche "stale" Support erlaubt und die Unterstützung bei wiederholenden Attacken
  erhöht.

- Authentifizierung mit Integritäts-Prüfung, oder "auth-int".

- Authentifizierungs-Info *HTTP* Header.

.. _zend.authentication.adapter.design_overview:

Design Übersicht
----------------

Dieser Adapter besteht aus zwei Sub-Komponenten, die *HTTP* Authentifizierungs Klasse selbst, und den sogenannten
"Auflöser". Die *HTTP* Authentifizierungs Klasse kapselt die Logik für die Ausführung beider, sowohl der Basis
als auch der Digest Authentifizierung. Sie verwendet einen Auflöser um die Identität eines Klienten in
Datenspeichern nachzusehen (standardmäßig eine Textdatei), und die Zeugnisse vom Datenspeicher zu empfangen. Die
"aufgelösten" Zeugnisse werden dann mit den Werten verglichen die vom Klienten übermittelt wurden um zu eruieren
ob die Authentifizierung erfolgreich war.

.. _zend.authentication.adapter.configuration_options:

Konfigurations Optionen
-----------------------

Die ``Zend\Auth\Adapter\Http`` Klasse benötigt ein Konfigurations Array das Ihrem Konstruktor übergeben werden
muß. Es sind verschiedene Konfigurations Optionen vorhanden, und einige davon werden benötigt:

.. _zend.authentication.adapter.configuration_options.table:

.. table:: Konfigurations Optionen

   +--------------+-------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Options Name  |Benötigt                             |Beschreibung                                                                                                                                                         |
   +==============+=====================================+=====================================================================================================================================================================+
   |accept_schemes|Ja                                   |Ermittelt welches Authentifizierungs Schema der Adapter vom Klienten akzeptiert. Muß eine Leerzeichen=getrennte Liste sein, die 'basic' und, oder 'digest' enthält.  |
   +--------------+-------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |realm         |Ja                                   |Setzt das Authentifizierungs-Bereich; Benutzernamen sollten im angegebenen Bereich einmalig sein.                                                                    |
   +--------------+-------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |digest_domains|Ja, wenn accept_schemesdigest enthält|Leerzeichen-getrennte Liste von URIs für welche die gleichen Authentifizierungs Informationen gültig sind. Die URIs müssen nicht alle auf den gleichen Server zeigen.|
   +--------------+-------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |nonce_timeout |Ja, wenn accept_schemesdigest enthält|Setzt die Anzahl an Sekunden für welche die Verfolgung gültig ist. Siehe die Notizen anbei.                                                                          |
   +--------------+-------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |proxy_auth    |Nein                                 |Standardmäßig ausgeschaltet. Einschalten um Proxi Authentifizierung durchzuführen statt normaler originaler Server Authentifizierung.                                |
   +--------------+-------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. note::

   Die aktuelle Implementation von ``nonce_timeout`` hat einige interessante Nebeneffekte. Diese Einstellung soll
   die gültige Lebenszeit einer gegebenen Verfolgung ermitteln, oder effektiv, wie lange die Authentifizierungs
   Information eines Klienten akzeptiert wird. Aktuell ist es auf 3600 (zum Beispiel) gesetzt, und führt dazu das
   der Klient jede Stunde um neue Zeugnisse gebeten wird. Das wird in einem zukünftigen Release behoben werden,
   sobald Verfolgung und "stale" Support implementiert werden.

.. _zend.authentication.adapter.http.resolvers:

Auflöser
--------

Der Job des Auflösers ist es einen Benutzernamen und einen Bereich, und gibt eine Art von Zeugnisswert zurück.
Basis Authentifizierung erwartet einen Hash des Benutzernamens, des Bereichs, und dessen Passwörter (jedes
seperiert durch ein Komma). Aktuell ist der einzige unterstützte Hash Algorithmus *MD5*.

``Zend\Auth\Adapter\Http`` ist darauf angewiesen das Objekte ``Zend\Auth\Adapter\Http\Resolver\Interface``
implementieren. Eine Textdatei Auflöser Klasse ist mit diesem Adapter inkludiert, aber jede Art von Auflöser kann
einfach erstellt werden indem das Resolver Interface implementiert wird.

.. _zend.authentication.adapter.http.resolvers.file:

Datei Auflöser
^^^^^^^^^^^^^^

Der Datei Auflöser ist eine sehr einfache Klasse. Sie hat eine einzelne Eigenschaft die einen Dateinamen
spezifiziert, welcher auch dem Konstruktor übergeben werden kann. Ihre ``resolve()`` Methode geht durch die
Textdatei, und sucht nach einer Zeile mit einem entsprechenden Benutzernamen und Bereich. Das Format der Textdatei
ist ähnlich dem von Apache htpasswd Dateien:

.. code-block:: text
   :linenos:

   <benutzername>:<bereich>:<zeugnisse>\n

Jede Zeile besteht aus drei Feldern - Benutzername, Bereich und Zeugnisse - jede abgeteilt durch einen Doppelpunkt.
Das Zeugnis Feld ist für den Datei Auflöser nicht sichtbar; es gibt den Wert einfach, wie er ist, an den Aufrufer
zurück. Deswegen kann dieses Dateiformat sowohl Basis als auch Digest Authentifizierung behandeln. In der Basis
Authentifizierung sollte das Zeugnis Feld im Klartext stehen. In der Digest Authentifizierung sollte es der oben
beschriebene *MD5* Hash sein.

Es gibt zwei gleiche einfache Wege um einen Datei Auflöser zu erstellen:

.. code-block:: php
   :linenos:

   $path     = 'files/passwd.txt';
   $resolver = new Zend\Auth\Adapter\Http\Resolver\File($path);

oder

.. code-block:: php
   :linenos:

   $path     = 'files/passwd.txt';
   $resolver = new Zend\Auth\Adapter\Http\Resolver\File();
   $resolver->setFile($path);

Wenn der angegebene Pfad leer oder nicht lesbar ist, wird eine Ausnahme geworfen.

.. _zend.authentication.adapter.http.basic_usage:

Grundsätzliche Verwendung
-------------------------

Zuerst muß ein Array mit den benötigen Konfigurationswerten gesetzt werden:

.. code-block:: php
   :linenos:

   $config = array(
       'accept_schemes' => 'basic digest',
       'realm'          => 'My Web Site',
       'digest_domains' => '/members_only /my_account',
       'nonce_timeout'  => 3600,
   );

Dieses Array bringt den Adapter dazu entwedet Basis oder Digest Authentifizierung zu akzeptieren, und benötigt
einen authentifizierten Zugriff auf alle Areale der Site unter ``/members_only`` und ``/my_account``. Der Bereichs
Wert wird normalerweise durch den Browser in der Passwort Dialog Box angezeigt. ``nonce_timeout`` verhält sich
natürlich so wie oben beschrieben.

Dann wird ein ``Zend\Auth\Adapter\Http`` Objekt erstellt:

.. code-block:: php
   :linenos:

   $adapter = new Zend\Auth\Adapter\Http($config);

Da beides, Basis und Digest Authentifizierung, unterstützt werden, werden zwei unterschiedliche
Auflösungs-Objekte benötigt. Man könnte das auch einfach durch die Verwendung von zwei unterschiedlichen Klassen
bewerkstelligen:

.. code-block:: php
   :linenos:

   $basicResolver = new Zend\Auth\Adapter\Http\Resolver\File();
   $basicResolver->setFile('files/basicPasswd.txt');

   $digestResolver = new Zend\Auth\Adapter\Http\Resolver\File();
   $digestResolver->setFile('files/digestPasswd.txt');

   $adapter->setBasicResolver($basicResolver);
   $adapter->setDigestResolver($digestResolver);

Letztendlich führen wir die Authentifizierung durch. Der Adapter benötigt eine Referenz zu beidem, dem Anfrage
und Antwort Objekten um seinen Job durchführen zu können:

.. code-block:: php
   :linenos:

   assert($request instanceof Zend\Controller\Request\Http);
   assert($response instanceof Zend\Controller\Response\Http);

   $adapter->setRequest($request);
   $adapter->setResponse($response);

   $result = $adapter->authenticate();
   if (!$result->isValid()) {
       // Schlechter Benutzername/Passwort, oder abgebrochener Passwort Prompt
   }



.. _`RFC-2617`: http://tools.ietf.org/html/rfc2617
.. _`Basis`: http://en.wikipedia.org/wiki/Basic_authentication_scheme
.. _`Digest`: http://en.wikipedia.org/wiki/Digest_access_authentication
