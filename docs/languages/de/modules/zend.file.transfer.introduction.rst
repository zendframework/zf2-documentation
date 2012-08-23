.. EN-Revision: none
.. _zend.file.transfer.introduction:

Zend_File_Transfer
==================

``Zend_File_Transfer`` bietet exzessiven Support für Datei Uploads und Downloads. Es kommt mit eingebauten
Prüfungen für Dateien und Funktionslitäten um Dateien mit Filtern zu verändern. Protokoll-Adapter erlauben
``Zend_File_Transfer`` die selbe *API* für Transportprotokolle wie *HTTP*, FTP, WEBDAV und andere zu verwenden.

.. note::

   **Einschränkungen**

   Die aktuelle Implementation von ``Zend_File_Transfer`` ist auf *HTTP* Post Uploads limitiert. Andere Adapter die
   Downloads und andere Protokolle unterstützen werden in zukünftigen Releases hinzugefügt. Aktuell sollte
   ``Zend_File_Transfer_Adapter_Http`` direkt verwendet werden. Sobald andere Adapter vorhanden sind, kann ein
   gemeinsames Interface verwendet werden.

.. note::

   **Formulare**

   Wenn man ``Zend_Form`` verwendet sollte man die *API*\ s die von ``Zend_Form`` zur Verfügung gestellt werden,
   und ``Zend_File_Transfer`` nicht direkt, verwenden. Der Dateitransfer Support von ``Zend_Form`` ist in
   ``Zend_File_Transfer`` implementiert, weshalb die Informationen in diesem Kapitel für fortgeschrittene Benutzer
   von ``Zend_Form`` interessant sind.

Die Verwendung von ``Zend_File_Transfer`` ist relativ einfach. Es besteht aus zwei Teilen. Dem *HTTP* Formular,
wärend ``Zend_File_Transfer`` die hochgeladenen Dateien behandelt. Siehe das folgende Beispiel:

.. _zend.file.transfer.introduction.example:

.. rubric:: Einfaches Formular für File-Uploads

Dieses Beispiel zeigt einen einfachen Dateiupload. Das erste Teil ist das Dateiformular. In unserem Beispiel gibt
es nur eine Datei welche wir hochladen wollen.

.. code-block:: xml
   :linenos:

   <form enctype="multipart/form-data" action="/file/upload" method="POST">
       <input type="hidden" name="MAX_FILE_SIZE" value="100000" />
           Choose a file to upload: <input name="uploadedfile" type="file" />
       <br />
       <input type="submit" value="Upload File" />
   </form>

Der Bequemlichkeit halber kann :ref:`Zend_Form_Element_File <zend.form.standardElements.file>` verwendet werden
statt das *HTML* manuell zu erstellen.

Der nächste Schritt ist die Erstellung des Empfängers des Uploads. In unserem Beispiel ist der Empfänger bei
``/file/upload`` zu finden. Als nächstes erstellen wir also den 'file' Controller mit der ``upload()`` Aktion.

.. code-block:: php
   :linenos:

   $adapter = new Zend_File_Transfer_Adapter_Http();

   $adapter->setDestination('C:\temp');

   if (!$adapter->receive()) {
       $messages = $adapter->getMessages();
       echo implode("\n", $messages);
   }

Dieses Codebeispiel demonstriert die einfachste Verwendung von ``Zend_File_Transfer``. Ein lokales Ziel wird mit
der ``setDestination()`` Methode definiert, und anschließend die ``receive()`` Methode aufgerufen. Wenn
irgendwelche Uploadfehler auftreten werden diese als Ausnahme zurückgegeben.

.. note::

   **Achtung**

   Dieses Beispiel ist nur für die Demonstration der grundsätzlichen *API* von ``Zend_File_Transfer``. Man sollte
   dieses Code Beispiel **niemals** in einer Produktivumgebung einsetzen da es massive Sicherheitslücken
   aufweisst. Man sollte immer Prüfungen verwenden um die Sicherheit zu erhöhen.

.. _zend.file.transfer.introduction.adapters:

Von Zend_File_Transfer unterstützte Adapter
-------------------------------------------

``Zend_File_Transfer`` wurde designt um verschiedenste Adapter und auch Richtungen zu unterstützen. Mit
``Zend_File_Transfer`` kann man Dateien Hochladen, Herunterladen und sogar Weiterleiten (Hochladen mit einem
Adapter und Herunterladen mit einem anderen Adapter zur gleichen Zeit).

.. _zend.file.transfer.introduction.options:

Optionen für Zend_File_Transfer
-------------------------------

``Zend_File_Transfer`` und seine Adapter unterstützen verschiedene Optionen. Alle Optionen können gesetzt werden
indem Sie entweder dem Constructor übergeben werden, oder durch Aufruf der ``setOptions($options)``.
``getOptions()`` gibt die Optionen zurück die aktuell gesetzt sind. Nachfolgend ist eine Liste aller
unterstützten Optionen:

