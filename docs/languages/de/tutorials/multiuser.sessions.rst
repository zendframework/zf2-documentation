.. EN-Revision: none
.. _learning.multiuser.sessions:

User Session im Zend Framework managen
======================================

.. _learning.multiuser.sessions.intro:

Einführung in Sessions
----------------------

Der Erfolg des Webs ist tief verwurzelt im Protokoll welches das Web antreibt: *HTTP*. *HTTP* über TCP ist von
seiner Natur her Statuslos, was bedeutet dass auch das Web selbst Statuslos ist. Wärend dieser Aspekt einer der
dominierenden Faktoren dafür ist warum das Web ein so populäres Medium geworden ist, verursacht es auch einige
interessante Probleme für Entwickler welche das Web als Anwendungsplattform verwenden wollen.

Das Akt der Interaktion mit einer Web Anwendung wird typischerweise definiert von der Summe aller Anfragen die an
den Web Server gesendet werden. Da es viele Konsumenten gibt die simultan bedient werden, muss die Anwendung
auswählen welche Anfragen zu welchem Benutzer gehören. Diese Anfragen sind typischerweise als "session" bekannt.

In *PHP* wurde das Session Problem durch die Session Erweiterung gelöst welche eine Form der Statusverfolgung,
typische Cookies und eine Form des lokalen Speichers verwendet der über die Superglobale $_SESSION bekanntgemacht
wird. Im Zend Framework fügt die Komponente ``Zend_Session`` zusätzliche Vorteile zu *PHP*'s Session Erweiterung
hinzu, welche es einfacher machen diese zu verwenden und auf objekt-orientierten Anwendungen beruht.

.. _learning.multiuser.sessions.basic-usage:

Grundsätzliche Verwendung von Zend_Session
------------------------------------------

Die Komponente ``Zend_Session`` ist sowohl ein Session Manager als auch eine *API* für das Speichern von Daten im
Session Objekt für eine Langzeit-Verfügbarkeit. Die *API* von ``Zend_Session`` ist für das Managen der Optionen
und des Verhaltens einer Session, wie Optionen, Starten und Stoppen einer Session, und ``Zend\Session\Namespace``
ist das aktuelle Objekt welches zum Speichern der Daten verwendet wird.

Wärend es generell eine gute Praxis ist eine Session im Bootstrap Prozess zu starten, ist dies generell nicht
notwendig da alle Sessions bei der ersten Erstellung eines ``Zend\Session\Namespace`` Objekts automatisch gestartet
werden.

``Zend_Application`` ist in der Lage ``Zend_Session`` als Teil des ``Zend\Application\Resource`` Systems zu
konfigurieren. Um das zu verwenden, nehmen wir an dass das Projekt ``Zend_Application`` für das Bootstrappen
verwendet. Man würde den folgenden Code in der Datei application.ini hinzufügen:

.. code-block:: php
   :linenos:

   resources.session.save_path = APPLICATION_PATH "/../data/session"
   resources.session.use_only_cookies = true
   resources.session.remember_me_seconds = 864000

Wie man sieht sind die übergebenen Optionen die gleichen Optionen welche man in der ext/session Erweiterung von
*PHP* erwarten würde zu finden. Diese Optionen stellen den Pfad zu den Session Dateien ein in dem Daten des
Projekts gespeichert werden. Da *INI* Dateien zusätzlich Konstanten verwenden können, wird das obige die
Konstante APPLICATION_PATH verwenden und relativ auf das Verzeichnis der Sessiondaten zeigen.

Die meisten Zend Framework Komponenten welche Sessions verwenden benötigen nichts zusätzliches um
``Zend_Session`` zu verwenden. An diesem Punkt verwendet man entweder eine Komponente welche ``Zend_Session``
verwendet, oder startet das Speichern eigener Daten in einer Session mit ``Zend\Session\Namespace``.

``Zend\Session\Namespace`` ist eine einfache Klasse welche auf Daten über eine einfach zu verwendende *API* in der
von ``Zend_Session`` gemanagten superglobalen $_SESSION verweist. Der Grund warum es ``Zend\Session\Namespace``
genannt wird ist, das es die Daten in $_SESSION effektiv namespaced, und es so mehreren Komponenten und Objekten
erlaubt Daten sicher zu speichern und zu empfangen. Im folgenden Code sehen wir wie ein einfacher hochzählender
Counter für Sessions erstellt werden kann der bei 1000 anfängt und sich selbst nach 1999 zurücksetzt.

.. code-block:: php
   :linenos:

   $mysession = new Zend\Session\Namespace('mysession');

   if (!isset($mysession->counter)) {
       $mysession->counter = 1000;
   } else {
       $mysession->counter++;
   }

   if ($mysession->counter > 1999) {
       unset($mysession->counter);
   }

Wie man oben sieht verwendet das Session Namespace Objekt die magischen \__get, \__set, \__isset, und \__unset um
die einfache und flüssige Interaktion mit der Session er erlauben. Die Information welche im obigen Beispiel
gespeichert wird, wird unter $_SESSION['mysession']['counter'] gespeichert.

.. _learning.multiuser.sessions.advanced-usage:

Gehobenere Verwendung von Zend_Session
--------------------------------------

Wenn man zusätzlich den DbTable Speicher Handler für ``Zend_Session`` verwenden will, dann kann man den folgenden
Code in der application.ini hinzufügen:

.. code-block:: php
   :linenos:

   resources.session.saveHandler.class = "Zend\Session\SaveHandler\DbTable"
   resources.session.saveHandler.options.name = "session"
   resources.session.saveHandler.options.primary.session_id = "session_id"
   resources.session.saveHandler.options.primary.save_path = "save_path"
   resources.session.saveHandler.options.primary.name = "name"
   resources.session.saveHandler.options.primaryAssignment.sessionId = "sessionId"
   resources.session.saveHandler.options.primaryAssignment.sessionSavePath = "sessionSavePath"
   resources.session.saveHandler.options.primaryAssignment.sessionName = "sessionName"
   resources.session.saveHandler.options.modifiedColumn = "modified"
   resources.session.saveHandler.options.dataColumn = "session_data"
   resources.session.saveHandler.options.lifetimeColumn = "lifetime"


