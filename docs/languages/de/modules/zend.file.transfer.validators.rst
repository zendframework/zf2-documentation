.. EN-Revision: none
.. _zend.file.transfer.validators:

Prüfungen für Zend\File\Transfer
================================

``Zend\File\Transfer`` wird mit verschiedenen Datei-relevanten Prüfungen ausgeliefert welche verwendet werden
können um die Sicherheit zu erhöhen und mögliche Attacken zu verhindern. Es ist zu beachten das diese Prüfungen
nur so effektiv sind wie Sie effektiv angewendet verwendet. Alle Prüfungen die mit ``Zend\File\Transfer``
angeboten werden können in der ``Zend_Validator`` Komponente gefunden werden und heißen ``Zend\Validate_File\*``.
Die folgenden Prüfungen sind vorhanden:

- ``Count``: Diese Prüfung checkt die Anzahl der Dateien. Es kann ein Minimum und ein Maximum spezifiziert werden.
  Ein Fehler wird geworfen wenn einer der zwei Werte überschritten wird.

- ``Crc32``: Diese Prüfung checkt den Crc32 Hashwert vom Inhalt einer Datei. Sie basiert auf der ``Hash`` Prüfung
  und bietet eine bequeme und einfache Prüfung die nur Crc32 unterstützt.

- ``ExcludeExtension``: Diese Prüfung checkt die Dateierweiterung. Sie wirft einen Fehler wenn die angegebene
  Datei eine definierte Erweiterung hat. Mit dieser Prüfung können definierte Erweiterungen von der Prüfung
  ausgenommen werden.

- ``ExcludeMimeType``: Diese Prüfung prüft den *MIME* Typ von Dateien. Sie kann auch Arten von *MIME* Typen
  prüfen und wirft einen Fehler wenn der *MIME* Typ einer spezifizierten Datei passt.

- ``Exists``: Diese Prüfung checkt ob Dateien existieren. Sie wirft einen Fehler wenn eine spezifizierte Datei
  nicht existiert.

- ``Extension``: Diese Prüfung checkt die Dateierweiterung. Sie wirft einen Fehler wenn eine spezifizierte Datei
  eine undefinierte Erweiterung hat.

- ``FilesSize``: Diese Prüfung checkt die Größe von geprüften Dateien. Sie merkt sich intern die Größe aller
  geprüften Dateien und wirft einen Fehler wenn die Summe aller spezifizierten Dateien die definierte Größe
  überschreitet. Sie bietet auch Mindest- und Maximalwerte an.

- ``ImageSize``: Diese Prüfung checkt die Größe von Bildern. Sie prüft die Breite und Höhe und erzwingt sowohl
  eine Mindest- als auch eine Maximalgröße.

- ``IsCompressed``: Diese Prüfung checkt ob die Datei komprimiert ist. Sie basiert auf der ``MimeType`` Prüfung
  und validiert Komprimierungsarchiven wie Zip oder Arc. Sie kann auch auf andere Archive begrenzt werden.

- ``IsImage``: Diese Prüfung checkt ob die Datei ein Bild ist. Sie basiert auf der ``MimeType`` Prüfung und
  validiert Bilddateien wie Jpg oder Gif. Sie kann auch auf andere Bildtypen begrenzt werden.

- ``Hash``: Diese Prüfung check den Hashwert des Inhalts einer Datei. Sie unterstützt mehrere Algorithmen.

- ``Md5``: Diese Prüfung checkt den Md5 Hashwert vom Inhalt einer Datei. Sie basiert auf der *Hash* Prüfung und
  bietet eine bequeme und einfache Prüfung die nur Md5 unterstützt.

- ``MimeType``: Diese Prüfung prüft den *MIME* Typ von Dateien. Sie kann auch Arten von *MIME* Typen prüfen und
  wirft einen Fehler wenn der *MIME* Typ einer spezifizierten Datei nicht passt.

- ``NotExists``: Diese Prüfung checkt ob Dateien existieren. Sie wirft einen Fehler wenn eine angegebene Datei
  existiert.

- ``Sha1``: Diese Prüfung checkt den Sha1 Hashwert vom Inhalt einer Datei. Sie basiert auf der ``Hash`` Prüfung
  und bietet eine bequeme und einfache Prüfung die nur Sha1 unterstützt.

- ``Size``: Diese Prüfung ist fähig Dateien auf Ihre Dateigröße zu prüfen. Sie bietet eine Mindest- und eine
  Maximalgröße an und wirft einen Fehler wenn eine der beiden Grenzen überschritten wird.

- ``Upload``: Diese Prüfung ist eine interne. Sie prüft ob ein Upload zu einem Fehler geführt hat. Dieser darf
  nicht gesetzt werden, da er automatisch durch ``Zend\File\Transfer`` selbst gesetzt wird. Deshalb darf diese
  Prüfung nicht direkt verwendet werden. Man sollte nur wissen das Sie existiert.

- ``WordCount``: Diese Prüfung ist fähig die Anzahl von Wörtern in Dateien zu prüfen. Sie bietet eine Mindest-
  und Maximalanzahl und wirft einen Fehler wenn eine der Grenzen überschritten wird.

.. _zend.file.transfer.validators.usage:

Prüfungen mit Zend\File\Transfer verwenden
------------------------------------------

Prüfungen einzubinden ist sehr einfach. Es gibt verschiedene Methoden für das Hinzufügen und Manipulieren von
Prüfungen:

- ``isValid($files = null)``: Prüft die spezifizierten Dateien indem alle Prüfungen verwendet werden. ``$files``
  kann entweder ein richtiger Dateiname, der Name des Elements, oder der Name der temporären Datei sein.

- ``addValidator($validator, $breakChainOnFailure, $options = null, $files = null)``: Fügt die spezifizierte
  Prüfung zu den Prüfungsstapel hinzu (optional nur zu den Datei(en) die spezifiziert wurden). ``$validator``
  kann entweder eine aktuelle Prüfinstanz sein oder ein Kurzname der den Prüfungstyp spezifiziert (z.B. 'Count').

- ``addValidators(array $validators, $files = null)``: Fügt die spezifizierten Prüfungen zum Prüfungsstapel
  hinzu. Jeder Eintrag kann entweder ein Prüfungstyp/-options Paar sein oder ein Array mit dem Schlüssel
  'validator' das die Prüfung spezifiziert. Alle anderen Optionen werden als Optionen für die Instanzierung der
  Prüfung angenommen.

- ``setValidators(array $validators, $files = null)``: Überschreibt alle bestehenden Prüfungen mit den
  spezifizierten Prüfungen. Die Prüfungen sollten der Syntax folgen die für ``addValidators()`` definiert ist.

- ``hasValidator($name)``: Zeigt ob eine Prüfung registriert wurde.

- ``getValidator($name)``: Gibt eine vorher registrierte Prüfung zurück.

- ``getValidators($files = null)``: Gibt registrierte Prüfungen zurück. Wenn ``$files`` spezifiziert wurde,
  werden die Prüfungen für die betreffende Datei oder das Set an Dateien zurückgegeben.

- ``removeValidator($name)``: Entfernt eine vorher registrierte Prüfung.

- ``clearValidators()``: Löscht alle registrierten Prüfungen.

.. _zend.file.transfer.validators.usage.example:

.. rubric:: Prüfungen zu einem File Transfer Objekt hinzufügen

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Setzt eine Dateigröße von 20000 Bytes
   $upload->addValidator('Size', false, 20000);

   // Setzt eine Dateigröße von mindestens 20 Bytes und maximal 20000 Bytes
   $upload->addValidator('Size', false, array('min' => 20, 'max' => 20000));

   // Setzt eine Dateigröße von mindestens 20 Bytes und Maximal
   // 20000 Bytes und eine Dateianzahl in einem Schritt
   $upload->setValidators(array(
       'Size'  => array('min' => 20, 'max' => 20000),
       'Count' => array('min' => 1, 'max' => 3),
   ));

.. _zend.file.transfer.validators.usage.exampletwo:

.. rubric:: Prüfungen auf eine einzelne Datei limitieren

``addValidator()``, ``addValidators()``, und ``setValidators()`` akzeptieren ein endendes Argument ``$files``.
Dieses Argument kann verwendet werden um eine Datei oder ein Array von Dateien zu spezifizieren auf dem die
angegebene Prüfung gesetzt werden soll.

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Setzt die Dateigröße auf 20000 Bytes und limitiert Sie nur auf 'file2'
   $upload->addValidator('Size', false, 20000, 'file2');

Normal sollte die ``addValidators()`` Methode verwendet werden, welche mehrmals aufgerufen werden kann.

.. _zend.file.transfer.validators.usage.examplemultiple:

.. rubric:: Mehrere Prüfungen hinzufügen

Oft ist es einfacher ``addValidator()`` mehrere Male aufzurufen mit einem Aufruf für jede Prüfung. Das erhöht
auch die Lesbarkeit und macht den Code wartbarer. Alle Methoden implementieren das Fluent-Interface, deshalb
können Aufrufe einfach wie anbei gezeigt gekoppelt werden:

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Setzt die Dateigröße auf 20000 Bytes
   $upload->addValidator('Size', false, 20000)
          ->addValidator('Count', false, 2)
          ->addValidator('Filessize', false, 25000);

.. note::

   Es ist zu beachten, dass das mehrfache Setzen der gleichen Prüfung erlaubt ist, dass das aber zu Problemen
   führen kann wenn verschiedene Optionen für die gleiche Prüfung verwendet werden.

Letztendlich können Dateien einfach geprüft werden indem ``isValid()`` verwendet wird.

.. _zend.file.transfer.validators.usage.exampleisvalid:

.. rubric:: Prüfen der Dateien

``isValid()`` akzeptiert den Dateinamen der hochgeladenen oder heruntergeladenen Datei, den temporären Dateinamen
oder den Namen des Formularelements. Wenn kein Parameter oder null angegeben wird, werden alle gefundenen Dateien
geprüft.

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Setzt die Dateigröße auf 20000 Bytes
   $upload->addValidator('Size', false, 20000)
          ->addValidator('Count', false, 2)
          ->addValidator('Filessize', false, 25000);

   if (!$upload->isValid()) {
       print "Prüfung fehlgeschlagen";
   }

.. note::

   Es ist zu beachten das ``isValid()`` automatisch aufgerufen wird, wenn die Dateien empfangen werden und es zuvor
   noch nicht aufgerufen wurde.

