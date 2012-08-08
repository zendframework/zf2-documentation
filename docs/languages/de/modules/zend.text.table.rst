.. EN-Revision: none
.. _zend.text.table.introduction:

Zend_Text_Table
===============

``Zend_Text_Table`` ist eine Komponente für die Erstellung von Text-basierenden Tabellen welche mit
unterschiedlichen Dekoratoren arbeitet. Das kann hilfreich sein, wenn man entweder strukturierte Daten in einer
Textemail verwenden will, welche normalerweise mit monospaced Schriftarten geschrieben sind, oder um
Tabelleninformationen in einer CLI Anwendung darzustellen. ``Zend_Text_Table`` unterstützt mehrzeilige Spalten,
Colspan und auch Ausrichtung.

.. note::

   **Kodierung**

   ``Zend_Text_Table`` erwartet die Strings standardmäßig als UTF-8 kodiert. Wenn das nicht der Fall ist, kann
   entweder die Zeichenkodierung als Parameter an den ``constructor()`` übergeben werden, oder an die
   ``setContent()`` Methode von ``Zend_Text_Table_Column``. Wenn man im kompletten Prozess eine andere Kodierung
   verwendet, kann man die standardmäßige Eingabekodierung mit ``Zend_Text_Table::setInputCharset($charset)``
   setzen. Im Fall, das man eine andere Ausgabekodierung für die Tabelle benötigt, kann diese mit
   ``Zend_Text_Table::setOutputCharset($charset)`` gesetzt werden.

Ein ``Zend_Text_Table`` Objekt besteht aus Zeilen, die Spalten enthalten, repräsentiert durch
``Zend_Text_Table_Row`` und ``Zend_Text_Table_Column``. Wenn eine Tabelle erstellt wird, kann ein Array mit
Optionen für die Tabelle angegeben werden: Diese sind:



   - ``columnWidths`` (required): Ein Array das alle Spalten mit Ihrer Breite in Zeichen definiert.

   - ``decorator``: Der Dekorator der für die Tabellenränder verwendet wird. Der Standard ist **unicode**, aber
     man kann auch **ascii** spezifizieren, oder eine Instanz eines eigenen Dekoratorobjekts angeben.

   - ``padding``: Die linke und rechte Füllung innerhalb der Spalten in Zeichen. Die Standardfüllung ist Null.

   - ``AutoSeparate``: Der Weg auf dem Zeilen mit horizontalen Linien getrennt werden. Der Standard ist eine
     Trennung zwischen allen Zeilen. Das ist als Bitmaske definiert die ein oder mehrere der folgenden Konstanten
     von ``Zend_Text_Table`` haben kann:



        - ``Zend_Text_Table::AUTO_SEPARATE_NONE``

        - ``Zend_Text_Table::AUTO_SEPARATE_HEADER``

        - ``Zend_Text_Table::AUTO_SEPARATE_FOOTER``

        - ``Zend_Text_Table::AUTO_SEPARATE_ALL``

     Wobei der Tabellenheader immer die erste Zeile, und der Tabellenfooter immer die letzte Zeile ist.



Zeilen werden zur Tabelle einfach hinzugefügt indem eine neue Instanz von ``Zend_Text_Table_Row`` erstellt, und
der Tabelle über die ``appendRow()`` Methode angehängt wird. Zeilen selbst haben keine Optionen. Man kann der
``appendRow()`` Methode auch direkt auch ein Array geben, welches dann automatisch in ein Zeilenobjekt konvertiert
wird, welches mehrere Spaltenobjekte enthält.

Auf dem gleichen Weg kann man Spalten zu Zeilen hinzufügen. Man erstellt eine neue Instanz von
``Zend_Text_Table_Column`` und setzt dann entweder die Zeilenoptionen im Constructor, oder später mit den
``set*()`` Methoden. Der erste Parameter ist der Inhalt der Spalte, welcher mehrere Zeilen haben kann, welche im
besten Fall einfach durch das '\\n' Zeichen getrennt sind. Der zweite Parameter definiert die Ausrichtung, welche
standardmäßig 'left' ist, und eine der Klassenkonstanten von ``Zend_Text_Table_Column`` sein kann:



   - ``ALIGN_LEFT``

   - ``ALIGN_CENTER``

   - ``ALIGN_RIGHT``

Der dritte Parameter ist die Colspan der Zeile. Wenn man, zum Beispiel, "2" als Colspan definiert, wird die Spalte
über 2 Spalten der Tabelle gespannt. Der letzt Parameter definiert die Kodierung des Inhalts, welche angegeben
werden sollte, wenn der Inhalt weder ASCII noch UTF-8 ist. Um die Spalte zur Zeile hinzuzufügen, muß einfach
``appendColumn()`` im Zeilenobjekt, mit dem Spaltenobjekt als Parameter, aufgerufen werden. Alternativ kann ein
String direkt an die ``appendColumn()`` Methode übergeben werden.

Um die Tabelle letztendlich darzustellen, kann man entweder die ``render()`` Methode der Tabelle verwenden, oder
die magische ``__toString()`` Methode der Tabelle, indem man ``echo $table;`` oder ``$tableString = (string)
$table`` ausführt.

.. _zend.text.table.example.using:

.. rubric:: Verwenden von Zend_Text_Table

Ein Beispiel zeigt die grundsätzliche Verwendung von ``Zend_Text_Table`` um eine einfache Tabelle zu erstellen:

.. code-block:: php
   :linenos:

   $table = new Zend_Text_Table(array('columnWidths' => array(10, 20)));

   // Entweder Einfach
   $table->appendRow(array('Zend', 'Framework'));

   // Oder wortreich
   $row = new Zend_Text_Table_Row();

   $row->appendColumn(new Zend_Text_Table_Column('Zend'));
   $row->appendColumn(new Zend_Text_Table_Column('Framework'));

   $table->appendRow($row);

   echo $table;

Das führt zur folgenden Ausgabe:

.. code-block:: text
   :linenos:

   ┌──────────┬────────────────────┐
   │Zend      │Framework           │
   └──────────┴────────────────────┘


