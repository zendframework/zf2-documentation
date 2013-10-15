.. EN-Revision: none
.. _zend.openid.provider:

ZendOpenId\Provider
====================

``ZendOpenId\Provider`` kann verwendet werden um OpenID Server zu implementieren. Dieses Kapitel bietet Beispiele
die Demonstrieren wie ein sehr einfacher Server erstellt werden kann. Für die Implementierung eines produktiven
OpenId Servers (wie zum Beispiel `www.myopenid.com`_) kann es aber notwendig sein mit komplexeren Problemen
umzugehen.

.. _zend.openid.provider.start:

Schellstart
-----------

Das folgende Beispiel beinhaltet Code für das Erstellen eines Benutzerzugang indem
``ZendOpenId\Provider::register`` verwendet wird. Das Link-Element mit ``rel="openid.server"`` zeigt auf das
eigene Serverscript. Wenn diese Identität zu einer OpenID-aktivierten Seite übertragen wird, wird eine
Authentifizierung zu diesem Server durchgeführt.

Der Code vor dem <html> Tag ist nur ein Trick der automatisch den Benutzerzugang erstellt. Man benötigt solch
einen Code nicht wenn echte Identitäten verwendet werden.

.. _zend.openid.provider.example-1:

.. rubric:: Die Identität

.. code-block:: php
   :linenos:

   <?php
   // eine Testidentität erstellen
   define("TEST_SERVER", ZendOpenId\OpenId::absoluteURL("example-8.php"));
   define("TEST_ID", ZendOpenId\OpenId::selfURL());
   define("TEST_PASSWORD", "123");
   $server = new ZendOpenId\Provider();
   if (!$server->hasUser(TEST_ID)) {
       $server->register(TEST_ID, TEST_PASSWORD);
   }
   ?>
   <html><head>
   <link rel="openid.server" href="<?php echo TEST_SERVER;?>" />
   </head><body>
   <?php echo TEST_ID;?>
   </body></html>

Das folgende Identitäts-Serverscript behandelt zwei Arten von Anfragen von OpenID-aktivierten Sites (for
Assoziation und Authentifizierung). Beide von Ihnen werden von der gleichen Methode behandelt:
``ZendOpenId\Provider::handle``. Die zwei Argumente für ``ZendOpenId\Provider`` Konstruktor sind die *URL*\ s
des Logins und der Vertrauten Seite, welche die Eingabe des End-Benutzers abfragen.

Bei Erfolg gibt die Methode ``ZendOpenId\Provider::handle`` einen String zurück der zur OpenID-aktivierten Seite
zurück übergeben werden sollte. Bei einem Fehler wird ``FALSE`` zurückgegeben. Dieses Beispiel gibt eine *HTTP*
403 Antwort zurück wenn ``ZendOpenId\Provider::handle`` fehlschlägt. Man erhält diese Antwort wenn man dieses
Skript mit einem Web-Browser öffnet, weil es eine nicht-OpenID konforme Anfrage sendet.

.. _zend.openid.provider.example-2:

.. rubric:: Einfacher Identitäts Provider

.. code-block:: php
   :linenos:

   $server = new ZendOpenId\Provider("example-8-login.php",
                                      "example-8-trust.php");
   $ret = $server->handle();
   if (is_string($ret)) {
       echo $ret;
   } else if ($ret !== true) {
       header('HTTP/1.0 403 Forbidden');
       echo 'Verboten';
   }

.. note::

   Es ist eine gute Idee eine sichere Verbindung (HTTPS) für diese Skripte zu verwenden - und speziell für die
   folgenden interaktiven Scripte - um den Diebstahl von Passwörtern zu verhindern.

Das folgende Skript implementiert einen Login Schirm für einen Identitäts Server indem ``ZendOpenId\Provider``
verwendet wird und leitet zu dieser Seite weiter wenn ein benötigter Benutzer sich noch nicht eingeloggt hat. Auf
dieser Seite gibt der Benutzer sein Passwort an um sich anzumelden.

Es sollte das Passwort "123" verwendet werden das im obigen Identitäts Skript verwendet wurde.

