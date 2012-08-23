.. EN-Revision: none
.. _zend.view.helpers.initial.placeholder:

Platzhalter (PlaceHolder) Helfer
================================

Der ``Placeholder`` View Helfer wird verwendet um Inhalte zwischen View Skripten und View Instanzen persistent zu
machen. Er bietet auch einige nützliche Features wie Inhalte zu vereinigen, Inhalte von View Skripten zu erfassen
und Vor- sowie Nach-Texte zu Inhalten hinzuzufügen (und eigene Separatoren für vereinigte Inhalte).

.. _zend.view.helpers.initial.placeholder.usage:

.. rubric:: Grundsätzliche Verwendung von Platzhaltern

Die grundsätzliche Verwendung von Platzhaltern ist die persistenz von View Daten. Jeder Aufruf des ``Placeholder``
Helfers erwartet einen Platzhalter Namen; der Helfer gibt dann ein Platzhalter Container Objekt zurück das
entweder manipuliert oder einfach ausgegeben werden kann.

.. code-block:: php
   :linenos:

   <?php $this->placeholder('foo')->set("Ein Text für später") ?>

   <?php
       echo $this->placeholder('foo');
       // Ausgabe "Ein Text für später"
   ?>

.. _zend.view.helpers.initial.placeholder.aggregation:

.. rubric:: Platzhalter verwenden um Inhalt zu vereinigen

Inhalt über Platzhalter zu vereinigen kann zeitweise auch sehr nützlich sein. Zum Beispiel kann ein View Skript
ein variables Array besitzen von dem Nachrichten empfangen werden sollen um diese später darzustellen; ein
späteres View Skript kann diese dann eruieren wie diese dargestellt werden sollen.

Der ``Placeholder`` View Helfer verwendet Container die ``ArrayObject`` erweitern, und ein reichhaltiges Set von
Features für die Manipulation von Arrays bieten. Zusätzlich bietet es eine Anzahl von Methoden für die
Formatierung des Inhalts der im Container gespeichert ist:

- ``setPrefix($prefix)`` setzt Text der dem Inhalt vorgesetzt wird. ``getPrefix()`` kann verwendet werden um
  jederzeit festzustellen wie die aktuellen Einstellungen sind.

- ``setPostfix($prefix)`` setzt Text der dem Inhalt angehängt wird. ``getPostfix()`` kann verwendet werden um
  jederzeit festzustellen wie die aktuellen Einstellungen sind.

- ``setSeparator($prefix)`` setzt Text mit dem zusammengefügte Inhalte seperiert werden. ``getSeparator()`` kann
  verwendet werden um jederzeit festzustellen wie die aktuellen Einstellungen sind.

- ``setIndent($prefix)`` kann verwendet werden um einen Markierungswert für den Inhalt zu setzen. Wenn ein Integer
  übergeben wird, wird diese Anzahl an Leerzeichen verwendet; wenn ein String übergeben wird, wird dieser String
  verwendet. ``getIndent()`` kann verwendet werden um jederzeit festzustellen wie die aktuellen Einstellungen sind.

.. code-block:: php
   :linenos:

   <!-- Erstes View Skript -->
   <?php $this->placeholder('foo')->exchangeArray($this->data) ?>

.. code-block:: php
   :linenos:

   <!-- Späteres View Skript -->
   <?php
   $this->placeholder('foo')->setPrefix("<ul>\n    <li>")
                            ->setSeparator("</li><li>\n")
                            ->setIndent(4)
                            ->setPostfix("</li></ul>\n");
   ?>

   <?php
       echo $this->placeholder('foo');
       // Ausgabe als unsortierte Liste mit schöner Einrückung
   ?>

Weil die ``Placeholder`` Container Objekte ``ArrayObject`` erweitern, können Inhalte einem speziellen Schlüssel
im Container sehr einfach zugeordnet werden, statt diese einfach an den Container anzufügen. Auf Schlüssel kann
entweder als Objekt Eigenschaften oder als Array Schlüssel zugegriffen werden.

