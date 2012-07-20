.. _zend.service.developergarden:

Zend_Service_DeveloperGarden
============================

.. _zend.service.developergarden.introduction:

Einführung in DeveloperGarden
-----------------------------

Developer Garden ist der Name für die Entwicker Community der Deutschen Telekom. Developer Garden erlaubt den
Zugriff auf die zentralen Services der Deutschen Telekom, wie z.B. Sprache Verbindungen oder der Versand von SMS
Nachrichten über die Open Apis. Der Zugriff auf die *API* Services erfolgt über *SOAP* oder *REST*.

Die Familie der ``Zend_Service_DeveloperGarden`` Komponenten bietet ein klares und einfaches Interface zur
`DeveloperGarden API`_ und bietet zusätzlich Funktionalitäten um die Behandlung und Geschwindigkeit zu
verbessern.

- :ref:`BaseUserService <zend.service.developergarden.baseuserservice>`: Klasse um *API* Anteile sowie Details von
  Benutzerzugangsdaten zu managen.

- :ref:`IPLocation <zend.service.developergarden.iplocation>`: Lokalisiert die angegebene IP und gibt deren Geo
  Koordinaten zurück. Arbeitet nur mit IPs welche dem Netzwerk der Deutschen Telekom zugeordnet sind.

- :ref:`LocalSearch <zend.service.developergarden.localsearch>`: Erlaubt die Suche mit Optionen in der Nähe oder
  um eine gegebene Geo Koordinate oder Stadt herum.

- :ref:`SendSMS <zend.service.developergarden.sendsms>`: Sendet eine SMS oder Flash SMS zu einer gegebenen Nummer.

- :ref:`SMSValidation <zend.service.developergarden.smsvalidation>`: Prüft eine Nummer um Sie mit SendSMS zu
  verwenden und auch um einen Rückkanal zu unterstützen.

- :ref:`VoiceCall <zend.service.developergarden.voicecall>`: Initiiert alle Anrufe zwischen zwei Teilnehmern.

- :ref:`ConferenceCall <zend.service.developergarden.conferencecall>`: Man kann einen kompletten Konferenzraum mit
  Teilnehmern für eine AdHoc Konferenz konfigurieren oder auch eigene Konferenzen planen.

Die Backend SOAP *API* ist `hier`_ dokumentiert.

.. _zend.service.developergarden.account:

Für einen Zugang anmelden
^^^^^^^^^^^^^^^^^^^^^^^^^

Bevor man damit beginnen kann die DeveloperGarden *API* zu verwenden muss man sich erst für einen Zugang
`anmelden`_.

.. _zend.service.developergarden.environment:

Die Umgebung
^^^^^^^^^^^^

Mit der DeveloperGarden *API* hat man die Möglichkeit zwischen 3 unterschiedlichen Umgebungen zu wählen mit denen
gearbeitet werden kann.

- **production**: In der Produktionsumgebung muss man für Anrufe, SMS und andere Services zahlen.

- **sandbox**: Im Sandbox Modus kann man die selben Features, mit ein paar Einschränkungen, verwenden wir in der
  Produktion ohne für Sie zu zahlen. Normalerweise kann man die eigene Anwendung wärend der Entwicklung testen.

- **mock**: Die Mock Umgebung erlaubt es eigene Anwendungen zu bauen und Ergebnisse zu erhlaten ohne das irgendeine
  Aktion auf Seiten der *API* ausgelöst wird.

Für jede Umgebung und jedes Service sind einige spezielle Features (Optionen) zum Testen vorhanden. Sehen Sie
bitte `hier`_ nach Details.

.. _zend.service.developergarden.config:

Your configuration
^^^^^^^^^^^^^^^^^^

Man kann allen Klassen ein Array an Konfigurationswerten übergeben. Mögliche Werte sind:

- **username**: Der eigene Benutzername für die DeveloperGarden *API*.

- **password**: Das eigene Passwort für die DeveloperGarden *API*.

- **environment**: Die Umgebung welche man ausgewählt hat.

.. _zend.service.developergarden.config.example:

.. rubric:: Konfigurationsbeispiel

