.. _zend.view.helpers.initial.headscript:

HeadScript Helfer
=================

Das *HTML* **<script>** Element wird verwendet um entweder Clientseitige Skriptelemente Inline zu ermöglichen oder
um eine entfernte Ressource zu verlinken die Clientseitigen Skriptcode enthält. Der ``HeadScript`` Helfer erlaubt
es beides zu Managen.

Der ``HeadScript`` Helfer unterstützt die folgenden Methoden für das Setzen und Hinzufügen von Skripten:

- ``appendFile($src, $type = 'text/javascript', $attrs = array())``

- ``offsetSetFile($index, $src, $type = 'text/javascript', $attrs = array())``

- ``prependFile($src, $type = 'text/javascript', $attrs = array())``

- ``setFile($src, $type = 'text/javascript', $attrs = array())``

- ``appendScript($script, $type = 'text/javascript', $attrs = array())``

- ``offsetSetScript($index, $script, $type = 'text/javascript', $attrs = array())``

- ``prependScript($script, $type = 'text/javascript', $attrs = array())``

- ``setScript($script, $type = 'text/javascript', $attrs = array())``

Im Falle der * ``File()`` Methoden ist ``$src`` der entfernte Ort des Skriptes das geladen werden soll; das ist
üblicherweise in der Form einer *URL* oder eines Pfades. Für die * ``Script()`` Methoden sind ``$script`` die
clientseitigen Skript Direktiven die in diesem Element verwendet werden sollen.

.. note::

   **Abhängige Kommentare setzen**

   ``HeadScript`` erlaubt es ein Script Tag in abhängige Kommentare zu setzen, das es erlaubt es vor speziellen
   Browsern zu verstecken. Um abhängige Tags zu setzen, muß der abhängige Wert als Teil des ``$attrs``
   Parameters im Methodenaufruf übergeben werden.

   .. _zend.view.helpers.initial.headscript.conditional:

   .. rubric:: Headscript mit abhängigen Kommentaren

   .. code-block:: php
      :linenos:

      // Scripte hinzufügen
      $this->headScript()->appendFile(
          '/js/prototype.js',
          'text/javascript',
          array('conditional' => 'lt IE 7')
      );

``HeadScript`` erlaubt auch das Erfassen von Skripten; das kann nützlich sein wenn man ein Clientseitiges Skript
programmtechnisch erstellen und es dann woanders platzieren will. Seine Verwendung wird in einem Beispiel anbei
gezeigt.

Letztendlich kann die ``headScript()`` Methode verwendet werden um Skript Elemente schnell hinzuzufügen; die
Signatur hierfür ist ``headScript($mode = 'FILE', $spec, $placement = 'APPEND')``. Der ``$mode`` ist entweder
'FILE' oder 'SCRIPT', anhängig davon ob das Skript verlinkt oder definiert wird. ``$spec`` ist entweder die
Skriptdatei die verlinkt wird, oder der Skriptcode selbst. ``$placement`` sollte entweder 'APPEND', 'PREPEND' oder
'SET' sein.

``HeadScript`` überschreibt ``append()``, ``offsetSet()``, ``prepend()``, und ``set()`` um um die Verwendung der
speziellen Methoden wie vorher gezeigt zu erzwingen. Intern wird jedes Element als ``stdClass`` Token gespeichert,
welches später mit Hilfe der ``itemToString()`` Methode serialisiert wird. Das erlaubt es Prüfungen an den
Elementen im Stack vorzunehmen, und diese Elemente optional zu ändern, einfach durch das Modifizieren des
zurückgegebenen Objektes.

Der ``HeadScript`` Helfer ist eine konkrete Implementation des :ref:`Platzhalter Helfers
<zend.view.helpers.initial.placeholder>`.

.. note::

   **InlineScript für HTML Body Skripte verwenden**

   ``HeadScript``'s Schwester Helfer, :ref:`InlineScript <zend.view.helpers.initial.inlinescript>`, sollte
   verwendet werden wenn man Inline Skripte im *HTML* **body** inkludieren will. Die Platzierung von Skripten am
   Ende des Dokuments ist eine gängige Praxis für die schnellere Auslieferung von Seiten, speziell wenn 3rd Party
   Analyse Skripte verwendet werden.

