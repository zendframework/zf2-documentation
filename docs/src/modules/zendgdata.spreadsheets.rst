.. _zendgdata.spreadsheets:

Using Google Spreadsheets
=========================

The Google Spreadsheets data *API* allows client applications to view and update Spreadsheets content in the form
of Google data *API* feeds. Your client application can request a list of a user's spreadsheets, edit or delete
content in an existing Spreadsheets worksheet, and query the content in an existing Spreadsheets worksheet.

See http://code.google.com/apis/spreadsheets/overview.html for more information about the Google Spreadsheets
*API*.

.. _zendgdata.spreadsheets.creating:

Create a Spreadsheet
--------------------

The Spreadsheets data *API* does not currently provide a way to programmatically create or delete a spreadsheet.

.. _zendgdata.spreadsheets.listspreadsheets:

Get a List of Spreadsheets
--------------------------

You can get a list of spreadsheets for a particular user by using the ``getSpreadsheetFeed()`` method of the
Spreadsheets service. The service will return a ``ZendGData\Spreadsheets\SpreadsheetFeed`` object containing a
list of spreadsheets associated with the authenticated user.

.. code-block:: php
   :linenos:

   $service = ZendGData\Spreadsheets::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $spreadsheetService = new ZendGData\Spreadsheets($client);
   $feed = $spreadsheetService->getSpreadsheetFeed();

.. _zendgdata.spreadsheets.listworksheets:

Get a List of Worksheets
------------------------

A given spreadsheet may contain multiple worksheets. For each spreadsheet, there's a worksheets metafeed listing
all the worksheets in that spreadsheet.

Given the spreadsheet key from the <id> of a ``ZendGData\Spreadsheets\SpreadsheetEntry`` object you've already
retrieved, you can fetch a feed containing a list of worksheets associated with that spreadsheet.

.. code-block:: php
   :linenos:

   $query = new ZendGData\Spreadsheets\DocumentQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $feed = $spreadsheetService->getWorksheetFeed($query);

The resulting ``ZendGData\Spreadsheets\WorksheetFeed`` object feed represents the response from the server. Among
other things, this feed contains a list of ``ZendGData\Spreadsheets\WorksheetEntry`` objects (``$feed->entries``),
each of which represents a single worksheet.

.. _zendgdata.spreadsheets.listfeeds:

Interacting With List-based Feeds
---------------------------------

A given worksheet generally contains multiple rows, each containing multiple cells. You can request data from the
worksheet either as a list-based feed, in which each entry represents a row, or as a cell-based feed, in which each
entry represents a single cell. For information on cell-based feeds, see :ref:`Interacting with cell-based feeds
<zendgdata.spreadsheets.cellfeeds>`.

The following sections describe how to get a list-based feed, add a row to a worksheet, and send queries with
various query parameters.

The list feed makes some assumptions about how the data is laid out in the spreadsheet.

In particular, the list feed treats the first row of the worksheet as a header row; Spreadsheets dynamically
creates *XML* elements named after the contents of header-row cells. Users who want to provide Gdata feeds should
not put any data other than column headers in the first row of a worksheet.

The list feed contains all rows after the first row up to the first blank row. The first blank row terminates the
data set. If expected data isn't appearing in a feed, check the worksheet manually to see whether there's an
unexpected blank row in the middle of the data. In particular, if the second row of the spreadsheet is blank, then
the list feed will contain no data.

A row in a list feed is as many columns wide as the worksheet itself.

.. _zendgdata.spreadsheets.listfeeds.get:

Get a List-based Feed
^^^^^^^^^^^^^^^^^^^^^

To retrieve a worksheet's list feed, use the ``getListFeed()`` method of the Spreadsheets service.

.. code-block:: php
   :linenos:

   $query = new ZendGData\Spreadsheets\ListQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $query->setWorksheetId($worksheetId);
   $listFeed = $spreadsheetService->getListFeed($query);

The resulting ``ZendGData\Spreadsheets\ListFeed`` object ``$listfeed`` represents a response from the server.
Among other things, this feed contains an array of ``ZendGData\Spreadsheets\ListEntry`` objects
(``$listFeed->entries``), each of which represents a single row in a worksheet.

Each ``ZendGData\Spreadsheets\ListEntry`` contains an array, ``custom``, which contains the data for that row. You
can extract and display this array:

.. code-block:: php
   :linenos:

   $rowData = $listFeed->entries[1]->getCustom();
   foreach ($rowData as $customEntry) {
     echo $customEntry->getColumnName() . " = " . $customEntry->getText();
   }

An alternate version of this array, ``customByName``, allows direct access to an entry's cells by name. This is
convenient when trying to access a specific header:

.. code-block:: php
   :linenos:

   $customEntry = $listFeed->entries[1]->getCustomByName('my_heading');
   echo $customEntry->getColumnName() . " = " . $customEntry->getText();

.. _zendgdata.spreadsheets.listfeeds.reverse:

Reverse-sort Rows
^^^^^^^^^^^^^^^^^

By default, rows in the feed appear in the same order as the corresponding rows in the GUI; that is, they're in
order by row number. To get rows in reverse order, set the reverse properties of the
``ZendGData\Spreadsheets\ListQuery`` object to ``TRUE``:

.. code-block:: php
   :linenos:

   $query = new ZendGData\Spreadsheets\ListQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $query->setWorksheetId($worksheetId);
   $query->setReverse('true');
   $listFeed = $spreadsheetService->getListFeed($query);

