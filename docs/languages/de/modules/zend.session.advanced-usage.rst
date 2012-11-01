.. EN-Revision: none
.. _zend.session.advanced_usage:

Fortgeschrittene Benutzung
==========================

Wärend die Beispiele für die Basisnutzung völlig akzeptierbar sind, in ihrem Weg Zend Framework Sessions zu
Benutzen, ist auch die beste Praxis zu bedenken. Diese Sektion beschreibt die näheren Details von Session Handling
und illustriert die fortgeschrittene Benutzung der ``Zend_Session`` Komponente.

.. _zend.session.advanced_usage.starting_a_session:

Starten einer Session
---------------------

Wenn man alle Anfragen einer Session durch ``Zend_Session`` bearbeitet haben will, muß die Session in der
Bootstrap Datei gestartet werden:

.. _zend.session.advanced_usage.starting_a_session.example:

.. rubric:: Starten einer globalen Session

.. code-block:: php
   :linenos:

   Zend\Session\Session::start();

Durch das Starten der Session in der Bootstrap Datei verhindert man das die Session gestartet werden könnte
nachdem die Header an den Browser gesendet wurde, was zu einer Ausnahme und möglicherweise zu einer fehlerhaften
Seiten im Browser führen würde. Viele gehobenen Features benötigen zuerst ``Zend\Session\Session::start()``. (Mehr dazu
später in den gehobenen Features)

Es gibt vier Wege eine Session zustarten wenn ``Zend_Session`` verwendet wird. Zwei sind falsch.

. Falsch: *PHP*'s `session.auto_start Einstellung`_ darf nicht eingeschaltet werden. Wenn keine Möglichkeit
  besteht diese Einstellung in php.ini zu deaktivieren, und mod_php (oder ähnliches) verwendet wird, und die
  Einstellung schon in *php.ini* aktiviert ist, kann das folgende in der *.htaccess* Datei (normalerweise im *HTML*
  Dokumenten Basisverzeichnis) hinzugefügt werden:

  .. code-block:: apache
     :linenos:

     php_value session.auto_start 0

. Falsch: *PHP*'s `session_start()`_ Funktion darf nicht direkt verwendet werden. Wenn ``session_start()`` direkt,
  und anschließend ``Zend\Session\Namespace`` verwendet wird, wird von ``Zend\Session\Session::start()`` eine Ausnahme
  geworfen ("session has already been started"). Wenn ``Zend\Session\Session::start()`` ausgerufen wird, nachdem
  ``Zend\Session\Namespace`` verwendet wird oder ``Zend\Session\Session::start()`` explizit verwendet wird, wird ein Fehler
  vom Level ``E_NOTICE`` erzeugt und der Aufruf wird ignoriert.

. Richtig: Verwenden von ``Zend\Session\Session::start()``. Wenn es gewünscht ist, das alle Anfragen eine Session haben
  und verwenden, sollte diese Funktion sehr früh, direkt und entscheidungslos in der Bootstrap Datei aufgerufen
  werden. Session haben einigen Overhead. Wenn einige Anfragen Sessions benötigen aber andere Anfragen keine
  Sessions verwenden, dann:

  - Entscheidungslos, die *strict* Option auf ``TRUE`` setzen durch Verwendung von ``Zend\Session\Session::setOptions()``
    in der Bootstrap Datei.

  - Aufruf von ``Zend\Session\Session::start()`` nur für die Anfragen die eine Session verwenden müssen und vor jeglichen
    ``Zend\Session\Namespace`` initiiert werden.

  - Normales verwenden von "*new Zend\Session\Namespace()*" wo es benötigt wird, aber sicherstellen das davor
    ``Zend\Session\Session::start()`` ausgerufen wurde.

  Die Option *strict* verhindert das *new Zend\Session\Namespace()* automatisch eine Session startet und dabei
  ``Zend\Session\Session::start()`` verwendet. Deshalb hilft diese Option Anwendungs Entwicklern, sich für ein Design
  entscheiden zu können welches verhindert das für bestimmte Anfragen Sessions verwendet werden, da es eine
  Ausnahme verursachen würde wenn ``Zend\Session\Namespace`` instanziiert wird, bevor ``Zend\Session\Session::start()``
  aufgerufen wird. Entwickler sollten vorsichtig entscheiden welchen Einfluß die Verwendung von
  ``Zend\Session\Session::setOptions()`` hat, da diese Optionen globale Seiteneffekte hat, in Folge der Korrespondenz der
  darunterliegenden Optionen für ext/session.

