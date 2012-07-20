.. _zend.gdata.spreadsheets:

Google Tabellenkalkulation verwenden
====================================

Die Google Tabellenkalkulations Daten *API* erlaubt es Client Anwendungen Inhalte von Tabellenkalkulationen zu
sehen und Inhalte von Tabellenkalkulationen in der form von Google Daten *API* Feeds zu aktualisieren. Die eigene
Client Anwendung kann eine Liste von Tabellenkalkulationen eines Benutzer anfragen, Inhalte eines bestehenden
Arbeitsblatts der Tabellenkalkulation bearbeiten oder löschen, und den Inhalt eines bestehenden Arbeitsblatt der
Tabellenkalkulation abfragen.

Siehe `http://code.google.com/apis/spreadsheets/overview.html`_ für weitere Informationen über die Google's
Tabellenkalkulations *API*.

.. _zend.gdata.spreadsheets.creating:

Eine Tabellenkalkulation erstellen
----------------------------------

Die Tabellenkalkulations Daten *API* bietet aktuell noch keinen Weg um eine Tabellenkalkulation programmtechnisch
zu erstellen oder zu löschen.

.. _zend.gdata.spreadsheets.listspreadsheets:

Eine Liste von Tabellenkalkulationen erhalten
---------------------------------------------

Man kann eine Liste von Tabellenkalkulationen für einen bestimmten Benutzer erhalten indem die
``getSpreadsheetFeed()`` Methode des Tabellenkalkulationsservices verwendet wird. Der Service wird ein
``Zend_Gdata_Spreadsheets_SpreadsheetFeed`` Objekt zurückgeben das eine Liste von Tabellenkalkulationen enthält
die mit dem authentifizierten Benutzer authentifiziert sind.

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Spreadsheets::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $spreadsheetService = new Zend_Gdata_Spreadsheets($client);
   $feed = $spreadsheetService->getSpreadsheetFeed();

.. _zend.gdata.spreadsheets.listworksheets:

Eine Liste von Arbeitsblättern erhalten
---------------------------------------

Eine gegebene Tabellenkalkulation kann mehrere Arbeitsblätter enthalten. Für jedes Arbeitsblass gibt es einen
Arbeitsblatt Metafeed der alle Arbeitsblätter in dieser Tabellenkalkulation auflistet.

Mit der Schlüssel der Tabellenkalkulation von der <id> des ``Zend_Gdata_Spreadsheets_SpreadsheetEntry`` Objekts
das man bereits empfangen hat, kann mein einen Feed holen der eine Liste von Arbeitsblättern enthält die mit
dieser Tabellenkalkulation assoziiert sind.

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Spreadsheets_DocumentQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $feed = $spreadsheetService->getWorksheetFeed($query);

Der sich ergebende ``Zend_Gdata_Spreadsheets_WorksheetFeed`` Objektfeed repräsentiert die Antwort des Servers.
Neben anderen Dingen enthält dieser Feed eine Liste von ``Zend_Gdata_Spreadsheets_WorksheetEntry`` Objekten
(``$feed->entries``), wobei jedes ein einzelnes Arbeitsblatt repräsentiert.

.. _zend.gdata.spreadsheets.listfeeds:

Mit listen-basierenden Feeds interagieren
-----------------------------------------

Ein gegebenes Arbeitsblatt enthält generell mehrere Zeilen, wobei jede mehrere Zellen enthält. Man kann Daten vom
Arbeitsblatt entweder als listen-basierenden Feed anfragen, in dem jeder Eintrag eine Zeile repräsentiert, oder
als zellen-basierenden Feed, in dem jeder Eintrag eine einzelne Zelle repräsentiert. Für Informationen über
zellen-basierende Feeds kann auch unter :ref:`Interaktion mit zellen-basierenden Feeds
<zend.gdata.spreadsheets.cellfeeds>` nachgesehen werden.

Die folgenden Sektionen beschreiben wie man einen Listen basierender Feed erhält, eine Zeile zu einem Arbeitsblatt
hinzufügt, und Abfragen mit verschiedenen Abfrage Parametern sendet.

Der Listenfeed macht einige Annahmen darüber wie die Daten in der Tabellenkalkulation ausgelegt sind.

Im speziellen, behandelt der Listenfeed die erste Zeile des Arbeitsblattes als Kopfzeile; Tabellenkalkulationen
erstellen dynamisch *XML* Elemente welche nach dem Inhalt der Kopfzeilen-Zellen benannt sind. Benutzer welche Gdata
Feeds anbieten wollen, sollten keine andere Daten als Spaltenheader in der ersten Zeile eines Arbeitsblattes
ablegen.

Der Listenfeed enthält alle Zeilen nach der ersten Zeile bis zur ersten leeren Zeile. Die erste leere Zeile
terminiert das Datenset. Wenn angenommene Daten nicht in einem Feed erscheinen, muß das Arbeitsblatt manuell
darauf geprüft werden ob eine unerwartete leere Zeile in der Mitte der Daten vorhanden ist. Im speziellen wird der
Listenfeed, wenn die zweite Zeile der Tabellenkalkulation leer ist, keine Daten enthalten.