Bei Abschicken, ruft das Skript ``ZendOpenId\Provider::login`` mit der akzeptierten Benutzer Identität und dem
Passwort auf, und leitet anschließend zum Hauptskript des Identitäts Providers zurück. Bei Erfolg baut
``ZendOpenId\Provider::login`` eine Session zwischen dem Benutzer und dem Identitäts-Provider auf und speichert
die Informationen über den Benutzer der nun angemeldet ist. Alle folgenden Anfragen vom gleichen Benutzer
benötigen keine Login-Prozedur mehr - selbst wenn diese von einer anderen OpenID aktivierten Web-Seite kommen.

.. note::

   Es ist zu beachten das die Session nur zwischen den End-Benutzer und dem Identitäts-Provider existiert. OpenID
   aktivierte Seiten wissen nichts darüber.

.. _zend.openid.provider.example-3:

.. rubric:: Einfacher Login Schirm

.. code-block:: php
   :linenos:

   <?php
   $server = new ZendOpenId\Provider();

   if ($_SERVER['REQUEST_METHOD'] == 'POST' &&
       isset($_POST['openid_action']) &&
       $_POST['openid_action'] === 'login' &&
       isset($_POST['openid_identifier']) &&
       isset($_POST['openid_password'])) {
       $server->login($_POST['openid_identifier'],
                      $_POST['openid_password']);
       ZendOpenId\OpenId::redirect("example-8.php", $_GET);
   }
   ?>
   <html>
   <body>
   <form method="post">
   <fieldset>
   <legend>OpenID Login</legend>
   <table border=0>
   <tr>
   <td>Name:</td>
   <td>
   <input type="text"
          name="openid_identifier"
          value="<?php echo htmlspecialchars($_GET['openid_identity']);?>">
   </td>
   </tr>
   <tr>
   <td>Passwort:</td>
   <td>
   <input type="text"
          name="openid_password"
          value="">
   </td>
   </tr>
   <tr>
   <td> </td>
   <td>
   <input type="submit"
          name="openid_action"
          value="login">
   </td>
   </tr>
   </table>
   </fieldset>
   </form>
   </body>
   </html>

Der Fakt das der Benutzer jetzt angemeldet ist bedeutet nicht das die Authentifizierung notwendigerweise
erfolgreich sein muß. Der Benutzer kann entscheiden das er der betreffenden OpenID aktivierten Seite nicht
vertraut. Der folgende Vertrauens-Schirm erlaubt dem Endbenutzer diese Wahl zu treffen. Diese Wahl kann entweder
nur für die aktuelle Anfrage oder für "immer" gemacht werden. Im zweiten Fall werden Informationen über
vertrauenswürdige/nicht vertrauenswürdige Seiten in einer internen Datenbank gespeichert, und alle folgenden
Authentifizierungs Anfragen von dieser Seite werden automatisch gehandhabt ohne einer Interaktion des Benutzers.

.. _zend.openid.provider.example-4:

.. rubric:: Einfacher Vertrauens Schirm

.. code-block:: php
   :linenos:

   <?php
   $server = new ZendOpenId\Provider();

   if ($_SERVER['REQUEST_METHOD'] == 'POST' &&
       isset($_POST['openid_action']) &&
       $_POST['openid_action'] === 'trust') {

       if (isset($_POST['allow'])) {
           if (isset($_POST['forever'])) {
               $server->allowSite($server->getSiteRoot($_GET));
           }
           $server->respondToConsumer($_GET);
       } else if (isset($_POST['deny'])) {
           if (isset($_POST['forever'])) {
               $server->denySite($server->getSiteRoot($_GET));
           }
           ZendOpenId\OpenId::redirect($_GET['openid_return_to'],
                                 array('openid.mode'=>'cancel'));
       }
   }
   ?>
   <html>
   <body>
   <p>Eine Seite die sich als
   <a href="<?php echo htmlspecialchars($server->getSiteRoot($_GET));?>
   <?php echo htmlspecialchars($server->getSiteRoot($_GET));?>
   </a>
   identifiziert hat uns nach Bestätigung gefragt ob
   <a href="<?php echo htmlspecialchars($server->getLoggedInUser());?>">
   <?php echo htmlspecialchars($server->getLoggedInUser());?>
   </a>
   ihre Identitäts URL ist.
   </p>
   <form method="post">
   <input type="checkbox" name="forever">
   <label for="forever">für immer</label><br>
   <input type="hidden" name="openid_action" value="trust">
   <input type="submit" name="allow" value="Allow">
   <input type="submit" name="deny" value="Deny">
   </form>
   </body>
   </html>

