.. EN-Revision: none
.. _zend.cache.introduction:

Einführung
==========

``Zend_Cache`` bietet einen generellen Weg für das Cachen von Daten.

Cachen im Zend Framework wird mit Frontends durchgeführt, wobei Cache Datensätze über Backend Adapter (**File**,
**Sqlite**, **Memcached**...), durch ein flexibles System von IDs und Tags, gespeichert werden. Durch deren
Verwendung ist es einfach, spezielle Typen von Datensätzen im Nachhinein zu Löschen (zum Beispiel: "Löschen
aller Cache Datensätze welche mit einem bestimmten Tag markiert sind").

Der Kern des Moduls (``Zend_Cache_Core``) ist generell, flexibel und konfigurierbar. Nun gibt es - für spezielle
Bedürfnisse - Cache Frontends, welche ``Zend_Cache_Core`` erweitern: **Output**, **File**, **Function** und
**Class**.

.. _zend.cache.introduction.example-1:

.. rubric:: Ein Frontend mit Zend_Cache::factory() erzeugen

``Zend_Cache::factory()`` instanziiert korrekte Objekte und fügt sie zusammen. In diesem ersten Beispiel wird das
**Core** Frontend zusammen mit dem **File** Backend verwendet.

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 7200, // Lebensdauer des Caches 2 Stunden
      'automatic_serialization' => true
   );

   $backendOptions = array(
       'cache_dir' => './tmp/' // Verzeichnis, in welches die Cache Dateien kommen
   );

   // Ein Zend_Cache_Core Objekt erzeugen
   $cache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

.. note::

   **Frontends und Backends bestehend aus mehrfachen Wörtern**

   Bei einige Frontends und Backends werden mehrere Wörter verwendet wie z.B. 'ZendPlatform'. Wenn diese der
   Fabrik spezifiziert werden, müssen diese aufgeteilt werden indem man ein Trennzeichen verwendet, wie z.B. das
   Leerzeichen (' '), Bindestrich ('-'), oder den Punkt ('.').

.. _zend.cache.introduction.example-2:

.. rubric:: Das Ergebnis einer Datenbankabfrage cachen

Jetzt, da wir ein Frontend haben, kann jeder Typ von Daten gecached werden (Serialisierung ist eingeschaltet). Zum
Beispiel können Ergebnisse von sehr umfangreichen Datenbankabfragen gecached werden. Nach dem Cachen ist es sogar
gar nicht mehr notwendig, eine Verbindung zur Datenbank zu machen; Datensätze werden vom Cache genommen und
deserialisiert.

.. code-block:: php
   :linenos:

   // $cache initialisiert im vorhergehenden Beispiel

   // Nachsehen, ob der Cache bereits existiert:
   if(!$result = $cache->load('myresult')) {

       // Cache miss; mit Datenbank verbinden

       $db = Zend_Db::factory( [...] );

       $result = $db->fetchAll('SELECT * FROM huge_table');

       $cache->save($result, 'myresult');

   } else {

       // Cache hit! Ausgeben, damit wir es wissen
       echo "Der ist vom Cache!\n\n";

   }

   print_r($result);

.. _zend.cache.introduction.example-3:

.. rubric:: Cache Ausgabe mit dem Zend_Cache Frontend

Abschnitte, in denen die Ausgabe gecached werden soll, werden 'markiert', durch Hinzufügen von etwas bedingter
Logik, wobei der Abschnitt innerhalb der ``start()`` und ``end()`` Methoden gekapselt wird (das ähnelt dem ersten
Beispiel, und ist eine Kernstrategie für das Cachen).

Darin muß die Ausgabe der Daten wie immer geschehen - jede Ausgabe wird gecached, wenn die Ausführung auf die
``end()`` Methode trifft. Bei der nächsten Ausführung wird der komplette Abschnitt übersprungen, dafür werden
die Daten vom Cache geholt (solange der Cache Datensatz gültig ist).

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 30,                   // Lebenszeit des Caches 30 Sekunden
      'automatic_serialization' => false  // Dieser Wert ist der Standardwert
   );

   $backendOptions = array('cache_dir' => './tmp/');

   $cache = Zend_Cache::factory('Output',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   // Wir übergeben eine eindeutige Identifizierung an die start() Methode
   if(!$cache->start('mypage')) {
       // Ausgabe wie gewöhnlich:

       echo 'Hallo Welt! ';
       echo 'Das ist gecached ('.time().') ';

       $cache->end(); // Die Ausgabe wird gespeichert und zum Browser gesendet
   }

   echo 'Das wird nie gecached ('.time().').';

Zu beachten ist dass das Ergebnis von ``time()`` zweimal ausgegeben wird; das ist etwas dynamisches für
Demonstrationszwecke. Beim Versuch dieses auszuführen und mehrfach zu refreshen, kann bemerkt werden, dass sich
die erste Nummer nie ändert, während die zweite sich ändert, während die Zeit verstreicht. Das geschieht, weil
die erste Nummer, die im gecacheten Abschnitt ausgegeben wird, im Gegensatz zur anderen Ausgabe gecached wurde.
Nach einer halben Minute (die Lebensdauer wurde auf 30 Sekunden gesetzt) sind die Nummern wieder identisch, weil
der Cache Eintrag abgelaufen ist - er muß wieder gecached werden. Man sollte das im Browser oder in der Konsole
testen.

.. note::

   Wenn ``Zend_Cache`` benutzt wird, muß auf die wichtigen Cache Identifizierungen geachtet werden (welche an
   ``save()`` und ``start()`` übergeben werden). Diese müssen für jede Ressource einzigartig sein, die gecached
   werden soll. Andernfalls würden sich unverknüpfte Cache Datensätze gegenseitig entfernen oder, noch
   schlimmer, anstatt des anderen dargestellt werden.