.. code-block:: php
   :linenos:

   require_once 'Zend/Service/DeveloperGarden/SendSms.php';
   $config = array(
       'username'    => 'meinBenutzername',
       'password'    => 'meinPasswort',
       'environment' => Zend_Service_DeveloperGarden_SendSms::ENV_PRODUCTION,
   );
   $service = new Zend_Service_DeveloperGarden_SendSms($config);

.. _zend.service.developergarden.baseuserservice:

BaseUserService
---------------

Diese Klasse kann verwendet werden um Quotenwerte fpr die Services zu setzen und zu holen sowie um Accountdetails
zu holen.

Die Methode ``getAccountBalance()`` kann ein Array von Account Id's mit dem aktuellen Kontostatus (Credits) holen.

.. _zend.service.developergarden.baseuserservice.getaccountbalance.example:

.. rubric:: Beispiel zum Holen des Kontostatus

.. code-block:: php
   :linenos:

   $service = new Zend_Service_DeveloperGarden_BaseUserService($config);
   print_r($service->getAccountBalance());

.. _zend.service.developergarden.baseuserservice.getquotainformation:

Holen von Quoteninformationen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Man kann mit den angebotenen Methoden Quoteninformationen für ein spezifisches Servicemodul holen.

.. _zend.service.developergarden.baseuserservice.getquotainformation.example:

.. rubric:: Beispiel zum Holen der Quoteninformation

.. code-block:: php
   :linenos:

   $service = new Zend_Service_DeveloperGarden_BaseUserService($config);
   $result = $service->getSmsQuotaInformation(
       Zend_Service_DeveloperGarden_BaseUserService::ENV_PRODUCTION
   );
   echo 'Sms Quote:<br />';
   echo 'Max Quote: ', $result->getMaxQuota(), '<br />';
   echo 'Max Benutzer Quote: ', $result->getMaxUserQuota(), '<br />';
   echo 'Quotenlevel: ', $result->getQuotaLevel(), '<br />';

Man erhält ein ``Result`` Objekt welches alle Informationen enthält die man benötigt. Optional kann der
``QuotaInformation`` Methode die Umgebungskonstante übergeben werden um die Quote für eine spezifische Umgebung
zu holen.

Hier ist eine Liste aller ``getQuotaInformation`` Methoden:

- ``getConfernceCallQuotaInformation()``

- ``getIPLocationQuotaInformation()``

- ``getLocalSearchQuotaInformation()``

- ``getSmsQuotaInformation()``

- ``getVoiceCallQuotaInformation()``

.. _zend.service.developergarden.baseuserservice.changequotainformation:

Quoteninformationen ändern
^^^^^^^^^^^^^^^^^^^^^^^^^^

Um die aktuelle Quote zu ändern kann eine der ``changeQuotaPool`` Methoden verwendet werden. Der erste Parameter
ist der neue Poolwert und der zweite ist die Umgebung.

.. _zend.service.developergarden.baseuserservice.changequotainformation.example:

.. rubric:: Beispiel zum Ändern der Quoteninformation

.. code-block:: php
   :linenos:

   $service = new Zend_Service_DeveloperGarden_BaseUserService($config);
   $result = $service->changeSmsQuotaPool(
       1000,
       Zend_Service_DeveloperGarden_BaseUserService::ENV_PRODUCTION
   );
   if (!$result->hasError()) {
       echo 'updated Quota Pool';
   }

Hier ist eine Liste aller ``changeQuotaPool`` Methoden:

- ``changeConferenceCallQuotaPool()``

- ``changeIPLocationQuotaPool()``

- ``changeLocalSearchQuotaPool()``

- ``changeSmsQuotaPool()``

- ``changeVoiceCallQuotaPool()``

.. _zend.service.developergarden.iplocation:

IP Lokalisierung
----------------

Dieser Service erlaubt es Lokalisierungsinformationen für eine gegebene IP Adresse zu erhalten.

Es gibt einige Einschränkungen:

- Die IP Adresse muss im T-Home Netzwerk sein

- Nur die nächste größere Stadt wird aufgelöst

- IPv6 wird aktuell nicht unterstützt

.. _zend.service.developergarden.iplocation.locateip.example:

.. rubric:: Eine gegebene IP lokalisieren

