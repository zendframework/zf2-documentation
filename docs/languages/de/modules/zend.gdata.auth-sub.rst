.. EN-Revision: none
.. _zend.gdata.authsub:

Authentifizierung mit AuthSub
=============================

Der AuthSub Mechanismum erlaubt es Web Anwendungen zu schreiben die einen authentifizierten Zugang zu Google Data
Services benötigen, ohne das Code geschrieben werden muß der Benutzerzugangsdaten behandelt.

Siehe `http://code.google.com/apis/accounts/AuthForWebApps.html`_ für weitere Informationen über Google Data
AuthSub Authentifizierung.

Die Google Dokumentation sagt das der ClientLogin Mechanismum ausreichend für "installierte Anwendungen" ist, und
der AuthSub Mechanismum für "Web Anwendungen". Der Unterschied ist das AuthSub Interaktion vom Benutzer benötigt,
und ein Browser Interface das auf Umleitungsanfragen reagieren kann. Die ClientLogin Lösung verwendet *PHP* Code
um die Benutzerzugangsdaten anzubieten; der Benutzer wird nicht benötigt um seine Zugangsdaten einzugeben.

Die Zugangsdaten die über den AuthSub Mechanismum bereitgestellt werden, werden vom Benutzer über die Web
Anwendung eingegeben. Deswegen müssen es Zugangsdaten sein die dem Benutzer bekannt sind.

.. note::

   **Registrierte Anwendungen**

   ``ZendGData`` unterstützt aktuell die Verwendung von sicheren Tokens nicht, weil die AuthSub Authentifizierung
   die Übergabe von Digitalen Zertifikaten, um ein sicheres Token zu erhalten, nicht unterstützt.

.. _zend.gdata.authsub.login:

Einen AuthSub authentifizierten Http Clienten erstellen
-------------------------------------------------------

Die *PHP* Anwendung sollte einen Hyperlink zur Google *URL* bieten welche die Authentifizierung durchführt. Die
statische Funktion ``ZendGData\AuthSub::getAuthSubTokenUri()`` liefert die richtige *URL*. Die Argumente dieser
Funktion inkludieren die *URL* zur eigenen *PHP* Anwendung so das Google den Browser des Benutzers um zur eigenen
Anwendung zurück umleiten kann, nachdem die Benutzerdaten verifiziert wurden.

Nachdem Google's Authentifizierungs Server den Browser des Benutzers zur aktuellen Anwendung umgeleitet haben, wird
eine ``GET`` Anfrageparameter gesetzt der **token** heißt. Der Wert dieses Parameters ist ein einmal-verwendbarer
Token der für authentifizierten Zugriff verwendet werden kann. Dieser Token kann in einen mehrfach-verwendbaren
Token konvertiert und in der eigenen Session gespeichert werden.

Um den Token dann zu verwenden muß ``ZendGData\AuthSub::getHttpClient()`` aufgerufen werden. Diese Funktion gibt
eine Instanz von ``Zend\Http\Client`` zurück, mit gültigen Headern gesetzt, sodas eine nachfolgende Anfrage der
Anwendung, die diesen *HTTP* Clienten verwenden, auch authentifiziert sind.

Nachfolgend ist ein Beispiel von *PHP* Code für eine Web Anwendung um eine Authentifizierung zu erlangen damit der
Google Calender Service verwendet werden kann, und der ein ``ZendGData`` Client Objekt erstellt das diesen
authentifizierten *HTTP* Client verwendet.

.. code-block:: php
   :linenos:

   $my_calendar = 'http://www.google.com/calendar/feeds/default/private/full';

   if (!isset($_SESSION['cal_token'])) {
       if (isset($_GET['token'])) {
           // Ein einmal-verwendbarer Token kann in einen Session Token konvertiert werden
           $session_token =
               ZendGData\AuthSub::getAuthSubSessionToken($_GET['token']);
           // Speichert den Session Token in der Session
           $_SESSION['cal_token'] = $session_token;
       } else {
           // Zeigt einen Link zur Erstellung eines einmal-verwendbaren Tokens
           $googleUri = ZendGData\AuthSub::getAuthSubTokenUri(
               'http://'. $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'],
               $my_calendar, 0, 1);
           echo "Klicke <a href='$googleUri'>hier</a> um diese Anwendung " .
                "zu authorisieren.";
           exit();
       }
   }

   // Erstellt einen authentifizierten Http Client um mit Google zu sprechen
   $client = ZendGData\AuthSub::getHttpClient($_SESSION['cal_token']);

   // Erstellt ein Gdara Objekt das den authentifizierten Http Client verwendet
   $cal = new ZendGData\Calendar($client);

.. _zend.gdata.authsub.logout:

Beenden der AuthSub Authentifizierung
-------------------------------------

Um den authentifizierten Status eines gegebenen Status zu beenden, kann die statische Funktion
``ZendGData\AuthSub::AuthSubRevokeToken()`` verwendet werden. Andernfalls bleibt der Token noch für einige Zeit
gültig.

.. code-block:: php
   :linenos:

   // Vorsichtig den Wert erstellen um Sicherheitsprobleme mit der Anwendung zu vermeiden
   $php_self = htmlentities(substr($_SERVER['PHP_SELF'],
                            0,
                            strcspn($_SERVER['PHP_SELF'], "\n\r")),
                            ENT_QUOTES);

   if (isset($_GET['logout'])) {
       ZendGData\AuthSub::AuthSubRevokeToken($_SESSION['cal_token']);
       unset($_SESSION['cal_token']);
       header('Location: ' . $php_self);
       exit();
   }

.. note::

   **Sicherheitshinweise**

   Das Vermeiden der ``$php_self`` Variable im obigen Beispiel ist eine generelle Sicherheits Richtlinie, die nicht
   nur für ``ZendGData`` gilt. Inhalt der zu *HTTP* Headern ausgegeben wird sollte immer gefiltert werden.

   Betreffend der Beendigung des authentifizierten Tokens wird empfohlen dass dies gemacht wird, sobald der
   Benutzer mit seiner Google Data Session fertig ist. Die Möglichkeit das jemand das Token herausfindet und für
   seine eigenen miesen Zwecke verwendet ist sehr klein, aber trotzdem ist es eine gute Praxis einen
   authentifizierten Zugriff auf jegliche Services zu beenden.



.. _`http://code.google.com/apis/accounts/AuthForWebApps.html`: http://code.google.com/apis/accounts/AuthForWebApps.html
