.. EN-Revision: none
.. _zend.authentication.adapter.ldap:

LDAP Authentifizierung
======================

.. _zend.authentication.adapter.ldap.introduction:

Einführung
----------

``Zend\Auth\Adapter\Ldap`` unterstützt Webanwendungen bei der Authentifizierung mit *LDAP* Services. Die Features
beinhalten Kanonisierung von Benutzernamen und Domainnamen, Mehrfach-Domain Authentifizierung, und
Fehlerbehandlungs Features. Es wurde getestet mit `Microsoft Active Directory`_ und `OpenLDAP`_, sollte auch mit
anderen *LDAP* Service Provider zusammenarbeiten.

Diese Dokumentation enthält eine Anleitung der Verwendung von ``Zend\Auth\Adapter\Ldap``, eine Beschreibung der
*API*, eine Ausgabe der verschiedenen Optionen, Diagnostische Informationen für die Fehlerbehandlung bei
Authentifizierungs Problemen, und Beispiel Optionen für beide, Active Directory und OpenLDAP Server.

.. _zend.authentication.adapter.ldap.usage:

Verwendung
----------

Um ``Zend\Auth\Adapter\Ldap`` Authentifizierung in eigene Anwendungen schnell einzubauen, selbst wenn
``Zend_Controller`` nicht verwendet wird, sollte das Fleisch des eigenen Codes in etwa wie folgt aussehen:

.. code-block:: php
   :linenos:

   $username = $this->_request->getParam('username');
   $password = $this->_request->getParam('password');

   $auth = Zend\Auth\Auth::getInstance();

   $config = new Zend\Config\Ini('../application/config/config.ini',
                                 'production');
   $log_path = $config->ldap->log_path;
   $options = $config->ldap->toArray();
   unset($options['log_path']);

   $adapter = new Zend\Auth\Adapter\Ldap($options, $username,
                                         $password);

   $result = $auth->authenticate($adapter);

   if ($log_path) {
       $messages = $result->getMessages();

       $logger = new Zend\Log\Log();
       $logger->addWriter(new Zend\Log\Writer\Stream($log_path));
       $filter = new Zend\Log\Filter\Priority(Zend\Log\Log::DEBUG);
       $logger->addFilter($filter);

       foreach ($messages as $i => $message) {
           if ($i-- > 1) { // $messages[2] und höher sind Log Nachrichten
               $message = str_replace("\n", "\n  ", $message);
               $logger->log("Ldap: $i: $message", Zend\Log\Log::DEBUG);
           }
       }
   }

Natürlich ist der Logging Code optional, aber es wird dringend empfohlen einen Logger zu verwenden.
``Zend\Auth\Adapter\Ldap`` zeichnet fast jedes Bisschen an Information in ``$messages`` auf das irgendwer
benötigen können (mehr anbei), was allerdings selbst ein nettes Feature für jemanden als History ist, kann
überaus schwierig zu debuggen sein.

Der ``Zend\Config\Ini`` wird oben verwendet um die Optionen des Adapters zu laden. Er ist also auch optional. Ein
reguläres Array würde genauso gut arbeiten. Das folgende ist eine Beispiel ``application/config/config.ini``
Datei die Optionen für zwei separate Server hat. Mit mehreren Sets von Server Optionen versucht der Adapter jede
in Reihenfolge bis die Zugangsdaten erfolgreich authentifiziert wurden. Die Namen der Server (z.B., 'server1' und
'server2') sind sehr verallgemeinert. Für Details betreffend dem Array für Optionen, siehe das Kapitel über
**Server Optionen** weiter unten. Es ist zu beachten das ``Zend\Config\Ini`` jeden Wert der mit Gleichheitszeichen
(**=**) geschrieben wird auch unter Anführungszeichen gesetzt wird (wie unten bei DNs gezeigt).

