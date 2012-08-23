.. EN-Revision: none
.. _zend.view.helpers.initial.headmeta:

HeadMeta Helfer
===============

Das *HTML* Element **<meta>** wird verwendet um Meta Informationen über das *HTML* Dokument anzubieten --
typischerweise Schlüsselwörter. Dokument Zeichensätze, Cache Pragmas, usw. Meta Tags können entweder
'http-equiv' oder 'name' Typen sein, müssen ein 'content' Attribut enthalten, und können auch eines der 'lang'
oder 'scheme' Modifikator Attributen enthalten.

Der ``HeadMeta`` Helfer unterstützt die folgenden Methoden für das Setzen und Hinzufügen von Meta Tags:

- ``appendName($keyValue, $content, $conditionalName)``

- ``offsetSetName($index, $keyValue, $content, $conditionalName)``

- ``prependName($keyValue, $content, $conditionalName)``

- ``setName($keyValue, $content, $modifiers)``

- ``appendHttpEquiv($keyValue, $content, $conditionalHttpEquiv)``

- ``offsetSetHttpEquiv($index, $keyValue, $content, $conditionalHttpEquiv)``

- ``prependHttpEquiv($keyValue, $content, $conditionalHttpEquiv)``

- ``setHttpEquiv($keyValue, $content, $modifiers)``

- ``setCharset($charset)``

Das ``$keyValue`` Element wird verwendet um einen Wert für den 'name' oder 'http-equiv' Schlüssel zu definieren;
``$content`` ist der Wert für den 'content' Schlüssel, und ``$modifiers`` ist ein optionales assoziatives Array
das Schlüssel für 'land und/oder 'scheme' enthalten kann.

Meta Tags können auch gesetzt werden indem die ``headMeta()`` Helfermethode verwendet wird, welche die folgende
Signatur hat: ``headMeta($content, $keyValue, $keyType = 'name', $modifiers = array(), $placement = 'APPEND')``.
``$keyValue`` ist der Intalt für den Schlüssel der in ``$keyType`` spezifiziert ist, und welche entweder 'name'
oder 'http-equiv' sein sollte. ``$placement`` kann entweder 'SET' (überschreibt alle vorher gespeicherten Werte),
'APPEND' (fügt an das Ende des Stacks hinzu), oder 'PREPEND' (fügt an den Beginn des Stacks hinzu) sein.

``HeadMeta`` überschreibt ``append()``, ``offsetSet()``, ``prepend()``, und ``set()`` um die Verwendung der
speziellen Methoden wie oben gelistet zu erzwingen. Intern wird jedes Element als ``stdClass`` Token gespeichert,
welches später durch Verwendung der ``itemToString()`` Methode serialisiert wird. Das erlaubt es Prüfungen an den
Elementen im Stack durchzuführen, und diese Elemente optional zu verändern indem einfach das zurückgegebene
Objekt verändert wird.

Der ``HeadMeta`` Helfer ist eine konkrete Implementation des :ref:`Platzhalter Helfers
<zend.view.helpers.initial.placeholder>`.

.. _zend.view.helpers.initial.headmeta.basicusage:

.. rubric:: Grundsätzliche Verwendung des HeadMeta Helfers

Neue Meta Tags können jederzeit spezifiziert werden. Typischerweise werden Clientseitige Cacheregeln oder SEO
Schlüsselwörter spezifiziert.

Wenn zum Beispiel ein spezielles SEO Schlüsselwort spezifiziert werden soll, kann das durch die Erstellung eines
Meta Nametags, mit dem Namen 'keywords' und dem Inhalt des Schlüsselworts das mit der Seite assoziiert werden
soll, geschehen:

.. code-block:: php
   :linenos:

   // Meta Schlüsselwörter setzen
   $this->headMeta()->appendName('keywords', 'framework, PHP, productivity');

Wenn Clientseitige Cacheregeln gesetzt werden sollen, können http-equiv Tags mit den Regeln die erzwungen werden
sollen, gesetzt werden:

.. code-block:: php
   :linenos:

   // Clientseitiges cachen verhindern
   $this->headMeta()->appendHttpEquiv('expires',
                                      'Wed, 26 Feb 1997 08:21:57 GMT')
                    ->appendHttpEquiv('pragma', 'no-cache')
                    ->appendHttpEquiv('Cache-Control', 'no-cache');

Ein anderer populärer Verwendungszweck für Meta Tags ist das Setzen des Inhalt-Typs, Zeichensatzes, und der
Sprache:

.. code-block:: php
   :linenos:

   // Setzen des Inhalttyps und des Zeichensatzes
   $this->headMeta()->appendHttpEquiv('Content-Type',
                                      'text/html; charset=UTF-8')
                    ->appendHttpEquiv('Content-Language', 'en-US');

Wenn man ein *HTML*\ 5 Dokument serviert, sollte man das Character Set wie folgt angeben:

.. code-block:: php
   :linenos:

   // Das Character Set im HTML5 setzen
   $this->headMeta()->setCharset('UTF-8'); // Sieht aus wie <meta charset="UTF-8">

Als letztes Beispiel, ein einfacher Weg um eine kurze Nachricht anzuzeigen bevor mit Hilfe eines "Meta Refreshes"
weitergeleitet wird:

.. code-block:: php
   :linenos:

   // Einen Meta Refresh mit 3 Sekunden zu einer neuen URL setzen:
   $this->headMeta()->appendHttpEquiv('Refresh',
                                      '3;URL=http://www.some.org/some.html');

Wenn man bereit ist die Meta Tags im Layout zu platzieren, muß einfach der Helfer ausgegeben werden:

.. code-block:: php
   :linenos:

   <?php echo $this->headMeta() ?>


