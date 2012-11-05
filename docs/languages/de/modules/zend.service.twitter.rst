.. EN-Revision: none
.. _zend.service.twitter:

Zend\Service\Twitter
====================

.. _zend.service.twitter.introduction:

Einführung
----------

``Zend\Service\Twitter`` bietet einen Client für die `RESTAPI von Twitter`_. ``Zend\Service\Twitter`` erlaubt es
eine öffentliche Zeitachse abzufragen. Wenn man einen Benutzernamen und ein OAuth Details für Twitter angibt, ist
es auch erlaubt den eigenen Status zu erhalten und zu aktualisieren, Freunden zu antworten, Nachrichten an Freunde
schicken, Tweets als Favoriten markieren und vieles mehr.

``Zend\Service\Twitter`` implementiert einen *REST* Service und alle Methoden geben eine Instanz von
``Zend\Rest_Client\Result`` zurück.

``Zend\Service\Twitter`` ist in Untersektionen geteilt damit man einfachst erkennen kann welcher Typ von Aufrufen
angefragt wird.

- *account* stellt sicher das die eigenen Zugangsdaten gültig sind, prüft das *API* Limit und beendet die
  aktuelle Session für den authentifizierten Benutzer.

- *status* empfängt die öffentlichen und die Zeitlinien von Benutzern, und zeigt den authentifizierten Benutzer
  an, aktualsiert Ihn, zerstört Ihn und empfängt Antworten.

- *user* empfängt Freunde und Verfolger des authentifizierten Benutzers und gibt erweiterte Informationen über
  den angegebenen Benutzer zurück.

- *directMessage* empfängt die direkten Nachrichten des authentifizierten Benutzers, löscht direkte Nachrichten
  und sendet neue direkte Nachrichten.

- *friendship* erstellt und entfernt Freundschaften für den authentifizierten Benutzer.

- *favorite* zeigt, erstellt und entfernt favorisierte Tweets.

- *block* blockiert und entfernt die Blockierung von Benutzern welche einem folgen.

.. _zend.service.twitter.authentication:

Authentifizierung
-----------------

Mit der Ausnahme des Holens der öffentlichen Zeitlinie benötigt ``Zend\Service\Twitter`` eine Authentifizierung
als gültiger Benutzer. Das wird erreicht indem das OAuth Authentifizierungs Protokoll verwendet wird. OAuth ist
der einzige unterstützte Authentifizierungsmodus für Twitter ab August 2010. Die OAuth Implementierung welche von
``Zend\Service\Twitter`` verwendet wird ist ``ZendOAuth``.

.. _zend.service.twitter.authentication.example:

.. rubric:: Erstellung der Twitter Klasse

``Zend\Service\Twitter`` muss sich selbst authorisieren, durch den Benutzer, bevor es mit der Twitter API verwendet
werden kann (außer für die öffentlichen Bereiche). Das muss durch Verwendung von OAuth durchgeführt werden da
Twitter seine grundsätzliche HTTP Authentifizierung mit August 2010 deaktiviert hat.

Es gibt zwei Optionen um Authorisierung zu ermöglichen. Der erste ist die Implementierung des Workflows von
``ZendOauth`` über ``Zend\Service\Twitter`` welche zu einem internen ``ZendOauth\Consumer`` Objekt weiterleitet.
Bitte sehen Sie in die Dokumentation von ``ZendOauth`` für ein vollständiges Beispiel dieses Workflows - man
kann alle dokumentierten Methoden von ``ZendOauth\Consumer`` auf ``Zend\Service\Twitter`` aufrufen inklusive der
Optionen des Constructors. Man kann ``ZendOauth`` auch direkt verwenden und nur den sich ergebenden Zugriffstoken
an ``Zend\Service\Twitter`` übergeben. Das ist der normale Workflow sobald man einen wiederverwendbaren
Zugriffstoken für einen bestimmten Twitter Benutzer bereitgestellt bekommt. Der sich ergebende Token für den
Zugriff mit OAuth sollte für die zukünftige Verwendung in einer Datenbank gespeichert werden (andernfalls muss
man sich für jede neue Instanz von ``Zend\Service\Twitter`` authorisieren). Man sollte im Kopf behalten dass die
Authorisierung über OAuth dazu führt dass der Benutzer zu Twitter umgeleitet wird um seine Bestätigung zur
beantragten Authorisierung zu geben (das wird für gespeicherte Zugriffstokens nicht wiederholt). Das benötigt
zusätzliche Arbeit (z.B. Umleiten von Benutzern und Bereitstellen einer Callback URL) über den vorherigen HTTP
Authentofizierungs Mechanismus bei dem ein Benutzer Anwendungen nur erlaubt seinen Benutzernamen und sein Passwort
zu speichern.