Produktive OpenID Server unterstützen normalerweise die einfache Registrierungs Erweiterung die es Benutzern
erlaubt einige Informationen über ein Benutzerformular beim Provider nachzufragen. In diesem Fall kann die
Vertraute Seite erweitert werden um die Eingabe von angefragten Feldern zu erlauben oder ein spezielles
Benutzerprofil auszuwählen.

.. _zend.openid.provider.all:

Kombinierte Skripte
-------------------

Es ist möglich alle Provider Funktionalitäten in einem Skript zusammen zu kombinieren. In diesem Fall werden
Login und Vertraute *URL*\ s unterdrückt, und ``ZendOpenId\Provider`` nimmt an das diese auf die gleiche Seite
zeigen mit einem zusätzlichen "openid.action"``GET`` Argument.

.. note::

   Das folgende Beispiel ist nicht komplett. Es bietet kein GUI für End-Benutzer wie es sein sollte, aber es
   führt automatisches Login und Vertrauen durch. Das wird getan um das Beispiel zu vereinfachen, und echte Server
   müssen Code von den vorherigen Beispielen inkludieren.

.. _zend.openid.provider.example-5:

.. rubric:: Alles zusammen

.. code-block:: php
   :linenos:

   $server = new ZendOpenId\Provider();

   define("TEST_ID", ZendOpenId\OpenId::absoluteURL("example-9-id.php"));
   define("TEST_PASSWORD", "123");

   if ($_SERVER['REQUEST_METHOD'] == 'GET' &&
       isset($_GET['openid_action']) &&
       $_GET['openid_action'] === 'login') {
       $server->login(TEST_ID, TEST_PASSWORD);
       unset($_GET['openid_action']);
       ZendOpenId\OpenId::redirect(ZendOpenId\OpenId::selfUrl(), $_GET);
   } else if ($_SERVER['REQUEST_METHOD'] == 'GET' &&
       isset($_GET['openid_action']) &&
       $_GET['openid_action'] === 'trust') {
       unset($_GET['openid_action']);
       $server->respondToConsumer($_GET);
   } else {
       $ret = $server->handle();
       if (is_string($ret)) {
           echo $ret;
       } else if ($ret !== true) {
           header('HTTP/1.0 403 Forbidden');
           echo 'Verboten';
       }
   }

Wenn man dieses Beispiel mit den vorherigen Beispielen vergleicht, die in einzelne Seiten aufgeteilt sind, sieht
man zusätzlich zum Dispatch Code, nur einen Unterschied: ``unset($_GET['openid_action'])``. Dieser Aufruf von
``unset()`` ist notwendig um die nächste Anfrage zum Haupthandler zu routen.

.. _zend.openid.provider.sreg:

Einfache Registrierungs Erweiterung (SREG)
------------------------------------------

Wieder ist der Code vor dem <html> Tag nur ein Trick um die Funktionalität zu demonstrieren. Er erstellt einen
neuen Benutzerzugang und assoziiert Ihn mit einem Profil (Spitzname und Passwort). Solche Tricks werden bei
ausgelieferten Providern nicht benötigt wo sich End Benutzer auf OpenID Servern registrieren und Ihre Profile
eintragen. Die Implementierung dieses GUI würde den Rahmen dieses Handbuches sprengen.

.. _zend.openid.provider.example-6:

.. rubric:: Identität mit Profil

.. code-block:: php
   :linenos:

   <?php
   define("TEST_SERVER", ZendOpenId\OpenId::absoluteURL("example-10.php"));
   define("TEST_ID", ZendOpenId\OpenId::selfURL());
   define("TEST_PASSWORD", "123");
   $server = new ZendOpenId\Provider();
   if (!$server->hasUser(TEST_ID)) {
       $server->register(TEST_ID, TEST_PASSWORD);
       $server->login(TEST_ID, TEST_PASSWORD);
       $sreg = new ZendOpenId\Extension\Sreg(array(
           'nickname' =>'test',
           'email' => 'test@test.com'
       ));
       $root = ZendOpenId\OpenId::absoluteURL(".");
       ZendOpenId\OpenId::normalizeUrl($root);
       $server->allowSite($root, $sreg);
       $server->logout();
   }
   ?>
   <html>
   <head>
   <link rel="openid.server" href="<?php echo TEST_SERVER;?>" />
   </head>
   <body>
   <?php echo TEST_ID;?>
   </body>
   </html>