. Richtig: Einfach *new Zend\Session\Namespace()* instanzieren wo dies auch immer notwendig ist, und die
  darunterliegende *PHP* Session wird automatisch gestartet. Das bietet eine extrem simple Handhabung die in den
  meisten Situationen gut funktioniert. Trotzdem ist man dann dafür verantwortlich darauf zu schauen dass das
  erste *new Zend\Session\Namespace()* passiert **bevor** irgendeine Ausgabe (z.B. `HTTP headers`_) von *PHP* an
  den Client gesendet wird, wenn standardmäßige, Cookie-basierte Sessions verwendet werden (sehr empfehlenswert).
  Siehe :ref:`dieses Kapitel <zend.session.global_session_management.headers_sent>` für weitere Informationen.

.. _zend.session.advanced_usage.locking:

Gesperrte Session Namensräume
-----------------------------

Session Namensräume können gesperrt werden um weitere Veränderungen der Daten in diesem Namensraum zu
verhindern. Die Verwendung von ``lock()`` macht einen speziellen Namensraum nur-lesbar, ``unLock()`` macht einen
nur-lesbaren Namensraum les- und schreibbar, und ``isLocked()`` prüft ob ein Namensraum vorher gesperrt wurde.
Sperren sind flüchtig und bestehen nicht von einer Anfrage zur nächsten. Die Sperre des Namensraumes hat keinen
Effekt auf Setz-Methoden von Objekten welche im Namensraum gespeichert sind, aber sie verhindert die Verwendung der
Setz-Methoden des Namensraumes welche das gespeicherte Objekt direkt im Namensraum löschen oder ersetzen.
Gleichwohl verhindert das Sperren von ``Zend\Session\Namespace`` Instanzen nicht die Verwendung von symbolischen
Tabellen-Aliasen auf die gleichen Daten (siehe `PHP references`_).

.. _zend.session.advanced_usage.locking.example.basic:

.. rubric:: Sperren von Session Namensräumen

.. code-block:: php
   :linenos:

   $userProfileNamespace = new Zend\Session\Namespace('userProfileNamespace');

   // marking session as read only locked
   $userProfileNamespace->lock();

   // unlocking read-only lock
   if ($userProfileNamespace->isLocked()) {
       $userProfileNamespace->unLock();
   }

.. _zend.session.advanced_usage.expiration:

Verfall von Namensräumen
------------------------

Limits können plaziert werden an der Lebensdauer von beidem, Namensräumen und individuellen Schlüsseln in
Namensräumen. Normale Anwendungsfälle beinhalten das Durchlaufen von temporären Informationen zwischen Anfragen,
und das vermindern der Aufdeckung von vielfältigen Sicherheitsrisiken durch das Entfernen des Zugangs zu
potentiell sensitiven Informationen, manchmal nachdem Authentifizierung stettgefunden hat. Das Ende kann entweder
auf abgelaufenen Sekunden oder der Anzahl von "Sprüngen" basieren, wobei ein Sprung für jede folgende Anfrage
stattfindet.

.. _zend.session.advanced_usage.expiration.example:

.. rubric:: Beispiel für den Verfall

.. code-block:: php
   :linenos:

   $s = new Zend\Session\Namespace('expireAll');
   $s->a = 'Apfel';
   $s->p = 'Pfirsich';
   $s->o = 'Orange';

   $s->setExpirationSeconds(5, 'a'); // Der Schlüssel "a" läuft in 5 Sekunden ab

   // Der komplette Namensraum läuft in 5 "Sprüngen"
   $s->setExpirationHops(5);

   $s->setExpirationSeconds(60);
   // Der "expireAll" Namensraum wird als "abgelaufen" markiert
   // sobald der erste Aufruf empfangen wurde und 60 Sekunden
   // vergangen sind, oder in 5 Sprüngen, was auch immer zuerst stattfindet

Wenn mit Daten einer Session gearbeitet wird, die in der aktuellen Anfrage ablaufen, sollte Vorsicht beim Empfangen
dieser Daten gehalten werden. Auch wenn diese Daten durch Referenz zurückgegeben werden, wird die Änderung
derselben, diese Daten nicht über diese Abfrage hinweg gültig machen. Um die Zeit für das Ablaufen
"zurückzusetzen", müssen die Daten in eine temporäre Variable geholt werden, diese im Namensraum entfernt und
anschliessend der entsprechende Schlüssel wieder gesetzt werden.

.. _zend.session.advanced_usage.controllers:

Kapseln von Sessions und Controller
-----------------------------------