Das folgende Beispiel demonstriert das Setup von ``Zend\Service\Twitter`` welchem ein bereits bereitgestellter
OAuth Zugriffstoken angegeben wird. Der Zugriffstoken ist ein Serialisiertes Objekt, damit man dass serialisierte
Objekt in einer Datenbank speichern kann, und es zum Zeitpunkt des Empfangs deserialisiert bevor die Objekte an
``Zend\Service\Twitter`` übergeben werden. Die Dokumentation von ``ZendOauth`` demonstriert den Workflow wenn
Objekte involviert sind.

.. code-block:: php
   :linenos:

   /**
    * Wir nehmen an dass $serializedToken der serialisierte Token ist welchen wir
    * von einer Datenbank oder sogar von $_SESSION bekommen haben
    * (wenn dem einfachen dokumentierten Beispiel von ZendOauth gefolgt wird)
    */
   $token = unserialize($serializedToken);

   $twitter = new Zend\Service\Twitter(array(
       'username' => 'johndoe',
       'accessToken' => $token
   ));

   // Die Daten des Benutzers mit Twitter prüfen
   $response = $twitter->account->verifyCredentials();

.. note::

   Um sich bei Twitter zu authentifizieren, MÜSSEN ALLE Anwendungen bei Twitter registriert werden um einen Kunden
   Schlüssel und ein Kunden Geheimnis zu erhalten welches benutzt wird wenn mit OAuth authentifiziert wird. Diese
   können nicht zwischen mehreren Anwendungen wiederverwendet werden - man muss jede neue Anwendung separat
   registrieren. Zugriffstoken von Twitter haben kein Ablaufdatum, deshalb ist deren Speicherung in einer Datenbank
   zu empfehlen (sie können natürlich aktualisiert werden indem der OAuth Prozess der Authorisierung wiederholt
   wird). Das kann nur getan werden indem mit dem betreffenden Benutzer, welchem der Zugriffstoken gehört,
   interagiert wird.

   Die vorher gezeigte pre-OAuth Version von ``Zend\Service\Twitter`` erlaubte die Übergabe eines Benutzernamens
   als ersten Parameter statt in einem Array. Dies wird nicht länger unterstützt.

.. _zend.service.twitter.account:

Account Methoden
----------------

- ``verifyCredentials()`` testet ob die angegebenen Benutzerdaten gültig sind, und das mit einem minimalen
  Overhead.

  .. _zend.service.twitter.account.verifycredentails:

  .. rubric:: Die Angaben prüfen

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->account->verifyCredentials();

- ``endSession()`` meldet Benutzer aus der Clientanwendung ab.

  .. _zend.service.twitter.account.endsession:

  .. rubric:: Beenden von Sessions

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->account->endSession();

- ``rateLimitStatus()`` gibt die restliche Anzahl von *API* Anfragen zurück die der authentifizierte Benutzer noch
  hat, bevor das *API* Limit für die aktuelle Stunde erreicht ist.

  .. _zend.service.twitter.account.ratelimitstatus:

  .. rubric:: Status des Rating Limits

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->account->rateLimitStatus();

.. _zend.service.twitter.status:

Status Methoden
---------------

- ``publicTimeline()`` gibt die 20 letzten Statusmeldungen von nicht geschützten Benutzern mit einem eigenen
  Benutzericon zurück. Die öffentliche Zeitlinie wird von Twitter alle 60 Sekunden gecacht.

  .. _zend.service.twitter.status.publictimeline:

  .. rubric:: Empfangen der öffentlichen Zeitlinie

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->status->publicTimeline();

