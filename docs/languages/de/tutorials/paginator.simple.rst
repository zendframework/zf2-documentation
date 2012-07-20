.. _learning.paginator.simple:

Einfaches Beispiel
==================

In diesem ersten Beispiel wollen wir nichts spektakuläres, aber hoffentlich gibt es eine gute Idee darüber wozu
``Zend_Paginator`` designt wurde. Angenommen wir haben ein Array das $data heißt mit den Zahlen 1 bis 100 in Ihm,
welches wir in eine Anzahl von Seiten aufteilen wollen. Man kann die statische ``factory()`` Methode in der Klasse
``Zend_Paginator`` verwenden um ein ``Zend_Paginator`` Objekt mit unseren Array in Ihm zu erhalten.

.. code-block:: php
   :linenos:

   // Erstellt ein Array mit den Zahlen 1 bis 100
   $data = range(1, 100);

   // Holt ein Paginator Objekt und verwendet Zend_Paginator's eingebaute Factory
   $paginator = Zend_Paginator::factory($data);

Wir sind fast fertig! Die Variable $paginator enthält jetzt eine Referenz auf das Paginator Objekt.
Standardmäßig ist es eingestellt 10 Elemente pro Seite anzuzeigen. Um die Elemente für die aktuell aktive Seite
anzuzeigen, ist alles was getan werden muss durch das Paginator Objekt mit einer foreach Schleife zu iterieren. Die
aktuell aktive Seite ist standardmäßig die erste Seite wenn Sie nicht explizit spezifiziert wurde. Wir werden
später sehen wie eine spezifische Seite ausgewählt werden kann. Der folgende Abschnitt zeigt eine unsortierte
Liste welche die Zahlen 1 bis 10 enthält ,welche die Zahlen der ersten Seite sind.

.. code-block:: php
   :linenos:

   // Erstellt ein Array mit den Zahlen 1 bis 100
   $data = range(1, 100);

   // Holt ein Paginator Objekt und verwendet Zend_Paginator's eingebaute Factory
   $paginator = Zend_Paginator::factory($data);

   ?><ul><?php

   // Jedes Element der aktuellen Seite in einem Listen Element darstellen
   foreach ($paginator as $item) {
       echo '<li>' . $item . '</li>';
   }

   ?></ul>

Jetzt versuchen wir die Elemente der zweiten Seite darzustellen. Die ``setCurrentPageNumber()`` Methode kann
verwendet werden um auszuwählen welche Seite man sehen will.

.. code-block:: php
   :linenos:

   // Erstellt ein Array mit den Zahlen 1 bis 100
   $data = range(1, 100);

   // Holt ein Paginator Objekt und verwendet Zend_Paginator's eingebaute Factory
   $paginator = Zend_Paginator::factory($data);

   // Wählt die zweite Seite
   $paginator->setCurrentPageNumber(2);

   ?><ul><?php

   // Jedes Element der aktuellen Seite in einem Listen Element darstellen
   foreach ($paginator as $item) {
       echo '<li>' . $item . '</li>';
   }

   ?></ul>

Wie erwartet stellt dieser kleine Abschnitt eine unsortierte Liste mit den Zahlen 11 bis 20 in Ihm dar.

Dieses einfache Beispiel demonstriert einen kleinen Teil davon was mit ``Zend_Paginator`` getan werden kann. Aber
eine echte Anwendung liest selten in seinen Daten von einem reinen Array, deshalb ist der nächste Abschnitt dazu
gedacht zu zeigen wir man Paginator verwenden kann um Ergebnisse einer Datenbank Abfrage seitenweise darzustellen.
Bevor weitergelesen wird, sollte man sicherstellen das man sich damit auskennt wie ``Zend_Db_Select`` arbeitet!

Im Datenbank Beispiel sehen wir nach einer Tabelle mit Blog Posts welche 'posts' genannt wird. Gehen wir direkt
hinein und schauen uns ein einfaches Beispiel an.

.. code-block:: php
   :linenos:

   // Eine Select Abfrage erstellen. $db ist ein Zend_Db_Adapter Objekt, von dem
   // wir annehmen das es bereits im Skript existiert
   $select = $db->select()->from('posts')->order('date_created DESC');

   // Holt ein Paginator Objekt und verwendet Zend_Paginator's eingebaute Factory
   $paginator = Zend_Paginator::factory($select);

   // Wählt die zweite Seite
   $paginator->setCurrentPageNumber(2);

   ?><ul><?php

   // Jedes Element der aktuellen Seite in einem Listen Element darstellen
   foreach ($paginator as $item) {
       echo '<li>' . $item->title . '</li>';
   }

   ?></ul>

Wie man sehen kann ist dieses Beispiel nicht sehr unterschiedlich vom vorhergehenden. Der einzige Unterschied
besteht darin dass man ein ``Zend_Db_Select`` Objekt statt einem Array an die ``factory()`` Methode des Paginator's
übergibt. Für weitere Details darüber wie der Datenbank Adapter sicherstellt das eigene Anfragen effizient
ausgeführt werden, sollte in das ``Zend_Paginator`` Kapitel im Referenz Handbuch bei den Adaptern DbSelect und
DbTableSelect nachgesehen werden.


