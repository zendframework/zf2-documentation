.. EN-Revision: none
.. _zend.filter.set.compress:

Compress und Decompress
=======================

Diese zwei Filter sind in der Lage Strings, Dateien und Verzeichnisse zu komprimieren und zu dekomprimieren. Sie
verwenden Adapter und unterstützen die folgenden Kompressions Formate:

- **Bz2**

- **Gz**

- **Lzf**

- **Rar**

- **Tar**

- **Zip**

Jedes Kompressions Format hat unterschiedliche Fähigkeiten die anbei beschrieben sind. Alle Kompressions Filter
können fast der selben Art und Weise verwendet werden, und unterscheiden sich primär in den vorhandenen Optionen
und der Art der Kompression welche diese anbieten (beide bieten Algorithmen für Strings vs. Dateien vs.
Verzeichnisse an)

.. _zend.filter.set.compress.generic:

Generelle Handhabung
--------------------

Um einen Kompressions Filter zu erstellen muss man das Kompressions Format auswählen welches man verwenden will.
Die folgende Beschreibung nimmt den **Bz2** Adapter. Details für alle anderen Adapter werden nach dieser Sektion
beschrieben.

Diese zwei Filter sind grundsätzlich identisch, da Sie das gleiche Backend verwenden. ``Zend\Filter\Compress``
sollte verwendet werden wenn man Elemente komprimieren will, und ``Zend\Filter\Decompress`` sollte verwendet werden
wenn man Elemente dekomprimieren will.

Wenn man zum Beispiel einen String komprimieren will, müssen wir ``Zend\Filter\Compress`` instanziieren und den
gewünschten Adapter angeben.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Compress('Bz2');

Um einen anderen Adapter zu verwenden muss dieser einfach im Constructor spezifiziert werden.

Man kann auch ein Array von Optionen oder ein ``Zend_Config`` Objekt anbieten. Wenn man das tut sollte mindestens
der Schlüssel "adapter" angegeben werden, und anschließend entweder der Schlüssel "options" oder
"adapterOptions" (welches ein Array von Optionen ein sollte das dem Adapter bei der Instanziierung übergeben
wird).

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Compress(array(
       'adapter' => 'Bz2',
       'options' => array(
           'blocksize' => 8,
       ),
   ));

.. note::

   **Standardmäßiger Kompressions Adapter**

   Wenn kein Kompressions Adapter angegeben wird, dann wird der **Gz** Adapter verwendet.

Fast die gleiche Verwendung ist die Dekomprimierung eines Strings. Wir müssen in diesem Fall nur den
Dekompressions Filter verwenden.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Decompress('Bz2');

Um einen komprimierten String zu erhalten muss der originale String angegeben werden. Der gefilterte Wert ist die
komprimierte Version des originalen Strings.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Compress('Bz2');
   $compressed = $filter->filter('Uncompressed string');
   // Gibt den komprimierten String zurück

Dekomprimierung funktioniert auf die gleiche Weise.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Decompress('Bz2');
   $compressed = $filter->filter('Compressed string');
   // Gibt den dekomprimierten String zurück

.. note::

   **Hinweis zur Komprimierung von Strings**

   Nicht alle Adapter unterstützen die Kompression von Strings. Kompressions Formate wie **Rar** können nur
   Dateien und Verzeichnisse verarbeiten. Für Details muss man in die Sektion für den Adapter gesehen werden den
   man verwenden will.

.. _zend.filter.set.compress.archive:

Ein Archiv erstellen
--------------------

Die Erstellung einer Archivedatei arbeitet fast auf die gleiche Weise wie die Komprimierung eines Strings. Trotzdem
benötigen wir in diesem Fall einen zusätzlichen Parameter welcher den Namen des Archivs enthält welches wir
erstellen wollen.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Compress(array(
       'adapter' => 'Bz2',
       'options' => array(
           'archive' => 'filename.bz2',
       ),
   ));
   $compressed = $filter->filter('Uncompressed string');
   // Gibt bei Erfolg true zurück und erstellt die Archiv Datei

Im obigen Beispeil wird der unkomprimierte String komprimiert, und wird dann in die angegebene Archiv Datei
geschrieben.

.. note::

   **Existierende Archive werden überschrieben**

   Der Inhalt einer existierenden Datei wird überschrieben wenn der angegebene Dateiname des Archivs bereits
   existiert.

Wenn man eine Datei komprimieren will, dann muss man den Namen der Datei mit dessen Pfad angeben.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Compress(array(
       'adapter' => 'Bz2',
       'options' => array(
           'archive' => 'filename.bz2'
       ),
   ));
   $compressed = $filter->filter('C:\temp\compressme.txt');
   // Gibt bei Erfolg true zurück und erstellt die Archiv Datei

