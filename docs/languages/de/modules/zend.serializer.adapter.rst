.. EN-Revision: none
.. _zend.serializer.adapter:

Zend\Serializer\Adapter
=======================

``Zend_Serializer`` Adapter erzeugen eine Brücke für unterschiedliche Methoden der Serialisierung mit geringem
Aufwand.

Jeder Adapter hat andere Vor- und Nachteile. In einigen Fällen kann nicht jeder *PHP* Datentyp (z.B. Objekte) in
die Repräsentation eines Strings konvertiert werden. In den meisten dieser Fälle wird der Typ in einen ähnlichen
Typ konvertiert der serialisierbar ist -- zum Beispiel werden *PHP* Objekte oft zu Arrays gecastet. Wenn dies
fehlschlägt wird eine ``Zend\Serializer\Exception`` geworfen.

Anbei ist eine Liste der vorhandenen Adapter.

.. _zend.serializer.adapter.phpserialize:

Zend\Serializer_Adapter\PhpSerialize
------------------------------------

Dieser Adapter verwendet die eingebauten *PHP* Funktionen ``un/serialize`` und ist eine gute Wahl für einen
Standardadapter.

Es gibt keine konfigurierbaren Optionen für diesen Adapter.

.. _zend.serializer.adapter.igbinary:

Zend\Serializer_Adapter\Igbinary
--------------------------------

`Igbinary`_ ist eine Open Source Software welche von Sulake Dynamoid Oy herausgegeben wird. Statt Zeit und Platz
auf eine textuelle Repräsentation zu verschwenden, speichert igbinary Datenstrukturen von *PHP* in einer kompakten
binären Form. Die Einsparungen sind signifikant wenn memcached oder ähnliche Hauptspeicher-basierte Speicher für
die Serialisierung der Daten verwendet wird.

Man muss die *PHP* Erweiterung igbinary am eigenen System installiert haben um diesen Adapter verwenden zu können.

Dieser Adapter nimnt keine Optionen zur Konfiguration an.

.. _zend.serializer.adapter.wddx:

Zend\Serializer_Adapter\Wddx
----------------------------

`WDDX`_ (Web Distributed Data eXchange) ist eine Programmier-Sprache-, Plattform- und ein transport-neutraler
datentauschender Mechanismus für die Übergabe von Daten zwischen unterschiedlichen Umgebungen und
unterschiedlichen Computern.

Der Adapter verwendet einfach die `wddx_*()`_ *PHP* Funktionen. Lesen Sie bitte im *PHP* Handbuch um herauszufinden
ob man Sie in der eigenen *PHP* Installation aktivieren kann.

Zusätzlich wird die *PHP* Erweiterung `SimpleXML`_ verwendet um zu prüfen ob ein von ``wddx_unserialize()``
zurückgegebener ``NULL`` Wert auf einem serialisierten ``NULL`` Wert basiert, oder auf ungültigen Daten.

Vorhandene Optionen sind:

.. _zend.serializer.adapter.wddx.table.options:

.. table:: Optionen für Zend\Serializer_Adapter\Wddx

   +-------+--------+------------+----------------------------------------------------------+
   |Option |Datentyp|Standardwert|Beschreibung                                              |
   +=======+========+============+==========================================================+
   |comment|string  |            |Ein optionales Kommentar welches im Paket Header vorkommt.|
   +-------+--------+------------+----------------------------------------------------------+

.. _zend.serializer.adapter.json:

Zend\Serializer_Adapter\Json
----------------------------

Der *JSON* Adapter bietet eine Brücke zur Komponente ``Zend_Json`` und zu ext/json. Lesen Sie bitte die
:ref:`Zend_Json Dokumentation <zend.json.introduction>` für weitere Informationen.

Vorhandene Optionen sind:

.. _zend.serializer.adapter.json.table.options:

.. table:: Optionen für Zend\Serializer_Adapter\Json

   +--------------------+-----------------+---------------------+----------------------+
   |Option              |Datentyp         |Standardwert         |Beschreibung          |
   +====================+=================+=====================+======================+
   |cycleCheck          |boolean          |false                |Siehe diesen Abschnitt|
   +--------------------+-----------------+---------------------+----------------------+
   |objectDecodeType    |Zend\Json\Json::TYPE_*|Zend\Json\Json::TYPE_ARRAY|Siehe diesen Abschnitt|
   +--------------------+-----------------+---------------------+----------------------+
   |enableJsonExprFinder|boolean          |false                |Siehe diesen Abschnitt|
   +--------------------+-----------------+---------------------+----------------------+

.. _zend.serializer.adapter.amf03:

Zend\Serializer_Adapter\Amf 0 und 3
-----------------------------------

Die *AMF* Adapter ``Zend\Serializer_Adapter\Amf0`` und ``Zend\Serializer_Adapter\Amf3`` bieten eine Brücke zum
Serialisierer der Komponente ``ZendAmf``. Lesen Sie bitte die :ref:`ZendAmf Dokumentation
<zend.amf.introduction>` für weitere Informationen.