- **ignoreNoFile**: Wenn diese Option auf ``TRUE`` gesetzt ist, ignorieren alle Prüfer Dateien die nicht vom
  Formular hochgeladen wurde. Der Standardwert ist ``FALSE``, was einen Fehler verursacht wenn die Datei nicht
  spezifiziert wurde.

.. _zend.file.transfer.introduction.checking:

Dateien prüfen
--------------

``Zend_File_Transfer`` hat verschiedene Methoden die auf verschiedenste Stati von spezifizierten Dateien prüfen.
Diese sind nützlich wenn man Dateien bearbeiten will nachdem Sie empfangen wurden. Diese Methoden beinhalten:

- **isValid($files = null)**: Diese Methode prüft ob die angegebene Datei gültig ist, basierend auf den
  Prüfungen welche dieser Datei angehängt sind. Wenn keine Dateien spezifiziert wurden, werden alle Dateien
  geprüft. Man kann ``isValid()`` aufrufen bevor ``receive()`` aufgerufen wird; in diesem Fall ruft ``receive()``
  intern ``isValid()`` nicht mehr auf.

- **isUploaded($files = null)**: Diese Methode prüft ob die spezifizierte Datei vom Benutzer hochgeladen wurde.
  Das ist nützlich wenn man eine oder mehrere Dateien definiert hat. Wenn keine Dateien spezifiziert wurden,
  werden alle Dateien geprüft.

- **isReceived($files = null)**: Diese Methode prüft ob die spezifizierte Datei bereits empfangen wurde. Wenn
  keine Dateien angegeben wurden, werden alle Dateien geprüft.

.. _zend.file.transfer.introduction.checking.example:

.. rubric:: Dateien prüfen

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Gibt alle bekannten internen Datei Informationen zurück
   $files = $upload->getFileInfo();

   foreach ($files as $file => $info) {
       // Datei hochgeladen ?
       if (!$upload->isUploaded($file)) {
           print "Warum hast Du die Datei nicht hochgeladen ?";
           continue;
       }

       // Prüfungen sind ok ?
       if (!$upload->isValid($file)) {
           print "Sorry, aber die Datei ist nicht das was wir wollten";
           continue;
       }
   }

   $upload->receive();

.. _zend.file.transfer.introduction.informations:

Zusätzliche Dateiinformationen
------------------------------

``Zend_File_Transfer`` kann zusätzliche Informationen über Dateien zurückgeben. Die folgenden Methoden sind
vorhanden:

- **getFileName($file = null, $path = true)**: Diese Methode gibt den wirklichen Namen der übertragenen Datei
  zurück.

- **getFileInfo($file = null)**: Diese Methode gibt die internen Informationen für die angegebene übertragene
  Datei zurück.

- **getFileSize($file = null)**: Diese Methode gibt die echte Dateigröße für die angegebene Datei zurück.

- **getHash($hash = 'crc32', $files = null)**: Diese Methode gibt einen Hash des Inhalts einer angegebenen
  übertragenen Datei zurück.

- **getMimeType($files = null)**: Diese Methode gibt den Mimetyp der angegebenen übertragenen Datei zurück.

``getFileName()`` akzeptiert den Namen des Elements als ersten Parameter. Wenn kein Name angegeben wird, werden
alle bekannten Dateinamen in einem Array zurückgegeben. Wenn die Datei eine MultiDatei ist, wird auch ein Array
zurückgegeben. Wenn nur eine einzelne Datei vorhanden ist wird nur ein String zurückgegeben.

Standardmäßig werden Dateinamen mit dem kompletten Pfad zurückgegeben. Wenn man nur den Dateinamen ohne Pfad
benötigt, kann der zweite Parameter ``$path`` gesetzt werden, welcher den Dateinamen ausschneidet wenn er auf
``FALSE`` gesetzt wird.

.. _zend.file.transfer.introduction.informations.example1:

.. rubric:: Den Dateinamen bekommen

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();
   $upload->receive();

   // Gibt die Dateinamen aller Dateien zurück
   $names = $upload->getFileName();

   // Gibt den Dateinamen des Formularelements 'foo' zurück
   $names = $upload->getFileName('foo');

.. note::

   Es ist zu beachten das sich der Dateinamen ändern kann nachdem die Datei empfangen wurde (receive) weil alle
   Filter angewendet werden, sobald die Datei empfangen wurde. Deswegen sollte man ``getFileName()`` immer
   ausführen nachdem die Dateien empfangen wurden.

``getFileSize()`` gibt standardmäßig die echte Dateigröße in SI Schreibweise zurück was bedeutet das man
**2kB** statt **2048** erhält. Wenn man die reine Größe benötigt muß man die ``useByteString`` Option auf
``FALSE`` setzen.

