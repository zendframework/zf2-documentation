.. EN-Revision: none
.. _zend.progressbar.adapter.console:

Zend\ProgressBar_Adapter\Console
================================

``Zend\ProgressBar_Adapter\Console`` ist ein Textbasierter Adapter für Terminals. Er kann automatisch die
Terminalbreite erkennen unterstützt aber auch eigene Breiten. Kann kann definieren welche Elemente mit dem
Fortschrittsbalken angezeigt werden und auch deren Reihenfolge ändern. Man kann auch den Stil des
Fortschrittsbalkens selbst definieren.

.. note::

   **Automatische Breitenerkennung der Konsole**

   *shell_exec* wird benötigt damit dieses Feature auf \*nix basierenden Systemen funktioniert. Auf Windows, ist
   die Terminalbreite immer auf 80 Zeichen begrenzt, sodas dort keine Erkennung notwendig ist.

Man kann auch die Optionen des Adapters entweder über die *set** Methoden oder durch die Übergabe eines Arrays,
oder einer Instanz von ``Zend_Config``, an den Constructor mit dem Optionen als ersten Parameter. Die möglichen
Optionen sind:

- *outputStream*: Ein anderer Ausgabe-Stream wenn man nicht auf STDOUT streamen will. Kann jeder andere Stream wie
  *php://stderr* oder ein Pfad zu einer Datei sein.

- *width*: Entweder ein Integer oder die Konstante ``AUTO`` von ``Zend\Console\ProgressBar``.

- *elements*: Entweder ``NULL`` für Standard oder ein Array mit zumindest einer der folgenden Konstanten von
  ``Zend\Console\ProgressBar`` als Wert:

  - ``ELEMENT_PERCENT``: Der aktuelle Wert in Prozent.

  - ``ELEMENT_BAR``: Die sichtbare Begrenzung welche den Prozentwert anzeigt.

  - ``ELEMENT_ETA``: Die automatisch berechnete ETA. Das Element wird zuerst nach fünf Sekunden angezeigt, weil es
    wärend dieser Zeit nicht möglich ist korrekte Ergebnisse zu berechnen.

  - ``ELEMENT_TEXT``: Eine optionale Statusmeldung über den aktuelle Fortschritt.

- *textWidth*: Breite in Zeichen des ``ELEMENT_TEXT`` Elements. Standard ist 20.

- *charset*: Zeichensatz des ``ELEMENT_TEXT`` Elements. Standardwert ist utf-8.

- *barLeftChar*: Ein String der auf der linken Seite des Zeigers des Fortschrittsbalkens verwendet wird.

- *barRightChar*: Ein String der auf der rechten Seite des Zeigers des Fortschrittsbalkens verwendet wird.

- *barIndicatorChar*: Ein String der für den Zeiger des Fortschrittsbalkens verwendet wird. Er kann auch leer
  sein.