.. code-block:: php
   :linenos:

   $service = new Zend_Service_DeveloperGarden_IpLocation($config);
   $service->setEnvironment(
       Zend_Service_DeveloperGarden_IpLocation::ENV_MOCK
   );
   $ip = new Zend_Service_DeveloperGarden_IpLocation_IpAddress('127.0.0.1');
   print_r($service->locateIp($ip));

.. _zend.service.developergarden.localsearch:

Lokalsuche
----------

Der Lokalsuch Service bietet die lokale Suchmaschine `suchen.de`_ über ein Webservice Interface an. Für weitere
Details wird auf `die Dokumentation`_ verwiesen.

.. _zend.service.developergarden.localsearch.example:

.. rubric:: Ein Restaurant lokalisieren

.. code-block:: php
   :linenos:

   $service = new Zend_Service_DeveloperGarden_LocalSearch($config);
   $search  = new Zend_Service_DeveloperGarden_LocalSearch_SearchParameters();
   /**
    * @see http://www.developergarden.com/static/docu/en/ch04s02s06s04.html
    */
   $search->setWhat('pizza')
          ->setWhere('jena');
   print_r($service->localSearch($search));

.. _zend.service.developergarden.sendsms:

SMS senden
----------

Der SMS Versandservice wird verwendet um normale und Flash SMS zu beliebigen Nummern zu versenden.

Die folgenden Einschränkungen sind auf die Verwendung des SMS Service anzuwenden:

- Eine SMS oder Flash SMS darf in der Produktionsumgebung nicht länger als 765 Zeichen sein und darf maximal an 10
  Empfänger versendet werden.

- Eine SMS oder Flash SMS wird in der Sandboxumgebung gekürzt und mit einer Notiz in DeveloperGarden ausgestattet.
  Die maximale Länger der gesendeten Nachricht beträgt 160 Zeichen.

- In der Sandboxumgebug können maximal 10 SMS pro Tag versendet werden.

- Die folgenden Zeichen werden doppelt gezählt: ``| ^ € { } [ ] ~ \ LF`` (Zeilenumbruch)

- Wenn eine SMS oder Flash SMS länger als 160 Zeichen ist, wird immer für 153 weitere Zeichen eine Nachricht
  berechnet (Quote und Kredit).

- Die Zustellung kann für SMS oder Flsh SMS bei Festnetzanschlüssen nicht garantiert werden.

- Der Sender darf maximal aus 11 Zeichen bestehen. Erlaubte Zeichen sind Buchstaben und Zahlen.

- Die Spezifikation einer Telefonnummer als Sender ist nur erlaubt wenn die Telefonnummer geprüft wurde. (Siehe
  :ref:`SMS Prüfung <zend.service.developergarden.smsvalidation>`)

.. _zend.service.developergarden.sendsms.example:

.. rubric:: Senden einer SMS

.. code-block:: php
   :linenos:

   $service = new Zend_Service_DeveloperGarden_SendSms($config);
   $sms = $service->createSms(
       '+49-172-123456; +49-177-789012',
       'die Testnachricht',
       'meinName'
   );
   print_r($service->send($sms));
.. _zend.service.developergarden.smsvalidation:

SMS Prüfung
-----------

Der SMS Prüfservice erlaubt die Prüfung einer physikalischen Telefonnummer um diese als Sender einer SMS zu
verwenden.

Zuerst muss ``setValidationKeyword()`` aufgerufen werden um eine SMS mit einem Schlüsselwort zu empfangen.

Nachdem man sein Schlüsselwort erhalten hat, muss man ``validate()`` verwenden um die Nummer mit dem
Schlüsselwort gegen das Service zu prüfen.

Mit der Methode ``getValidatedNumbers()`` erhält man eine Liste aller bereits geprüften Nummern und den Status
einer jeden.

.. _zend.service.developergarden.smsvalidation.request.example:

.. rubric:: Prüfschlüsselwörter anfragen

.. code-block:: php
   :linenos:

   $service = new Zend_Service_DeveloperGarden_SmsValidation($config);
   print_r($service->sendValidationKeyword('+49-172-123456'));

.. _zend.service.developergarden.smsvalidation.validate.example:

.. rubric:: Eine Nummer mit einem Schlüsselwort prüfen

.. code-block:: php
   :linenos:

   $service = new Zend_Service_DeveloperGarden_SmsValidation($config);
   print_r($service->validate('DasSchlüsselWort', '+49-172-123456'));

Um eine geprüft Nummer als ungeprüft zu markieren muss die Methode ``inValidate()`` aufgerufen werden.

.. _zend.service.developergarden.voicecall:

Sprachanruf
-----------

Der Sprachanruf Service wird für das Setzen einer Sprachverbindung zwischen zwei Telefonverbindungen verwendet.
Für spezifische Details lesen Sie bitte die `API Dokumentation`_.

Normalerweise arbeitet der Service wie folgt:

- Den ersten Teilnehmer anrufen.

- Wenn die Verbindung erfolgreich war, den zweiten Teilnehmer anrufen.

- Wenn der zweite Teilnehmer erfolgreich verbunden ist, werden beide Teilnehmer miteinander verbunden.

- Der Anruf bleibt geöffnet bis einer der Teilnehmer auflegt oder der Ablaufmechanismus eingreift.

.. _zend.service.developergarden.voicecall.call.example:

.. rubric:: Zwei Nummern anrufen

.. code-block:: php
   :linenos:

   $service = new Zend_Service_DeveloperGarden_VoiceCall($config);
   $aNumber = '+49-30-000001';
   $bNumber = '+49-30-000002';
   $expiration  = 30;  // Sekunden
   $maxDuration = 300; // 5 Minuten
   $newCall = $service->newCall($aNumber, $bNumber, $expiration, $maxDuration);
   echo $newCall->getSessionId();

Wenn der Anruf initiiert wurde, kann das Ergebnisobjekt nach der Session ID gefragt werden und diese Session ID
für einen zusätzlichen Aufruf der Methoden ``callStatus`` oder ``tearDownCall()`` verwendet werden. Der zweite
Parameter der Methode ``callStatus()`` erweitert die Ablaufzeit für diesen Anruf.

.. _zend.service.developergarden.voicecall.teardown.example:

.. rubric:: Zwei Nummern anrufen, den Status abfragen und Trennen

.. code-block:: php
   :linenos:

   $service = new Zend_Service_DeveloperGarden_VoiceCall($config);
   $aNumber = '+49-30-000001';
   $bNumber = '+49-30-000002';
   $expiration  = 30; // Sekunden
   $maxDuration = 300; // 5 Minuten

   $newCall = $service->newCall($aNumber, $bNumber, $expiration, $maxDuration);

   $sessionId = $newCall->getSessionId();

   $service->callStatus($sessionId, true); // Den Anruf verlängern

   sleep(10); // 10s schlummern und dann tearDown

   $service->tearDownCall($sessionId);

.. _zend.service.developergarden.conferencecall:

ConferenceCall
--------------

Konferenzanruf erlaubt es eine Telefonkonferenz zu konfigurieren und zu starten.

Die folgenden Features sind vorhanden:

- Konferenzen mit einem sofortigen Start

- Konferenzen mit einem definierten Startdatum

- Wiederkehrende Konferenzserien

- Teilnehmer einer Konferenz hinzufügen, löschen und lautlos stellen

- Templates für Konferenzen

Hier ist eine Liste der aktuell implementierten *API* Methoden:

- ``createConference()`` erstellt eine neue Konferenz

- ``updateConference()`` aktualisiert eine existierende Konferenz

- ``commitConference()`` speichert die Konferenz, und wenn kein Datum konfiguriert wurde wird die Konferenz sofort
  gestartet

- ``removeConference()`` entfernt eine Konferenz

- ``getConferenceList()`` gibt eine Liste aller konfigurierten Konferenzen zurück

- ``getConferenceStatus()`` zeigt Informationen für eine existierende Konferenz an

- ``getParticipantStatus()`` zeigt Statusinformationen über einen Konferenzteilnehmer an

- ``newParticipant()`` erstellt einen neuen Teilnehmer

- ``addParticipant()`` fügt einen neuen Teilnehmer zu einer Konferenz hinzu