Man kann auch ein Verzeichnis statt einem Dateinamen spezifizieren. In diesem Fall wird das gesamte Verzeichnis mit
allen seinen Dateien und Unterverzeichnissen in das Archiv komprimiert.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Compress(array(
       'adapter' => 'Bz2',
       'options' => array(
           'archive' => 'filename.bz2'
       ),
   ));
   $compressed = $filter->filter('C:\temp\somedir');
   // Gibt bei Erfolg true zurück und erstellt die Archiv Datei

.. note::

   **Keine großen oder Basisverzeichnisse komprimieren**

   Man sollte niemals große oder Basisverzeichnisse wie eine komplette Partition komprimieren. Die Komprimierung
   einer kompletten Partition ist ein sehr Zeitintensiver Task welcher zu massiven Problemen auf dem Server führen
   kann, wenn es nicht genug Platz gibt, oder das eigene Skript zu viel Zeit benötigt.

.. _zend.filter.set.compress.decompress:

Ein Archiv dekomprimieren
-------------------------

Die Dekomprimierung einer Archivdatei arbeitet fast wie dessen Komprimierung. Man muss entweder die Eigenschaft
``archive`` spezifizieren, oder den Dateinamen des Archivs angeben wenn man die Datei dekomprimiert.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Decompress('Bz2');
   $compressed = $filter->filter('filename.bz2');
   // Gibt bei Erfolg true zurück und dekomprimiert die Archiv Datei

Einige Adapter unterstützen die Dekomprimierung des Archivs in ein anderes Unterverzeichnis. In diesem Fall kann
der Parameter ``target`` spezifiziert werden.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Decompress(array(
       'adapter' => 'Zip',
       'options' => array(
           'target' => 'C:\temp',
       )
   ));
   $compressed = $filter->filter('filename.zip');
   // Gibt bei Erfolg true zurück und dekomprimiert die Archiv Datei
   // in das angegebene Zielverzeichnis

.. note::

   **Verzeichnisse in welche extrahiert werden soll müssen existieren**

   Wenn man ein Archiv in ein Verzeichnis dekomprimieren will, dann muss dieses Verzeichnis existieren.

.. _zend.filter.set.compress.bz2:

Bz2 Adapter
-----------

Der Bz2 Adapter kann folgendes komprimieren und dekomprimieren:

- Strings

- Dateien

- Verzeichnisse

Dieser Adapter verwendet *PHP*'s Bz2 Erweiterung.

Um die Komprimierung anzupassen unterstützt dieser Adapter die folgenden Optionen:

- **Archive**: Dieser Parameter setzt die Archivdatei welche verwendet oder erstellt werden soll.

- **Blocksize**: Dieser Parameter setzt die Blockgröße welche zu verwenden ist. Diese kann zwischen '0' und '9'
  liegen. Der Standardwert ist '4'.

Alle Optionen können bei der Instanziierung oder durch Verwendung der betreffenden Methode verwendet werden. Zum
Beispiel sind die zu 'Blocksize' gehörenden Methoden ``getBlocksize()`` und ``setBlocksize()``. Man kann auch die
``setOptions()`` Methode verwenden welche alle Optionen als Array akzeptiert.

.. _zend.filter.set.compress.gz:

Gz Adapter
----------

Der Gz Adapter kann folgendes komprimieren und dekomprimieren:

- Strings

- Dateien

- Verzeichnisse

Dieser Adapter verwendet *PHP*'s Zlib Erweiterung.

Um die Komprimierung anzupassen unterstützt dieser Adapter die folgenden Optionen:

- **Archive**: Dieser Parameter setzt die Archivdatei welche verwendet oder erstellt werden soll.

- **Level**: Das Level der Kompression welches verwendet werden soll. Es kann zwischen '0' und '9' liegen. Der
  Standardwert ist '9'.

- **Mode**: Es gibt zwei unterstützte Modi. 'compress' und 'deflate'. Der Standardwert ist 'compress'.

Alle Optionen können bei der Instanziierung oder durch Verwendung der betreffenden Methode verwendet werden. Zum
Beispiel sind die zu 'Level' gehörenden Methoden ``getLevel()`` und ``setLevel()``. Man kann auch die
``setOptions()`` Methode verwenden welche alle Optionen als Array akzeptiert.

.. _zend.filter.set.compress.lzf:

Lzf Adapter
-----------

Der Lzf Adapter kann folgendes komprimieren und dekomprimieren:

- Strings

.. note::

   **Lzf unterstützt nur Strings**

   Der Lzf Adapter kann keine Dateien oder Verzeichnisse verarbeiten.