Es gibt keine Optionen für diese Adapter.

.. _zend.serializer.adapter.pythonpickle:

Zend\Serializer_Adapter\PythonPickle
------------------------------------

Dieser Adapter konvertiert *PHP* Typen in eine `Python Pickle`_ String Repräsentation. Mit Ihm können die
serialisierten Daten mit Python gelesen werden und Pickled Daten von Python mit *PHP* gelesen werden.

Vorhandene Optionen sind:

.. _zend.serializer.adapter.pythonpickle.table.options:

.. table:: Optionen für Zend\Serializer_Adapter\PythonPickle

   +--------+-----------------------+------------+----------------------------------------------------------------------+
   |Option  |Datentyp               |Standardwert|Beschreibung                                                          |
   +========+=======================+============+======================================================================+
   |protocol|integer (0 | 1 | 2 | 3)|0           |Die Version des Pickle Protokolls welches bei serialize verwendet wird|
   +--------+-----------------------+------------+----------------------------------------------------------------------+

Der Wechsel von Datentypen (PHP zu Python) findet wie folgt statt:

.. _zend.serializer.adapter.pythonpickle.table.php2python:

.. table:: Wechseln des Datentyps (PHP zu Python)

   +-----------------+----------+
   |PHP Typ          |Python Typ|
   +=================+==========+
   |NULL             |None      |
   +-----------------+----------+
   |boolean          |boolean   |
   +-----------------+----------+
   |integer          |integer   |
   +-----------------+----------+
   |float            |float     |
   +-----------------+----------+
   |string           |string    |
   +-----------------+----------+
   |array            |list      |
   +-----------------+----------+
   |associative array|dictionary|
   +-----------------+----------+
   |object           |dictionary|
   +-----------------+----------+

Der Wechsel von Datentypen (Python zu *PHP*) findet wie folgt statt:

.. _zend.serializer.adapter.pythonpickle.table.python2php:

.. table:: Wechseln des Datentyps (PHP zu Python)

   +------------------+----------------------------------------------------+
   |Python Typ        |PHP Typ                                             |
   +==================+====================================================+
   |None              |NULL                                                |
   +------------------+----------------------------------------------------+
   |boolean           |boolean                                             |
   +------------------+----------------------------------------------------+
   |integer           |integer                                             |
   +------------------+----------------------------------------------------+
   |long              |integer | float | string | Zend\Serializer\Exception|
   +------------------+----------------------------------------------------+
   |float             |float                                               |
   +------------------+----------------------------------------------------+
   |string            |string                                              |
   +------------------+----------------------------------------------------+
   |bytes             |string                                              |
   +------------------+----------------------------------------------------+
   |Unicode string    |UTF-8 string                                        |
   +------------------+----------------------------------------------------+
   |list              |array                                               |
   +------------------+----------------------------------------------------+
   |tuple             |array                                               |
   +------------------+----------------------------------------------------+
   |dictionary        |associative array                                   |
   +------------------+----------------------------------------------------+
   |Alle anderen Typen|Zend\Serializer\Exception                           |
   +------------------+----------------------------------------------------+

.. _zend.serializer.adapter.phpcode:

Zend\Serializer_Adapter\PhpCode
-------------------------------

Dieser Adapter erzeugt eine Repräsentation an *PHP* Code der geparst werden kann indem `var_export()`_ verwendet
wird. Bei der Wiederherstellung werden die Daten ausgeführt indem `eval`_ verwendet wird.

Es gibt keine Optionen für die Konfiguration dieses Adapters.

.. warning::

   **Objekte deserialisieren**

   Objekte werden serialisiert indem die magische Methode `\__set_state`_ verwendet wird. Wenn die Klasse diese
   Methode nicht implementiert wird wärend der Ausführung ein fataler Fehler auftreten.

.. warning::

   **Verwendet eval()**

   Der Adapter ``PhpCode`` verwendet ``eval()`` für die Deserialisierung. Das führt sowohl zu Performanz- als
   auch zu einem potentiellen Sicherheitsproblem da ein neuer Prozess ausgeführt wird. Typischerweise sollte der
   Adapter ``PhpSerialize`` verwendet werden solange man die Lesbarkeit der serialisierten Daten durch Menschen
   benötigt.



.. _`Igbinary`: http://opensource.dynamoid.com
.. _`WDDX`: http://wikipedia.org/wiki/WDDX
.. _`wddx_*()`: http://php.net/manual/book.wddx.php
.. _`SimpleXML`: http://php.net/manual/book.simplexml.php
.. _`Python Pickle`: http://docs.python.org/library/pickle.html
.. _`var_export()`: http://php.net/manual/function.var-export.php
.. _`eval`: http://php.net/manual/function.eval.php
.. _`\__set_state`: http://php.net/manual/language.oop5.magic.php#language.oop5.magic.set-state