.. _zend.file.transfer.introduction.informations.example.getfilesize:

.. rubric:: Die Größe einer Datei erhalten

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();
   $upload->receive();

   // Gibt die Größen aller Dateien als Array zurück
   // wenn mehr als eine Datei hochgeladen wurde
   $size = $upload->getFileSize();

   // Wechsle die SI Schreibweise damit reine Nummern zurückgegeben werden
   $upload->setOption(array('useByteString' => false));
   $size = $upload->getFileSize();

.. note::

   **Vom Client angegebene Dateigröße**

   Es ist zu beachten das die Dateigröße welche vom Client angegeben wird, nicht als sichere Eingabe angesehen
   wird. Deswegen wird die echte Größe der Datei erkannt und statt der Dateigröße zurückgegeben welche vom
   Client geschickt wurde.

``getHash()`` akzeptiert den Namen eines Hash Algorithmus als ersten Parameter. Für eine Liste bekannter
Algorithmen kann in `PHP's hash_algos Methode`_ gesehen werden. Wenn kein Algorithmus spezifiziert wird, wird
**crc32** als Standardalgorithmus verwendet.

.. _zend.file.transfer.introduction.informations.example2:

.. rubric:: Den Hash einer Datei erhalten

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();
   $upload->receive();

   // Gibt die Hashes von allen Dateien als Array zurück
   // wenn mehr als eine Datei hochgeladen wurde
   $hash = $upload->getHash('md5');

   // Gibt den Has für das 'foo' Formularelement zurück
   $names = $upload->getHash('crc32', 'foo');

.. note::

   **Rückgabewert**

   Es ist zu beachten das der zurückgegebene Wert ein Array ist, wenn die Datei oder der Formularname mehr als
   eine Datei enthält.

``getMimeType()`` gibt den Mimetyp einer Datei zurück. Wenn mehr als eine Datei hochgeladen wurde wird ein Array
zurückgegeben, andernfalls ein String.

.. _zend.file.transfer.introduction.informations.getmimetype:

.. rubric:: Den Mimetyp einer Datei bekommen

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();
   $upload->receive();

   $mime = $upload->getMimeType();

   // Gibt den Mimetyp des 'foo' Form Elements zurück
   $names = $upload->getMimeType('foo');

.. note::

   **Vom Client angegebener MimeTyp**

   Es ist zu beachten das der MimeTyp welcher vom Client angegeben wird, nicht als sichere Eingabe betrachtet wird.
   Deswegen wird der echte MimeTyp der Datei erkannt und statt dem Mimetyp welcher vom Client geschickt wird,
   zurückgegeben.

.. warning::

   **Mögliche Exception**

   Beachte das diese Methode die fileinfo Erweiterung verwendet wenn Sie vorhanden ist. Wenn diese Erweiterung
   nicht gefunden werden kann wird die mimemagic Erweiterung verwendet. Wenn keine Erweiterung gefunden wird dann
   wird eine Exception geworfen.

.. warning::

   **Originale Daten in $_FILES**

   Aus Sicherheitsgründen werden auch die originalen Daten in $_FILES überschrieben sobald ``Zend_File_Transfer``
   initiiert wird. Wenn man dieses Verhalten unterdrücken will und die originalen Daten benötigt, kann bei der
   Instanzierung die Option ``detectInfos`` einfach auf ``FALSE`` gesetzt werden.

   Diese Option hat keinen Effekt nachdem ``Zend_File_Transfer`` instanziert wurde.

.. _zend.file.transfer.introduction.uploadprogress:

Fortschritt für Datei Uploads
-----------------------------

``Zend_File_Transfer`` kann den aktuellen Status eines gerade stattfindenden Datei Uploads erheben. Um dieses
Feature zu verwenden muß man entweder die *APC* Erweiterung verwenden, die mit den meisten standardmäßigen *PHP*
Installationen vorhanden ist, oder die ``UploadProgress`` Erweiterung. Beide Erweiterungen werden erkannt und
automatisch verwendet. Um den Fortschritt zu erhalten muß man einige Voraussetzungen erfüllen.

Erstens, muß man entweder *APC* oder ``UploadProgress`` aktiviert haben. Es ist zu beachten das dieses Feature von
*APC* in der eigenen ``php.ini`` ausgeschaltet werden kann.

Zweitens, muß man die richtigen unsichtbaren Felder im Formular hinzugefügt haben das die Dateien sendet. Wenn
man ``Zend_Form_Element_File`` verwendet werden diese unsichtbaren Felder automatisch von ``Zend_Form``
hinzugefügt.

Wenn die oberen zwei Punkte vorhanden sind dann ist man in der Lage den aktuellen Fortschritt des Datei uploads zu
erhalten indem man die ``getProgress()`` Methode verwendet. Aktuell gibt es 2 offizielle Wege um das hand zu haben.

