.. EN-Revision: none
.. _zend.session.introduction:

Einführung
==========

Das Zend Framework Auth Team begrüsst Feedback und Beiträge in der Mailing Liste: `fw-auth@lists.zend.com`_

In Web Anwendungen die mit *PHP* geschrieben sind, repräsentiert eine **Session** eine logische Eins-zu-Eins
Verbindung zwischen fixen Daten auf dem Server und einem bestimmten Benutzer Client (z.B., einem Web Browser).
``Zend_Session`` hilft beim Verwalten und Aufbewahren von Session Daten, einer logischen Verbindung von Cookie
Daten über mehrere Seitenaufrufe hinweg durch den gleichen Client. Anders als Cookie Daten, werden Session Daten
nicht beim Client gespeichert und stehen diesem nur dann zur Verfügung wenn der Server-seitige Sourcecode diese
Daten freiwillig zur Verfügung stellt und diese vom Client angefragt werden. Innerhalb dieser Komponente und der
Dokumentation bezeichnt der Term "Session Daten" die Server-seitigen Daten welche in `$_SESSION`_ gespeichert,
durch ``Zend_Session`` verwaltet und durch ``Zend\Session\Namespace`` Zugriffsobjekte individuell verändert
werden. **Session Namensräume** gestatten den Zugriff auf Session Daten durch Verwendung klassischer
`Namensräume`_ welche durch logische, namentlich gruppierte, assoziative Arrays, dessen Schlüssel mit
Zeichenketten benannt sind (ähnlich wie bei normalen *PHP* Arrays), implementiert sind.

``Zend\Session\Namespace`` Instanzen sind Zugriffsobjekte für benannte Abschnitte von ``$_SESSION``. Die
``Zend_Session`` Komponente wrappt die bestehende *PHP* Erweiterung ext/session mit einem Administrations und
Management Interface sowie einer *API* für ``Zend\Session\Namespace`` um Session Namensräume zu erlauben.
``Zend\Session\Namespace`` bietet ein standardisiertes, objektorientiertes Interface für das Arbeiten mit
Namensräumen welche innerhalb von *PHP*'s Standard Session Mechanismum bereitgehalten werden. Es werden sowohl
anonyme als auch authentifizierte (z.B., "login") Session Namensräume unterstützt. ``Zend_Auth``, die
Authentifizierungs-Komponente des Zend Framework verwendet ``Zend\Session\Namespace`` um einige Informationen,
welche mit den authentifizierten Benutzern verbunden sind, innerhalb des "Zend_Auth" Namensraums zu speichern. Da
``Zend_Session`` intern die normalen *PHP* ext/session Funktionen verwendet, sind alle bekannten
Konfigurationsoptionen und Einstellungen vorhanden (siehe `http://www.php.net/session`_), mit dem Bonus und Komfort
durch ein Objekt-orientiertes Interface und unterstützt standardmäßig beides, sowohl die beste Lösung als auch
eine reibungslose Integration innerhalb des Zend Frameworks. Deshalb hält eine standardmäßige *PHP* Session
Identifizierer, welche entweder in einem Client-Cookie gespeichert oder in einer *URL* integriert ist, die
Verbindung zwischen Client und bestehenden Sessiondaten aufrecht.

Das standardmäßige `ext/session Speichermodul`_ löst das Problem des Verwaltens dieser Verbindung unter
bestimmten Bedingungen nicht, weil Session Daten am Dateisystem des Servers gespeichert werden der auf die Anfrage
antwortet. Wenn eine Anfrage von einem anderen Server beantwortet wird and dem wo die Session Daten vorhanden sind,
hat der antwortende Server keinen Zugriff auf die Session Daten (wenn diese nicht durch ein Netzwerk Dateisystem
verfügbar sind). Eine Liste von zusätzlichen, geeigneten Speichermodule wird, sobald Sie vorhanden ist, zur
Verfügung gestellt. Mitglieder der Community werden ermutigt Speichermodule vorzuschlagen und an die
`fw-auth@lists.zend.com`_ Mailing-Liste zu senden. Ein ``Zend_Db`` kompatibles Speichermodul wurde schon in der
Liste veröffentlicht.



.. _`fw-auth@lists.zend.com`: mailto:fw-auth@lists.zend.com
.. _`$_SESSION`: http://www.php.net/manual/de/reserved.variables.php#reserved.variables.session
.. _`Namensräume`: http://en.wikipedia.org/wiki/Namespace_%28computer_science%29
.. _`http://www.php.net/session`: http://www.php.net/session
.. _`ext/session Speichermodul`: http://www.php.net/manual/de/function.session-set-save-handler.php
