.. _zend.gdata.clientlogin:

Authentifizieren mit ClientLogin
================================

Der ClientLogin Mechanismus erlaubt es *PHP* Anwendungen zu schreiben die Authentifizierungs-zugriff zu Google
Services benötigen, durch die Spezifikation von Benutzer Zugangsdaten im *HTTP* Client.

Siehe `http://code.google.com/apis/accounts/AuthForInstalledApps.html`_ für weitere Informationen über die Google
Data ClientLogin Authentifizierung.

Die Google Dokumentation sagt das der ClientLogin Mechanismus genau richtig für "installierte Anwendungen" ist und
der AuthSub Mechanismus für "Web Anwendungen". Der Unterschied ist, das AuthSub Interaktion vom Benutzer
benötigt, und ein Browser Interface das auf Weiterleitungs Anfragen reagieren kann. Die ClientLogin Lösung
verwendet *PHP* Code um die Benutzer Zugangsdaten zu liefern; der Benutzer wird nicht benötigt um seine
Zugangsdaten interaktiv einzugeben.

Die Account Zugangsdaten die über den ClientLogin Mechanismum geliefert werden müssen gültige Zugangsdaten für
Google Services sein, aber es müssen nicht die des Benutzers sein, der die *PHP* Anwendung verwendet.

.. _zend.gdata.clientlogin.login:

Erstellen eines ClientLogin autentifizierten Http Clienten
----------------------------------------------------------

Der Prozess der Erstellung eines autentifizierten *HTTP* Clients durch Verwendung des ClientLogin Mechanismus
besteht darin die statische Funktion ``Zend_Gdata_ClientLogin::getHttpClient()`` aufzurufen und die Google Account
Zugangsdaten als reinen Text zu übergeben. Der Rückgabewert dieser Funktion ist ein Objekt der Klasse
``Zend_Http_Client``.

Der optionale dritte Parameter ist der Name des Google Data Services. Zum Beispiel kann dieser 'cl' sein für
Google Calendar. Der Standardwert ist "xapi", welcher von den Google Data Servern als generischer Service Name
erkannt wird.

Der optionale vierte Parameter ist eine Instanz von ``Zend_Http_Client``. Das erlaubt das Setzen von Optionen an
den Client, wie z.B. Proxy Server Einstellungen. Wenn für diesen Parameter ``NULL`` übergeben wird, wird ein
generisches ``Zend_Http_Client`` Objekt erstellt.

Der optionale fünfte Parameter ist ein kurzer String den Google Data Server verwenden um die Client Anwendung für
logging Zwecke zu identifizieren. Standardmäßig ist dieser String "Zend-ZendFramework";

Der optionale sechste Parameter ist eine String ID für eine CAPTCHA(tm) Challenge die vom Server angefordert wird.
Er wird nur benötigt wenn eingeloggt werden soll nachdem eine CAPTCHA(tm) Challenge von einem vorhergehenden Login
Versuch empfangen wurde.

Der optionale siebente Parameter ist die Antwort des Benutzer's zu einer CAPTCHA(tm) Challenge die von dem Server
angefordert wurde. Er wird nur benötigt wenn eingeloggt werden soll nachdem eine CAPTCHA(tm) Challenge von einem
vorhergehenden Login Versuch empfangen wurde.

Anbei ist ein Beispiel in *PHP* Code für eine Web Anwendung die Authentifizierung benötigt um das Google Calendar
Service zu verwenden und ein ``Zend_Gdata`` Client Objekt zu erstellen das diesen authentifizierten
``Zend_Http_Client`` verwendet.

.. code-block:: php
   :linenos:

   // Die Google Zugangdaten angeben
   $email = 'johndoe@gmail.com';
   $passwd = 'xxxxxxxx';
   try {
      $client = Zend_Gdata_ClientLogin::getHttpClient($email, $passwd, 'cl');
   } catch (Zend_Gdata_App_CaptchaRequiredException $cre) {
       echo 'URL des CAPTCHA Bildes: ' . $cre->getCaptchaUrl() . "\n";
       echo 'Token ID: ' . $cre->getCaptchaToken() . "\n";
   } catch (Zend_Gdata_App_AuthException $ae) {
      echo 'Authentifizierungs Problem: ' . $ae->exception() . "\n";
   }

   $cal = new Zend_Gdata_Calendar($client);

.. _zend.gdata.clientlogin.terminating:

Den über ClientLogin authentifizierten Http Client beenden
----------------------------------------------------------

Es gibt keine Methode um ClientLogin Authentifizierungen zu verwerfen da es eine AuthSub token-basierte Lösung
gibt. Die Zugangsdaten die in der ClientLogin Authentifizierung verwendet werden sind der Login und das Passwort zu
einem Google Account, und deshalb können diese wiederholend in der Zukunft verwendet werden.



.. _`http://code.google.com/apis/accounts/AuthForInstalledApps.html`: http://code.google.com/apis/accounts/AuthForInstalledApps.html
