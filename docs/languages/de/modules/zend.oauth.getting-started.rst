.. EN-Revision: none
.. _zend.oauth.introduction.getting-started:

Beginnen
========

Da das OAuth Protokoll jetzt erklärt wurde sehen wir uns ein einfaches Beispiel mit Quellcode an. Unser neuer
Konsument wird Twitter Statusübertragungen verwenden. Um das tun zu können muss er bei Twitter registriert sein
um einen OAuth Konsumentenschlüssel und ein Konsumentengeheimnis zu empfangen. Diese werden verwendet um einen
Zugriffstoken zu erhalten bevor wir die Twitter *API* verwenden um eine Statusmeldung zu schicken.

Angenommen wir haben einen Schlüssel und ein Geheimnis bekommen, dann können wir den OAuth Workflow starten indem
eine ``ZendOauth\Consumer`` Instanz wie folgt eingerichtet und eine Konfiguration übergeben wird (entweder ein
Array oder ein ``Zend_Config`` Objekt).

.. code-block:: php
   :linenos:

   $config = array(
       'callbackUrl' => 'http://example.com/callback.php',
       'siteUrl' => 'http://twitter.com/oauth',
       'consumerKey' => 'gg3DsFTW9OU9eWPnbuPzQ',
       'consumerSecret' => 'tFB0fyWLSMf74lkEu9FTyoHXcazOWpbrAjTCCK48A'
   );
   $consumer = new ZendOauth\Consumer($config);

callbackUrl ist die URI von der wir wollen das Sie Twitter von unserem Server anfragt wenn Informationen gesendet
werden. Wir sehen uns das später an. siteUrl ist die Basis URL der OAuth *API* Endpunkte von Twitter. Die
komplette Liste der Endpunkt enthält http://twitter.com/oauth/request_token, http://twitter.com/oauth/access_token
und http://twitter.com/oauth/authorize. Die grundsätzliche siteUrl verwendet eine Konvention welche auf diese drei
OAuth Endpunkte verweist (als Standard) um einen Anfragetoken, den Zugriffstoken oder die Authorisierung zu
erhalten. Wenn sich der aktuelle Endpunkt eines beliebigen Services vom Standardset unterscheidet, dann können
diese drei URIs separat gesetzt werden indem die Methoden ``setRequestTokenUrl()``, ``setAccessTokenUrl()``, und
``setAuthorizeUrl()``, oder die Konfigurationsfelder requestTokenUrl, accessTokenUrl und authorizeUrl verwendet
werden.

consumerKey und consumerSecret werden von Twitter empfangen wenn sich die eigene Anwendung für den OAuth Zugriff
registriert. Das wird auch bei jedem OAuth aktivierten Service so angewendet, so dass jeder einen Schlüssel und
ein Geheimnis für die eigene Anwendung anbietet.

Alle diese Konfigurationsoptionen müssen durch Verwendung von Methodenaufrufen gesetzt werden indem Sie einfach
von callbackUrl auf setCallbackUrl() konvertiert werden.

Zusätzlich sollte beachtet werden das verschiedene andere Konfigurationswerte nicht explizit verwendet werden:
requestMethod und requestScheme. Standardmäßig sendet ``ZendOauth\Consumer`` Anfragen als POST (ausgenommen bei
einer Weiterleitung welche ``GET`` verwendet). Der konsumierende Client (siehe später) enthält auch seine
Authorisierung in Art eines Headers. Einige Services können, zu Ihrer Diskretion, Alternativen benötigen. Man
kann requestMethod (welche standardmäßig ZendOauth\Oauth::POST ist) zum Beispiel auf ZendOauth\Oauth::GET zurückgesetzt,
und requestScheme von seinem Standardwert ZendOauth\Oauth::REQUEST_SCHEME_HEADER entweder auf
ZendOauth\Oauth::REQUEST_SCHEME_POSTBODY oder auf ZendOauth\Oauth::REQUEST_SCHEME_QUERYSTRING. Typischerweise sollten die
Standardwerte bis auf ein paar bestimmte Ausnahmen problemlos funktionieren. Für Details sehen Sie bitte in die
Dokumentation des Service Providers.

Der zweite Teil der Anpassung definiert wie *HMAC* arbeitet wenn es für alle Anfragen berechnet und verglichen
wird. Das wird durch Verwendung des Konfigurationsfeldes signatureMethod oder durch ``setSignatureMethod()``
konfiguriert. Standardmäßig ist es HMAC-SHA1. Man kann es auch auf die vom Provider bevorzugte Methode setzen
inklusive RSA-SHA1. Für RSA-SHA1 sollte man die privaten und öffentlichen RSA Schlüssel über die
Konfigurationsfelder rsaPrivateKey und rsaPublicKey oder die Methoden ``setRsaPrivateKey()`` und
``setRsaPublicKey()`` konfigurieren.

Der erste Teil des OAuth Workflows holt sich einen Anfragetoken. Das wird bewerkstelligt indem folgendes verwendet
wird:

.. code-block:: php
   :linenos:

   $config = array(
       'callbackUrl' => 'http://example.com/callback.php',
       'siteUrl' => 'http://twitter.com/oauth',
       'consumerKey' => 'gg3DsFTW9OU9eWPnbuPzQ',
       'consumerSecret' => 'tFB0fyWLSMf74lkEu9FTyoHXcazOWpbrAjTCCK48A'
   );
   $consumer = new ZendOauth\Consumer($config);

   // Holt den Anfragetoken
   $token = $consumer->getRequestToken();

Der neue Anfragetoken (eine Instanz von ``ZendOauth\Token\Request``) ist nicht authorisiert. Um Ihn mit einem
authorisierten Token zu wechseln mit dem wir auf die Twitter *API* zugreifen können, muss Ihn der Benutzer
authorisieren. Wir bewerkstelligen das indem der Benutzer auf den Authorisierungsendpunkt von Twitter umgeleitet
wird:

.. code-block:: php
   :linenos:

   $config = array(
       'callbackUrl' => 'http://example.com/callback.php',
       'siteUrl' => 'http://twitter.com/oauth',
       'consumerKey' => 'gg3DsFTW9OU9eWPnbuPzQ',
       'consumerSecret' => 'tFB0fyWLSMf74lkEu9FTyoHXcazOWpbrAjTCCK48A'
   );
   $consumer = new ZendOauth\Consumer($config);

   // Holt den Anfragetoken
   $token = $consumer->getRequestToken();

   // Den token im Speicher fixieren
   $_SESSION['TWITTER_REQUEST_TOKEN'] = serialize($token);

   // Den Benutzer umleiten
   $consumer->redirect();

Der Benutzer wird jetzt auf Twitter umgeleitet. Er wird gefragt den Anfragetoken zu authorisieren, welcher an den
Anfragestring der umgeleiteten URI angehängt ist. Angenommen er akzeptiert und vervollständigt die
Authorisierung, dann wird er wieder umgeleitet. Dieses Mal auf unsere Callback URL die vorher gesetzt wurde
(Beachte das die Callback URL auch in Twitter registriert wurde als wir unsere Anwendung registriert haben).

Bevor der Benutzer umgeleitet wird, sollten wir den Anfragetoken im Speicher fixieren. Der Einfachheit halber
verwenden wir nur die Session des Benutzer, aber man kann sehr einfach eine Datenbank für den gleichen Zweck
verwenden, solange der Anfragetoken mit dem aktuellen Benutzer verbunden bleibt, damit er empfangen werden kann
wenn dieser zu unserer Anwendung zurückkommt.

Die umgeleitete URI von Twitter enthält einen authorisierten Zugriffstoken. Wir können Code einbauen um diesen
Zugriffstoken wie folgt herauszuschneiden - dieser Sourcecode würde im ausgeführten Code unserer Callback URI
existieren. Sobald er herausgeschnitten wurde können wir den vorherigen Anfragetoken entfernen, und statt dessen
den Zugriffstoken für die zukünftige Verendung mit der *API* von Twitter fixieren. Nochmals, wir fixieren einfach
die Session des Benutzer, aber in Wirklichkeit kann ein Zugriffstoken eine lange Lebenszeit haben, und sollte
deshalb wirklich in einer Datenbank abgespeichert werden.

.. code-block:: php
   :linenos:

   $config = array(
       'callbackUrl' => 'http://example.com/callback.php',
       'siteUrl' => 'http://twitter.com/oauth',
       'consumerKey' => 'gg3DsFTW9OU9eWPnbuPzQ',
       'consumerSecret' => 'tFB0fyWLSMf74lkEu9FTyoHXcazOWpbrAjTCCK48A'
   );
   $consumer = new ZendOauth\Consumer($config);

   if (!empty($_GET) && isset($_SESSION['TWITTER_REQUEST_TOKEN'])) {
       $token = $consumer->getAccessToken(
                    $_GET,
                    unserialize($_SESSION['TWITTER_REQUEST_TOKEN'])
                );
       $_SESSION['TWITTER_ACCESS_TOKEN'] = serialize($token);

       // Jetzt da wir den Zugriffstoken haben können wir den Anfragetoken löschen
       $_SESSION['TWITTER_REQUEST_TOKEN'] = null;
   } else {
       // Fehlgeschlagene Anfrage? Ein Gauner versucht etwas?
       exit('Ungültige Callback Anfrage. Oops. Entschuldigung.');
   }

Erfolg! Wir haben einen authorisierten Zugriffstoken - zu dieser Zeit verwenden wir schon die *API* von Twitter. Da
dieser Zugriffstoken bei jeder einzelnen *API* Anfrage enthalten sein muss, bietet ``ZendOauth\Consumer`` einen
fix-fertigen *HTTP* Client an (eine Subklasse von ``Zend\Http\Client``) welcher entweder für sich verwendet
werden, oder der als eigener *HTTP* Client an eine andere Bibliothek oder Komponente übergeben werden kann. Hier
ist ein Beispiel für die eigenständige Verwendung. Das kann von überall aus der Anwendung heraus getan werden,
solange man Zugriff auf die OAuth Konfiguration hat, und den endgültigen authorisierten Zugriffstoken empfangen
kann.

.. code-block:: php
   :linenos:

   $config = array(
       'callbackUrl' => 'http://example.com/callback.php',
       'siteUrl' => 'http://twitter.com/oauth',
       'consumerKey' => 'gg3DsFTW9OU9eWPnbuPzQ',
       'consumerSecret' => 'tFB0fyWLSMf74lkEu9FTyoHXcazOWpbrAjTCCK48A'
   );

   $statusMessage = 'Ich sende über Twitter und verwende ZendOauth!';

   $token = unserialize($_SESSION['TWITTER_ACCESS_TOKEN']);
   $client = $token->getHttpClient($configuration);
   $client->setUri('http://twitter.com/statuses/update.json');
   $client->setMethod(Zend\Http\Client::POST);
   $client->setParameterPost('status', $statusMessage);
   $response = $client->request();

   $data = Zend\Json\Json::decode($response->getBody());
   $result = $response->getBody();
   if (isset($data->text)) {
       $result = 'true';
   }
   echo $result;

Als Notiz zum eigenen Client, kann dieser an den meisten Services von Zend Framework übergeben werden, oder an
andere Klassen welche ``Zend\Http\Client`` verwenden um damit den Standardclient zu ersetzen welcher andernfalls
verwendet werden würde.