.. _zend.file.transfer.introduction.uploadprogress.progressadapter:

Verwenden eines Progressbar Adapters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Man kann einen bequemen **Zend_ProgressBar** verwenden um den aktuellen Fortschritt zu erhalten und kann Ihn dann
auf einfachem Wege dem Benutzer zeigen.

Um das zu ermöglichen, muß man den gewünschten **Zend_ProgressBar_Adapter** bei ``getProgress()`` hinzufügen
wenn es das erste Mal aufgerufen wird. Für Details über den zu verwendenden Adapter, bitte im Kapitel
:ref:`Zend_ProgressBar Standard Adapters <zend.progressbar.adapters>` nachsehen.

.. _zend.file.transfer.introduction.uploadprogress.progressadapter.example1:

.. rubric:: Verwenden eines Progressbar Adapters um den aktuellen Status zu erhalten

.. code-block:: php
   :linenos:

   $adapter = new Zend_ProgressBar_Adapter_Console();
   $upload  = Zend_File_Transfer_Adapter_Http::getProgress($adapter);

   $upload = null;
   while (!$upload['done']) {
       $upload = Zend_File_Transfer_Adapter_Http:getProgress($upload);
   }

Die komplette Handhabung wird von ``getProgress()`` im Hintergrund durchgeführt.

.. _zend.file.transfer.introduction.uploadprogress.manually:

getProgress() händisch verwenden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Man kann mit ``getProgress()`` auch händisch arbeiten, also ohne die Verwendung von ``Zend_ProgressBar``.

``getProgress()`` muß ohne Einstellungen aufgerufen werden. Es gibt anschließend ein Array mit verschiedenen
Schlüssel zurück. Sie unterscheiden sich, abhängig von der verwendeten *PHP* Extension. Aber die folgenden
Schlüssel werden unabhängig von der Extension zurück gegeben:

- **id**: Die ID dieses Uploads. Die ID identifiziert den Upload in der Extension. Man kann Sie auf den Wert des
  versteckten Schlüssels setzen welcher den Upload identifiziert wenn ``getProgress()`` das erste Mal aufgerufen
  wird. Standardmäßig ist er auf **progress_key** gesetzt. Man darf die ID nicht im Nachhinein ändern.

- **total**: Die komplette Größe der Datei die hochgeladen wird in Bytes als Integer.

- **current**: Die aktuelle hochgeladene Größe der Datei in Bytes als Integer.

- **rate**: Die durchschnittliche Geschwindigkeit des Uploads in Bytes pro Sekunde als Integer.

- **done**: Gibt ``TRUE`` zurück wenn der Upload abgeschlossen wurde, andernfalls ``FALSE``.

- **message**: Die aktuelle Meldung. Entweder der Fortschritt als Text in der Form **10kB / 200kB**, oder eine
  hilfreiche Nachricht im Fall eines Problems. Probleme könnten sein, das kein Upload durchgeführt wird, das ein
  Fehler wärend des Empfangens der Daten, für den Fortschritt, aufgetreten ist, oder das der Upload abgebrochen
  wurde.

- **progress**: Dieser optionale Schlüssel nimmt eine Instanz von ``Zend_ProgressBar_Adapter`` oder
  ``Zend_ProgressBar``, und erlaubt es, den aktuellen Status des Uploads, in einer Progressbar zu erhalten

- **session**: Dieser optionale Schlüssel nimmt den Namen eines Session Namespaces entgegen der in
  ``Zend_ProgressBar`` verwendet wird. Wenn dieser Schlüssel nicht angegeben wird, ist er standardmäßig
  ``Zend_File_Transfer_Adapter_Http_ProgressBar``.

Alle anderen zurückgegebenen Schlüssel werden direkt von den Extensions übernommen und werden nicht geprüft.

Das folgende Beispiel zeigt eine mögliche händische Verwendung:

.. _zend.file.transfer.introduction.uploadprogress.manually.example1:

.. rubric:: Händische Verwendung des Datei Fortschritts

.. code-block:: php
   :linenos:

   $upload  = Zend_File_Transfer_Adapter_Http::getProgress();

   while (!$upload['done']) {
       $upload = Zend_File_Transfer_Adapter_Http:getProgress($upload);
       print "\nAktueller Fortschritt:".$upload['message'];
       // Tu was zu tun ist
   }

.. note::

   **Die Datei kennen von welcher der Fortschritt kommen soll**

   Das obige Beispiel funktioniert wenn der identifizierte Upload auf 'progress_key' gesetzt wurde. Wenn man einen
   anderen Identifikator im Formular verwendet muss man den verwendeten Identifikator als ersten Parameter an
   ``getProgress()`` bei initialen Aufruf übergeben.



.. _`PHP's hash_algos Methode`: http://php.net/hash_algos
