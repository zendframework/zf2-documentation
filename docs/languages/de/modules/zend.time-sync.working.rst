.. _zend.timesync.working:

Arbeiten mit Zend_TimeSync
==========================

``Zend_TimeSync`` kann die aktuelle Zeit von jedem angegebenen **NTP** oder **SNTP** Zeitserver zurückgeben. Es
kann automatisch mehrere Server handhaben und bietet ein einfaches Interface.

.. note::

   Alle Beispiele in diesem Kapitel verwenden einen öffentlichen, generellen Zeitserver:
   **0.europe.pool.ntp.org**. Man sollte einen öffentlichen, generellen Zeitserver verwenden, der in der Nähe des
   eigenen Anwendungsservers steht. Siehe `http://www.pool.ntp.org`_ für Informationen.

.. _zend.timesync.working.generic:

Generelle Anfragen von Zeitserver
---------------------------------

Die Anfrage der Zeit von einem Zeitserver ist einfach. Zuerst gibt man den Zeitserver, von dem man die Zeit
anfragen will, an.

.. code-block:: php
   :linenos:

   $server = new Zend_TimeSync('0.pool.ntp.org');

   print $server->getDate()->getIso();

Was passiert also im Hintergrund von ``Zend_TimeSync``? Zuerst wird der Syntax des Timeservers geprüft. In unserem
Beispiel wird also '**0.pool.ntp.org**' geprüft und als möglicherweise richtige Adresse für einen Zeitserver
erkannt. Wenn jetzt ``getDate()`` aufgerufen wird, wird der aktuell gesetzte Zeitserver angefragt und dieser gibt
dessen eigene Zeit zurück. ``Zend_TimeSync`` berechnet darauf die Differenz zur aktuellen Zeit des Servers, auf
dem das Skript läuft, und gibt ein ``Zend_Date`` Objekt mit der korrigierten Zeit zurück.

Für Details über ``Zend_Date`` und dessen Methoden siehe unter der Dokumentation von :ref:`Zend_Date
<zend.date.introduction>` nach.

.. _zend.timesync.working.multiple:

Mehrere Zeitserver
------------------

Nicht alle Zeitserver sind immer erreichbar und geben eine Zeit zurück. Server können wärend Wartungsarbeiten
nicht erreichbar sein. Wenn die Zeit nicht vom Zeitserver angefragt werden kann, erhält man eine Exception.

``Zend_TimeSync`` ist eine einfache Lösung, die mehrere Zeitserver behandeln kann und einen automatischen Fallback
Mechanismus bietet. Es gibt zwei unterstützte Wege; man kann entweder ein Array von Zeitservern angeben wenn die
Instanz erstellt wird, oder zusätzliche Zeitserver zur Instanz durch Verwendung der Methode ``addServer()``
hinzufügen.

.. code-block:: php
   :linenos:

   $server = new Zend_TimeSync(array('0.pool.ntp.org',
                                     '1.pool.ntp.org',
                                     '2.pool.ntp.org'));
   $server->addServer('3.pool.ntp.org');

   print $server->getDate()->getIso();

Es gibt keine Begrenzung in der Anzahl an Zeitservern, die hinzugefügt werden können. Wenn ein Zeitserver nicht
erreicht werden kann, dann fällt ``Zend_TimeSync`` zurück und versucht den nächsten Zeitserver zu erreichen.

Wenn man mehr als einen Zeitserver angibt - was die beste Praxis für ``Zend_TimeSync`` ist - sollte man jeden
Server benennen. Man kann die Server mit dem Arrayschlüssel, mit dem zweiten Parameter wärend der Initiierung
oder mit dem zweiten Parameter beim Hinzufügen von anderen Zeitservern, benennen.

.. code-block:: php
   :linenos:

   $server = new Zend_TimeSync(array('generic'  => '0.pool.ntp.org',
                                     'fallback' => '1.pool.ntp.org',
                                     'reserve'  => '2.pool.ntp.org'));
   $server->addServer('3.pool.ntp.org', 'additional');

   print $server->getDate()->getIso();

Die Benennung der Zeitserver gibt die Möglichkeit, dass ein spezieller Zeitserver angefragt werden kann, wie man
später in diesem Kapitel sieht.

.. _zend.timesync.working.protocol:

Protokolle von Zeitservern
--------------------------

Es gibt verschiedene Typen von Zeitservern. Die meisten öffentlichen Zeitserver verwenden **NTP** als Protokoll.
Es sind auch andere Zeit Synchronisationsprotokolle vorhanden.

Man kann das richtige Prokoll mit der Adresse des Zeitservers setzen. Aktuell gibt es zwei Prokolle, die von
``Zend_TimeSync`` unterstützt werden: **NTP** und **SNTP**. Das Standardprotokoll ist **NTP**. Wenn man nur
**NTP** verwendet, kann man das Protokoll in der Adresse, wie im vorherigen Beispiel gezeigt, unterdrücken.

.. code-block:: php
   :linenos:

   $server = new Zend_TimeSync(array('generic'  => 'ntp:\\0.pool.ntp.org',
                                     'fallback' => 'ntp:\\1.pool.ntp.org',
                                     'reserve'  => 'ntp:\\2.pool.ntp.org'));
   $server->addServer('sntp:\\internal.myserver.com', 'additional');

   print $server->getDate()->getIso();

``Zend_TimeSync`` kann gemischte Zeitserver verwenden. Man ist also nicht auf ein einzelnes Prokoll beschränkt,
aber man kann jeden Zeitserver unabhängig von seinem Protokoll hinzufügen.

.. _zend.timesync.working.ports:

Ports für Zeitserver verwenden
------------------------------