Eine Zeile in einem Listenfeed ist soviele Spalten breit wie das Arbeitsblatt selbst.

.. _zend.gdata.spreadsheets.listfeeds.get:

Einen listen-basierenden Feed erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um einen Listenfeed eines Arbeitsblattes zu erhalten, kann die ``getListFeed()`` Methode des Tabellenkalkulations
Services verwendet werden.

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Spreadsheets_ListQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $query->setWorksheetId($worksheetId);
   $listFeed = $spreadsheetService->getListFeed($query);

Das sich ergebende ``Zend_Gdata_Spreadsheets_ListFeed`` Objekt ``$listfeed`` repräsentiert eine Antwort vom
Server. Neben anderen Dingen enthält dieser Feed ein Array von ``Zend_Gdata_Spreadsheets_ListEntry`` Objekten
(``$listFeed->entries``), wobei jedes eine einzelne Zeile in einem Arbeitsblatt repräsentiert.

Jeder ``Zend_Gdata_Spreadsheets_ListEntry`` enthält ein Array, ``custom``, welches die Daten für die Zeile
enthält. Dieses Array kann extrahiert und angezeigt werden:

.. code-block:: php
   :linenos:

   $rowData = $listFeed->entries[1]->getCustom();
   foreach($rowData as $customEntry) {
     echo $customEntry->getColumnName() . " = " . $customEntry->getText();
   }

Eine alternative Version dieses Arrays, ``customByName``, erlaubt den direkten Zugriff zu dem Eintrag einer Zelle
durch den Namen. Das ist üblich, wenn man versucht auf einen speziellen Header zuzugreifen:

.. code-block:: php
   :linenos:

   $customEntry = $listFeed->entries[1]->getCustomByName('my_heading');
   echo $customEntry->getColumnName() . " = " . $customEntry->getText();

.. _zend.gdata.spreadsheets.listfeeds.reverse:

Umgekehrt-sortierte Zeilen
^^^^^^^^^^^^^^^^^^^^^^^^^^

Standardmäßig werden die Zeilen im Feed in der gleichen Reihenfolge angezeigt wie in den entsprechenden Zeilen im
GUI; das ist die Reihenfolge anhand der Zeilennummer. Um Zeilen in einer umgekehrten Reihenfolge zu erhalten, muß
die reverse Eigenschaft des ``Zend_Gdata_Spreadsheets_ListQuery`` Objektes auf ``TRUE`` gesetzt werden:

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Spreadsheets_ListQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $query->setWorksheetId($worksheetId);
   $query->setReverse('true');
   $listFeed = $spreadsheetService->getListFeed($query);

Es ist zu beachten, das wenn nach einer speziellen Spalte sortiert (oder umgekehrt sortiert) werden soll, statt
nach der Position im Arbeitsblatt, kann der ``orderby`` Wert des ``Zend_Gdata_Spreadsheets_ListQuery`` Objekts auf
**column:<Der Header dieser Spalte>** gesetzt werden.

.. _zend.gdata.spreadsheets.listfeeds.sq:

Eine strukturierte Abfrage senden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Der ``sq`` Wert von ``Zend_Gdata_Spreadsheets_ListQuery`` kann gesetzt werden um einen Feed mit Einträgen zu
erzeugen die ein spezielles Kriterium erfüllen. Angenommen, man hat ein Arbeitsblatt das personelle Daten
enthält, in denen jede Zeile Informationen über eine einzelne Person repräsentiert, und man will alle Zeilen
empfangen will in denen der Name der Person "John" ist, und das Alter der Person über 25. Um das tu tun, muß
``sq`` wie folgt gesetzt werden:

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Spreadsheets_ListQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $query->setWorksheetId($worksheetId);
   $query->setSpreadsheetQuery('name=John and age>25');
   $listFeed = $spreadsheetService->getListFeed($query);

.. _zend.gdata.spreadsheets.listfeeds.addrow:

Hinzufügen einer Zeile
^^^^^^^^^^^^^^^^^^^^^^

Zeilen können zu einer Tabellenkalkulation hinzugefügt werden durch Verendung der ``insertRow()`` Methode des
Tabellenkalkulations Services.

.. code-block:: php
   :linenos:

   $insertedListEntry = $spreadsheetService->insertRow($rowData,
                                                       $spreadsheetKey,
                                                       $worksheetId);

Der ``$rowData`` Parameter enthält ein Array von Spaltenschlüssel zu Datenwerten. Die Methode gibt ein
``Zend_Gdata_Spreadsheets_SpreadsheetsEntry`` Objekt zurück welches die eingefügte Zeile repräsentiert.

