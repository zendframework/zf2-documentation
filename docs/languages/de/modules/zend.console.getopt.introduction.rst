.. EN-Revision: none
.. _zend.console.getopt.introduction:

Einführung
==========

Die ``Zend_Console_Getopt`` Klasse hilft Kommandozeilen Anwendungen Ihre Optionen und Argumente zu Analysieren.

Benutzer können Kommandozeilen Argumente definieren wenn die Anwendung ausgeführt wird. Diese Argumente haben
für die Anwendung die Bedeutung, das Verhalten in einem bestimmten Weg zu Ändern oder Ressourcen auszuwählen,
oder Parameter zu definieren. Viele Optionen haben eine einheitliche Bedeutung entwickelt wie zum Beispiel
``--verbose`` welches die Ausgabe von zusätzlicher Ausgabe für viele Anwendungen erlaubt. Andere Optionen haben
auch eine Bedeutung die in jeder Anwendung unterschiedlich ist. Zum Beispiel erlaubt ``-c`` unterschiedliche
Features in ``grep``, ``ls``, und ``tar``.

Anbei sind einige Definitionen von Ausdrücken. Die übliche Verwendung der Ausdrücke variiert, aber diese
Dokumentation wird die anbei beschriebenen Definitionen verwenden.

- "Argument": eine Zeichenkette die in der Kommandozeile dem Namen des Kommandos folgt. Argumente können Optionen
  sein, oder auch ohne Option vorkommen, um eine Ressource zu benennen die das Kommando verwendet.

- "Option": ist ein Argument das andeutet dass das Kommando sein Verhalten in einem bestimmten Weg verändern soll.

- "Flag": Der erste Teil einer Option, identifiziert den Zweck der Option. Einem Flag werden normalerweise ein oder
  zwei Bindestriche vorangestellt (``-`` oder ``--``). Ein einzelner wird einem Einzel-Zeichen Flag vorangestellt
  oder einem Verbund von Einzel-Zeichen Flags. Ein doppelter Bindestrich wird einem Mehr-Zeichen Flag
  vorangestellt. Lange Flags können nicht gebündelt werden.

- "Parameter": Der zweite Teil einer Option; Ein Datenwert der ein Flag begleitet, wenn er zu einer Option passt.
  Zum Beispiel kann ein Kommando eine ``--verbose`` Option akzeptieren, aber typischerweise hat diese Option keine
  Parameter. Trotzdem wird eine Option wie ``--user`` immer einen nachfolgenden Parameter benötigen.

  Ein Parameter kann als separates Argument angegeben werden der einem Flag Argument folgt, oder als Teil der
  gleichen Zeichenkette des Arguments, getrennt vom Flag durch ein Gleichheitszeichen (``=``). Die zweite Form wird
  nur bei langen Flags unterstützt. Zum Beispiel, ``-u username``, ``--user username``, und ``--user=username``
  sind Formen welche durch ``Zend_Console_Getopt`` unterstützt werden.

- "Verbund": Mehrere Einzel-Zeichen Flags kombiniert in einem einzelnen Argument als Zeichenkette und vorangestellt
  durch einen einzelnen Bindestrich. Zum Beispiel "``ls -1str``" benutzt einen Verbund von vier kurzen Flags.
  Dieses Kommando ist identisch mit "``ls -1 -s -t -r``". Nur Einzel-Zeichen Flags können kombiniert werden. Ein
  Verbund von langen Flags kann nicht erstellt werden.

Zum Beispiel ``mysql --user=root mydatabase``. ``mysql`` ist ein **Kommando**, ``--user=root`` ist eine **Option**,
``--user`` ist ein **Flag**, ``root`` ist ein **Parameter** für diese Option und ``mydatabase`` ist ein Argument
aber nicht eine Option laut unserer Definition.

``Zend_Console_Getopt`` bietet ein Interface um zu definieren welche Flags für die Anwendung gültig sind, das
einen Fehler und Benutzungshinweise ausgibt wenn ein ungültiges Flag verwendet wird, und dem Code der Anwendung
bekanntgibt welche Flags der Benutzer definiert hat.

.. note::

   **Getopt ist kein Framework für eine Anwendung**

   ``Zend_Console_Getopt`` kann **nicht** die Bedeutung der Flags und Parameter interpretieren, noch implementiert
   diese Klasse einen Anwendungsworkflow oder ruft Anwendungscode auf. Diese Aktionen müssen im eigenen
   Anwendungscode integriert werden. Die ``Zend_Console_Getopt`` Klasse kann dazu verwendet werden um die
   Kommandozeile zu analysieren und bietet Objekt-Orientierte Methoden für die Abfrage welche Optionen durch den
   Benutzer angegeben wurden. Aber der Code um diese Informationen zu Verwenden und Teile der eigenen Anwendung
   aufzurufen sollten in einer anderen *PHP* Klasse sein.

Die folgende Sektion beschreibt die Verwendung von ``Zend_Console_Getopt``.