Dieser Adapter verwendet *PHP*'s Lzf Erweiterung.

Es sind keine Optionen vorhanden um diesen Adapter anzupassen.

.. _zend.filter.set.compress.rar:

Rar Adapter
-----------

Der Rar Adapter kann folgendes komprimieren und dekomprimieren:

- Dateien

- Verzeichnisse

.. note::

   **Rar unterstützt keine Strings**

   Der Rar Adapter kann keine Strings verarbeiten.

Dieser Adapter verwendet *PHP*'s Rar Erweiterung.

.. note::

   **Die Kompression wird von Rar nicht unterstützt**

   Durch Beschränkungen des Kompressions Formats von Rar, gibt es keine frei erhältliche Komprimierung. Wenn man
   Dateien in ein neues Rar Archiv komprimieren will, muss man dem Adapter einen Callback anbieten mit dem ein Rar
   Kompressions Programm aufgerufen wird.

Um die Komprimierung anzupassen unterstützt dieser Adapter die folgenden Optionen:

- **Archive**: Dieser Parameter setzt die Archivdatei welche verwendet oder erstellt werden soll.

- **Callback**: Ein Callback welcher diesem Adapter Unterstützung für Komprimierung anbietet.

- **Password**: Das Passwort welches für die Dekomprimierung verwendet werden soll.

- **Target**: Das Ziel zu dem dekomprimierte Dateien geschrieben werden.

Alle Optionen können bei der Instanziierung oder durch Verwendung der betreffenden Methode verwendet werden. Zum
Beispiel sind die zu 'Target' gehörenden Methoden ``getTarget()`` und ``setTarget()``. Man kann auch die
``setOptions()`` Methode verwenden welche alle Optionen als Array akzeptiert.

.. _zend.filter.set.compress.tar:

Tar Adapter
-----------

Der Rar Adapter kann folgendes komprimieren und dekomprimieren:

- Dateien

- Verzeichnisse

.. note::

   **Tar unterstützt keine Strings**

   Der Tar Adapter kann keine Strings verarbeiten.

Dieser Adapter verwendet *PEAR*'s ``Archive_Tar`` Komponente.

Um die Komprimierung anzupassen unterstützt dieser Adapter die folgenden Optionen:

- **Archive**: Dieser Parameter setzt die Archivdatei welche verwendet oder erstellt werden soll.

- **Mode**: Ein Modus der für die Komprimierung verwendet werden soll. Unterstützt werden entweder '``NULL``',
  was keine Komprimierung bedeutet, 'Gz' was *PHP*'s Zlib Erweiterung verwendet, und 'Bz2' was *PHP*'s Bz2
  Erweiterung verwendet. Der Standardwert ist '``NULL``'.

- **Target**: Das Ziel zu dem dekomprimierte Dateien geschrieben werden.

Alle Optionen können bei der Instanziierung oder durch Verwendung der betreffenden Methode verwendet werden. Zum
Beispiel sind die zu 'Target' gehörenden Methoden ``getTarget()`` und ``setTarget()``. Man kann auch die
``setOptions()`` Methode verwenden welche alle Optionen als Array akzeptiert.

.. note::

   **Verwendung von Verzeichnissen**

   Wenn Verzeichnisse mit Tar komprimiert werden, dann wird der komplette Dateipfad verwendet. Das bedeutet das
   erstellte Tar Dateien nicht nur das Unterverzeichnis sondern den kompletten Pfad für die komprimierten Dateien
   enthält.

.. _zend.filter.set.compress.zip:

Zip Adapter
-----------

Der Rar Adapter kann folgendes komprimieren und dekomprimieren:

- Strings

- Dateien

- Verzeichnisse

.. note::

   **Zip unterstützt die Dekomprimierung von Strings nicht**

   Der Zip Adapter kann die Dekomprimierung von Strings nicht verarbeiten; eine Dekomprimierung wird immer in eine
   Datei geschrieben.

Dieser Adapter verwendet *PHP*'s ``Zip`` Erweiterung.

Um die Komprimierung anzupassen unterstützt dieser Adapter die folgenden Optionen:

- **Archive**: Dieser Parameter setzt die Archivdatei welche verwendet oder erstellt werden soll.

- **Target**: Das Ziel zu dem dekomprimierte Dateien geschrieben werden.

Alle Optionen können bei der Instanziierung oder durch Verwendung der betreffenden Methode verwendet werden. Zum
Beispiel sind die zu 'Target' gehörenden Methoden ``getTarget()`` und ``setTarget()``. Man kann auch die
``setOptions()`` Methode verwenden welche alle Optionen als Array akzeptiert.