- ``friendsTimeline()`` gibt die 20 letzten Statusmeldungen zurück die von authentifizierten Benutzer und deren
  Freunde gesendet wurden.

  .. _zend.service.twitter.status.friendstimeline:

  .. rubric:: Empfangen der Zeitlinie von Freunden

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->status->friendsTimeline();

  Die ``friendsTimeline()`` Methode akzeptiert ein Array von optionalen Parameters um die Abfrage zu verändern.

  - *since* grenzt die zurückgegeben Ergebnisse auf jene Statusmeldungen ein die nach dem spezifizierten
    Datum/Zeit (bis zu 24 Stunden alt) erstellt wurden.

  - *page* spezifiziert die Seite die man zurückbekommen will.

- ``userTimeline()`` gibt die 20 letzten Statusmeldungen zurück die von authentifizierten Benutzern geschrieben
  wurden.

  .. _zend.service.twitter.status.usertimeline:

  .. rubric:: Empfangen der Zeitlinie von Benutzern

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->status->userTimeline();

  Die ``userTimeline()`` Methode akzeptiert ein Array von optionalen Parametern um die Abfrage zu verändern.

  - *id* spezifiziert die ID oder den Bildschirmnamen des Benutzers für den die friends_timeline zurückzugeben
    ist.

  - *since* grenzt die zurückzugebenden Ergebnisse auf jene Stati ein die nach dem spezifizierten Datum/Zeit (bis
    zu 24 Stunden als) erstellt wurden.

  - *page* spezifiziert welche Seite zurückgegeben werden soll.

  - *count* spezifiziert die Anzahl der Stati die man erhalten will. Kann nicht größer als 200 sein.

- ``show()`` gibt einen einzelnen Status zurück, der durch den ID Parameter, wie anbei, spezifiziert wird. Der
  Author des Status wird auch zurückgegeben.

  .. _zend.service.twitter.status.show:

  .. rubric:: Den Status eines Benutzers sehen

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->status->show(1234);

- ``update()`` aktualisiert den Status des authentifizierten Benutzers. Diese Methode erwartet das der
  aktualisierte Status übergeben wird den man an Twitter übermitteln will.

  .. _zend.service.twitter.status.update:

  .. rubric:: Aktualisieren des Benutzerstatus

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->status->update('Mein größter Tweet');

  Die ``update()`` Methode akzeptiert einen zweiten optionalen Parameter.

  - *in_reply_to_status_id* spezifiziert die ID eines bestehenden Status auf den dieser Status als Antwort gesendet
    werden soll.

- ``replies()`` gibt die 20 letzten Antworten/@replies (Statusaktualisierungen die mit @username anfangen) für den
  authentifizierten Benutzer zurück.

  .. _zend.service.twitter.status.replies:

  .. rubric:: Zeigt Benutzerantworten

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->status->replies();

  Die ``replies()`` Methode akzeptiert ein Array von optionalen Parametern um die Anfrage zu verändern.

  - *since* grenzt die Ergebnisse die man erhält auf jene ein, deren Stati nach dem spezifizierten Datum/Zeit (bis
    zu 24 Stunden alt) erstellt wurden.

  - *page* spezifiziert welche Seite soll zurückgegeben werden.

  - *since_id* gibt nur Stati zurück die eine größere ID (das ist die aktuellere) als die spezifizierte ID
    haben.

- ``destroy()`` entfernt den Status der durch den benötigten *id* Parameter spezifiziert ist.

  .. _zend.service.twitter.status.destroy:

  .. rubric:: Löschen eines Benutzerstatus

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->status->destroy(12345);

.. _zend.service.twitter.user:

Benutzermethoden
----------------

- ``friends()`` gibt bis zu 100 Freunde des authentifizierten Benutzers zurück, die zuletzt aktualisiert haben,
  und jeden von Ihnen mit dem aktuellen Status.

  .. _zend.service.twitter.user.friends:

  .. rubric:: Empfangen von Benutzerfreunden

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->user->friends();

  Die ``friends()`` Methode akzeptiert ein Array von optionalen Parameter um die Abfrage zu verändern.

  - *id* spezifiziert die ID oder den Bildschirmnamen des Benutzers von dem die Liste an Freunden zurückgegeben
    werden soll.

  - *since* grenzt die zurückzugebenden Ergebnisse auf jene Stati ein die nach dem spezifizierten Datum/Zeit (bis
    zu 24 Stunden als) erstellt wurden.

  - *page* spezifiziert welche Seite soll zurückgegeben werden.