.. code-block:: ini
   :linenos:

   [production]

   ldap.log_path = /tmp/ldap.log

   ; Typische Optionen für OpenLDAP
   ldap.server1.host = s0.foo.net
   ldap.server1.accountDomainName = foo.net
   ldap.server1.accountDomainNameShort = FOO
   ldap.server1.accountCanonicalForm = 3
   ldap.server1.username = "CN=user1,DC=foo,DC=net"
   ldap.server1.password = pass1
   ldap.server1.baseDn = "OU=Sales,DC=foo,DC=net"
   ldap.server1.bindRequiresDn = true

   ; Typische Optionen für Active Directory
   ldap.server2.host = dc1.w.net
   ldap.server2.useStartTls = true
   ldap.server2.accountDomainName = w.net
   ldap.server2.accountDomainNameShort = W
   ldap.server2.accountCanonicalForm = 3
   ldap.server2.baseDn = "CN=Users,DC=w,DC=net"

Die obige Konfiguration instruiert ``Zend\Auth\Adapter\Ldap`` das es versuchen soll Benutzer zuerst mit dem
OpenLDAP Server ``s0.foo.net`` authentifizieren soll. Wenn die Authentifizierung auf irgendeinem Grund
fehlschlägt, wird der AD Server ``dc1.w.net`` versucht.

Mit Servern in verschiedenen Domains, zeigt diese Konfiguration Multi-Domain Authentifizierung. Es können auch
mehrere Server in der gleichen Domain sein um Redundanz anzubieten.

In diesem Fall ist zu beachten das, selbst wenn OpenLDAP keine Notwendigkeit für kurze NetBIOS Stil Domainnamen
hat die von Windows verwendet werden bieten wir Sie hier an wegen der Kanonifizierung der Namen (beschrieben im
**Kanonifizierung von Benutzernamen** Kapitel anbei).

.. _zend.authentication.adapter.ldap.api:

Die API
-------

Der ``Zend\Auth\Adapter\Ldap`` Konstruktor akzeptiert drei Parameter.

Der ``$options`` Parameter wird benötigt und muß ein Array sein das ein oder mehrere Sets von Optionen enthält.
Es ist zu beachten das es sich um **Array von Arrays** von :ref:`Zend_Ldap <zend.ldap>` Optionen handelt. Selbst
wenn nur ein einzelner *LDAP* Server verwendet wird, müssen die Optionen trotzdem in einem anderen Array sein.

Anbei ist eine `print_r()`_ Ausgabe von beispielhaften Optionsparameters die zwei Sets von Serveroptionen für
*LDAP* Server enthalten, ``s0.foo.net`` und ``dc1.w.net`` (die gleichen Optionen wie in der oberen *INI*
Repräsentation):

.. code-block:: console
   :linenos:

   Array
   (
       [server2] => Array
           (
               [host] => dc1.w.net
               [useStartTls] => 1
               [accountDomainName] => w.net
               [accountDomainNameShort] => W
               [accountCanonicalForm] => 3
               [baseDn] => CN=Users,DC=w,DC=net
           )

       [server1] => Array
           (
               [host] => s0.foo.net
               [accountDomainName] => foo.net
               [accountDomainNameShort] => FOO
               [accountCanonicalForm] => 3
               [username] => CN=user1,DC=foo,DC=net
               [password] => pass1
               [baseDn] => OU=Sales,DC=foo,DC=net
               [bindRequiresDn] => 1
           )

   )

Die oben angebotene Information in jedem Set von Optionen ist hauptsächlich deswegen unterschiedlich weil AD
keinen Benutzernamen wärend des Bindesn in der DN Form benötigt (siehe die ``bindRequiresDn`` Option des **Server
Optionen** Kapitels weiter unten), was bedeutet das die Anzahl der, mit dem Empfangen der DN, für einen
Benutzernamen der Authentifiziert werden soll, assoziierten Optionen, unterdrückt werden kann.

.. note::

   **Was ist ein ausgezeichneter Name?**

   Ein DN oder "distinguished name" ist ein String der den Pfad zu einem Objekt im *LDAP* Verzeichnis
   repräsentiert. Jede komma-seperierte Komponente ist ein Attribut und Wert der einen Node repräsentiert. Die
   Komponenten werden rückwirkend evaluiert. Zum Beispiel ist der Benutzeraccount **CN=Bob
   Carter,CN=Users,DC=w,DC=net** direkt in **CN=Users,DC=w,DC=net container** enthalten. Diese Struktur wird am
   besten mit einem *LDAP* Browser wie das *ADSI* Edit *MMC* snap-in für Active Directory oder phpLDAPadmin
   erkundet.