.. code-block:: php
   :linenos:

   <?php $this->placeholder('foo')->bar = $this->data ?>
   <?php echo $this->placeholder('foo')->bar ?>

   <?php
   $foo = $this->placeholder('foo');
   echo $foo['bar'];
   ?>

.. _zend.view.helpers.initial.placeholder.capture:

.. rubric:: Verwenden von Platzhaltern um Inhalt zu erfassen

Gelegentlich will man Inhalte für einen Platzhalter in einem View Skript haben die einfachst als Vorlage zu
verwenden sind; der ``Placeholder`` View Helfer erlaubt es willkürliche Inhalte zu erfassen um diese später durch
Verwendung der folgenden *API* darstellen zu können.

- ``captureStart($type, $key)`` beginnt die Erfassung der Inhalte.

  ``$type`` sollte eine der ``Placeholder`` Konstanten ``APPEND`` oder ``SET`` sein. ``APPEND`` fügt erfasste
  Inhalte der Liste der aktuellen Inhalte im Placeholder an; ``SET`` verwendet erfasste Inhalte als einzigen Wert
  für den Platzhalter (überschreibt potentiell alle vorherigen Inhalte). Standardmäßig ist ``$type``
  ``APPEND``.

  ``$key`` kann verwendet werden um einen speziellen Schlüssel im Placeholder Container zu spezifizieren an dem
  der Inhalt erfasst werden soll.

  ``captureStart()`` sperrt die Erfassung bis ``captureEnd()`` aufgerufen wurde; Erfassungen können nicht mit dem
  selben Placeholder Container verschachtelt werden. Das führt zu einer Ausnahme.

- ``captureEnd()`` stoppt die Erfassung von Inhalten, und platziert Ihn im Container Objekt anhängig davon wie
  ``captureStart()`` aufgerufen wurde.

.. code-block:: php
   :linenos:

   <!-- Standarderfassung: anhängen -->
   <?php $this->placeholder('foo')->captureStart();
   foreach ($this->data as $datum): ?>
   <div class="foo">
       <h2><?php echo $datum->title ?></h2>
       <p><?php echo $datum->content ?></p>
   </div>
   <?php endforeach; ?>
   <?php $this->placeholder('foo')->captureEnd() ?>

   <?php echo $this->placeholder('foo') ?>

.. code-block:: php
   :linenos:

   <!-- Erfassung zum Schlüssel -->
   <?php $this->placeholder('foo')->captureStart('SET', 'data');
   foreach ($this->data as $datum): ?>
   <div class="foo">
       <h2><?php echo $datum->title ?></h2>
       <p><?php echo $datum->content ?></p>
   </div>
   <?php endforeach; ?>
   <?php $this->placeholder('foo')->captureEnd() ?>

   <?php echo $this->placeholder('foo')->data ?>

.. _zend.view.helpers.initial.placeholder.implementations:

Konkrete Platzhalter Implementationen
-------------------------------------

Zend Framework kommt mit einer Anzahl an "konkreten" Platzhalter Implementationen. Diese sind für üblich
verwendete Platzhalter: Doctype, Seitentitel, und verschiedene <head> Elemente. In allen Fällen gibt der Aufruf
des Platzhalters ohne Argumente das Element selbst zurück.

Die Dokumentation für jedes Element wird separat behandelt, wie anbei beschrieben:

- :ref:`Doctype <zend.view.helpers.initial.doctype>`

- :ref:`HeadLink <zend.view.helpers.initial.headlink>`

- :ref:`HeadMeta <zend.view.helpers.initial.headmeta>`

- :ref:`HeadScript <zend.view.helpers.initial.headscript>`

- :ref:`HeadStyle <zend.view.helpers.initial.headstyle>`

- :ref:`HeadTitle <zend.view.helpers.initial.headtitle>`

- :ref:`InlineScript <zend.view.helpers.initial.inlinescript>`


