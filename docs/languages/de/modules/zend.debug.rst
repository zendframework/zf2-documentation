.. EN-Revision: none
.. _zend.debug.dumping:

Variablen ausgeben
==================

Die statische Methode ``Zend\Debug\Debug::dump()`` druckt oder gibt Informationen über einen Ausdruck zurück. Diese
einfache Technik des Debuggens ist üblich, weil Sie in einer Ad-Hoc Weise einfach zu verwenden ist und keine
Initialisierung, spezielle Tools oder eine Debuggingumgebung benötigt.

.. _zend.debug.dumping.example:

.. rubric:: Beispiel der dump() Methode

.. code-block:: php
   :linenos:

   Zend\Debug\Debug::dump($var, $label = null, $echo = true);

Das Argument ``$var`` definiert den Ausdruck oder die Variable, über welche die Methode ``Zend\Debug\Debug::dump()``
Informationen ausgeben soll.

Das Argument ``$label`` ist eine Zeichenkette, die der Ausgabe von ``Zend\Debug\Debug::dump()`` vorgestellt wurd. Das
kann beispielsweise hilfreich sein, um Überschriften zu erhalten, wenn Informationen über mehrere Variablen auf
einen Bildschirm ausgegeben werden.

Das boolsche Argument ``$echo`` definiert, ob die Ausgabe von ``Zend\Debug\Debug::dump()`` mit Echo ausgegeben wird oder
nicht. Wenn der Wert ``TRUE`` ist, wird mit Echo ausgegeben, sonst nicht. Unabhängig vom Wert des ``$echo``
Arguments enthält der Rückgabewert dieser Methode die Ausgabe.

Es könnte hilfreich sein, zu verstehen, dass die ``Zend\Debug\Debug::dump()`` Methode die *PHP* Funktion `var_dump()`_
verwendet. Wenn der Ausgabestream als Webdarstellung erkannt wird, wird die Ausgabe von ``var_dump()`` mit Hilfe
von `htmlspecialchars()`_ ausgeführt und mit (X)HTML ``<pre>`` Tags umschlossen.

.. tip::

   **Debuggen mit Zend_Log**

   Die Verwendung von ``Zend\Debug\Debug::dump()``\ eignet sich am besten für Ad-Hoc Debuggen wärend der Software
   Entwicklung. Es kann für die Ausgabe einer Variablen Code hinzugefügt werden und dieser auch wieder sehr
   schnell entfernt werden. wieder sehr schnell entfernt werden.

   Um permanenteren Debugging-Code zu schreiben, sollte die :ref:`Zend_Log <zend.log.overview>` Komponente
   verwendet werden. Zum Beispiel kann der ``DEBUG`` Loglevel mit dem :ref:`Stream Logger
   <zend.log.writers.stream>` verwendet werden, um die Zeichenkette auszugeben, die durch ``Zend\Debug\Debug::dump()``
   zurückgegeben wird.



.. _`var_dump()`: http://php.net/var_dump
.. _`htmlspecialchars()`: http://php.net/htmlspecialchars
