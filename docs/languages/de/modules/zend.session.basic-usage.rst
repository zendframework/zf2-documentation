.. EN-Revision: none
.. _zend.session.basic_usage:

Grundsätzliche Verwendung
=========================

``Zend_Session_Namespace`` Instanzen stellen die primäre *API* für das Manipulieren von Session Daten im Zend
Framework bereit. Namensräume werden verwendet um alle Session Daten zu kapseln, aber es existiert auch ein
Standard Namensraum für jene die nur einen Namensraum für alle Session Daten benötigen. ``Zend_Session``
verwendet die Erweiterung ext/session und dessen spezielle superglobale Variable ``$_SESSION`` als
Speichermechanismus für Session Daten. Wärend ``$_SESSION`` im globalen Namensraum von *PHP* noch immer vorhanden
ist, sollten Entwickler davon absehen diese direkt zu verwenden, damit ``Zend_Session`` und
``Zend_Session_Namespace`` am effizientesten und sichersten Ihre Sammlung von Session relevanten Funktionen
bereitstellen können.

Jede Instanz von ``Zend_Session_Namespace`` korrespondiert mit einem Eintrag des Superglobalen Arrays
``$_SESSION``, wobei die Namensräume als Schlüssel verwendet werden.

.. code-block:: php
   :linenos:

   $myNamespace = new Zend_Session_Namespace('myNamespace');

   // $myNamespace corresponds to $_SESSION['myNamespace']

Es ist möglich ``Zend_Session`` in Verbindung mit anderem Code zu verwenden welche ``$_SESSION`` direkt verwendet.
Um Probleme zu vermeiden wird trotzdem stärkstens empfohlen das solcher Code nur Teile von ``$_SESSION`` verwendet
die nicht mit Instanzen von ``Zend_Session_Namespace`` korrespondieren.

.. _zend.session.basic_usage.basic_examples:

Übungs Beispiele
----------------

Wenn kein Namensraum bei der Instanziierung von ``Zend_Session_Namespace`` definiert wurde, werden alle Daten
transparent in einem Namensraum gespeichert der "*Default*" heißt. ``Zend_Session`` ist nicht dazu gedacht um
direkt mit den Inhalten von Containern der Session Namensräume zu arbeiten. Stattdessen wird
``Zend_Session_Namespace`` verwendet. Das folgende Beispiel demonstriert die Verwendung dieses Standard Namensraums
und zeigt wie die Anzahl der Zugriffe eines Benutzers gezählt werden kann.

.. _zend.session.basic_usage.basic_examples.example.counting_page_views:

.. rubric:: Seitenzugriffe zählen

.. code-block:: php
   :linenos:

   $defaultNamespace = new Zend_Session_Namespace('Default');

   if (isset($defaultNamespace->numberOfPageRequests)) {
    // Das erhöht den Zählen für jeden Seitenaufruf
       $defaultNamespace->numberOfPageRequests++;
   } else {
       $defaultNamespace->numberOfPageRequests = 1; // Erster Zugriff
   }

   echo "Seitenzugriffe in dieser Session: ",
       $defaultNamespace->numberOfPageRequests;

Wenn mehrere Module Instanzen von ``Zend_Session_Namespace`` verwenden die verschiedene Namensräume haben, erhält
jedes Modul Datenkapselung für die eigenen Daten der Session. Dem ``Zend_Session_Namespace`` Konstruktor kann ein
optionales ``$namespace`` Argument übergeben werden, welches Entwicklern erlaubt Session Daten in eigene
Namensräume zu partitionieren. Die Verwendung von Namensräumen ist ein effektiver und populärer Weg um Session
Daten gegenüber Änderungen durch ungewollte Namenskollisionen sicher zu machen.

Namen für Namensräume sind limitiert auf Sequenzen von Zeichen die als nicht leere *PHP* Strings dargestellt
werden und nicht mit einem Unterstrich ("*_*") Zeichen beginnen. Nur Kern Komponenten die im Zend Framework
inkludiert sind sollten Namen für Namensräume der wenden die mit "*Zend*" beginnen.

.. _zend.session.basic_usage.basic_examples.example.namespaces.new:

.. rubric:: Neuer Weg: Namensräume verhindern Kollisionen

.. code-block:: php
   :linenos:

   // In der Zend_Auth Komponente
   require_once 'Zend/Session.php';
   $authNamespace = new Zend_Session_Namespace('Zend_Auth');
   $authNamespace->user = "meinbenutzername";

   // In einer Web Service Komponente
   $webServiceNamespace = new Zend_Session_Namespace('Mein_Web_Service');
   $webServiceNamespace->user = "meinwebbenutzername";

Das obige Beispiel erzielt den gleichen Effekt wie der folgende Code, ausser das die obigen Session Objekte die
Kapselung der Session Daten innerhalb des jeweiligen Namensraumes aufrecht erhält.

.. _zend.session.basic_usage.basic_examples.example.namespaces.old:

.. rubric:: Alter Weg: PHP Session Zugriff

.. code-block:: php
   :linenos:

   $_SESSION['Zend_Auth']['user'] = "meinbenutzername";
   $_SESSION['Some_Web_Service']['user'] = "meinwebbenutzername";

.. _zend.session.basic_usage.iteration:

Session Namensräume wiederholen
-------------------------------

``Zend_Session_Namespace`` stellt das komplette `IteratorAggregate Interface`_ zur Verfügung, was die
Unterstützung der *foreach* Anweisung beinhält:

.. _zend.session.basic_usage.iteration.example:

.. rubric:: Session wiederholen

.. code-block:: php
   :linenos:

   $aNamespace =
       new Zend_Session_Namespace('Einige_Namensräume_Mit_aktuellen_Daten');

   foreach ($aNamespace as $index => $value) {
       echo "aNamespace->$index = '$value';\n";
   }

.. _zend.session.basic_usage.accessors:

Zugriffsfunktionen für Session Namensräume
------------------------------------------

``Zend_Session_Namespace`` implementiert die `magischen Methoden`_ ``__get()``, ``__set()``, ``__isset()``, und
``__unset()`` welche nicht direkt angesprochen werden sollte, ausser von innerhalb einer Subklasse. Stattdessen
verwenden die normalen Opteratoren automatisch diese Methoden, wie im folgenden Beispiel:

.. _zend.session.basic_usage.accessors.example:

.. rubric:: Zugriff auf Session Daten

.. code-block:: php
   :linenos:

   $namespace = new Zend_Session_Namespace(); // Standard Namensraum

   $namespace->foo = 100;

   echo "\$namespace->foo = $namespace->foo\n";

   if (!isset($namespace->bar)) {
       echo "\$namespace->bar nicht gesetzt\n";
   }

   unset($namespace->foo);



.. _`IteratorAggregate Interface`: http://www.php.net/~helly/php/ext/spl/interfaceIteratorAggregate.html
.. _`magischen Methoden`: http://www.php.net/manual/de/language.oop5.overloading.php