Namensräume können auch verwendet werden um den Zugriff auf Sessions durch Controller zu seperieren um Variablen
vor Kontaminierung zu schützen. Zum Beispiel könnte ein Authentifizierungs Controller seine Session Daten von
allen anderen Controllern separat halten um notwendigen Sicherheiten zu entsprechen.

.. _zend.session.advanced_usage.controllers.example:

.. rubric:: Session Namensräume für Controller mit automatischem Verfall

Der folgende Code ist Teil eines Controllers der die Test Frage anzeigt und eine boolsche Variable initialisiert
die anzeigt ob eine geschickte Antwort zur Test Frage akzeptiert werden sollte oder nicht. In diesem Fall wird dem
Benutzer der Anwendung 300 Sekunden Zeit gegeben die angezeigte Frage zu beantworten.

.. code-block:: php
   :linenos:

   // ...
   // Im Frage-View Controller
   $testSpace = new Zend\Session\Namespace('testSpace');
   $testSpace->setExpirationSeconds(300, 'accept_answer');
   // Nur diese Variable ablaufen lassen
   $testSpace->accept_answer = true;
   //...

Danach bestimmt der Controller der die Antworten für die Test Fragen bearbeitet ob eine Antwort akzeptiert wird
oder nach basierend darauf ob der Benutzer die Antwort in der erlaubten Zeit übermittelt hat:

.. code-block:: php
   :linenos:

   // ...
   // Im Frage-Prozess Controller
    $testSpace = new Zend\Session\Namespace('testSpace');
    if ($testSpace->accept_answer === true) {
        // innerhalb der Zeit
    }
    else {
        // nicht innerhalb der Zeit
    }
   // ...

.. _zend.session.advanced_usage.single_instance:

Mehrfache Instanzen pro Namensraum verhindern
---------------------------------------------

Obwohl :ref:`session locking <zend.session.advanced_usage.locking>` einen guten Grad von Schutz gegen unerlaubte
Verwendung von Session Daten in einem Namensraum bietet, bietet ``Zend\Session\Namespace`` auch die Fähigkeit die
Erzeugung von mehreren Instanzen zu verhindern die zu einem einzelnen Namensraum korrespondieren.

Um dieses Verhalten einzuschalten, muß ``TRUE`` als zweites Argument im Konstruktor angegeben werden wenn die
letzte erlaubt Instanz von ``Zend\Session\Namespace`` erzeugt wurde. Jeder weitere Versuch den selben Namensraum zu
instanzieren wird in einer geworfenen Ausnahme resultieren.

.. _zend.session.advanced_usage.single_instance.example:

.. rubric:: Zugriff auf Session Namensräume auf eine einzelne Instanz limitieren

.. code-block:: php
   :linenos:

   // Eine Instanz eines Namensraumes erstellen
   $authSpaceAccessor1 = new Zend\Session\Namespace('Zend_Auth');

   // Eine weitere Instanz des selben Namensraumes erstellen,
   // aber weitere Instanzen verbieten
   $authSpaceAccessor2 = new Zend\Session\Namespace('Zend_Auth', true);

   // Eine Referenz erstellen ist immer noch möglich
   $authSpaceAccessor3 = $authSpaceAccessor2;

   $authSpaceAccessor1->foo = 'bar';

   assert($authSpaceAccessor2->foo, 'bar');

   try {
       $aNamespaceObject = new Zend\Session\Namespace('Zend_Auth');
   } catch (Zend\Session\Exception $e) {
       echo 'Dieser Namensraum kann nicht instanziert werden da ' .
            '$authSpaceAccessor2 erstellt wurde\n';
   }

Der zweite Parameter oben im Konstruktor sagt ``Zend\Session\Namespace`` das alle zukünftigen Instanzen mit dem
``Zend_Auth`` Namensraum nicht erlaubt sind. Der Versuch solche Instanzen zu erstellen verursacht eine Ausnahme die
vom Konstruktor geworfen wird. Der Entwickler wird darauf aufmerksam gemacht eine Referenz zu einer Instanz des
Objektes irgendwo zu speichern (``$authSpaceAccessor1``, ``$authSpaceAccessor2``, oder ``$authSpaceAccessor3`` im
obigen Beispiel), wenn der Zugriff auf den Namensraum der Session zu einer späteren Zeit wärend des selben
Requests benötigt wird. Zum Beispiel, könnte ein Entwickler die Referenz in einer statischen Variable speichern,
die Referenz zu einer `Registry`_ hinzufügen (siehe :ref:`Zend_Registry <zend.registry>`), oder diese andernfalls
für andere Methoden verfügbar zu machen die Zugriff auf den Namensraum der Session benötigen.