Wenn Prüfungen fehlgeschlagen sind, ist es eine gute Idee Informationen über die gefundenen Probleme zu erhalten.
Um diese Information zu erhalten können die Methoden ``getMessages()``, welche alle Prüfmeldungen als Array
zurückgibt, ``getErrors()`` welche alle Fehlercodes zurückgibt, und ``hasErrors()`` welche ``TRUE`` zurückgibt
sobald ein Prüffehler gefunden wurde, verwendet werden.

.. _zend.file.transfer.validators.count:

Count Prüfung
-------------

Die ``Count`` Prüfung checkt die Anzahl der Dateien die angegeben wurde. Sie unterstützt die folgenden Schlüssel
für Optionen:

- ``min``: Setzt die minimale Anzahl der Dateien die übertragen wird.

  .. note::

     Wenn diese Option verwendet wird, muß die minimale Anzahl an Dateien übergeben werden wenn die Prüfung das
     erste Mal aufgerufen wird; sonst wird ein Fehler zurückgegeben.

  Mit dieser Option kann die Mindestanzahl an Dateien definiert werden die man Empfangen sollte.

- ``max``: Setzt die maximale Anzahl an Dateien die übertragen wird.

  Mit dieser Option kann die Anzahl der Dateien limitiert werden die man akzeptiert, aber genauso eine mögliche
  Attacke erkennen wenn mehr Dateien übertragen werden als im Formular definiert wurden.

Wenn diese Prüfung mit einem String oder Integer initiiert wird, wird Sie als ``max`` verwendet. Es können aber
auch die Methoden ``setMin()`` und ``setMax()`` verwendet werden um beide Optionen im Nachhinein zu setzen und
``getMin()`` und ``getMax()`` um die aktuell gesetzten Werte zu erhalten.

.. _zend.file.transfer.validators.count.example:

.. rubric:: Die Count Prüfung verwenden

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Die Anzahl der Dateien auf maximal 2 limitieren
   $upload->addValidator('Count', false, 2);

   // Die Anzahl der Dateien auf maximal 5 und mindestens 1 Datei limitieren
   $upload->addValidator('Count', false, array('min' =>1, 'max' => 5));

.. note::

   Beachte das diese Prüfung die Anzahl der geprüften Dateien intern speichert. Die Datei welche das Maximum
   überschrietet wird als Fehler zurückgegeben.

.. _zend.file.transfer.validators.crc32:

Crc32 Prüfung
-------------

Die ``Crc32`` Prüfung checkt den Inhalt einer übertragenen Datei durch hashen. Diese Prüfung verwendet die Hash
Erweiterung von *PHP* mit dem Crc32 Algorithmus. Sie unterstützt die folgenden Optionen:

- ``*``: Setzt einen beliebigen Schlüssel oder ein nummerisches Array. Dieser Wert wird als Hash verwendet gegen
  den geprüft wird.

  Man kann mehrere Hashes setzen indem unterschiedliche Schlüssel angegeben werden. Jeder von Ihnen wird geprüft
  und die Prüfung schlägt nur fehl wenn alle Werte fehlschlagen.

.. _zend.file.transfer.validators.crc32.example:

.. rubric:: Verwenden der Crc32 Prüfung

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Prüft ob der Inhalt der hochgeladenen Datei den angegebenen Hash hat
   $upload->addValidator('Hash', false, '3b3652f');

   // Begrenzt diese Prüfung auf zwei unterschiedliche Hashes
   $upload->addValidator('Crc32', false, array('3b3652f', 'e612b69'));

.. _zend.file.transfer.validators.excludeextension:

ExcludeExtension Prüfung
------------------------

Die ``ExcludeExtension`` Prüfung checkt die Dateierweiterung der angegebenen Dateien. Sie unterstützt die
folgenden Optionen:

- ``*``: Setzt einen beliebigen Schlüssel oder ein nummerisches Array. Dieser Wert wird verwendet um zu prüfen ob
  die angegebene Datei diese Dateierweiterung nicht verwendet.

- ``case``: Setzt ein Boolean der anzeigt ob die Prüfung auf die Klein/Großschreibung achten soll.
  Standardmäßig ist die Klein/Großschreibung egal. Beachte das dieser Schlüssel für alle vorhandenen
  Erweiterungen angewendet werden kann.

Dieser Prüfer akzeptiert mehrere Erweiterungen entweder als komma-getrennten String, oder als ein Array. Man kann
auch die ``setExtension()``, ``addExtension()`` und ``getExtension()`` Methoden verwenden um Erweiterungen zu
setzen und zu erhalten.

In einigen Fällen ist es nützlich auch auf Klein/Großschreibung zu testen. Deshalb erlaubt der Constructor einen
zweiten Parameter ``$case`` der, wenn er auf ``TRUE`` gesetzt wird, die Erweiterungen abhängig von der Klein- oder
Großschreibung prüft.

.. _zend.file.transfer.validators.excludeextension.example:

.. rubric:: Die ExcludeExtension Prüfung verwenden

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Dateien mit der Erweiterung php oder exe nicht erlauben
   $upload->addValidator('ExcludeExtension', false, 'php,exe');

   // Dateien mit der Erweiterung php oder exe nicht erlauben
   // aber die Array Schreibweise verwenden
   $upload->addValidator('ExcludeExtension', false, array('php', 'exe'));

   // Prüft abhängig von der Groß-/Kleinschreibung
   $upload->addValidator('ExcludeExtension',
                         false,
                         array('php', 'exe', 'case' => true));

