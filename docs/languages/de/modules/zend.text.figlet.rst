.. EN-Revision: none
.. _zend.text.figlet:

Zend\Text\Figlet
================

``Zend\Text\Figlet`` ist eine Komponente die es Entwicklern erlaubt einen sogenannten FIGlet Text zu erstellen. Ein
FIGlet Text ist ein String der eine *ASCII* Kunst repräsentiert. FIGlets sind ein spezielles Schriftformat, das
FLT (FigLet Font) genannt wird. Standardmäßig wird eine Schriftart mit ``Zend\Text\Figlet`` ausgeliefert, aber
man kann zusätzliche Schriftarten unter http://www.figlet.org herunterladen.

.. note::

   **Komprimierte Schriftarten**

   ``Zend\Text\Figlet`` unterstützt gezippte Schriftarten. Das bedeutet das man eine ``.flf`` Datei nehmen und
   diese gzip-pen kann. Um ``Zend\Text\Figlet`` zu erlauben diese Datei zu erkennen, muß die gezippte Schriftart
   die Erweiterung ``.gz`` haben. Weiters, um die gezippte Schriftart verwenden zu können muß in *PHP* die
   Erweiterung GZIP aktiviert sein.

.. note::

   **Encoding**

   ``Zend\Text\Figlet`` erwartet das Strings standardmäßig UTF-8 kodiert sind. Wenn das nicht der Fall ist, kann
   die Zeichenkodierung als zweiter Parameter an die ``render()`` Methode übergeben werden.

Man kann mehrere Optionen für ein FIGlet definieren. Wenn ein ``Zend\Text\Figlet`` instanziiert wird, kann ein
Array oder eine Instanz von ``Zend_Config`` übergeben werden.



   - ``font``- Definiert die Schriftart die für die Darstellung verwendet werden soll. Wenn keine definiert wird,
     wird die eingebaute Schriftart verwendet.

   - ``outputWidth``- Definiert die maximale Breite des Ausgabestrings. Das wird für die Trennung von Wörtern
     verwendet sowie für die Feineinstellung. Achtung vor zu kleinen Werten, da diese zu undefiniertem Verhalten
     führen können. Der Standardwert ist 80.

   - ``handleParagraphs``- Ein boolscher Wert welcher anzeigt wie neue Zeilen zu handhaben sind. Wenn er auf
     ``TRUE`` gesetzt wird, werden einzelne neue Zeilen ignoriert und stattdessen als einzelnes Leerzeichen
     behandelt. Nur mehrere neue Zeilen werden als solche behandelt. Der Standardwert ist ``FALSE``.

   - ``justification``- Kann einer der Werte von ``Zend\Text\Figlet::JUSTIFICATION_*`` sein. Es gibt
     ``JUSTIFICATION_LEFT``, ``JUSTIFICATION_CENTER`` und ``JUSTIFICATION_RIGHT``. Die standardmäßige Justierung
     ist mit dem Wert ``rightToLeft`` definiert.

   - ``rightToLeft``- Definiert in welche Richtung geschrieben wird. Das kann entweder
     ``Zend\Text\Figlet::DIRECTION_LEFT_TO_RIGHT`` oder ``Zend\Text\Figlet::DIRECTION_RIGHT_TO_LEFT`` sein.
     Standardmäßig wird die Einstellung der Datei der Schriftart verwendet. Wenn die Justierung nicht definiert
     ist, wird ein Text der von rechts-nach-links geschrieben wird automatisch nach rechts gerückt.

   - ``smushMode``- Ein Integer-Bitfeld welches definiert wie einzelne Zeichen ineinander gesmusht (verflochten)
     werden. Das kann die Summe von mehreren Werten von ``Zend\Text\Figlet::SM_*`` sein. Es gibt die folgenden
     Smush-Modi: SM_EQUAL, SM_LOWLINE, SM_HIERARCHY, SM_PAIR, SM_BIGX, SM_HARDBLANK, SM_KERN und SM_SMUSH. Ein Wert
     von 0 schaltet das Smushing nicht aus sondern erzwingt die Anwendung von SM_KERN, wärend es ein Wert von -1
     ausschaltet. Eine Erklärung der verschiedenen Smush-Modi kann `hier`_ gefunden werden. Die Smush-Mode Option
     wird normalerweise nur von Schriftart-Designer verwendet um die verschiedenen Layoutmodi mit einer neuen
     Schriftart zu testen.



.. _zend.text.figlet.example.using:

.. rubric:: Verwendung von Zend\Text\Figlet

Dieses Beispiel zeigt die einfache Verwendung von ``Zend\Text\Figlet`` um einen einfachen FIGlet Text zu erstellen:

.. code-block:: php
   :linenos:

   $figlet = new Zend\Text\Figlet();
   echo $figlet->render('Zend');

Angenommen es wird eine Monospace Schriftart verwenden dann würde das Beispiel wie folgt aussehen:

.. code-block:: text
   :linenos:

     ______    ______    _  __   ______
    |__  //   |  ___||  | \| || |  __ \\
      / //    | ||__    |  ' || | |  \ ||
     / //__   | ||___   | .  || | |__/ ||
    /_____||  |_____||  |_|\_|| |_____//
    `-----`'  `-----`   `-` -`'  -----`



.. _`hier`: http://www.jave.de/figlet/figfont.txt
