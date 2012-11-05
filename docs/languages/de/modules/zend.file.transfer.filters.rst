.. EN-Revision: none
.. _zend.file.transfer.filters:

Filter für Zend\File\Transfer
=============================

``Zend\File\Transfer`` wird mit verschiedenen Datei bezogenen Filtern ausgeliefert die verwendet werden können um
verschiedene Arbeiten die oft auf Dateien angewendet werden zu automatisieren. Es ist zu beachten das Dateifilter
nach der Validierung angewendet werden. Dateifilter verhalten sich auch etwas anders als andere Filter. Sie geben
immer den Dateinamen zurück, und nicht den geänderten Inhalt (was eine schlechte Idee wäre wenn auf 1GB Dateien
gearbeitet wird). Alle Dateifilter welche mit ``Zend\File\Transfer`` angeboten werden können in der
``Zend_Filter`` Komponente gefunden werden und heißen ``Zend\Filter_File\*``. Die folgenden Filter sind aktuell
vorhanden:

- ``Decrypt``: Dieser Filter kann verschlüsselte Dateien entschlüsseln.

- ``Encrypt``: Dieser Filter kann Dateien verschlüsseln.

- ``LowerCase``: Dieser Filter kann den Inhalt einer Textdatei auf Kleinschreibung ändern.

- ``Rename``: Dieser Filter kann Dateien umbenennen, den Ort ändern und sogar das Überschreiben von existierenden
  Dateien erzwingen.

- ``UpperCase``: Dieser Filter kann den Inhalt einer Textdatei auf Großschreibung ändern.

.. _zend.file.transfer.filters.usage:

Verwenden von Filtern mit Zend\File\Transfer
--------------------------------------------

Die Verwendung von Filtern ist sehr einfach. Es gibt verschiedene Methoden für das Hinzufügen und Manipulieren
von Filtern.

- ``addFilter($filter, $options = null, $files = null)``: Fügt den angegebenen Filter zu den Filterstapel hinzu
  (optional nur zu den Datei(en) die spezifiziert wurden). ``$filter`` kann entweder eine aktuelle Filterinstanz
  sein, oder ein Kurzname der den Filtertyp spezifiziert (z.B. 'Rename').

- ``addFilters(array $filters, $files = null)``: Fügt die angegebenen Filter zum Filterstapel hinzu. Jeder Eintrag
  kann entweder ein Filtertyp/-options Paar sein, oder ein Array mit dem Schlüssel 'filter' das den Filter
  spezifiziert (alle anderen Optionen werden als Optionen für die Instanzierung der Filter angenommen).

- ``setFilters(array $filters, $files = null)``: Überschreibt alle bestehenden Filter mit den spezifizierten
  Filtern. Die Filter sollten der Syntax folgen die für ``addFilters()`` definiert ist.

- ``hasFilter($name)``: Zeigt ob ein Filter registriert wurde.

- ``getFilter($name)``: Gibt einen vorher registrierten Filter zurück.

- ``getFilters($files = null)``: Gibt registrierte Filter zurück; wenn ``$files`` übergeben wurde, werden die
  Filter für die betreffende Datei oder das Set an Dateien zurückgegeben.

- ``removeFilter($name)``: Entfernt einen vorher registrierten Filter.

- ``clearFilters()``: Löscht alle registrierten Filter.

.. _zend.file.transfer.filters.usage.example:

.. rubric:: Filter zu einem Dateitransfer hinzufügen

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Setzt einen neuen Zielpfad
   $upload->addFilter('Rename', 'C:\picture\uploads');

   // Setzt einen neuen Zielpfad und überschreibt bestehende Dateien
   $upload->addFilter('Rename',
                      array('target' => 'C:\picture\uploads',
                            'overwrite' => true));

.. _zend.file.transfer.filters.usage.exampletwo:

.. rubric:: Filter auf eine einzelne Datei begrenzen