.. _zend.session.advanced_usage.arrays:

Arbeiten mit Arrays
-------------------

Durch die Vergangenheit der Implmentationen der Magischen Methoden in *PHP*, wird das Ändern von Arrays innerhalb
eines Namensraumes nicht unter *PHP* Versionen vor 5.2.1 funktionieren. Wenn nur mit *PHP* 5.2.1 oder neuer
gearbeitet wird, kann :ref:`zum nächsten Kapitel gesprungen <zend.session.advanced_usage.objects>` werden.

.. _zend.session.advanced_usage.arrays.example.modifying:

.. rubric:: Array Daten innerhalb eines Session Namensraumes verändern

Das folgende illustriert wie das Problem reproduziert werden kann:

.. code-block:: php
   :linenos:

   $sessionNamespace = new Zend\Session\Namespace();
   $sessionNamespace->array = array();
   // wird nicht wie gewünscht funktionieren vor PHP 5.2.1
   $sessionNamespace->array['testKey'] = 1;
   echo $sessionNamespace->array['testKey'];

.. _zend.session.advanced_usage.arrays.example.building_prior:

.. rubric:: Arrays erstellen bevor es Session Speicher gab

Wenn möglich, sollte das Problem vermieden werden indem Array nur dann im Session Namensraum gespeichert werden
nachdem alle gewünschten Arraywerte gesetzt wurden.

.. code-block:: php
   :linenos:

   $sessionNamespace = new Zend\Session\Namespace('Foo');
   $sessionNamespace->array = array('a', 'b', 'c');

Wenn eine betroffene Version von *PHP* verwendet wird and ein Array modifiziert werden soll nachdem es mit einem
Schlüssel für den Session Namensraum verbunden wurde, kann einer oder beide der folgenden Workarounds verwendet
werden.

.. _zend.session.advanced_usage.arrays.example.workaround.reassign:

.. rubric:: Workaround: Ein geändertes Array neu Verbinden

Im folgenden Code wird eine Kopie des gespeicherten Array erstellt, geändert und wieder dem Platz von dem die
Kopie erstellt wurde zugeordnet wobei das originale Array überschrieben wird.

.. code-block:: php
   :linenos:

   $sessionNamespace = new Zend\Session\Namespace();

   // Das ursprüngliche Array hinzufügen
   $sessionNamespace->array = array('tree' => 'apple');

   // Eine Kopie des Arrays erstellen
   $tmp = $sessionNamespace->array;

   // Die Kopie des Arrays ändern
   $tmp['fruit'] = 'peach';

   // Die Kopie des Arrays wieder mit dem Namensraum der Session verknüpfen
   $sessionNamespace->array = $tmp;

   echo $sessionNamespace->array['fruit']; // gibt "peach" aus

.. _zend.session.advanced_usage.arrays.example.workaround.reference:

.. rubric:: Workaround: Array das Referenz enthält speichern

Alternativ, kann ein Array gespeichert werden das eine Referenz zum gewünschten Array enthält, die auf dieses
dann indirekt zugegriffen werden.

.. code-block:: php
   :linenos:

   $myNamespace = new Zend\Session\Namespace('myNamespace');
   $a = array(1, 2, 3);
   $myNamespace->someArray = array( &$a );
   $a['foo'] = 'bar';
   echo $myNamespace->someArray['foo']; // gibt "bar" aus

.. _zend.session.advanced_usage.objects:

Sessions mit Objekten verwenden
-------------------------------

Wenn Objekte in einer *PHP* Session fixiert werden sollen, muß bedacht werden das diese für das Speichern
`serialisiert`_ werden. Deshalb muß jedes Objekt das in einer *PHP* Session verewigt wurde deserialisiert werden
nachdem es vom Speicher empfangen wurde. Das impliziert das der Entwickler sicherstellen muß das die Klassen für
das verewigte Objekt definiert werden müssen bevor das Objekt vom Session Speicher deserialisiert wird. Wenn die
Klasse eines unserialisierten Objektes nicht definiert wurde, wird es eine Instand von *stdClass*.

.. _zend.session.advanced_usage.testing:

Verwenden von Sessions mit Unit Tests
-------------------------------------

