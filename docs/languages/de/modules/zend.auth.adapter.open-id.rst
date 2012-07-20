.. _zend.auth.adapter.openid:

Open ID Authentifikation
========================

.. _zend.auth.adapter.openid.introduction:

Einführung
----------

Der ``Zend_Auth_Adapter_OpenId`` Adapter kann verwendet werden um Benutzer durch Verwendung eines entfernten OpenID
Servers zu authentifizieren. Diese Authentifizierungsmethode nimmt an das Benutzer nur ihre OpenID Identität an
die Web Anwendung übermitteln. Dann werden Sie zu Ihrem OpenID Anbieter umgeleitet um die Eigentümerschaft der
Identität mit Hilfe eines Passwortes oder einer anderen Methode zu prüfen. Dieses Passwort wird der Web Anwendung
nie bekannt gegeben.

Die OpenID Identität ist nur eine *URL* die auf eine Webseite mit entsprechenden Informationen über den Benutzer
und spezielle Tags verweist welche beschreiben welcher Server verwendet werden soll und welche Identität dort zu
übermitteln ist. Mehr über OpenID kann auf der `offiziellen OpenID Site`_ nachgelesen werden.

Die ``Zend_Auth_Adapter_OpenId`` Klasse umgibt die ``Zend_OpenId_Consumer`` Komponente welche das OpenID
Authentifizierungs Protokoll selbst implementiert.

.. note::

   ``Zend_OpenId`` hat Vorteile davon wenn die `GMP Erweiterung`_ vorhanden ist. Es sollte Angedacht werden die
   *GMP* Erweiterung für eine bessere Performance einzuschalten wenn ``Zend_Auth_Adapter_OpenId`` verwendet wird.

.. _zend.auth.adapter.openid.specifics:

Spezielles
----------

Wie in diesem Fall für alle ``Zend_Auth`` Adapter, implementiert die ``Zend_Auth_Adapter_OpenId`` Klasse das
``Zend_Auth_Adapter_Interface``, welches nur eine Methode definiert: ``authenticate()``. Diese Methode führt die
Authentifizierung selbst durch, allerdings muß das Objekt vor dem Aufruf vorbereitet werden. So eine Vorbereitung
des Adapters beinhaltet das Setzen der OpenID Identität und einige andere ``Zend_OpenId`` spezifische Optionen.

Trotzdem, im Gegensatz zu anderen ``Zend_Auth`` Adaptern führt ``Zend_Auth_Adapter_OpenId`` Authentifizierungen an
einem externen Server durch und das wird in zwei separaten *HTTP* Anfragen getan. Deswegen muß
``Zend_Auth_Adapter_OpenId::authenticate()`` zweimal aufgerufen werden. Beim ersten Aufruf wird die Methode nichts
zurückgeben, aber den Benutzer zu seinem OpenID Server umleiten. Dann, nachdem der Benutzer auf dem entfernten
Server authentifiziert ist wird dieser wieder zurück umleiten und das Skript muß für diese zweite Anfrage
``Zend_Auth_Adapter_OpenId::authenticate()`` nochmals aufrufen um die Signatur zu prüfen, welche mit der
umgeleiteten Anfrage vom Server geschickt wird, und den Authentifikationsprozess zu beenden. Bei diesem zweiten
Aufruf wird wie erwartet ein ``Zend_Auth_Result`` Objekt zurückgegeben.

Das folgende Beispiel zeigt die Verwendung von ``Zend_Auth_Adapter_OpenId``. Wie vorher erwähnt wird die
``Zend_Auth_Adapter_OpenId::authenticate()`` Methode zweimal aufgerufen. Das erste Mal, ist nachdem der Benutzer
das *HTML* Formular übermittelt hat und ``$_POST['openid_action']`` auf **"login"** gesetzt wurde, und das zweite
Mal nach der *HTTP* Umleitung vom OpenID Server wenn ``$_GET['openid_mode']`` oder ``$_POST['openid_mode']``
gesetzt wurde.

.. code-block:: php
   :linenos:

   $status = "";
   $auth = Zend_Auth::getInstance();
   if ((isset($_POST['openid_action']) &&
        $_POST['openid_action'] == "login" &&
        !empty($_POST['openid_identifier'])) ||
       isset($_GET['openid_mode']) ||
       isset($_POST['openid_mode'])) {
       $result = $auth->authenticate(
           new Zend_Auth_Adapter_OpenId(@$_POST['openid_identifier']));
       if ($result->isValid()) {
           $status = "Sie sind angemeldet als "
                   . $auth->getIdentity()
                   . "<br>\n";
       } else {
           $auth->clearIdentity();
           foreach ($result->getMessages() as $message) {
               $status .= "$message<br>\n";
           }
       }
   } else if ($auth->hasIdentity()) {
       if (isset($_POST['openid_action']) &&
           $_POST['openid_action'] == "logout") {
           $auth->clearIdentity();
       } else {
           $status = "Sie sind angemeldet als "
                   . $auth->getIdentity()
                   . "<br>\n";
       }
   }
   ?>
   <html><body>
   <?php echo htmlspecialchars($status);?>
   <form method="post"><fieldset>
   <legend>OpenID Login</legend>
   <input type="text" name="openid_identifier" value="">
   <input type="submit" name="openid_action" value="login">
   <input type="submit" name="openid_action" value="logout">
   </fieldset></form></body></html>
   */

Man kann den OpenID Authentifizierungs Prozess auf verschiedenen Wegen anzupassen. Man kann,zum Bespiel, die
Umleitung des OpenID Servers auf eine eigene Seite erhalten, indem der "root" der Webseite spezifiziert wird und
ein eigener ``Zend_OpenId_Consumer_Storage`` oder ``Zend_Controller_Response`` verwendet wird. Man kann auch eine
einfache Registrierungserweiterung verwenden um Informationen über den Benutzer vom OpenID Server zu erhalten.
Alle diese Möglichkeiten werden detailierter im Kapitel ``Zend_OpenId_Consumer`` beschrieben.



.. _`offiziellen OpenID Site`: http://www.openid.net/
.. _`GMP Erweiterung`: http://php.net/gmp