.. note::

   Es ist zu beachten das diese Prüfung nur die Dateierweiterung prüft. Sie prüft nicht den *MIME* Typ der
   Datei.

.. _zend.file.transfer.validators.excludemimetype:

ExcludeMimeType Prüfung
-----------------------

Die ``ExcludeMimeType`` Prüfung checkt den *MIME* Typ von übertragenen Dateien. Sie unterstützt die folgenden
Optionen:

- ``*``: Setzt einen beliebigen Schlüssel oder ein nummerisches Array. Setzt den *MIME* Typ gegen den geprüft
  werden soll.

  Mit dieser Option kann der *MIME* Typ von Dateien definiert werden die nicht akzeptiert werden.

- ``headerCheck``: Wenn diese Option auf ``TRUE`` gesetzt wird, dann werden die *HTTP* Informationen für den
  Dateityp geprüft wenn die **fileInfo** oder **mimeMagic** Erweiterungen nicht gefunden werden können. Der
  Standardwert dieser Option ist ``FALSE``.

Diese Prüfung akzeptiert viele *MIME* Typ entweder als Komma-getrennter String, oder als Array. Man kan auch die
Methoden ``setMimeType()``, ``addMimeType()``, und ``getMimeType()`` verwenden um *MIME* Typen zu setzen und zu
erhalten.

.. _zend.file.transfer.validators.excludemimetype.example:

