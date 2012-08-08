.. EN-Revision: none
.. _performance.database:

Zend_Db Performance
===================

``Zend_Db`` ist ein Datenbank Abstraktion Layer und ist dazu gedacht eine gemeinsame *API* für *SQL* Operationen
zu bieten. ``Zend_Db_Table`` ist ein Table Data Gateway, dazu gedacht übliche Tabellen-artige Datenbank
Operationen zu abstrahieren. Wegen Ihrer abstrakten Natur und der "Magie" die Sie versteckt haben um Ihre
Operationen durchführen zu können, können Sie manchmal auch zu Geschwindigkeitsnachteilen führen.

.. _performance.database.tableMetadata:

Wie kann ich den Overhead reduzieren der von Zend_Db_Table eingeführt wird um die Metadaten der Tabelle zu erhalten?
--------------------------------------------------------------------------------------------------------------------

Um die Verwendung so einfach wie möglich zu halten, und auch sich konstant ändernde Schemata wärend der
Entwicklung zu unterstützen, macht ``Zend_Db_Table`` einiges an Magie unter seinem Hut: bei der ersten Verwendung,
holt es das Tabellenschema und speichert es im Objekt. Diese Operation ist normalerweise sehr teuer, unabhängig
von der Datenbank -- das zu einer Schwachstelle in der Produktion führen kann.

Glücklicherweise gibt es Techniken um die Situation zu verbessern.

.. _performance.database.tableMetadata.cache:

Den Metadaten Cache verwenden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Db_Table`` kann optional ``Zend_Cache`` verwenden um die Metadaten der Tabelle zu cachen. Dieser ist
typischerweise schneller im Zugriff und nicht so teuer wie das holen der Metadaten von der Tabelle selbst.

Die Dokumentation von :ref:`Zend_Db_Table enthält Informationen über das Cachen der Metadaten
<zend.db.table.metadata.caching>`.

.. _performance.database.tableMetadata.hardcoding:

Die Metadaten in der Tabellendefinition fix codieren
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Mit 1.7.0, bietet ``Zend_Db_Table`` auch :ref:`Unterstützung für fix kodierte Metadaten in der Tabellen
Definition <zend.db.table.metadata.caching.hardcoding>`. Das ist ein schwierigerer Verwendungsfall, und sollte nur
dann verwendet werden wenn man weiß das sich das Tabellenschema nicht ändern wird, oder das man fähig ist die
Definition immer up-to-date zu halten.

.. _performance.database.select:

SQL die mit Zend_Db_Select erzeugt wurde greift nicht auf die Indezes zu; wie kann man das besser machen?
---------------------------------------------------------------------------------------------------------

``Zend_Db_Select`` ist relativ gut in seinem Job. Trotzdem kann es, wenn man komplexe Abfragen benötigt die Joins
oder Unterabfragen enthalten, sehr naiv sein.

.. _performance.database.select.writeyourown:

Selbst getuntes SQL schreiben
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die einzige echte Antwort ist es eigenes *SQL* zu schreiben; ``Zend_Db`` erfordert nicht die Verwendung von
``Zend_Db_Select``, als ist die Verwendung von eigenen, getunten *SQL* Select Statements, eine perfekte und
legitime Anwendung.

Lasse ``EXPLAIN`` auf den Abfragen laufen, und teste eine Vielzahl von Möglichkeiten bis man die eigenen Indezes
auf dem besten und performantesten Weg trifft -- und dann sollte dieses *SQL* als Klasseneigenschaft oder Konstante
fix kodiert werden.

Wenn das *SQL* variable Argumente benötigt, können Platzhalter im *SQL* verwendet werden und in einer Kombination
von ``vsprintf()`` und ``array_walk()`` verwendet werden um Werte in das *SQL* zu injizieren:

.. code-block:: php
   :linenos:

   // $adapter ist der DB Adapter. In Zend_Db_Table ist es durch
   // Verwendung von $this->getAdapter() zu empfangen.
   $sql = vsprintf(
       self::SELECT_FOO,
       array_walk($values, array($adapter, 'quoteInto'))
   );