- ``followers()`` gibt die Verfolger des authentifizierten Benutzers zurück, und jeden von Ihnen mit seinem
  aktuellen Status.

  .. _zend.service.twitter.user.followers:

  .. rubric:: Empfangen der Verfolger eines Benutzers

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->user->followers();

  Die ``followers()`` Methode akzeptiert ein Array von optionalen Parametern welche die Anfrage verändern.

  - *id* spezifiziert die ID oder den Bildschirmnamen des Benutzers von dem die Liste an Verfolgern zurückgegeben
    werden soll.

  - *page* spezifiziert welche Seite soll zurückgegeben werden.

- ``show()`` gibt erweiterte Informationen über einen angegebenen Benutzer zurück, der durch eine ID oder einen
  Bildschirmnamen spezifiziert wird wie durch den anbei benötigten *id* Parameter.

  .. _zend.service.twitter.user.show:

  .. rubric:: Zeigt Benutzerinformationen

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->user->show('myfriend');

.. _zend.service.twitter.directmessage:

Methoden zur direkten Benachrichtigung
--------------------------------------

- ``messages()`` gibt eine Liste der 20 letzten direkten Nachrichten für den authentifizierten Benutzer zurück.

  .. _zend.service.twitter.directmessage.messages:

  .. rubric:: Empfangen der letzten empfangenen direkten Nachrichten

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->directMessage->messages();

  Die ``message()`` Methode akzeptiert ein Array von optionalen Parametern um die Anfrage zu verändern.

  - *since_id* gibt nur direkte Nachrichten mit einer ID zurück, die größer als (das ist aktueller als) die
    spezifizierte ID sind.

  - *since* grenzt die zurückzugebenden Ergebnisse auf jene Stati ein die nach dem spezifizierten Datum/Zeit (bis
    zu 24 Stunden als) erstellt wurden.

  - *page* spezifiziert welche Seite soll zurückgegeben werden.

- ``sent()`` gibt eine Liste der 20 letzten direkten Nachrichten zurück die vom authentifizierten Benutzer
  gesendet wurden.

  .. _zend.service.twitter.directmessage.sent:

  .. rubric:: Empfangen der letzten gesendeten direkten Nachrichten

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->directMessage->sent();

  Die ``sent()`` Methode akzeptiert ein Array von optionalen Parametern um die Abfrage zu verändern.

  - *since_id* gibt nur direkte Nachrichten mit einer ID zurück, die größer als (das ist aktueller als) die
    spezifizierte ID sind.

  - *since* grenzt die zurückzugebenden Ergebnisse auf jene Stati ein die nach dem spezifizierten Datum/Zeit (bis
    zu 24 Stunden als) erstellt wurden.

  - *page* spezifiziert welche Seite soll zurückgegeben werden.

- ``new()`` sendet eine neue direkte Nachricht vom authentifizierten Benutzer zum spezifizierten Benutzer.
  Benötigt sowohl den Benutzer also auch den Text Parameter wie unten gezeigt.

  .. _zend.service.twitter.directmessage.new:

  .. rubric:: Senden einer direkten Nachricht

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->directMessage->new('myfriend', 'mymessage');

- ``destroy()`` entfernt eine direkte Nachricht die im benötigten *id* Parameter spezifiziert wird. Der
  authentifizierte Benutzer muß der Empfänger der spezifizierten direkten Nachricht sein.

  .. _zend.service.twitter.directmessage.destroy:

  .. rubric:: Löschen einer direkten Nachricht

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->directMessage->destroy(123548);

.. _zend.service.twitter.friendship:

Methoden für die Freundschaft
-----------------------------

- ``create()`` befreundet den im *id* Parameter spezifizierten Benutzer mit dem authentifizierten Benutzer.

  .. _zend.service.twitter.friendship.create:

  .. rubric:: Erstellung eines Freundes

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->friendship->create('mynewfriend');

- ``destroy()`` beendet die Freundschaft des im *id* Parameter spezifizierten Benutzers, mit dem authentifizierten
  Benutzer.

  .. _zend.service.twitter.friendship.destroy:

  .. rubric:: Löschen eines Freundes

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->friendship->destroy('myoldfriend');

- ``exists()`` testet ob eine Freundschaft zwischen dem authentifizierten Benutzer und dem im *id* Parameter
  übergebenen Benutzer existiert.

  .. _zend.service.twitter.friendship.exists:

  .. rubric:: Prüfen ob eine Freundschaft existiert

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->friendship->exists('myfriend');