.. note::

   **Andere Attribute werden stanadrdmäßig ausgeschaltet**

   Standardmäßig wird ``HeadScript`` nur **<script>** Attribute darstellen die von W3C abgesegnet sind. Diese
   beinhalten 'type', 'charset', 'defer', 'language', und 'src'. Trotzdem, verwenden einige Javascript Frameworks,
   vorallem `Dojo`_, eigene Attribute um Verhalten zu ändern. Um solche Attribute zu erlauben, können diese über
   die ``setAllowArbitraryAttributes()`` Methode eingeschaltet werden:

   .. code-block:: php
      :linenos:

      $this->headScript()->setAllowArbitraryAttributes(true);

.. _zend.view.helpers.initial.headscript.basicusage:

.. rubric:: Grundsätzliche Verwendung des HeadScript Helfers

Neue Skript Tags können jederzeit spezifiziert werden. Wie vorher beschrieben können diese Links auf externe
Ressourcen Dateien oder Skripte sein.

.. code-block:: php
   :linenos:

   // Skripte hinzufügen
   $this->headScript()->appendFile('/js/prototype.js')
                      ->appendScript($onloadScript);

Die Reihenfolge ist oft wichtig beim Clientseitigen Skripting; es kann notwendig sein sicherzustellen das
Bibliotheken in einer speziellen Reihenfolge geladen werden da Sie Abhängigkeiten zueinander haben; die
verschiedenen append, prepend und offsetSet Direktiven können hierbei helfen:

.. code-block:: php
   :linenos:

   // Skripte in eine Reihenfolge bringen

   // An einem bestimmten Offset Platzieren um Sicherzustellen
   // das es als letztes geladen wird
   $this->headScript()->offsetSetFile(100, '/js/myfuncs.js');

   // Scriptige Effekte verwenden (append verwendet den nächsten Index, 101)
   $this->headScript()->appendFile('/js/scriptaculous.js');

   // Aber Basis Prototype Skripte müssen immer als erstes geladen werden
   $this->headScript()->prependFile('/js/prototype.js');

Wenn man letztendlich damit fertig ist am alle Skripte im Layoutskript darzustellen, muß der Helfer einfach
ausgegeben werden:

.. code-block:: php
   :linenos:

   <?php echo $this->headScript() ?>

.. _zend.view.helpers.initial.headscript.capture:

.. rubric:: Skripte einfachen mit Hilfe des HeadScript Helfers

Manchmal mit ein Clientseitiges Skript programmtechnisch erstellt werden. Wärend man Strings zusammenhängen,
Heredocs und ähnliches verwenden könnte, ist es oft einfacher nur das Skript zu erstellen und in *PHP* Tags
einzubetten. ``HeadScript`` lässt das zu, und erfasst es in den Stack:

.. code-block:: php
   :linenos:

   <?php $this->headScript()->captureStart() ?>
   var action = '<?php echo $this->baseUrl ?>';
   $('foo_form').action = action;
   <?php $this->headScript()->captureEnd() ?>

Die folgenden Annahmen werden gemacht:

- Das Skript wird an den Stack angefügt. Wenn es den Stack ersetzen soll oder an den Anfang hinzugefügt werden
  soll, muß 'SET' oder 'PREPEND' als erstes Argument an ``captureStart()`` übergeben werden.

- Der *MIME* Typ des Skripts wird mit 'text/javascript' angenommen; wenn ein anderer Typ spezifiziert werden soll
  muß dieser als zweites Argument an ``captureStart()`` übergeben werden.

- Wenn irgendwelche zusätzlichen Attribute für das **<script>** Tag spezifiziert werden sollen, müssen diese in
  einem Array als drittes Argument an ``captureStart()`` übergeben werden.



.. _`Dojo`: http://www.dojotoolkit.org/
