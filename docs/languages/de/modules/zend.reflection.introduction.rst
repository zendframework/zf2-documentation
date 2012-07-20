.. _zend.reflection.introduction:

Einführung
==========

``Zend_Reflection`` ist ein Ersatz zu *PHP*'s eigener `Reflection API`_ die verschiedene zusätzliche Features
bietet:

- Die Möglichkeit die Typen der Rückgabewerte zu erhalten.

- Die Möglichkeit Methoden und Funktions Parametertypen zu erhalten.

- Die Möglichkeit Eigenschaftstypen von Klassen zu erhalten.

- DocBlocks mit der Reflection Klasse, welche die Begutachtung von DocBlocks erlauben. Das bietet die Möglichkeit
  zu erheben welche Typen definiert wurden, sowie deren Werte zu erhalten, und die Möglichkeit die Kurz- und
  Langbeschreibungen zu empfangen.

- Dateien mit der Reflection Klasse, erlauben es *PHP* Dateien zu betrachten. Das bietet die Möglichkeit zu
  eruieren welche Funktionen und Klasssen in der gegebenen Datei definiert sind, sowie Sie zu betrachten.

- Die Möglichkeit jede Reflection Klasse mit einer eigenen Variante zu überladen, für den kompletten Reflection
  Baum den man erstellt.

Generell arbeitet ``Zend_Reflection`` genauso wie die Standard Reflection *API*, bietet aber einige zusätzliche
Methoden für das Empfangen von Teilinformationen die in der Reflection *API* nicht definiert sind.



.. _`Reflection API`: http://php.net/reflection
