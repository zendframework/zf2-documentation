.. EN-Revision: none
.. _zend.console.getopt.rules:

Definieren von Getopt Regeln
============================

Der Constructor für die ``Zend_Console_Getopt`` Klasse nimmt ein bis drei Argumente. Das erste Argument definiert
welche Optionen durch die Anwendung unterstützt werden. Diese Klasse unterstützt alternative Syntaxformen für
das definieren der Optionen. Die nächsten Sektionen geben Auskunft über das Format und die Verwendung dieser
Syntaxformen.

Der Constructor nimmt zwei weitere Argumente, welche optional sind. Das zweite Argument kann Kommandozeilen
Argumente enthalten. Sein Standardwert ist ``$_SERVER['argv']``.

Das dritte Argument des Constructors kann Konfigurationsoptionen enthalten um das Verhalten von
``Zend_Console_Getopt`` anzupassen. Siehe :ref:`Konfiguration hinzufügen
<zend.console.getopt.configuration.config>` für eine Referenz der möglichen Optionen.

.. _zend.console.getopt.rules.short:

Optionen mit der kurzen Syntax definieren
-----------------------------------------

``Zend_Console_Getopt`` unterstützt eine kompakte Syntax wie Sie durch *GNU* Getopt verwendet wird (siehe
`http://www.gnu.org/software/libc/manual/html_node/Getopt.html`_). Diese Syntax unterstützt nur Einzel-Zeichen
Flags. In einer einzelnen Zeichenkette, wird jeder Buchstabe angegeben der einem Flag entspricht das durch die
Anwendung unterstützt wird. Der Buchstabe, gefolgt von einem Doppelpunkt Zeichen (**:**) zeigt ein Flag das einen
Parameter benötigt.

.. _zend.console.getopt.rules.short.example:

.. rubric:: Verwendung der kurzen Syntax

.. code-block:: php
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');

Das obige Beispiel zeigt die Verwendung von ``Zend_Console_Getopt`` um die Optionen zu definieren die als ``-a``,
``-b``, oder ``-p`` angegeben werden können. Das letzte Flag benötigt einen Parameter.

Die kurze Syntax ist limitiert auf Flags mit einzelnen Zeichen. Aliase, Parametertypen und Hilfszeichenketten
werden in der kurzen Syntax nicht unterstützt.

.. _zend.console.getopt.rules.long:

Optionen mit der langen Syntax definieren
-----------------------------------------

Eine andere Syntax mit mehr Möglichkeiten ist auch vorhanden. Diese Syntax ermöglicht es Aliase für Flags, Typen
von Optionsparametern und auch Hilfszeichenkette zu definieren um die Verwendung für den Benutzer zu beschreiben.
Statt einer einzelnen Zeichenkette die in der kurzen Syntax verwendet wird um die Optionen zu definieren, verwendet
die lange Syntax ein assoziatives Array als erstes Argument für den Constructor.

Der Schlüssel jeden Elements des assoziativen Array ist eine Zeichenkette mit einem Format dass das Flag benennt,
mit jedem Alias, getrennt durch ein Pipe Symbol ("**|**"). Dieser Serie von Flag Aliasen folgende, wenn die Option
einen Parameter benötigt, ist ein Gleichheitszeichen ("**=**") mit einem Buchstaben der für den **Typ** dieses
Parameters steht:

- "**=s**" für einen Zeichenketten Parameter

- "**=w**" für einen Wort Parameter (eine Zeichenkette die keine Leerzeichen enthält)

- "**=i**" für einen Integer Parameter

Wenn der Parameter optional ist, kann ein Bindestrich ("**-**") statt des Gleichheitszeichens verwendet werden.

Der Wert jeden Elements in diesem assiziativen Array ist eine Hilfszeichenkette um dem Benutzer zu beschreiben wie
das Programm verwendet werden kann.

.. _zend.console.getopt.rules.long.example:

.. rubric:: Verwendung der langen Syntax

.. code-block:: php
   :linenos:

   $opts = new Zend_Console_Getopt(
       array(
           'apfel|a'    => 'Apfel Option, ohne Parameter',
           'banane|b=i' => 'Bananen Option, mit benötigtem Integer Parameter',
           'pfirsich|p-s' => 'Pfirsich Option, mit optionalem String Parameter'
       )
   );

In der obigen Beispieldefinition, sind drei Optionen. ``--apfel`` und ``-a`` sind Aliase füreinander, und diese
Option nimmt keinen Parameter. ``--banane`` und ``-b`` sind Aliase füreinander, und diese Option nimmt einen
notwendigen Integer Parameter. Letztendlich, ``--pfirsich`` und ``-p`` sind Aliase füreinander, und diese Option
kann einen Optionalen Zeichenketten Parameter annehmen.



.. _`http://www.gnu.org/software/libc/manual/html_node/Getopt.html`: http://www.gnu.org/software/libc/manual/html_node/Getopt.html
