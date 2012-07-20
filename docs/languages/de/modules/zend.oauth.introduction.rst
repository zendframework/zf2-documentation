.. _zend.oauth.introduction:

Einführung zu OAuth
===================

OAuth erlaubt es Zugriffe auf private Daten welche in einer Website gespeicher sind von jeder Anwendung aus zu
gestatten ohne dazu gezwungen zu sein den Benutzernamen oder das Passwort herauszugeben. Wenn man darüber nachdenk
ist die Praxis der Herausgabe von Benutzername und Passwort für Sites wie Yahoo Mail oder Twitter seit einer
ganzen Weile endemisch. Dies hat einige Bedenken ausgelöst weil es nichts gibt um zu verhindern das Anwendungen
diese Daten missbrauchen. Ja, einige Serives mögen vertrauenswürdig erscheinen aber dies kann nie garantiert
werden. OAuth löst dieses Problem indem es die Notwendigkeit eliminiert Benutzernamen und Passwörter zu teilen,
und es mit einem vom Benutzer kontrollierten Authorisationsprozess ersetzt.

Dieser Authorisationsprozess basiert auf Tokens. Wenn man eine Anwendung authorisiert (wobei eine Anwendung jede
Webbasierende- oder Desktop- anwendung enthält) auf die eigenen Daten zuzugreifen, wird diese einen Access Token
erhalten der mit dem eigenen Account assoziiert ist. Bei Verwendung dieses Access Tokens kann die Anwendungen auf
die privaten Daten zugreifen ohne dauernd die Zugangsdaten zu benötigen. Insgesamt ist dieses Prokoll einer
delegationsartigen Authorisierung eine sicherere Lösung des Problems auf private Daten über eine beliebige
Webservice *API* zuzugreifen.

OAuth ist keine komplett neue Idee, es ist mehr ein standardisiertes Protokoll welches auf existierende
Eigenschaften von Protokollen wie Google AuthSub, Yahoo BBAuth, Flickr *API*, usw. aufsetzt. Alle von Ihnen
arbeiten im weiteren Sinne auf der Basis einer standardisierten Benutzerkennung für eine Art Access Token. Der
Vorteil einer standardisierten Spezifikation wie OAuth ist, das Sie nur eine einzelne Implementation benötigt im
gegensatz zu vielen unterschiedlichen abhängig vom verwendeten Webservice. Diese Standardisierung hat nicht
unabhängig von den Major Players stattgefunden, und aktuell unterstützen viele bereits OAuth als Alternative und
wollen in Zukunft Ihre eigenen Lösungen damit ersetzen.

Zend Framework's ``Zend_Oauth`` implementiert aktuell über die Klasse ``Zend_Oauth_Consumer`` einen vollständigen
OAuth Konsumenten welcher der OAuth Core 1.0 Revision A Spezifikation (24 Juni 2009) entspricht.

.. include:: zend.oauth.protocol-workflow.rst
.. include:: zend.oauth.security-architecture.rst
.. include:: zend.oauth.getting-started.rst

