.. EN-Revision: none
.. _zend.progressbar.introduction:

Zend_ProgressBar
================

.. _zend.progressbar.whatisit:

Einführung
----------

``Zend_ProgressBar`` ist eine Komponente um Fortschrittsbalken in verschiedenen Umgebungen zu erstellen und zu
aktualisieren. Sie besteht aus einem einzelnen Backend, welches des Fortschritt durch eines der verschiedenen
Backends ausgibt. Bei jedem Update nimmt es einen absoluten Wert und optional eine Statusmeldung und ruft dann den
Adapter mit einigen vorkalkulierten Werten, wie Prozentwerte und voraussichtliche Restzeit, auf.

.. _zend.progressbar.basic:

Grundsätzliche Verwendung von Zend_Progressbar
----------------------------------------------

``Zend_ProgressBar`` ist sehr einfach in seiner Verwendung. Man erstellt einfach eine neue Instanz von
``Zend_Progressbar``, definiert einen minimalen und einen maximalan Wert, und wählt den Adapter der die Daten
ausgibt. Wenn man die Datei ausführen will, muß man etwas ähnliches wie folgt machen:

.. code-block:: php
   :linenos:

   $progressBar = new Zend_ProgressBar($adapter, 0, $fileSize);

   while (!feof($fp)) {
       // Mach was

       $progressBar->update($currentByteCount);
   }

   $progressBar->finish();

Im ersten Schritt, wird eine Instanz von ``Zend_ProgressBar`` erstellt, mit einem speziellen Adapter, einem
minimalen Wert von 0 und einem maximalen Wert der kompletten Dateigröße. Dann wird die Datei ausgeführt und bei
jeder Schleife wird der Fortschrittsbalken mit der aktuellen Byteanzahl aktualisiert. Am Ende der Schleife, wird
der Status des Fortschrittsbalken auf fertig gestellt.

Man kann auch die ``update()`` Methode von ``Zend_ProgressBar`` ohne Argumente aufrufen, das die ETA einfach neu
berechnet und den Adapter aktualisiert. Das ist nützlich wenn kein Update der Daten war, man aber den
Fortschrittsbalken aktualisieren will.

.. _zend.progressbar.persistent:

Persistenter Fortschritt
------------------------

Wenn man den Fortschrittsbalken über mehrere Aufrufe hinweg persistent haben will, kann man den Namen eines
Session Namespaces als viertes Argument an den Constructor angeben. In diesem Fall wird der Fortschrittsbalken den
Adapter nicht im Constructor benachrichtigen, sondern nur wenn man ``update()`` oder ``finish()`` aufruft. Auch der
aktuelle Wert, der Statustext und die Startzeit für die ETA Kalkulation werden im nächsten Ablauf erneut geholt.

.. _zend.progressbar.adapters:

Standard Adapter
----------------

``Zend_ProgressBar`` kommt mit den folgenden zwei Adaptern:



   - :ref:`Zend_ProgressBar_Adapter_Console <zend.progressbar.adapter.console>`

   - :ref:`Zend_ProgressBar_Adapter_JsPush <zend.progressbar.adapter.jspush>`

   - :ref:`Zend_ProgressBar_Adapter_JsPull <zend.progressbar.adapter.jspull>`



.. include:: zend.progress-bar.adapter.console.rst
.. include:: zend.progress-bar.adapter.js-push.rst
.. include:: zend.progress-bar.adapter.js-pull.rst