Die Identität sollte jetzt der OpenID-aktivierten Webseite übergeben werden (verwende das einfache Registrierungs
Erweiterung Beispiel aus dem vorherigen Kapitel) und sie sollte das folgende OpenID Server Skript verwenden.

Dieses Skript ist eine Variation des Skripts im "Alles zusammen" Beispiel. Es verwendet den gleichen automatischen
Login Mechanismus, aber es enthält keinen Code für die Vertrauens-Seite. Der Benutzer hat dem Beispielskript
bereits für immer vertraut. Dieses Vertrauen wurde durch den Aufruf der ``ZendOpenId\Provider::allowSite()``
Methode im Identitäts Skript hergestellt. Die gleiche Methode assoziiert das Profil mit der vertrauten *URL*.
Dieses Profil wird automatisch für eine Anfrage von der vertrauten *URL* zurückgegeben.

Um die einfache Registrierungs Erweiterung funktionsfähig zu machen ist einfach die Übergabe einer Instanz von
``ZendOpenId\Extension\Sreg`` als zweites Argument der ``ZendOpenId\Provider::handle()`` Methode.

.. _zend.openid.provider.example-7:

.. rubric:: Provider mit SREG

.. code-block:: php
   :linenos:

   $server = new ZendOpenId\Provider();
   $sreg = new ZendOpenId\Extension\Sreg();

   define("TEST_ID", ZendOpenId\OpenId::absoluteURL("example-10-id.php"));
   define("TEST_PASSWORD", "123");

   if ($_SERVER['REQUEST_METHOD'] == 'GET' &&
       isset($_GET['openid_action']) &&
       $_GET['openid_action'] === 'login') {
       $server->login(TEST_ID, TEST_PASSWORD);
       unset($_GET['openid_action']);
       ZendOpenId\OpenId::redirect(ZendOpenId\OpenId::selfUrl(), $_GET);
   } else if ($_SERVER['REQUEST_METHOD'] == 'GET' &&
       isset($_GET['openid_action']) &&
       $_GET['openid_action'] === 'trust') {
      echo "UNTRUSTED DATA" ;
   } else {
       $ret = $server->handle(null, $sreg);
       if (is_string($ret)) {
           echo $ret;
       } else if ($ret !== true) {
           header('HTTP/1.0 403 Forbidden');
           echo 'Verboten';
       }
   }

.. _zend.openid.provider.else:

Sonst noch was?
---------------

Das Erstellen von OpenID Providern ist eine viel seltenere Aufgabe als die Erstellung von OpenID-aktivierten Sites,
weswegen dieses Handbuch nicht alle ``ZendOpenId\Provider`` Features so ausführlich abdeckt wie es für
``ZendOpenId\Consumer`` getan wurde.

Zusammenfassend enthält ``ZendOpenId\Provider``:

- Ein Set von Methoden um ein End-Benutzer GUI zu Erstellen das es Benutzern erlauben sich zu registrieren und Ihre
  vertrauten Seiten und Profile zu managen.

- Einen abstrakten Speicherlayer um Informationen über Benutzer, Ihre Seiten und Ihre Profile zu speichern. Es
  speichert auch Assoziationen zwischen Providern und OpenID-aktivierten Seiten. Dieser Layer ist ähnlich dem der
  ``ZendOpenId\Consumer`` Klasse. Er verwendet standardmäßg auch den Dateispeicher, kann aber mit anderen
  Backends abgeleitet werden.

- Einen Abtraktions Benutzer-Assoziierungs Layer der Web-Browser von Benutzern mit eingeloggten Identitäten
  verknüpfen kann.

Die ``ZendOpenId\Provider`` Klasse versucht nicht alle möglichen Features abzudecken die von OpenID Servern
implementiert werden können, z.B. wie digitale Zertifikate, kann aber einfach erweitert werden durch
``ZendOpenId\Extension``\ s oder durch standardmäßige Objektorientierte Erweiterungen.



.. _`www.myopenid.com`: http://www.myopenid.com