Die Tabellenkalkulation fügt die neue Zeile unmittelbar nach der letzten Zeile ein die in dem listen-basierenden
Feed erscheint, was bedeutet unmittelbar vor der ersten komplett leeren Zeile.

.. _zend.gdata.spreadsheets.listfeeds.editrow:

Eine Zeile bearbeiten
^^^^^^^^^^^^^^^^^^^^^

Sobald ein ``Zend_Gdata_Spreadsheets_ListEntry`` Objekt geholt wird, können diese Zeilen durch die Verwendung der
``updateRow()`` Methode des Tabellenkalkulations Services aktualisiert werden.

.. code-block:: php
   :linenos:

   $updatedListEntry = $spreadsheetService->updateRow($oldListEntry,
                                                      $newRowData);

Der ``$oldListEntry`` Parameter enthält den Listeneintrag der aktualisiert werden soll. ``$newRowData`` enthält
ein Array von Spaltenschlüssel zu Datenwerten, die als neue Zeilendaten verwendet werden. Diese Methode gibt ein
``Zend_Gdata_Spreadsheets_SpreadsheetsEntry`` Objekt zurück welches die aktualisierte Zeile repräsentiert.

.. _zend.gdata.spreadsheets.listfeeds.deleterow:

Eine Zeile löschen
^^^^^^^^^^^^^^^^^^

Um eine Zeile zu löschen muß einfach ``deleteRow()`` auf dem ``Zend_Gdata_Spreadsheets`` Objekt mit dem
bestehenden Eintrag aufgerufen werden, der gelöscht werden soll:

.. code-block:: php
   :linenos:

   $spreadsheetService->deleteRow($listEntry);

Alternativ kann die ``delete()`` Methode des Eintrags selbst aufgerufen werden:

.. code-block:: php
   :linenos:

   $listEntry->delete();

.. _zend.gdata.spreadsheets.cellfeeds:

Mit zellen-basierenden Feeds interagieren
-----------------------------------------

In einem zellen-basierenden Feed repräsentiert jeder Eintrag eine einzelne Zelle.

Es wird nicht empfohlen mit beiden, einem zellen-basierenden Feed und einem listen-basierenden Feed für das
gleiche Arbeitsblatt zur selben Zeit zu interagieren.

.. _zend.gdata.spreadsheets.cellfeeds.get:

Einen zellen-basierenden Feed erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um einen Zellen Feed des Arbeitsblatt zu erhalten muß die ``getCellFeed()`` Methode des Tabellenkalkulations
Services verwendet werden.

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Spreadsheets_CellQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $query->setWorksheetId($worksheetId);
   $cellFeed = $spreadsheetService->getCellFeed($query);

Im resultierenden ``Zend_Gdata_Spreadsheets_CellFeed`` Objekt repräsentiert ``$cellFeed`` eine Antwort vom Server.
Neben anderen Dingen enthält dieser Feed ein Array von ``Zend_Gdata_Spreadsheets_CellEntry`` Objekten
(``$cellFeed>entries``), von denen jeder eine einzelne Zelle in einem Arbeitsblatt repräsentiert. Diese
Information kann angezeigt werden:

.. code-block:: php
   :linenos:

   foreach($cellFeed as $cellEntry) {
     $row = $cellEntry->cell->getRow();
     $col = $cellEntry->cell->getColumn();
     $val = $cellEntry->cell->getText();
     echo "$row, $col = $val\n";
   }

.. _zend.gdata.spreadsheets.cellfeeds.cellrangequery:

Eine Zellen-Bereichs Abfrage senden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Angenommen man will die Zellen der ersten Spalte des Arbeitsblattes empfangen. Man kann einen Zellen Feed abfragen
der nur diese Spalte enthält und geht hierbei wie folgt vor:

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Spreadsheets_CellQuery();
   $query->setMinCol(1);
   $query->setMaxCol(1);
   $query->setMinRow(2);
   $feed = $spreadsheetService->getCellsFeed($query);

Das fragt alle Daten in der Spalte 1, beginnend mit der Zeile 2, ab.

.. _zend.gdata.spreadsheets.cellfeeds.updatecell:

Den Inhalt einer Zelle ändern
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um den Inhalt einer Zelle zu ändern, muß ``updateCell()`` mit der Zeile, Spalte und dem neuen Wert der Zelle,
aufgerufen werden.

.. code-block:: php
   :linenos:

   $updatedCell = $spreadsheetService->updateCell($row,
                                                  $col,
                                                  $inputValue,
                                                  $spreadsheetKey,
                                                  $worksheetId);

Die neuen Daten werden in der spezifizierten Zelle im Arbeitsblatt plaziert. Wenn die spezifizierte Zelle bereits
Daten enthält, werden diese überschrieben. Beachte: ``updateCell()`` muß verwedet werden um Daten in einer Zelle
zu verändern, selbst wenn diese Zelle leer ist.



.. _`http://code.google.com/apis/spreadsheets/overview.html`: http://code.google.com/apis/spreadsheets/overview.html