Zend Framework vertraut auf PHPUnit um das Testen von sich selbst zu ermöglichen. Viele Entwickler erweitern die
existierende Sammlung von Unit Tests um den Code in deren Anwendungen anzudecken. Die Ausnahme "**Zend_Session ist
aktuell als nur-lesbar markiert**" wird geworfen wärend Unit Tests durchgeführt werden, wenn irgendeine
schreibende Methode verwendet wird nachdem Ende der Session. Trotzdem benötigen Unit Tests die ``Zend_Session``
verwenden besondere Aufmerksamkeit weil das Schließen (``Zend\Session\Session::writeClose()``) oder Zerstören einer
Session (``Zend\Session\Session::destroy()``) weitere Änderungen oder Rücknahmen von Schlüsseln in jeder Instanz von
``Zend\Session\Namespace`` verhindert. Dieses Verhalten ist ein direktes Resultat des darunterliegenden ext/session
Mechanismus und *PHP*'s ``session_destroy()`` und ``session_write_close()`` welche keinen "rückgängig machen"
Mechanismus unterstützen um Setup/Teardown innerhalb der Unit Tests zu unterstützen.

Um das Umzuarbeiten, siehe den Unit Test ``testSetExpirationSeconds()`` in *SessionTest.php* und
*SessionTestHelper.php*, beide im *tests/Zend/Session* Verzeichnis, welche *PHP*'s ``exec()`` verwenden um einen
eigenständigen Prozess zu starten. Der neue Prozess simuliert eine zweite Anfrage eines Browsers, viel genauer.
Der separate Prozess beginnt mit einer "reinen" Session, genauso wie jede *PHP* Skript Ausführung für eine Web
Anfrage. Auch jede Änderung in ``$_SESSION`` welche im aufrufenden Prozess gemacht wurde, ist im Kind-Prozess
verfügbar, ermöglicht wenn der Elternprozess die Session beendet hat, bevor ``exec()`` verwendet wird.

.. _zend.session.advanced_usage.testing.example:

.. rubric:: PHPUnit Test Code der auf Zend_Session beruht

.. code-block:: php
   :linenos:

   // testen von setExpirationSeconds()
   $script = 'SessionTestHelper.php';
   $s = new Zend\Session\Namespace('space');
   $s->a = 'apple';
   $s->o = 'orange';
   $s->setExpirationSeconds(5);

   Zend\Session\Session::regenerateId();
   $id = Zend\Session\Session::getId();
   // Session freigeben damit der untere Prozess Sie verwenden kann
   session_write_close();
   sleep(4); // nicht lange genug damit die Dinge ablaufen
   exec($script . "expireAll $id expireAll", $result);
   $result = $this->sortResult($result);
   $expect = ';a === apfel;o === orange;p === pfirsich';
   $this->assertTrue($result === $expect,
       "Iterierung durch standard Zend_Session Namensraum fehlgeschlagen; " .
       "erwartet result === '$expect', aber '$result' bekommen");
   sleep(2); // lange genug damit die Dinge ablaufen (insgesamt 6 Sekunden
             // warten, aber nach 5 Sekunden abgelaufen)
   exec($script . "expireAll $id expireAll", $result);
   $result = array_pop($result);
   $this->assertTrue($result === '',
       "Iterierung durch standard Zend_Session Namensraum fehlgeschlagen; " .
       "erwartet result === '', aber '$result' bekommen)");
   session_start(); // wiederherstellen der vorher eingefrorenen Session

   // Das könnte in einen separaten Test abgeteilt werden, aber aktuell, wenn
   // irgendwas vom darüberleigenden Test den darunterliegenden Test
   // kontaminiert, ist das auch ein Fehler den wir wissen wollen.
   $s = new Zend\Session\Namespace('expireGuava');
   $s->setExpirationSeconds(5, 'g'); // Versuch nur einen Schlüssel im
                                     // Namensraum ablaufen zu lassen
   $s->g = 'guava';
   $s->p = 'peach';
   $s->p = 'plum';

   // Session auflösen damit der untere Prozess sie verwenden kann
   session_write_close();
   sleep(6); // Nicht lange genug damit die Dinge ablaufen können
   exec($script . "expireAll $id expireGuava", $result);
   $result = $this->sortResult($result);
   session_start(); // Die bestimmte Session wiederherstellen
   $this->assertTrue($result === ';p === plum',
       "Iterierung durch benannte Zend_Session Namensräume " .
       "fehlgeschlaten (result=$result)");



.. _`session.auto_start Einstellung`: http://www.php.net/manual/de/ref.session.php#ini.session.auto-start
.. _`session_start()`: http://www.php.net/session_start
.. _`HTTP headers`: http://www.php.net/headers_sent
.. _`PHP references`: http://www.php.net/references
.. _`Registry`: http://www.martinfowler.com/eaaCatalog/registry.html
.. _`serialisiert`: http://www.php.net/manual/de/language.oop.serialization.php