- ``updateParticipant()`` aktualisiert einen Teilnehmer, normalerweise um den Teilnehmer stumm zu schalten oder Ihn
  erneut anzurufen

- ``removeParticipant()`` entfernt einen Teilnehmer von einer Konferenz

- ``getRunningConference()`` fragt die laufende Instanz einer geplanten Konferenz ab

- ``createConferenceTemplate()`` erstellt ein neues Konferenztemplate

- ``getConferenceTemplate()`` fragt ein existierendes Konferenztemplate ab

- ``updateConferenceTemplate()`` aktualisiert die Details eines existierenden Konferenztemplates

- ``removeConferenceTemplate()`` entfernt ein Konferenztemplate

- ``getConferenceTemplateList()`` fragt alle Konferenztemplates eines Benutzers ab

- ``addConferenceTemplateParticipant()`` fügt einen Konferenzteilnehmer zu einem Konferenztemplate hinzu

- ``getConferenceTemplateParticipant()`` zeigt die Details des Teilnehmers eines Konferenztemplates an

- ``updateConferenceTemplateParticipant()`` aktualisiert die Details eines Teilnehmers in einem Konferenztemplate

- ``removeConferenceTemplateParticipant()`` entfernt einen Teilnehmer von einem Konferenztemplates

.. _zend.service.developergarden.conferencecall.example:

.. rubric:: Ad-Hoc Konferenz

.. code-block:: php
   :linenos:

   $client = new Zend_Service_DeveloperGarden_ConferenceCall($config);

   $conferenceDetails =
       new Zend_Service_DeveloperGarden_ConferenceCall_ConferenceDetail(
           'Zend-Conference',                    // Name der Konferenz
           'this is my private zend conference', // Beschreibung
           60                                    // Dauer in Sekunden
       );

   $conference = $client->createConference('MeinName', $conferenceDetails);

   $part1 = new Zend_Service_DeveloperGarden_ConferenceCall_ParticipantDetail(
       'Jon',
       'Doe',
       '+49-123-4321',
       'your.name@example.com',
       true
   );

   $client->newParticipant($conference->getConferenceId(), $part1);
   // add a second, third ... participant

   $client->commitConference($conference->getConferenceId());

.. _zend.service.developergarden.performance:

Geschwindigkeit und Cachen
--------------------------

Man kann verschiedene Cacheoptionen setzen um die Geschwindigkeit zu verbessern um WSDL und Authentifizierungs
Tokens aufzulösen.

Als erstes müssen die Cachewerte des internen SoapClients (PHP) eingestellt werden.

.. _zend.service.developergarden.performance.wsdlcache.example:

.. rubric:: WSDL Cacheoptionen

.. code-block:: php
   :linenos:

   Zend_Service_DeveloperGarden_SecurityTokenServer_Cache::setWsdlCache(
       [PHP KONSTANTE]
   );

Die ``[PHP KONSTANTE]`` kann eine der folgenden Werte enthalten:

- ``WSDL_CACHE_DISC``: aktiviert das Cachen auf Disk

- ``WSDL_CACHE_MEMORY``: aktiviert das Cachen im Speicher

- ``WSDL_CACHE_BOTH``: aktiviert das Cachen auf Disk und Speicher

- ``WSDL_CACHE_NONE``: deaktiviert beide Caches

Wenn man das Ergebnis der Aufrufe zum SecuritTokenServer cachen will kann man eine Instanz von ``Zend_Cache``
einrichten und diese an ``setCache()`` übergeben.

.. _zend.service.developergarden.performance.cache.example:

.. rubric:: Cacheoptionen für SecurityTokenServer

.. code-block:: php
   :linenos:

   $cache = Zend_Cache::factory('Core', ...);
   Zend_Service_DeveloperGarden_SecurityTokenServer_Cache::setCache($cache);



.. _`DeveloperGarden API`: http://www.developergarden.com
.. _`hier`: http://www.developergarden.com/openapi/dokumentation/
.. _`anmelden`: http://www.developergarden.com/register
.. _`suchen.de`: http://www.suchen.de
.. _`die Dokumentation`: http://www.developergarden.com/static/docu/en/ch04s02s06.html
.. _`API Dokumentation`: http://www.developergarden.com/static/docu/en/ch04s02.html
