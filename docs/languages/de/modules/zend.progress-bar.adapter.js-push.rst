.. EN-Revision: none
.. _zend.progressbar.adapter.jspush:

Zend_ProgressBar_Adapter_JsPush
===============================

``Zend_ProgressBar_Adapter_JsPush`` ist ein Adapter der es erlaubt den Fortschrittsbalken in einem Browser über
Javascript Push zu aktualisieren. Das bedeutet das keine zweite Verbindung benötigt wird um den Status über den
aktuell laufenden Prozess zu erhalten, sondern das der Prozess selbst seinen Status direkt an den Browser schickt.

Man kann auch die Optionen des Adapters entweder über die *set** Methoden oder durch die Übergabe eines Arrays,
oder einer Instanz von ``Zend_Config``, an den Constructor mit dem Optionen als ersten Parameter. Die möglichen
Optionen sind:

- *updateMethodName*: Die Javascript Methode die bei jeder Aktualisierung aufgerufen werden soll. Standardwert ist
  ``Zend_ProgressBar_Update``.

- *finishMethodName*: Die Javascript Methode die aufgerufen werden soll wenn der Beendet-Status gesetzt wurde. Der
  Standardwert ist ``NULL``, was bedeutet das nichts passiert.

Die Verwendung dieses Adapters ist recht einfach. Zuerst wird ein Fortschrittsbalken im Browser erstellt, entweder
mit JavaScript oder mit vorher erstelltem reinen *HTML*. Dann definiert man die Update Methode und optional die
Finish Methode in JavaScript, die beide ein Json Objekt als einziges Argument nehmen. Das wird die Webseite mit
einem lange laufenden Prozess, in einem versteckten *iframe* oder *object* Tag, aufgerufen. Wärend der Prozess
läuft wird der Adapter die Update Methode bei jedem Update mit einem Json Objekt aufgerufen, das die folgenden
Parameter enthält:

- *current*: Der aktuelle absolute Wert

- *max*: Der maximale absolute Wert

- *percent*: Der berechnete Prozentwert

- *timeTaken*: Die Zeit die der Prozess bis jetzt gelaufen ist

- *timeRemaining*: Die erwartete Zeit bis der Prozess beendet ist

- *text*: Die optionale Statusmeldung, wenn angegeben

.. _zend.progressbar-adapter.jspush.example:

.. rubric:: Grundsätzliches Beispiel für den Client-seitigen Teil

Dieses Beispiel zeigt ein grundsätzliches Setup von *HTML*, *CSS* und JavaScript für den JsPush Adapter

.. code-block:: html
   :linenos:

   <div id="zend-progressbar-container">
       <div id="zend-progressbar-done"></div>
   </div>

   <iframe src="long-running-process.php" id="long-running-process"></iframe>

.. code-block:: css
   :linenos:

   #long-running-process {
       position: absolute;
       left: -100px;
       top: -100px;

       width: 1px;
       height: 1px;
   }

   #zend-progressbar-container {
       width: 100px;
       height: 30px;

       border: 1px solid #000000;
       background-color: #ffffff;
   }

   #zend-progressbar-done {
       width: 0;
       height: 30px;

       background-color: #000000;
   }

.. code-block:: javascript
   :linenos:

   function Zend_ProgressBar_Update(data)
   {
       document.getElementById('zend-progressbar-done').style.width =
           data.percent + '%';
   }

Das erstellt einen einfachen Container mit einem schwarzen Rand und einem Block der den aktuellen Prozess anzeigt.
Man sollte den *iframe* oder *object* nicht mit *display: none;* verstecken, da einige Browser wie Safari 2 den
aktuellen Inhalt dann nicht laden.

Statt einen eigenen Fortschrittsbalken zu erstellen, kann es gewünscht sein einen von einer vorhandenen Bibliothek
wir Dojo, jQuery usw zu verwenden. Es gibt zum Beispiel:

- Dojo: `http://dojotoolkit.org/reference-guide/dijit/ProgressBar.html`_

- jQuery: `http://t.wits.sg/2008/06/20/jquery-progress-bar-11/`_

- MooTools: `http://davidwalsh.name/dw-content/progress-bar.php`_

- Prototype: `http://livepipe.net/control/progressbar`_

.. note::

   **Intervall der Updates**

   Man sollte davon Abstand nehmen zuviele Updates zu senden, da jedes Update eine Mindestgröße von 1kb hat. Das
   ist eine Notwendigkeit für den Safari Browser um den Funktionsaufruf darzustellen und auszuführen. Der
   Internet Explorer hat eine ähnliche Einschränkung von 256 Bytes.



.. _`http://dojotoolkit.org/reference-guide/dijit/ProgressBar.html`: http://dojotoolkit.org/reference-guide/dijit/ProgressBar.html
.. _`http://t.wits.sg/2008/06/20/jquery-progress-bar-11/`: http://t.wits.sg/2008/06/20/jquery-progress-bar-11/
.. _`http://davidwalsh.name/dw-content/progress-bar.php`: http://davidwalsh.name/dw-content/progress-bar.php
.. _`http://livepipe.net/control/progressbar`: http://livepipe.net/control/progressbar
