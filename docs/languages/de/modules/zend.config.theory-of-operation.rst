.. _zend.config.theory_of_operation:

Theory of Operation
===================

Konfigurations-Daten werden dem ``Zend_Config``-Konstruktor als assoziatives Array zur Verfügung gestellt. Das
Array kann mehrdimensional sein, um die Übergabe geordneter Daten zu unterstützen. Spezifische Adapter fungieren
als Schnittstelle zwischen der Datenhaltung und dem ``Zend_Config``-Konstruktor, indem sie die Daten für diesen
als Array aufbereiten. Es können auch direkt aus dem eigenen Code Arrays an den ``Zend_Config``-Konstruktor
übergeben werden, ohne eine Adapter-Klasse zu benutzen. In manchen Situationen kann das angebracht sein.

Jeder Konfigurationswert des Arrays wird zu einer Eigenschaft des ``Zend_Config`` Objektes. Der Schlüssel wird als
Name der Eigenschaft verwendet. Wenn ein Wert selbst ein Array ist, wird die resultierende Eigenschaft des Objektes
selbst als ein neues ``Zend_Config`` Objekt erstellt und mit den Array Daten geladen. Das findet rekursiv statt,
sodas hirarchische Konfigurationswerte mit einer beliebigen Anzahl an Level erstellt werden können.

``Zend_Config`` implementiert die Interfaces **Countable** und **Iterator** um den einfachen Zugriff auf
Konfigurationsdaten zu gewährleisten. Dementsprechend kann man die `count()`_-Funktion und auch *PHP* Konstrukte
wie `foreach`_ auf ``Zend_Config``-Objekte anwenden.

Standardmäßig gewährt ``Zend_Config`` nur Lesezugriff auf die Daten und der Versuch einer Wertzuweisung (wie z.
B. ``$config->database->host = 'example.com';``) löst eine Ausnahme aus. Dieses Standard-Verhalten kann mit Hilfe
des Konstruktors aber so überschrieben werden, dass die Veränderung von Daten erlaubt ist. Wenn auch Änderungen
erlaubt sind, unterstützt ``Zend_Config`` das entfernen von Werten (z.B. ``unset($config->database->host)``). Die
``readOnly()`` Methode kann verwendet werden um festzustellen ob Änderungen an einem gegebenen ``Zend_Config``
Objekt erlaubt sind und die ``setReadOnly()`` kann verwendet werden um weitere Änderungen an einem ``Zend_Config``
Objekt, das erstellt wurde und Änderungen erlaubt, zu verhindern.

.. note::

   Es muss angemerkt werden, dass hierbei nur die Daten im Speicher verändert werden. Es wird keine Änderung an
   den Konfigurations-Daten auf dem Speichermedium vorgenommen. Werkzeuge zur Veränderung gespeicherter
   Konfigurations-Daten liegen nicht im Bereich von ``Zend_Config``. Drittanbieter bieten bereits diverse
   Open-Source-Lösungen für das Erstellen und Verändern von Konfigurations-Datensätzen in verschienen Formaten.

Adapter-Klassen erben von der ``Zend_Config``-Klasse, da sie ihre Funktionalität nutzen.

Die Familie der ``Zend_Config``-Klassen ermöglicht es, Daten in Sektionen einzuteilen. Beim Initialisieren eines
``Zend_Config``-Adapter-Objektes können eine einzelne spezifizierte Sektion, mehrere spezifizierte Sektionen oder
alle Sektionen (wenn keine spezifiziert ist) geladen werden.

Die ``Zend_Config``-Adapter-Klassen unterstützen ein Modell einfacher Vererbung, welches es ermöglicht, dass
Konfigurations-Daten aus einer Sektion an eine Andere vererbt werden können. Dadurch kann die Notwendigeit
doppelter Konfigurations-Daten für verschiedene Einsatzgebiete reduziert oder beseitigt werden. Eine erbende
Sektion kann die von der Eltern-Sektion geerbten Werte auch überschreiben. Wie auch bei der Klassen-Vererbung in
*PHP* kann eine Sektion von einer Eltern-Sektion geerbt werden, die wiederum von einer Großeltern-Sektion geerbt
hat und so weiter. Mehrfaches Erben (Beispielsweise der Fall, dass Sektion C direkt von den Eltern-Sektionen A und
B erbt) wird dagegen nicht unterstützt.

Wenn zwei ``Zend_Config`` Objekte vorhanden sind, können diese in ein einzelnes Objekt zusammengeführt werden
indem die ``merge()`` Funktion verwendet wird. Angenommen es gibt ``$config`` und ``$localConfig``, kann
``$localConfig`` in ``$config`` zusammengeführt werden indem ``$config->merge($localConfig);`` aufgerufen wird.
Die Elemente in ``$localConfig`` überschreiben gleichnamige Elemente in ``$config``.

.. note::

   Das ``Zend_Config`` Objekt das die Zusammenführung durchführt muß so erstellt worden sein das es Änderungen
   erlaubt, indem dem Constructor ``TRUE`` als zweiter Parameter übergeben wird. Die ``setReadOnly()`` Methode
   kann dann verwendet werden um weitere Änderungen zu verhindern nachdem die Zusammenführung fertiggestellt ist.



.. _`count()`: http://php.net/count
.. _`foreach`: http://php.net/foreach