``addFilter()``, ``addFilters()``, und ``setFilters()`` akzeptieren ein endenes ``$files`` Argument. Dieses
Argument kann verwendet werden um eine Datei oder ein Array von Dateien zu spezifizieren auf dem der angegebene
Filter gesetzt werden soll.

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Setzt einen neuen Zielpfad und begrenzt Ihn auf 'file2'
   $upload->addFilter('Rename', 'C:\picture\uploads', 'file2');

Generell sollte einfach die ``addFilters()`` Methode verwendet werden, welche mehrmals aufgerufen werden kann.

.. _zend.file.transfer.filters.usage.examplemultiple:

.. rubric:: Mehrere Filter hinzufügen

Oft ist es einfacher ``addFilter()`` mehrere Male aufzurufen. Ein Aufruf für jeden Filter. Das erhöht auch die
Lesbarkeit und macht den Code wartbarer. Da alle Methoden das Fluent-Interface implementieren können Aufrufe
einfach wie anbei gezeigt gekoppelt werden:

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Setzt mehrere Rename Filter
   $upload->addFilter('Rename', 'C:\picture\newjpg', 'file1')
          ->addFilter('Rename', 'C:\picture\newgif', 'file2');

.. note::

   Es ist zu beachten das, auch wenn das mehrfache Setzen des gleichen Filters erlaubt ist, das zu Problemen
   führen kann wenn verschiedene Optionen für den gleichen Filter verwendet werden.

.. _zend.file.transfer.filters.decrypt:

Decrypt Filter
--------------

Der ``Decrypt`` Filter erlaubt es verschlüsselte Dateien zu entschlüsseln.

Dieser Filter verwendet ``Zend\Filter\Decrypt``. Er unterstützt die Erweiterungen ``Mcrypt`` und ``OpenSSL`` von
*PHP*. Lesen Sie bitte das betreffende Kapitel für Details darüber wie Optionen für die Entschlüsselung gesetzt
werden können und welche Optionen unterstützt werden.

Dieser Filter unterstützt eine zusätzliche Option die verwendet werden kann um die entschlüsselte Datei unter
einem anderen Dateinamen zu speichern. Setze die ``filename`` Option um den Dateinamen zu ändern unter dem die
entschlüsselte Datei abgespeichert wird. Wenn diese Option nicht angegeben wird, überschreibt die entschlüsselte
Datei die verschlüsselte Originaldatei.

.. _zend.file.transfer.filters.decrypt.example1:

.. rubric:: Verwenden des Decrypt Filters mit Mcrypt

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer\Adapter\Http();

   // Fügt einen Filter hinzu um die hochgeladene verschlüsselte Datei
   // mit Mcrypt und dem Schlüssel mykey zu entschlüsseln
   // with mcrypt and the key mykey
   $upload->addFilter('Decrypt',
       array('adapter' => 'mcrypt', 'key' => 'mykey'));

.. _zend.file.transfer.filters.decrypt.example2:

.. rubric:: Verwenden des Decrypt Filters mit OpenSSL

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer\Adapter\Http();

   // Fügt einen Filter hinzu um die hochgeladene verschlüsselte Datei
   // mit openssl und den angegebenen Schlüsseln zu entschlüseln
   $upload->addFilter('Decrypt',
       array('adapter' => 'openssl',
             'private' => '/path/to/privatekey.pem',
             'envelope' => '/path/to/envelopekey.pem'));

.. _zend.file.transfer.filters.encrypt:

Encrypt Filter
--------------

Der ``Encrypt`` Filter erlaubt es eine Datei zu verschlüsseln.

Dieser Filter verwendet ``Zend\Filter\Encrypt``. Er unterstützt die Erweiterungen ``Mcrypt`` und ``OpenSSL`` von
*PHP*. Lesen Sie bitte das betreffende Kapitel für Details darüber wie Optionen für die Entschlüsselung gesetzt
werden können und welche Optionen unterstützt werden.

Dieser Filter unterstützt eine zusätzliche Option die verwendet werden kann um die verschlüsselte Datei unter
einem anderen Dateinamen zu speichern. Setze die ``filename`` Option um den Dateinamen zu ändern unter dem die
verschlüsselte Datei abgespeichert wird. Wenn diese Option nicht angegeben wird, überschreibt die verschlüsselte
Datei die Originaldatei.