Note that if you want to order (or reverse sort) by a particular column, rather than by position in the worksheet,
you can set the ``orderby`` value of the ``ZendGData\Spreadsheets\ListQuery`` object to **column:<the header of
that column>**.

.. _zendgdata.spreadsheets.listfeeds.sq:

Send a Structured Query
^^^^^^^^^^^^^^^^^^^^^^^

You can set a ``ZendGData\Spreadsheets\ListQuery``'s ``sq`` value to produce a feed with entries that meet the
specified criteria. For example, suppose you have a worksheet containing personnel data, in which each row
represents information about a single person. You wish to retrieve all rows in which the person's name is "John"
and the person's age is over 25. To do so, you would set ``sq`` as follows:

.. code-block:: php
   :linenos:

   $query = new ZendGData\Spreadsheets\ListQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $query->setWorksheetId($worksheetId);
   $query->setSpreadsheetQuery('name=John and age>25');
   $listFeed = $spreadsheetService->getListFeed($query);

.. _zendgdata.spreadsheets.listfeeds.addrow:

Add a Row
^^^^^^^^^

Rows can be added to a spreadsheet by using the ``insertRow()`` method of the Spreadsheet service.

.. code-block:: php
   :linenos:

   $insertedListEntry = $spreadsheetService->insertRow($rowData,
                                                       $spreadsheetKey,
                                                       $worksheetId);

The ``$rowData`` parameter contains an array of column keys to data values. The method returns a
``ZendGData\Spreadsheets\SpreadsheetsEntry`` object which represents the inserted row.

Spreadsheets inserts the new row immediately after the last row that appears in the list-based feed, which is to
say immediately before the first entirely blank row.

.. _zendgdata.spreadsheets.listfeeds.editrow:

Edit a Row
^^^^^^^^^^

Once a ``ZendGData\Spreadsheets\ListEntry`` object is fetched, its rows can be updated by using the
``updateRow()`` method of the Spreadsheet service.

.. code-block:: php
   :linenos:

   $updatedListEntry = $spreadsheetService->updateRow($oldListEntry,
                                                      $newRowData);

The ``$oldListEntry`` parameter contains the list entry to be updated. ``$newRowData`` contains an array of column
keys to data values, to be used as the new row data. The method returns a
``ZendGData\Spreadsheets\SpreadsheetsEntry`` object which represents the updated row.

.. _zendgdata.spreadsheets.listfeeds.deleterow:

Delete a Row
^^^^^^^^^^^^

To delete a row, simply invoke ``deleteRow()`` on the ``ZendGData\Spreadsheets`` object with the existing entry to
be deleted:

.. code-block:: php
   :linenos:

   $spreadsheetService->deleteRow($listEntry);

Alternatively, you can call the ``delete()`` method of the entry itself:

.. code-block:: php
   :linenos:

   $listEntry->delete();

.. _zendgdata.spreadsheets.cellfeeds:

Interacting With Cell-based Feeds
---------------------------------

In a cell-based feed, each entry represents a single cell.

Note that we don't recommend interacting with both a cell-based feed and a list-based feed for the same worksheet
at the same time.

.. _zendgdata.spreadsheets.cellfeeds.get:

Get a Cell-based Feed
^^^^^^^^^^^^^^^^^^^^^

To retrieve a worksheet's cell feed, use the ``getCellFeed()`` method of the Spreadsheets service.

.. code-block:: php
   :linenos:

   $query = new ZendGData\Spreadsheets\CellQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $query->setWorksheetId($worksheetId);
   $cellFeed = $spreadsheetService->getCellFeed($query);

The resulting ``ZendGData\Spreadsheets\CellFeed`` object ``$cellFeed`` represents a response from the server.
Among other things, this feed contains an array of ``ZendGData\Spreadsheets\CellEntry`` objects
(``$cellFeed>entries``), each of which represents a single cell in a worksheet. You can display this information:

.. code-block:: php
   :linenos:

   foreach ($cellFeed as $cellEntry) {
     $row = $cellEntry->cell->getRow();
     $col = $cellEntry->cell->getColumn();
     $val = $cellEntry->cell->getText();
     echo "$row, $col = $val\n";
   }

.. _zendgdata.spreadsheets.cellfeeds.cellrangequery:

Send a Cell Range Query
^^^^^^^^^^^^^^^^^^^^^^^

Suppose you wanted to retrieve the cells in the first column of a worksheet. You can request a cell feed containing
only this column as follows:

.. code-block:: php
   :linenos:

   $query = new ZendGData\Spreadsheets\CellQuery();
   $query->setMinCol(1);
   $query->setMaxCol(1);
   $query->setMinRow(2);
   $feed = $spreadsheetService->getCellsFeed($query);

This requests all the data in column 1, starting with row 2.

.. _zendgdata.spreadsheets.cellfeeds.updatecell:

Change Contents of a Cell
^^^^^^^^^^^^^^^^^^^^^^^^^

To modify the contents of a cell, call ``updateCell()`` with the row, column, and new value of the cell.

.. code-block:: php
   :linenos:

   $updatedCell = $spreadsheetService->updateCell($row,
                                                  $col,
                                                  $inputValue,
                                                  $spreadsheetKey,
                                                  $worksheetId);

The new data is placed in the specified cell in the worksheet. If the specified cell contains data already, it will
be overwritten. Note: Use ``updateCell()`` to change the data in a cell, even if the cell is empty.