.. _zend.service.twitter.favorite:

Methoden für Favoriten
----------------------

- ``favorites()`` gibt die 20 letzten Stati von Favoriten für den authentifizierten oder durch den *id* Parameter
  spezifizierten Benutzer zurück.

  .. _zend.service.twitter.favorite.favorites:

  .. rubric:: Favoriten empfangen

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->favorite->favorites();

  Die ``favorites()`` Methode akzeptiert ein Array von optionalen Parametern um die Abfrage zu modifizieren.

  - *id* spezifiziert die ID oder der Bildschirmname des Benutzers von dem die Liste der bevorzugten Stati
    zurückgegeben werden soll.

  - *page* spezifiziert welche Seite soll zurückgegeben werden.

- ``create()`` favorisiert den mit dem *id* Parameter spezifizierten Status für den authentifizierten Benutzer

  .. _zend.service.twitter.favorite.create:

  .. rubric:: Favoriten erstellen

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->favorite->create(12351);

- ``destroy()`` entfernt die Favorisierung des des mit dem *id* Parameter spezifizierten Status für den
  authentifizierten Benutzer.

  .. _zend.service.twitter.favorite.destroy:

  .. rubric:: Entfernt Favoriten

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->favorite->destroy(12351);

.. _zend.service.twitter.block:

Blockierende Methoden
---------------------

- ``exists()`` retourniert ob der authentifizierende Benutzer einen Zielbenutzer blockiert und kann optional das
  Objekt des blockierten Benutzers zurückgeben wenn ein Block existiert.

  .. _zend.service.twitter.block.exists:

  .. rubric:: Prüfen ob ein Block existiert

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));

     // gibt true oder false zurück
     $response = $twitter->block->exists('blockeduser');

     // gibt die Info des blockierten Benutzers zurück wenn dieser blockiert ist
     $response2 = $twitter->block->exists('blockeduser', true);

  Die ``favorites()`` Methode akzeptiert einen optionalen zweiten Parameter.

  - *returnResult* spezifiziert ob das Objekt des Benutzers zurückgegeben werden soll, oder einfach nur ``TRUE``
    oder ``FALSE``.

- ``create()`` blockiert den Benutzer der im *id* Parameter als authentifizierter Benutzer spezifiziert wurde und
  löscht eine Freundschaft zum blockierten Benutzer wenn eine existiert. Gibt den blockierten Benutzer im
  angeforderten Format zurück wenn es erfolgreich war

  .. _zend.service.twitter.block.create:

  .. rubric:: Einen Benutzer blockieren

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->block->create('usertoblock);

- ``destroy()`` entfernt die Blockierung des Benutzers der im *id* Parameter für den authentifizierten Benutzer
  spezifiziert wurde. Gibt den un-blockierten Benutzer im angeforderten Format zurück wenn diese erfolgreich war.

  .. _zend.service.twitter.block.destroy:

  .. rubric:: Entfernung einer Blockierung

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));
     $response = $twitter->block->destroy('blockeduser');

- ``blocking()`` gibt ein Array von Benutzerobjekten zurück die der authentifizierte Benutzer blockiert.

  .. _zend.service.twitter.block.blocking:

  .. rubric:: Wen blockiert man

  .. code-block:: php
     :linenos:

     $twitter = new Zend\Service\Twitter(array(
         'username' => 'johndoe',
         'accessToken' => $token
     ));

     // gibt die komplette Benutzerliste zurück
     $response = $twitter->block->blocking(1);

     // gibt ein Array von nummerischen Benutzer IDs zurück
     $response2 = $twitter->block->blocking(1, true);

  Die ``favorites()`` Methode akzeptiert zwei optionale Parameter.

  - *page* spezifiziert die man zurück erhalten will. Eine einzelne Seite enthält 20 Id's.

  - *returnUserIds* spezifiziert ob ein Array von nummerischen Benutzer Id's zurückzugeben ist welche der
    authenzifizierte Benutzer blockiert, oder ein Array von Benutzerobjekten.

.. include:: zend.service.twitter.search.rst


.. _`RESTAPI von Twitter`: http://apiwiki.twitter.com/Twitter-API-Documentation