.. _zend.file.transfer.filters.encrypt.example1:

.. rubric:: Verwenden des Encrypt Filters mit Mcrypt

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer\Adapter\Http();

   // Fügt einen Filter hinzu um die hochgeladene Datei mit mcrypt
   // und dem Schlüssel mykey zu verschlüsseln
   $upload->addFilter('Encrypt',
       array('adapter' => 'mcrypt', 'key' => 'mykey'));

.. _zend.file.transfer.filters.encrypt.example2:

.. rubric:: Verwenden des Encrypt Filters mit OpenSSL

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer\Adapter\Http();

   // Fügt einen Filter hinzu um die hochgeladene Datei mit openssl
   // und den angegebenen Schlüsseln zu verschlüsseln
   $upload->addFilter('Encrypt',
       array('adapter' => 'openssl',
             'public' => '/path/to/publickey.pem'));

.. _zend.file.transfer.filters.lowercase:

LowerCase Filter
----------------

Der ``LowerCase`` Filter erlaubt es den Inhalt einer Datei auf Kleinschreibung zu ändern. Dieser Filter sollte nur
mit Textdateien verwendet werden.

Bei der Initialisierung kann ein String angegeben werden welcher dann als Kodierung verwendet wird. Oder man kann
die ``setEncoding()`` Methode verwenden um Sie im Nachhinein zu setzen.

.. _zend.file.transfer.filters.lowercase.example:

.. rubric:: Verwenden des Lowercase Filters

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('MimeType', 'text');

   // Fügt einen Filter hinzu der hochgeladene Textdateien
   // auf Kleinschreibung ändert
   $upload->addFilter('LowerCase');

   // Fügt einen Filter hinzu um die hochgeladene Datei auf Kleinschreibung
   // zu ändern aber nur für uploadfile1
   $upload->addFilter('LowerCase', null, 'uploadfile1');

   // Fügt einen Filter für die Kleinschreibung hinzu wobei die Kodierung
   // auf ISO-8859-1 gesetzt wird
   $upload->addFilter('LowerCase', 'ISO-8859-1');

.. note::

   Da die Optionen für den LowerCase Filter optional sind muß man darauf achten das man als zweiten Parameter
   eine ``NULL`` (die Optionen) geben muß wenn man Ihn auf ein einzelnes Dateielement einschränken will.

.. _zend.file.transfer.filters.rename:

Rename Filter
-------------

Der ``Rename`` Filter erlaubt es das Ziel des Uploads zu Ändern, den Dateinamen sowie bereits bestehende Dateien
zu überschreiben. Er unterstützt die folgenden Optionen:

- ``source``: Der Name und das Ziel der alten Datei welche umbenannt werden soll.

- ``target``: Das neue Verzeichnis, oder der Dateiname der Datei.

- ``overwrite``: Definiert ob die alte Datei von der neuen überschrieben wird wenn diese bereits existiert. Der
  Standardwert ist ``FALSE``.

Zusätzlich kann die ``setFile()`` Methode verwendet werden um Dateien zu setzen, sie überschreibt alle vorher
gesetzten Dateien, ``addFile()`` um eine neue Datei zu bereits bestehenden zu setzen, und ``getFile()`` um alle
aktuell gesetzten Dateien zu erhalten. Um die Dinge zu vereinfachen, versteht dieser Filter verschiedene
Schreibweisen und seine Methoden und der Contructor verstehen die gleichen Schreibweisen.

.. _zend.file.transfer.filters.rename.example:

.. rubric:: Verwenden des Rename Filters

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer\Adapter\Http();

   // Setzt einen neuen Zielpfad für alle Dateien
   $upload->addFilter('Rename', 'C:\mypics\new');

   // Setzt einen neuen Zielpfad nur für uploadfile1
   $upload->addFilter('Rename', 'C:\mypics\newgifs', 'uploadfile1');

