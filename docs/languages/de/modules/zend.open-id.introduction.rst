.. _zend.openid.introduction:

Einführung
==========

``Zend_OpenId`` ist eine Zend Framework Komponente die eine einfache *API* für das Erstellen von
OpenID-verwendenden Sites und Identitäts Providern bietet.

.. _zend.openid.introduction.what:

Was ist OpenID?
---------------

OpenID ist ein Set von Protokollen für Benutzer-zentrierte digitale Identitäts Provider. Diese Protokolle
erlauben Benutzern online die Erstellung einer Identität, indem ein Identitäts Provider verwendet wird. Diese
Identität kann auf jeder Seite verwendet werden die OpenID unterstützt. Die Verwendung von OpenID-erlaubenden
Sites gestattet es Benutzern, das Sie sich traditionelle Authentifizierungs Tokens nicht merken müssen, wie
Benutzernamen und Passwörter für jede Seite. Alle OpenID-erlaubenden Sites akzeptieren eine einzelne OpenID
Identität. Diese Identität ist typischerweise eine *URL*. Das kann die *URL* der persönlichen Seite eines
Benutzers sein, ein Blog oder eine andere Ressource die zusätzliche Daten zu Ihm liefert. Das bedeutet das ein
Benutzer nur mehr einen Identifikator für alle Seiten, die er oder Sie benutzt, benötigt. OpenID ist eine offene,
dezentralisierte und freie Benutzer-zentrierte Lösung. Benutzer können auswählen welcher OpenID Anbieter
verwendet werden soll, oder sogar Ihren eigenen persönlichen Identitäts Server erstellen. Es wird keine zentrale
Authorität benötigt um OpenID-erlaubende Sites zuzulassen oder zu registrieren noch irgendwelche Identitäts
Provider.

Für weitere Informationen über OpenId siehe die `offizielle OpenID Seite`_.

.. _zend.openid.introduction.how:

Wie funktioniert das ?
----------------------

Der Zweck der ``Zend_OpenId`` Komponente ist es das OpenID Authentifizierungsprotokoll zu implementieren, wie im
folgenden Sequenzdiagramm beschrieben:

.. image:: ../images/zend.openid.protocol.jpg
   :width: 559
   :align: center

. Authentifizierung wird durch den Endbenutzer initiiert, welcher seinen OpenID Identifikator zum OpenID
  Konsumenten, durch einen User-Agenten, übergibt.

. Der OpenID Konsument führt eine Normalisierung und Begutachtung des vom Benutzer gelieferten Identifikators
  durch. Durch diesen Prozess erhält der Benutzer den geforderten Identifikator, die *URL* des OpenID Providers
  und eine OpenID Protokoll Version.

. Der OpenID Konsument führt eine optionale Assoziierung mit dem Provider durch wobei Diffie-Hellman Schlüssel
  verwendet werden. Als Ergebnis haben beide Parteien ein übliches "geteiltes Geheimnis" das für das
  unterschreiben und verifizieren der nachfolgenden Nachrichten verwendet wird.

. Der OpenID Konsument leitet den Benutzer-Agenten zur *URL* des OpenID Providers mit einer OpenID
  Authentifizierungs Anfrage weiter.

. Der OpenID Provider prüft ob der Benutzer-Agent bereits authentifiziert wurde, und wenn nicht bietet er es an.

. Der Endbenutzer gibt das benötigte Passwort an.

. Der OpenID Provider prüft ob es erlaubt ist die Identität des Benutzers zum gegebenen Konsumenten zu
  übergeben, und fragt den Benutzer wenn das notwendig ist.

. Der Benutzer erlaubt oder verweigert das übergeben seiner Identität.

. Der OpenID Provider leitet den Benutzer-Agenten zum OpenID Konsumenten zurück mit einer "Authentifizierung
  durchgeführt" oder "fehlgeschlagen" Anfrage.

. Der OpenID Konsument verifiziert die vom Provider empfangenen Informationen durch die Verwendung des geteilten
  Geheimnisses das er in Schritt 3 erhalten hat oder durch das Senden einer direkten Anfrage zum OpenID Provider.

.. _zend.openid.introduction.structure:

Zend_OpenId Struktur
--------------------

``Zend_OpenId`` besteht aus zwei Unterpaketen. Das erste ist ``Zend_OpenId_Consumer`` für die Entwicklung von
OpenID-verwendenden Servern und der zweite ist ``Zend_OpenId_Provider`` für die Entwicklung von OpenID Servern.
Diese sind komplett unabhängig voneinander und können separat verwendet werden.

Der einzige gemeinsame Code der von diesen Unterpaketen verwendet wird ist die OpenID Simply Registry Erweiterung
die von der ``Zend_OpenId_Extension_Sreg`` Klasse implementiert wird und ein Set von Hilfs Funktionen die von der
``Zend_OpenId`` Klasse implementiert werden.

.. note::

   ``Zend_OpenId`` hat Vorteile davon wenn die `GMP Erweiterung`_ vorhanden ist. Es sollte Angedacht werden die GMP
   Erweiterung für eine verbesserte Performance einzuschalten wenn ``Zend_OpenId`` verwendet wird.OpenID

.. _zend.openid.introduction.standards:

Unterstützte OpenId Standards
-----------------------------

Die ``Zend_OpenId`` Komponente unterstützt die folgenden Standards:

- OpenID Authentifizierungs Protokoll Version 1.1

- OpenID Authentifizierungs Protokoll Version 2.0 Entwurf 11

- OpenID Einfache Registrierungs Erweiterung Version 1.0

- OpenID Einfache Registrierungs Erweiterung Version 1.1 Entwurf 1



.. _`offizielle OpenID Seite`: http://www.openid.net/
.. _`GMP Erweiterung`: http://php.net/gmp