Die Namen von Servern (z.B. 'server1' und 'server2' wie unten gezeigt) sind großteils beliebig, aber aus Gründen
der Verwendung von ``Zend_Config`` sollten die Identifikatoren (im Gegensatz dazu das Sie nummerische Indezes sind)
vorhanden sein, und sollten keine spezielle Zeichen enthalten die vom assoziierten Dateiformat verwendet werden
(z.B. der '**.**'*INI* Eigenschafts Separator, '**&**' für *XML* Entity Referenzen, usw.).

Mit mehreren Sets von Serveroptionen, kann der Adapter Benutzer in mehreren Domains authentifizieren und bietet ein
Failover damit, wenn ein Server nicht erreichbar ist, ein anderer abgefragt wird.

.. note::

   **Die glorreichen Details: Was passiert bei der Authentifizierungs Methode?**

   Wenn die ``authenticate()`` Methode aufgerufen wird, iteriert der Adapter über jedes Set von Serveroptione,
   setzt diese auf der internen ``Zend_Ldap`` Instanz und ruft die ``Zend\Ldap\Ldap::bind()`` Methode, mit dem
   Benutzernamen und Passwort das authentifiziert werden soll, auf. Die ``Zend_Ldap`` Klasse prüft um zu sehen ob
   der Benutzer mit einer Domain qualifiziert ist (hat z.B. eine Domainkomponente wie ``alice@foo.net`` oder
   ``FOO\alice``). Wenn eine Domain vorhanden ist, aber mit keiner der Domainnamen der Server (``foo.net`` oder
   *FOO*) übereinstimmt, wird eine spezielle Ausnahme geworfen und durch ``Zend\Auth\Adapter\Ldap`` gefangen, was
   bewirkt das der Server ignoriert wird und der nächste, in den Serveroptionen gesetzte Server, ausgewählt wird.
   Wenn eine Domain **doch** passt, oder der Benutzer keinen qualifizierten Benutzernamen angegeben hat, fährt
   ``Zend_Ldap`` weiter fort und versucht mit den angegebenen Zugangsdaten zu binden. Wenn das Binden nicht
   erfolgreich war wirft ``Zend_Ldap`` eine ``Zend\Ldap\Exception`` welche durch ``Zend\Auth\Adapter\Ldap``
   gefangen wird, und das nächste Set von Serveroptionen wird versucht. Wenn das Binden erfolgreich war, wird die
   Iteration gestoppt, und die ``authenticate()`` Methode des Adapters gibt ein erfolgreiches Ergebnis zurück.
   Wenn alle Serveroptionen ohne Erfolg durchprobiert wurden, schlägt die Authentifizierung fehl, und
   ``authenticate()`` gibt ein Fehlerergebnis zurück mit der Fehlermeldung der letzten Iteration.

Die username und password Parameter des ``Zend\Auth\Adapter\Ldap`` Konstruktors repräsentieren die Zugangsdaten
die authentifiziert werden sollen (z.B. die Zugangsdaten die durch den Benutzer über eine *HTML* Login Form
angegeben werden). Alternativ können Sie auch mit den ``setUsername()`` und ``setPassword()`` Methoden gesetzt
werden.

.. _zend.authentication.adapter.ldap.server-options:

Server Optionen
---------------

Jedes Set von Serveroptionen **im Kontext von Zend\Auth\Adapter\Ldap** besteht aus den folgenden Optionen welche,
großteils ungeändert, an ``Zend\Ldap\Ldap::setOptions()`` übergeben werden:

.. _zend.authentication.adapter.ldap.server-options.table:

.. table:: Server Optionen

   +----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Name                  |Beschreibung                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
   +======================+=====================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
   |host                  |Der Hostname des LDAP Servers der diese Optionen repräsentiert. Diese Option wird benötigt.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
   +----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |port                  |Der Port auf den der LDAP Server schaut. Wenn useSslTRUE ist, ist der Standardwert von port 636. Wenn useSslFALSE ist, ist der Standardwert von port 389.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
   +----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |useStartTls           |Ob der LDAP Client einen TSL (aka SSLv2) verschlüsselten Transport verwenden soll oder nicht. Der Wert TRUE wird in einer Produktionsumgebung strengstens empfohlen um zu verhindern das Passwörter im Klartext übertragen werden. Der Standardwert ist FALSE, da Server typischerweise nach deren Installation erwarten das ein Zertifikat installiert wird. Die useSsl und useStartTls Optionen schließen sich gegenseitig aus. Die useStartTls Option sollte über useSsl favorisiert werden, aber nicht alle Server unterstützen diesen neueren Mechanismus.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
   +----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |useSsl                |Ob der LDAP Client einen SSL verschlüsselten Transport verwenden soll. Die useSsl und useStartTls Optionen schließen sich gegenseitig aus, aber useStartTls sollte favorisiert werden wenn der Server und die LDAP Bibliothek des Clients diese unterstützen. Dieser Wert ändert auch den Standardwert von port (siehe die port Beschreibung weiter oben).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
   +----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |username              |Der DN des Accounts der verwendet wird um DN Account Loopups durchzuführen. LDAP Server die den Benutzernamen in DN Form benötigen wenn "bind" durchgeführt wird, benötigen diese Option. Wenn bindRequiresDnTRUE ist, wird diese Option benötigt. Dieser Account muß kein privilegierter Account sein - ein Account mit nur-lese Zugriff zu Objekten unter baseDn ist alles was notwendig ist (und bevorzugt unter dem Prinzip des geringsten Privilegs).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
   +----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |password              |Das Passwort des Accounts der verwendet wird um DN Lookups durchzuführen. Wenn diese Option nicht unterstützt wird, versucht der LDAP Client einen "anonymen bind" wenn DN Lookups durchgeführt werden.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
   +----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |bindRequiresDn        |Einige LDAP Server benötigen den zum Binden verwendeten Benutzernamen in der DN Form wie CN=Alice Baker,OU=Sales,DC=foo,DC=net (grundsätzlich alle Server außer AD). Wenn diese Option TRUE ist, instuiert dies Zend_Ldap das der DN automatisch empfangen wird, abhängig vom Benutzernamen der authentifiziert wird, wenn er nicht bereits in DN Form ist, und diesen dann wieder mit der richtigen DN zu binden. Der Standardwert ist FALSE. Aktuell ist nur von Microsoft Active Directory Server (ADS) bekannt das es den Benutzernamen nicht in der DN Form benötigt wenn gebunden wird, und deswegen kann diese Option mit AD auch FALSE sein (und sollte das auch, da das Empfangen des DN eine extra Anfrage zum Server benötigt). Andernfalls muß diese Option auf TRUE gesetzt werden (z.B. für OpenLDAP). Diese Option kontrolliert das Standard acountFilterFormat das verwendet wird wenn nach Accounts gesucht wird. Siehe auch die accountFilterFormat Option.                                                                                                                                                                                                                                                                                                                        |
   +----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |baseDn                |Der Ort vom DN unter dem alle Accounts die authentifiziert werden. Diese Option wird benötigt. Wenn man sich unsicher über den richtigen baseDn ist, sollte es genug sein Ihn von der DNS Domain des Benutzers der die DC= Komponenten verwedet abzuleiten. Wenn der Hauptname eines Benutzers alice@foo.net ist, sollte ein baseDn von DC=foo,DC=net funktionieren. Eine präzisere Ortsangabe (z.B. OU=Sales,DC=foo,DC=net) ist trotzdem effizienter.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
   +----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |accountCanonicalForm  |Ein Wert von 2, 3 oder 4 zeigt die Form zu der Account Namen authorisiert werden sollten nachdem die Authentifizierung erfolgreich war. Die Werte sind wie folgt: 2 für traditionelle Benutzernamen-Stil Namen (z.B., alice), 3 für Schrägstrich-Stil Namen (z.B., FOO\\alice) oder 4 für Authentifiziert-Sil Namen (z.B., alice@foo.net). Der Standardwert ist 4 (z.B., alice@foo.net). Mit einem Wert von 3, z.B., wird die Identität die von Zend\Auth\Result::getIdentity() zurückgegeben wird (und Zend\Auth\Auth::getIdentity(), wenn Zend_Auth verwendet wird), immer FOO\\alice sein, unabhängig von der Form in der Alice angegeben wurde, egal ob es alice, alice@foo.net, FOO\\alice, FoO\\aLicE, foo.net\\alice, etc. Siehe das Kapitel Kanonisierung von Account Namen in der Zend_Ldap Dokumentation für Details. Bei der Verwendung von mehreren Sets von Serveroptionen ist es empfehlenswert, aber nicht notwendig, das die selbe accountCanonicalForm in allen Serveroptionen verwendet wird, sodas die sich ergebenden Benutzernamen immer auf die selbe Art und Weise kanonisiert werden (z.b. wenn man auf EXAMPLE\\username mit einem AD Server kanonisiert, aber zu username@example.com mit einem OpenLDAP Server, kann das quirks für die High-Level Logik einer Anwendung sein).|
   +----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |accountDomainName     |Der FQDN Domainname für welchen der Ziel LDAP Server eine Authorität ist (z.B., example.com). Diese Option wird verwendet um Namen zu kanonisieren sodas der Benutzername der vom Benutzer angeboten wird, wie es für das Binden notwendig ist, konvertiert werden kann. Er wird auch verwendet um festzustellen ob der Server eine Authorität für den angegebenen Benutzernamen ist (z.B., wenn accountDomainNamefoo.net ist und der angegebene Benutzer bob@bar.net, wird der Server nicht abgefragt, und das Ergebnis wird ein Fehler sein). Diese Option wird nicht benötigt, aber wenn Sie nicht angegeben wird, dann werden Benutzernamen in prinzipieller Namensform (z.B., alice@foo.net) nicht unterstützt. Es wird stark empfohlen das diese Option angegeben wird, da es viele Anwendungsfälle gibt welche die Erstellung von prinzipieller Namensform benötigen.                                                                                                                                                                                                                                                                                                                                                                                                                         |
   +----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |accountDomainNameShort|Die 'short' Domain für die der Ziel LDAP Server eine Authorität ist (z.B., FOO). Es ist z ubeachten das es ein 1:1 Mapping zwischen accountDomainName und accountDomainNameShort existiert. Diese Option sollte verwendet werden um den NetBIOS Domainnamen für Windows Netzwerke zu spezifizieren, kann aber auch von nicht-AD Servern verwendet werden (z.B., für Konsistenz bei mehreren Sets von Serveroptionen bei dem Schrägstrich Stil accountCanonicalForm). Diese Option wird nicht benötigt, aber wenn Sie nicht angegeben wird, werden Benutzernamen im Schrägstrich Stil (z.B. FOO\\alice) nicht unterstützt.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
   +----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |accountFilterFormat   |Der LDAP Suchfilter der für die Suche nach Accounts verwendet wird. Dieser String ist ein printf()-Stil Ausdruck der ein '%s' enthalten muß um den Benutzernamen unterzubringen. Der Standardwert ist '(&(objectClass=user)(sAMAccountName=%s))', ausgenommen bindRequiresDn wird auf TRUE gesetzt. In diesem Fall ist der Standardwert '(&(objectClass=posixAccount)(uid=%s))'. Wenn, zum Beispiel, aus irgendeinem Grund bindRequiresDn = true mit AD verwendet werden soll, muß accountFilterFormat = '(&(objectClass=user)(sAMAccountName=%s))' gesetzt werden.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
   +----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |optReferrals          |Wenn sie auf TRUE gesetzt wird, zeigt diese Option dem LDAP Client an, das Referenzen gefolgt werden soll. Der Standardwert ist FALSE.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
   +----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. note::

   Wenn **useStartTls = TRUE** oder **useSsl = TRUE** aktiviert ist, erzeugt der *LDAP* Client einen Fehler der
   aussagt das er das Zertifikat des Servers nicht überprüfen kann. Angenommen die *PHP* *LDAP* Erweiterung ist
   ultimativ verlinkt mit der OpenLDAP Client Bibliothek, muß man um dieses Problem zu lösen "``TLS_REQCERT
   never``" im OpenLDAP Client ``ldap.conf`` setzen (und den Web Server restarten) um der OpenLDAP Client
   Bibliothek anzuzeigen das man dem Server vertraut. Alternativ, wenn man annimmt das der Server gehackt werden
   könnte kann das Basiszertifikat des *LDAP* Servers exportiert und auf den Webserver gegeben werden so dass der
   OpenLDAP Client die Identität des Servers prüfen kann.