Man kann verschiedene Schreibweisen verwenden. Anbei ist eine Tabelle in der eine Beschreibung und der Hintergrund
für die verschiedenen unterstützten Schreibweisen zu finden ist. Es ist zu beachten das, wenn man den Adapter
oder das Form Element verwendet, man nicht alle beschriebenen Schreibweisen verwenden kann.

.. _zend.file.transfer.filters.rename.notations:

.. table:: Verschiedene Schreibweisen des Rename Filters und deren Bedeutung

   +-----------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Schreibweise                                                                                   |Beschreibung                                                                                                                                                                                                                                                                                  |
   +===============================================================================================+==============================================================================================================================================================================================================================================================================================+
   |addFile('C:\\uploads')                                                                         |Spezifiziert einen neuen Pfad für alle Dateien wenn der angegebene String ein Verzeichnis ist. Es ist zu beachten das man eine Exception erhält wenn die Datei bereits existiert, siehe den overwriting Parameter.                                                                            |
   +-----------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addFile('C:\\uploads\\file.ext')                                                               |Spezifiziert einen neuen Pfad und Dateinamen für alle Dateien wenn der angegebene String nicht als Verzeichnis erkannt wird. Es ist zu beachten das man eine Exception erhält wenn die angegebene Datei bereits existiert, siehe den overwriting Parameter.                                   |
   +-----------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addFile(array('C:\\uploads\\file.ext', 'overwrite' => true))                                   |Spezifiziert einen neuen Pfad und Dateinamen für alle Dateien wenn der angegebene String nicht als Verzeichnis erkannt wird, und überschreibt alle existierenden Dateien mit dem gleichen Zielnamen. Es ist zu beachten das man keine Verständigung erhält das eine Datei überschrieben wurde.|
   +-----------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addFile(array('source' => 'C:\\temp\\uploads', 'target' => 'C:\\uploads'))                     |Spezifiziert einen neuen Pfad für alle Dateien im alten Pfad wenn die angegebenen Strings als Verzeichnis erkannt werden. Es ist zu beachten das man eine Exception erhält wenn die Datei bereits exstiert, siehe den overwriting Parameter.                                                  |
   +-----------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addFile(array('source' => 'C:\\temp\\uploads', 'target' => 'C:\\uploads', 'overwrite' => true))|Spezifiziert einen neuen Pfad für alle Dateien im alten Pfad wenn die angegebenen Strings als Verzeichnis erkant werden und überschreibt alle existierenden Dateien mit dem gleichen Zielnamen. Es ist zu beachten das man keine Benachrichtigung erhält das eine Datei überschrieben wurde.  |
   +-----------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.file.transfer.filters.uppercase:

UpperCase Filter
----------------

Der ``UpperCase`` Filter erlaubt es den Inhalt einer Datei auf Großschreibung zu ändern. Dieser Filter sollte nur
mit Textdateien verwendet werden.

Bei der Initialisierung kann ein String angegeben werden welcher dann als Kodierung verwendet wird. Oder man kann
die ``setEncoding()`` Methode verwenden um Sie im Nachhinein zu setzen.

.. _zend.file.transfer.filters.uppercase.example:

.. rubric:: Verwenden des UpperCase Filters

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('MimeType', 'text');

   // Fügt einen Filter hinzu um die hochgeladene Textdatei auf
   // Großschreibung zu ändern
   $upload->addFilter('UpperCase');

   // Fügt einen Filter hinzu um die hochgeladene Datei auf Großschreibung
   // zu ändern aber nur für uploadfile1
   $upload->addFilter('UpperCase', null, 'uploadfile1');

   // Fügt einen Filter für die Großschreibung hinzu wobei die Kodierung
   // auf ISO-8859-1 gesetzt wird
   $upload->addFilter('UpperCase', 'ISO-8859-1');

.. note::

   Da die Optionen für den UpperCase Filter optional sind muß man darauf achten das man als zweiten Parameter
   eine ``NULL`` (die Optionen) geben muß wenn man Ihn auf ein einzelnes Dateielement einschränken will.