Wie bei jedes Protkoll im World Wide Web, verwenden die Protokolle **NTP** und **SNTP** Standardports. NTP
verwendet den Port **123**, SNTP hingegen den Port **37**.

Aber manchmal weicht der, für ein Protokoll verwendete Port vom Standard ab. Der zu verwendende Port kann mit der
Adresse für jeden Server definiert werden. Es muß nur die Nummer des Ports nach der Adresse hinzugefügt werden.
Wenn kein Port definiert wurde, dann verwendet ``Zend_TimeSync`` den Standardport.

.. code-block:: php
   :linenos:

   $server = new Zend_TimeSync(array('generic'  => 'ntp:\\0.pool.ntp.org:200',
                                     'fallback' => 'ntp:\\1.pool.ntp.org'));
   $server->addServer('sntp:\\internal.myserver.com:399', 'additional');

   print $server->getDate()->getIso();

.. _zend.timesync.working.options:

Optionen für Zeitserver
-----------------------

Es gibt nur eine Option in ``Zend_TimeSync`` die intern verwendet wird: **timeout**. Wenn gewünscht, können
beliebige selbstdefinierte Optionen verwendent und abgefragt werden.

Die Option **timeout** definiert die Anzahl an Sekunden nach der eine Verbindung als abgebrochen erkannt wird, wenn
keine Antwort kommt. Der Standardwert ist **1**, was bedeutet das ``Zend_TimeSync`` auf den nächsten Zeitserver
zurückfällt, wenn der angefragte Server nicht in einer Sekunde antwortet.

Mit der ``setOptions()`` Methode kann jede Option gesetzt werden. Diese Funktion akzeptiert ein Array, wobei die
Schlüssel die zu setzende Option sind und der Wert der Wert dieser Option. Jede vorher gesetzte Option wird mit
dem neuen Wert überschrieben. Wenn man wissen will, welche Optionen gesetzt sind, kann die ``getOptions()``
Methode verwendet werden. Sie akzeptiert entweder einen Schlüssel, der die gegebene Option zurückgibt sofern
diese gesetzt ist, oder, wenn kein Schlüssel angegeben wird, gibt sie alle gesetzten Optionen zurück.

.. code-block:: php
   :linenos:

   Zend_TimeSync::setOptions(array('timeout' => 3, 'myoption' => 'timesync'));
   $server = new Zend_TimeSync(array('generic'  => 'ntp:\\0.pool.ntp.org',
                                     'fallback' => 'ntp:\\1.pool.ntp.org'));
   $server->addServer('sntp:\\internal.myserver.com', 'additional');

   print $server->getDate()->getIso();
   print_r(Zend_TimeSync::getOptions();
   print "Timeout = " . Zend_TimeSync::getOptions('timeout');

Wie man sieht, sind die Optionen für ``Zend_TimeSync`` statisch. Jede Instanz von ``Zend_TimeSync`` verwendet die
gleichen Optionen.

.. _zend.timesync.working.different:

Verschiedene Zeitserver verwenden
---------------------------------

``Zend_TimeSync``'s Standardverhalten für die Anfrage einer Zeit ist diese vom ersten gegebenen Server anzufragen.
Manchmal ist es aber sinnvoll, einen anderen Zeitserver zu setzen, von dem die Zeit abgefragt werden soll. Das kann
mit der ``setServer()`` Methode getan werden. Um den zu verwendenden Zeitserver zu definieren, muss einfach der
Alias als Parameter in dieser Methode gesetzt werden. Und um den aktuell verwendeten Zeitserver zu erhalten, kann
die ``getServer()`` Methode aufgerufen werden. Wenn kein Parameter angegeben wird, wird der aktuelle Zeitserver
zurückgegeben.

.. code-block:: php
   :linenos:

   $server = new Zend_TimeSync(array('generic'  => 'ntp:\\0.pool.ntp.org',
                                     'fallback' => 'ntp:\\1.pool.ntp.org'));
   $server->addServer('sntp:\\internal.myserver.com', 'additional');

   $actual = $server->getServer();
   $server = $server->setServer('additional');

.. _zend.timesync.working.informations:

Informationen von Zeitservern
-----------------------------

Zeitserver bieten nicht nur die Zeit selbst, sondern auch zusätzliche Informationen. Man kann diese Informationen
mit der ``getInfo()`` Methode erhalten.

.. code-block:: php
   :linenos:

   $server = new Zend_TimeSync(array('generic'  => 'ntp:\\0.pool.ntp.org',
                                     'fallback' => 'ntp:\\1.pool.ntp.org'));

   print_r ($server->getInfo());

Die zurückgegebenen Informationen unterscheiden sich im verwendeten Protokoll und im verwendeten Server.

.. _zend.timesync.working.exceptions:

Behandeln von Ausnahmen
-----------------------

Ausnahmen werden für alle Zeitserver gesammelt und als Array zurückgegeben. Es ist also möglich, durch alle
geworfenen Ausnahmen zu laufen, wie im folgenden Beispiel gezeigt: gezeigt:

.. code-block:: php
   :linenos:

   $serverlist = array(
           // invalid servers
           'invalid_a'  => 'ntp://a.foo.bar.org',
           'invalid_b'  => 'sntp://b.foo.bar.org',
   );

   $server = new Zend_TimeSync($serverlist);

   try {
       $result = $server->getDate();
       echo $result->getIso();
   } catch (Zend_TimeSync_Exception $e) {

       $exceptions = $e->get();

       foreach ($exceptions as $key => $myException) {
           echo $myException->getMessage();
           echo '<br />';
       }
   }



.. _`http://www.pool.ntp.org`: http://www.pool.ntp.org