.. _zend.authentication.adapter.ldap.debugging:

Debug Nachrichten sammeln
-------------------------

``Zend\Auth\Adapter\Ldap`` sammelt Debug Informationen in seiner ``authenticate()`` Methode. Diese Information wird
im ``Zend\Auth\Result`` Objekt als Nachrichten gespeichert. Das von ``Zend\Auth\Result::getMessages()``
zurückgegebene Array kann wie folgt beschrieben werden:

.. _zend.authentication.adapter.ldap.debugging.table:

.. table:: Debug Nachrichten

   +-------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Array Index der Nachricht|Beschreibung                                                                                                                                                                                                                            |
   +=========================+========================================================================================================================================================================================================================================+
   |Index 0                  |Eine generelle, Benutzerfreundliche Meldung die für die Anzeige für Benutzer passt (z.B. "Ungültige Anmeldedaten"). Wenn die Authentifizierung erfolgreich ist, dann ist dieser String leer.                                            |
   +-------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Index 1                  |Eine detailiertere Fehlermeldung die nicht für die Anzeige für Benutzer hergenommen werden kann, die aber mitgeloggt werden sollte zum Vorteil des Server Operators. Wenn die Authentifizierung erfolgreich war, ist dieser String leer.|
   +-------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Indezes 2 und höher      |Alle Logmeldungen in Reihenfolge starten bei Index 2.                                                                                                                                                                                   |
   +-------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Aus der Praxis heraus sollte der Index 0 dem Benutzer angezeigt werden (z.B. bei Verwendung des FlashMessenger
Helfers), Index 1 sollte geloggt werden und, wenn die Debugging Information gesammelt wird, sollten die Indezes 2
und höher auch geloggt werden (auch wenn die letzte Nachricht immer den String vom Index 1 enthält).