.. rubric:: Verwendung der ExcludeMimeType Prüfung

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Verweigert den MIME Typ gif für alle gegebenen Dateien
   $upload->addValidator('ExcludeMimeType', 'image/gif');

   // Verweigert den MIME Typ gif und jpeg für alle gegebenen Dateien
   $upload->setValidator('ExcludeMimeType', array('image/gif',
                                                  'image/jpeg');

   // Verweigert die MIME Typ Gruppe image für alle Dateien
   $upload->setValidator('ExcludeMimeType', 'image');

Das obige Beispiel zeigt das es auch möglich ist Gruppen von *MIME* Typen zu verweigern. Um, zum Beispiel, alle
Bilder zu verweigern, muß nur 'image' als *MIME* Typ verwendet werden. Das kann für alle Gruppen von *MIME* Typen
wie 'image', 'audio', 'video', 'test', und so weiter verwendet werden.

.. note::

   Es ist zu beachten das bei Verwendung von *MIME* Typ-Gruppen alle Mitglieder dieser Gruppe verweigert werden,
   selbst wenn das nicht gewünscht ist. Wenn man 'image' verweigert, werden alle Typen von Bildern verweigert wie
   'image/jpeg' oder 'image/vasa'. Wenn man nicht sicher ist ob man alle Typen verweigern will sollte man nur
   definierte *MIME* Typen zu verweigern statt der kompletten Gruppe.

.. _zend.file.transfer.validators.exists:

Exists Prüfung
--------------

Die ``Exists`` Prüfung checkt ob Dateien die spezifiziert werden existieren. Sie unterstützt die folgenden
Optionen:

- ``*``: Setzt einen beliebigen Schlüssel oder ein nummerisches Array um zu prüfen ob die spezifizierte Datei im
  gegebenen Verzeichnis existiert.

Diese Prüfung akzeptiert mehrere Verzeichnisse, entweder als Komma-getrennter String, oder als Array. Es können
aber auch die Methoden ``setDirectory()``, ``addDirectory()``, und ``getDirectory()`` verwendet werden um die
Verzeichnisse zu setzen und zu erhalten.

.. _zend.file.transfer.validators.exists.example:

.. rubric:: Die Exists Prüfung verwenden

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Das temporäre Verzeichnis für die Prüfung hinzufügen
   $upload->addValidator('Exists', false, '\temp');

   // Zwei Verzeichnisse hinzufügen indem die Array Schreibweise verwendet wird
   $upload->addValidator('Exists',
                         false,
                         array('\home\images', '\home\uploads'));

.. note::

   Beachte das diese Prüfung checkt ob die spezifizierte Datei in allen angegebenen Verzeichnissen existiert. Die
   Prüfung schlägt fehl, wenn die Datei in irgendeinem der angegebenen Verzeichnisse nicht existiert.

.. _zend.file.transfer.validators.extension:

Extension Prüfung
-----------------

Die ``Extension`` Prüfung checkt die Dateierweiterung der angegebenen Dateien. Sie unterstützt die folgenden
Optionen:

- ``*``: Setzt einen beliebigen Schlüssel oder ein nummerisches Array um zu prüfen ob die angegebene Datei diese
  Dateierweiterung verwendet.

- ``case``: Definiert of die Prüfung auf die Klein/Großschreibung achten soll. Standardmäßig ist die
  Klein/Großschreibung egal. Es ist zu beachten das dieser Schlüssel für alle verwendeten Erweiterungen
  angegeben wird.

Dieser Prüfer akzeptiert mehrere Erweiterungen entweder als komma-getrennten String, oder als ein Array. Man kann
auch die ``setExtension()``, ``addExtension()`` und ``getExtension()`` Methoden verwenden um Erweiterungs Werte zu
setzen und zu erhalten.

In einigen Fällen ist es nützlich auch auf Klein/Großschreibung zu testen. Hierfür nimmt der Constructor einen
zweiten Parameter ``$case`` der, wenn er auf ``TRUE`` gesetzt wird, die Erweiterungen abhängig von der Klein- oder
Großschreibung prüft.

.. _zend.file.transfer.validators.extension.example:

.. rubric:: Verwendung der Extension Prüfung

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Limitiert die Erweiterungen auf jpg und png Dateien
   $upload->addValidator('Extension', false, 'jpg,png');

   // Limitiert die Erweiterungen auf jpg und png Dateien,
   // verwendet aber die Array Schreibweise
   $upload->addValidator('Extension', false, array('jpg', 'png'));

   // Abhängig von der Klein/Großschreibung prüfen
   $upload->addValidator('Extension', false, array('mo', 'png', 'case' => true));
   if (!$upload->isValid('C:\temp\myfile.MO')) {
       print 'Nicht gültig da MO und mo Kleinschreibungsmäßig nicht passen';
   }

.. note::

   Es ist zu beachten das diese Prüfung nur die Dateierweiterung prüft. Sie prüft nicht den *MIME* Typ der
   Datei.

.. _zend.file.transfer.validators.filessize:

FilesSize Prüfung
-----------------

Die ``FilesSize`` Prüfung checkt die komplette Größe aller übertragenen Dateien. Sie unterstützt die folgenden
Optionen:

- ``min``: Setzt die minimale gemeinsame Dateigröße. Diese Option definiert die mindeste gemeinsame Größe die
  übertragen werden soll.

- ``max``: Setzt die maximale gemeinsame Dateigröße.

  Diese Option begrenzt die gemeinsame Dateigröße aller Dateien die übertragen werden, aber nicht die
  Dateigröße von einzelnen Dateien.

- ``bytestring``: Definiert ob im Fehlerfall eine benutzerfreundliche Nummer, oder die reine Dateigröße
  zurückgegeben wird.

  Diese Option definiert ob der Benutzer '10864' oder '10MB' sieht. Der Standardwert ist ``TRUE`` weshalb '10MB'
  zurückgegeben wird wenn nicht anders angegeben.

Diese Prüfung kann auch mit einem String initiiert werden, der dann verwendet wird um die ``max`` Option zu
setzen. Man kann auch die Methoden ``setMin()`` und ``setMax()`` verwenden um beide Optionen nach den Contrucor zu
setzen, zusammen mit ``getMin()`` und ``getMax()`` um die Werte zu erhalten die vorher gesetzt wurden.

Die Größe selbst wird auch in der SI Schreibweise akzeptiert wie Sie die meisten Betriebsystemen verwenden. Statt
**20000 bytes** kann auch **20kB** angeben werden. Alle Einheiten werden mit dem Basiswert 1024 konvertiert. Die
folgenden Einheiten werden akzeptiert: **kB**, **MB**, **GB**, **TB**, **PB** und **EB**. Beachte das 1kB gleich
1024 Bytes ist, 1MB gleich 1024kB, und so weiter.

.. _zend.file.transfer.validators.filessize.example:

.. rubric:: Verwenden der FilesSize Prüfung

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Limitiert die Größe aller Dateien die hochgeladen werden auf 40000 Bytes
   $upload->addValidator('FilesSize', false, 40000);

   // Limitiert die Größe aller Dateien die hochgeladen
   // werden auf maximal 4MB und minimal 10kB
   $upload->addValidator('FilesSize',
                         false,
                         array('min' => '10kB', 'max' => '4MB'));

   // Wie zuvor, gibt aber die reine Dateigröße
   // statt einem benutzerfreundlichen String zurück
   $upload->addValidator('FilesSize',
                         false,
                         array('min' => '10kB',
                               'max' => '4MB',
                               'bytestring' => false));

.. note::

   Beachte das diese Prüfung intern die Dateigrößen der geprüften Dateien intern speichert. Die Datei welche
   die Größe überschreitet wird als Fehler zurückgegeben.

.. _zend.file.transfer.validators.imagesize:

ImageSize Prüfung
-----------------

Die ``ImageSize`` Prüfung checkt die Größe von Bildern. Sie unterstützt die folgenden Optionen:

- ``minheight``: Setzt die mindeste Höhe des Bildes.

- ``maxheight``: Settzt die maximale Höhe des Bildes.

- ``minwidth``: Setzt die mindeste Breite des Bildes.

- ``maxwidth``: Setzt die maximale Breite des Bildes.

Die Methoden ``setImageMin()`` und ``setImageMax()`` setzen auch beide Minimal- und Maximalwerte im Nachhinein,
wärend die ``getMin()`` und ``getMax()`` Methoden die aktuell gesetzten Werte zurückgeben.

Der Bequemlichkeit halber gibt es auch eine ``setImageWidth()`` und ``setImageHeight()`` Methode welche die
Mindest- und Maximalhöhe und -Breite der Bilddatei setzen. Sie haben auch passende ``getImageWidth()`` und
``getImageHeight()`` Methoden um die aktuell gesetzten Werte zu erhalten.

Um die Prüfung einer betreffenden Dimension zu gestatten, muß die relevante Option einfach nicht gesetzt werden.

.. _zend.file.transfer.validators.imagesize.example:

.. rubric:: Verwendung der ImageSize Prüfung

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Begrenzt die Größe eines Bildes auf eine Höhe von 100-200
   // und eine Breite von 40-80 Pixel
   $upload->addValidator('ImageSize', false,
                         array('minwidth' => 40,
                               'maxwidth' => 80,
                               'minheight' => 100,
                               'maxheight' => 200
                        );

   // Setzt die Breite der Prüfung zurück
   $upload->setImageWidth(array('minwidth' => 20, 'maxwidth' => 200));

.. _zend.file.transfer.validators.iscompressed:

IsCompressed Prüfung
--------------------

Die ``IsCompressed`` Prüfung checkt ob eine übertragene Datei komprimiert ist wie zum Beispiel Zip oder Arc.
Diese Prüfung basiert auf der ``MimeType`` Prüfung und unterstützt die gleichen Methoden und Optionen. Diese
Prüfung kann mit den dort beschriebenen Methoden auf gewünschte Komprimierungstypen limitiert werden.

.. _zend.file.transfer.validators.iscompressed.example:

.. rubric:: Verwenden der IsCompressed Prüfung

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Checkt ob die hochgeladene Datei komprimiert ist
   $upload->addValidator('IsCompressed', false);

   // Limitiert diese Prüfung auf Zip Dateien
   $upload->addValidator('IsCompressed', false, array('application/zip'));

   // Limitiert diese Prüfung auf Zip Dateien,
   // und verwendet eine einfachere Schreibweise
   $upload->addValidator('IsCompressed', false, 'zip');

.. note::

   Es ist zu beachten das nicht geprüft wird ob ein gesetzter *MIME* Typ ein Komprimierungstyp ist oder nicht. Man
   könnte zum Beispiel definieren das Gif Dateien von dieser Prüfung akzeptiert werden. Die Verwendung der
   'MimeType' Prüfung für Dateien welche nicht archiviert sind, führt zu besser lesbarem Code.

.. _zend.file.transfer.validators.isimage:

IsImage Prüfung
---------------

Die ``IsImage`` Prüfung checkt ob eine übertragene Datei eine Bilddatei ist, wie zum Beispiel Gif oder Jpeg.
Diese Prüfung basiert auf der ``MimeType`` Prüfung und unterstützt die gleichen Methoden und Optionen. Diese
Prüfung kann mit den dort beschriebenen Methoden auf gewünschte Bildarten limitiert werden.

.. _zend.file.transfer.validators.isimage.example:

.. rubric:: Verwenden der IsImage Prüfung

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Checkt ob die hochgeladene Datei ein Bild ist
   $upload->addValidator('IsImage', false);

   // Limitiert diese Prüfung auf Gif Dateien
   $upload->addValidator('IsImage', false, array('application/gif'));

   // Limitiert diese Prüfung auf Jpeg Dateien,
   // verwendet eine einfachere Schreibweise
   $upload->addValidator('IsImage', false, 'jpeg');

.. note::

   Es ist zu beachten das nicht geprüft wird ob ein gesetzter *MIME* Typ kein Bild ist. Es ist zum Beispiel
   möglich, Zip Dateien von dieser Prüfung akzeptieren zu lassen. Die Verwendung der 'MimeType' Prüfung für
   Dateien welche keine Bilder sind, führt zu besser lesbarem Code.

.. _zend.file.transfer.validators.hash:

Hash Prüfung
------------

Die ``Hash`` Prüfung checkt den Inhalt einer übertragenen Datei indem Sie gehasht wird. Diese Prüfung verwendet
die Hash Erweiterung von *PHP*. Sie unterstützt die folgenden Optionen:

- ``*``: Nimmt einen beliebigen Schlüssel oder ein nummerisches Array. Setzt den Hash gegen den geprüft werden
  soll.

  Man kann mehrere Hashes setzen indem Sie als Array angegeben werden. Jede Datei wird geprüft, und die Prüfung
  wird nur fehlschlagen wenn alle Dateien die Prüfung nicht bestehen.

- ``algorithm``: Setzt den Algorithmus der für das Hashen des Inhalts verwendet wird.

  Man kann mehrere Algorithmen setzen indem die ``addHash()`` Methode mehrere Male aufgerufen wird.

.. _zend.file.transfer.validators.hash.example:

.. rubric:: Verwenden der Hash Prüfung

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Prüft ob der Inhalt der hochgeladenen Datei den angegebenen Hash enthält
   $upload->addValidator('Hash', false, '3b3652f');

   // Begrenzt diese Prüfung auf zwei unterschiedliche Hashes
   $upload->addValidator('Hash', false, array('3b3652f', 'e612b69'));

   // Setzt einen anderen Algorithmus gegen den geprüft wird
   $upload->addValidator('Hash',
                         false,
                         array('315b3cd8273d44912a7',
                               'algorithm' => 'md5'));

.. note::

   Diese Prüfung unterstützt über 34 verschiedene Hash Algorithmen. Die bekanntesten sind 'crc32', 'md5' und
   'sha1'. Eine gesammelte Liste aller unterstützten Hash Algorithmen kann in PHP's `hash_algos Methode`_ auf der
   `php.net Seite`_ gefunden werden.

.. _zend.file.transfer.validators.md5:

Md5 Prüfung
-----------

Die ``Md5`` Prüfung checkt den Inhalt einer übertragenen Datei durch hashen. Diese Prüfung verwendet die Hash
Erweiterung von *PHP* mit dem Md5 Algorithmus. Sie unterstützt die folgenden Optionen:

- ``*``: nimmt einen beliebigen Schlüssel oder ein nummerisches Array.

  Man kann mehrere Hashes setzen indem Sie als Array übergeben werden. Jede Datei wird geprüft und die Prüfung
  schlägt nur dann fehl wenn die Prüfung alle Dateien fehlschlägt.

.. _zend.file.transfer.validators.md5.example:

.. rubric:: Verwenden der Md5 Prüfung

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Prüft ob der Inhalt der hochgeladenen Datei den angegebenen Hash hat
   $upload->addValidator('Md5', false, '3b3652f336522365223');

   // Begrenzt diese Prüfung auf zwei unterschiedliche Hashes
   $upload->addValidator('Md5',
                         false,
                         array('3b3652f336522365223',
                               'eb3365f3365ddc65365'));

.. _zend.file.transfer.validators.mimetype:

MimeType Prüfung
----------------

Die ``MimeType`` Prüfung checkt den *MIME* Typ von übertragenen Dateien. Sie unterstützt die folgenden Optionen:

- ``*``: Setzt einen beliebigen Schlüssel oder ein nummerisches Array. Setzt die Art des *MIME* Typs der geprüft
  werden soll.

  Definiert den *MIME* Typ von Dateien die akzeptiert werden soll.

- ``headerCheck``: Wenn diese Option auf ``TRUE`` gesetzt wird, dann werden die *HTTP* Informationen für den
  Dateityp geprüft wenn die **fileInfo** oder **mimeMagic** Erweiterungen nicht gefunden werden können. Der
  Standardwert dieser Option ist ``FALSE``.

- ``magicfile``: Das Magicfile das verwendet werden soll.

  Mit dieser Option kann definiert werden welches Magicfile zu verwenden ist. Wenn es nicht gesetzt wird, oder leer
  ist, wird stattdessen die MAGIC Konstante verwendet. Diese Option ist seit dem Zend Framework 1.7.1 vorhanden.

Diese Prüfung akzeptiert viele *MIME* Typen entweder als Komma-getrennter String, oder als Array. Man kan auch die
Methoden ``setMimeType()``, ``addMimeType()``, und ``getMimeType()`` verwenden um *MIME* Typen zu setzen und zu
erhalten.

Man kann mit der 'magicfile' Option auch die Magicdatei setzen die von Fileinfo verwendet werden soll. Zusätzlich
gibt es die komfortablen ``setMagicFile()`` und ``getMagicFile()`` Methoden die das spätere Setzen und Empfangen
des Magicfile Parameters erlauben. Diese Methoden sind seit dem Zend Framework 1.7.1 vorhanden.

.. _zend.file.transfer.validators.mimetype.example:

.. rubric:: Verwendung der MimeType Prüfung

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Begrenzt den MIME Typ aller gegebenen Dateien auf Gif Bilder
   $upload->addValidator('MimeType', 'image/gif');

   // Begrenzt den MIME Typ alle gegebenen Dateien auf Gif und Jpeg Dateien
   $upload->addValidator('MimeType', array('image/gif', 'image/jpeg');

   // Begrenzt den MIME Typ aller Dateien auf die Gruppe image
   $upload->addValidator('MimeType', 'image');

   // Ein anderes magicfile verwenden
   $upload->addValidator('MimeType',
                         false,
                         array('image',
                               'magicfile' => '/path/to/magicfile.mgx'));

Das obige Beispiel zeigt das es auch möglich ist den akzeptierten *MIME* Typ auf eine Gruppe von *MIME* Typen zu
begrenzen. Um alle Bilder zu erlauben kann einfach 'image' als *MIME* Typ verwendet werden. Das kann für alle
Gruppen von *MIME* Typen wie 'image', 'audio', 'video', 'test', und so weiter gemacht werden.

.. note::

   Es ist zu beachten das die Verwendung von *MIME* Typ-Gruppen alle Mitglieder dieser Gruppe akzeptiert, selbst
   wenn die Anwendung diese nicht unterstützt. Wenn man 'image' erlaubt, erhält man auch 'image/xpixmap' oder
   'image/vasa' was problematisch sein könnte. Wenn man nicht sicher ist ob die eigene Anwendung alle Typen
   unterstützt ist es besser nur definierte *MIME* Typen zu erlauben statt der kompletten Gruppe.

.. note::

   Diese Komponente verwendet die ``FileInfo`` Erweiterung wenn Sie vorhanden ist. Wenn nicht wird Sie die
   ``mime_content_type()`` Funktion verwenden. Und wenn dieser Funktionsaufruf fehlschlägt wird der *MIME* Typ
   verwendet der von *HTTP* angegeben wurde.

   Man sollte sich vor möglichen Sicherheitsproblemen vorsehen wenn weder ``FileInfo`` noch
   ``mime_content_type()`` vorhanden sind. Der von *HTTP* angegebene *MIME* Typ ist nicht sicher und kann einfach
   manipuliert werden.

.. _zend.file.transfer.validators.notexists:

NotExists Prüfung
-----------------

Die ``NotExists`` Prüfung checkt ob Dateien die angegeben werden existieren. Sie unterstützt die folgenden
Optionen:

- ``*``: Setzt einen beliebigen Schlüssel oder ein nummerisches Array. Checkt ob die Datei im gegebenen
  Verzeichnis existiert.

Diese Prüfung akzeptiert mehrere Verzeichnisse, entweder als Komma-getrennter String, oder als Array. Es können
aber auch die Methoden ``setDirectory()``, ``addDirectory()``, und ``getDirectory()`` verwendet werden um die
Verzeichnisse zu setzen und zu erhalten.

.. _zend.file.transfer.validators.notexists.example:

.. rubric:: Verwendung der NotExists Prüfung

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Das temporäre Verzeichnis für die Prüfung hinzufügen
   $upload->addValidator('NotExists', '\temp');

   // Zwei Verzeichnisse durch Verwendung der Array Schreibweise hinzufügen
   $upload->addValidator('NotExists',
                         array('\home\images',
                               '\home\uploads')
                        );

.. note::

   Beachte das diese Prüfung checkt ob die Datei in allen angegebenen Verzeichnissen nicht existiert. Die Prüfung
   schlägt fehl, wenn die Datei in irgendeinem der angegebenen Verzeichnisse existiert.

.. _zend.file.transfer.validators.sha1:

Sha1 Prüfung
------------

Die ``Sha1`` Prüfung checkt den Inhalt einer übertragenen Datei durch hashen. Diese Prüfung verwendet die Hash
Erweiterung von *PHP* mit dem Sha1 Algorithmus. Sie unterstützt die folgenden Optionen:

- ``*``: Nimmt einen beliebigen Schlüssel oder ein nummerisches Array.

  Man kann mehrere Hashes setzen indem Sie als Array übergeben werden. Jeder Datei wird geprüft und die Prüfung
  schlägt nur dann fehl wenn alle Dateien fehlschlagen.

.. _zend.file.transfer.validators.sha1.example:

.. rubric:: Verwenden der Sha1 Prüfung

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Prüft ob der Inhalt der hochgeladenen Datei den angegebenen Hash hat
   $upload->addValidator('Sha1', false, '3b3652f336522365223');

   // Begrenzt diese Prüfung auf zwei unterschiedliche Hashes
   $upload->addValidator('Sha1',
                         false, array('3b3652f336522365223',
                                      'eb3365f3365ddc65365'));

.. _zend.file.transfer.validators.size:

Size Prüfung
------------

Die ``Size`` Prüfung checkt die Größe von einzelnen Dateien. Sie unterstützt die folgenden Optionen:

- ``min``: Setzt die minimale Dateigröße.

- ``max``: Setzt die maximale Dateigröße.

- ``bytestring``: Definiert ob ein Fehler mit einer benutzerfreundlichen Nummer zurückgegeben wird, oder mit der
  reinen Dateigröße.

  Mit dieser Option kann definiert werden ob der Benutzer '10864' oder '10MB' erhält. Der Standardwert ist
  ``TRUE`` was '10MB' zurückgibt.

Man kann diese Prüfung auch nur mit einem String initialisieren, der dann verwendet wird um die ``max`` Option zu
setzen. Man kann auch die Methoden ``setMin()`` und ``setMax()`` verwenden um beide Optionen nach der
Instanziierung setzen, zusammen mit ``getMin()`` und ``getMax()`` um die Werte zu setzen die vorher gesetzt wurden.

Die Größe selbst wird auch in der SI Schreibweise akzeptiert wie Sie von den meisten Betriebsystemen verwendet
wird. Statt **20000 bytes** kann man auch **20kB** angeben. Alle Einheiten werden konvertiert wobei 1024 als
Basiswert verwendet wird. Die folgenden Einheiten werden akzeptiert: **kB**, **MB**, **GB**, **TB**, **PB** und
**EB**. Beachte das 1kB identisch mit 1024 Bytes ist, 1MB identisch mit 1024kB ist, und so weiter.

.. _zend.file.transfer.validators.size.example:

.. rubric:: Verwendung der Size Prüfung

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Limitiert die Größe einer Datei auf 40000 Bytes
   $upload->addValidator('Size', false, 40000);

   // Limitiert die Größe der angegebenen Datei auf maximal 4MB und  minimal 10kB
   // Gibt auch im Fall eines Fehlers die reine Zahl statt einer
   // Benutzerfreundlichen zurück
   $upload->addValidator('Size',
                         false,
                         array('min' => '10kB',
                               'max' => '4MB',
                               'bytestring' => false));

.. _zend.file.transfer.validators.wordcount:

WordCount Prüfung
-----------------

Die ``WordCount`` Prüfung checkt die Anzahl von Wörtern in angegebenen Dateien. Sie Unterstützt die folgenden
Optionen:

- ``min``: Setzt die mindeste Anzahl an Wörtern die gefunden werden soll.

- ``max``: Setzt die maximale Anzahl an Wörtern die gefunden werden soll.

Wenn man diese Prüfung mit einem String oder Integer initiiert, wird der Wert als ``max`` verwendet. Oder man
verwendet die ``setMin()`` und ``setMax()`` Methoden um beide Optionen im Nachhinein zu Setzen und ``getMin()``
sowie ``getMax()`` um die aktuell gesetzten Werte zu erhalten.

.. _zend.file.transfer.validators.wordcount.example:

.. rubric:: Verwendung der WordCount Prüfung

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Begrenzt die Anzahl der Wörter in Dateien auf maximal 2000
   $upload->addValidator('WordCount', false, 2000);

   // Begrenzt die Anzahl der Wörter in Dateien auf maximal 5000
   // und mindestens 1000 Wörter
   $upload->addValidator('WordCount', false, array('min' => 1000, 'max' => 5000));



.. _`hash_algos Methode`: http://php.net/hash_algos
.. _`php.net Seite`: http://php.net