.. _zend.authentication.adapter.ldap.options-common-server-specific:

Übliche Optionen für spezielle Server
-------------------------------------

.. _zend.authentication.adapter.ldap.options-common-server-specific.active-directory:

Optionen für Active Directory
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Für *ADS* sind die folgenden Optionen beachtenswert:

.. _zend.authentication.adapter.ldap.options-common-server-specific.active-directory.table:

.. table:: Optionen für Active Directory

   +----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Name                  |Zusätzliche Notizen                                                                                                                                                                                                                                                                                                                                                                                                                                           |
   +======================+==============================================================================================================================================================================================================================================================================================================================================================================================================================================================+
   |host                  |Wie bei allen Servern, wird diese Option benötigt.                                                                                                                                                                                                                                                                                                                                                                                                            |
   +----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |useStartTls           |Zum Zwecke der Sicherheit, sollte das TRUE sein wenn der Server das notwendige Zertifikat installiert hat.                                                                                                                                                                                                                                                                                                                                                    |
   +----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |useSsl                |Möglicherweise als Alternative zu useStartTls zu verwenden (siehe davor).                                                                                                                                                                                                                                                                                                                                                                                     |
   +----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |baseDn                |Wie bei allen Servern, wird diese Option benötigt. Standardmäßig platziert AD alle Benutzer Accounts unter dem Users Container (z.B., CN=Users,DC=foo,DC=net), aber der Standard ist in größeren Organisationen nicht üblich. Der AD Administrator sollte nach der besten DN für Accounts für die eigene Anwendung gefragt werden.                                                                                                                            |
   +----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |accountCanonicalForm  |Das wird man normalerweise für Schrägstrich-Stil Namen auf 3 stellen (z.B., FOO\\alice), was für Windows Benutzer am bekanntesten ist. Man sollte nicht die unqualifizierte Form 2 verwenden (z.B., alice), da das anderen Benutzern Zugriff auf die Anwendung geben würde, wenn Sie den gleichen Benutzernamen in anderen vertrauten Domains haben (z.B., BAR\\alice und FOO\\alice würden als der gleiche Benutzer behandelt). (siehe auch die Notiz anbei.)|
   +----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |accountDomainName     |Das wird mit AD benötigt, ausser accountCanonicalForm 2 wird verwendet, was wiederum nicht eingesetzt werden sollte.                                                                                                                                                                                                                                                                                                                                          |
   +----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |accountDomainNameShort|Der NetBIOS Name der Domain in der die Benutzer sind und für den der AD Server die Authorität ist. Das wird benötigt wenn der Schrägstrich-Stil accountCanonicalForm verwendet wird.                                                                                                                                                                                                                                                                          |
   +----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. note::

   Technisch sollte es keine Probleme mit irrtümlichen Domain-übergreifenden Authentifizierungen mit der
   aktuellen ``Zend\Auth\Adapter\Ldap`` Implementation geben, da Serverdomains explizit geprüft werden, aber das
   muss für zukünftige Implementationen, welche die Domain wärend der Laufzeit ermitteln, nicht wahr sein, oder
   auch wenn ein alternativer Adapter verwendet wird (z.B., Kerberos). Generell ist bekannt das die Mehrdeutigkeit
   von Accountnamen ein Sicherheitsproblem ist. Man sollte deswegen immer versuchen qualifizierte Accountnamen zu
   verwenden.

.. _zend.authentication.adapter.ldap.options-common-server-specific.openldap:

Optionen für OpenLDAP
^^^^^^^^^^^^^^^^^^^^^

Für OpenLDAP oder einen generellen *LDAP* Server der ein typisches posixAccount Stil Schema verwendet sind die
folgenden Optionen beachtenswert:

.. _zend.authentication.adapter.ldap.options-common-server-specific.openldap.table:

.. table:: Optionen für OpenLDAP

   +----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Name                  |Zusätzliche Notizen                                                                                                                                                                                                                                                                                                            |
   +======================+===============================================================================================================================================================================================================================================================================================================================+
   |host                  |Wie bei allen Servern, wird diese Option benötigt.                                                                                                                                                                                                                                                                             |
   +----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |useStartTls           |Zum Zwecke der Sicherheit, sollte das TRUE sein wenn der Server das notwendige Zertifikat installiert hat.                                                                                                                                                                                                                     |
   +----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |useSsl                |Möglicherweise als Alternative zu useStartTls zu verwenden (siehe davor).                                                                                                                                                                                                                                                      |
   +----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |username              |Benötigt und muß ein DN sein, da OpenLDAP den Benutzernamen in DN Form benötigt wenn ein Binden durchgeführt wird. Es sollte versucht werden einen nicht privilegierten Account zu verwenden.                                                                                                                                  |
   +----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |password              |Das Passwort das zum Benutzernamen von oben gehört. Es kann aber unterdrückt werden wenn der LDAP Server anonymes Binden bei Abfragen zu Benutzer Accounts erlaubt.                                                                                                                                                            |
   +----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |bindRequiresDn        |Benötigt und muß TRUE sein, da OpenLDAP den Benutzernamen in DN Form benötigt wenn ein Binden durchgeführt wird.                                                                                                                                                                                                               |
   +----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |baseDn                |Wie bei allen Servern, wird diese Option benötigt und zeigt den DN in dem alle Accounts die authentifiziert werden enthalten sind.                                                                                                                                                                                             |
   +----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |accountCanonicalForm  |Optional, aber der Standardwert ist 4 (prinzipielle-Stil Namen wie alice@foo.net) und könnte für die Benutzer nicht ideal sein wenn diese Schrägstrich-Stil Namen verwendetn (z.B., FOO\\alice). Für Schrägstrich-Stil Namen sollte der Wert 3 verwendet werden.                                                               |
   +----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |accountDomainName     |Benötigt es sei denn man verwendet accountCanonicalForm 2, was nicht zu empfehlen ist.                                                                                                                                                                                                                                         |
   +----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |accountDomainNameShort|Wenn AD auch nicht verwendet wird, wird dieser Wert nicht benötigt. Andernfalls, wenn accountCanonicalForm 3 verwendet wird, wird diese Option benötigt und sollte ein Kurzname sein der adäquat zu accountDomainName korrespondiert (z.B., wenn accountDomainNamefoo.net ist, wäre ein guter accountDomainNameShort Wert FOO).|
   +----------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _`Microsoft Active Directory`: http://www.microsoft.com/windowsserver2003/technologies/directory/activedirectory/
.. _`OpenLDAP`: http://www.openldap.org/
.. _`print_r()`: http://php.net/print_r
