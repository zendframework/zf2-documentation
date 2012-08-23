.. EN-Revision: none
.. _zend.console.getopt.configuration:

Konfigurieren von Zend_Console_Getopt
=====================================

.. _zend.console.getopt.configuration.addrules:

Regeln für das Hinzufügen von Optionen
--------------------------------------

Man kann mehr Optionsregeln hinzufügen, zusätzlich zu denen die schon im ``Zend_Console_Getopt`` Constructor
definiert wurden, durch Verwendung der ``addRules()`` Methode. Das Argument für ``addRules()`` ist das gleiche wie
das erste Argument für den Constructor der Klasse. Es ist entweder eine Zeichenkette im Format der kurzen Syntax
wie für das Definieren für Optionen definiert, oder ein assoziatives Array im Format der langen Syntax wie für
das Definieren für Optionen definiert. Siehe :ref:`Definieren von GetOpt Regeln <zend.console.getopt.rules>` für
Details über die Syntax für die Definition von Optionen.

.. _zend.console.getopt.configuration.addrules.example:

.. rubric:: Verwenden von addRules()

.. code-block:: php
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->addRules(
     array(
       'verbose|v' => 'Druckt zusätzliche Ausgaben'
     )
   );

Das obige Beispiel zeigt das hinzufügen der ``--verbose`` Option mit einem Alias von ``-v`` zu einem Set von
Optionen welche bereits im Aufruf durch den Constructor definiert wurden. Man kann kurze Format Optionen und lange
Format Optionen in der gleichen Instanz von ``Zend_Console_Getopt`` vermischen.

.. _zend.console.getopt.configuration.addhelp:

Hilfstexte hinzufügen
---------------------

Zusätzlich zum Definieren von Hilfstexten bei der Definition von Optionsregeln im langen Format, können
Hilfstexte mit Optionsregeln verknüpft werden durch Verwendung der ``setHelp()`` Methode. Das Argument für die
``setHelp()`` Methode ist ein assoziatives Array, in welchen der Schlüssel ein Flag ist, und der Wert der
betreffende Hilfetext.

.. _zend.console.getopt.configuration.addhelp.example:

.. rubric:: Verwenden von setHelp()

.. code-block:: php
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->setHelp(
       array(
           'a' => 'Apfel Option, ohne Parameter',
           'b' => 'Bananen Option, mit benötigtem Integer Parameter',
           'p' => 'Pfirsich Option, mit optionalem Zeichenketten Parameter'
       )
   );

Wenn Optionen mit Aliasen definiert wurden, kann jeder dieser Aliase als Schlüssel für das assizoative Array
verwendet werden.

Die ``setHelp()`` Methode ist der einzige Weg um einen Hilfetext zu definieren wenn die Optionen mit der kurzen
Syntax definiert wurden.

.. _zend.console.getopt.configuration.addaliases:

Aliase für Optionen hinzufügen
------------------------------

Aliase für Optionen können mit der ``setAliases()`` Methode definiert werden. Das Argument ist ein assoziatives
Array, dessen Schlüssel ein zuvor definiertes Flag, und dessen Wert ein neuer Alias für dieses Flag ist. Diese
Aliase werden mit jedem existierenden Alias für dieses Flag gemischt. Mit anderen Worten, die zuvor definierten
Aliase sind noch immer in Verwendung.

Ein Alias kann nur einmal definiert werden. Wenn versucht wird einen Alias nochmals zu definieren wird eine
``Zend_Console_Getopt_Exception`` geworfen.

.. _zend.console.getopt.configuration.addaliases.example:

.. rubric:: Verwenden von setAliases()

.. code-block:: php
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->setAliases(
       array(
           'a' => 'apple',
           'a' => 'apfel',
           'p' => 'pfirsich'
       )
   );

Im obigen Beispiel sind, nach Definition der Aliase, ``-a``, ``--apple`` und ``--apfel`` Aliase füreinander. Auch
``-p`` und ``--pfirsich`` sind füreinander Aliase.

Die ``setAliases()`` Methode ist der einzige Weg um Aliase zu definieren wenn die Optionen mit der kurzen Syntax
definiert wurden.

.. _zend.console.getopt.configuration.addargs:

Argument Listen hinzufügen
--------------------------

Standardmäßig verwendet ``Zend_Console_Getopt`` ``$_SERVER['argv']`` für die Analyse des Arrays von
Kommandozeilen Argumenten. Alternativ kann das Array mit Argumenten als zweites Argument dem Constructor angegeben
werden. Letztendlich können zusätzliche Argumente zu den bereits in Verwendung befindlichen hinzugefügt werden,
durch Verwendung der ``addArguments()`` Methode, oder es kann das aktuelle Array von Argumenten ersetzt werden mit
Hilfe der ``setArguments()`` Methode. In beiden Fällen ist der Parameter für diese Methoden ein einfaches Array
von Zeichenketten, und die letztere Methode substituiert das Array für seine aktuellen Argumente.

.. _zend.console.getopt.configuration.addargs.example:

.. rubric:: Verwenden von addArguments() und setArguments()

.. code-block:: php
   :linenos:

   // Normalerweise verwendet der Constructor $_SERVER['argv']
   $opts = new Zend_Console_Getopt('abp:');

   // Ein Array zu den bestehenden Argumenten hinzufügen
   $opts->addArguments(array('-a', '-p', 'p_parameter', 'non_option_arg'));

   // Ein neues Array als Ersatz für die bestehenden Argumente
   $opts->setArguments(array('-a', '-p', 'p_parameter', 'non_option_arg'));

.. _zend.console.getopt.configuration.config:

Konfiguration hinzufügen
------------------------

Der dritte Parameter des ``Zend_Console_Getopt`` Constructors ist ein Array von Optionen zur Konfiguration welche
das Verhalten der zurückgegebenen Objektinstanz beeinflusst. Es können auch durch Verwendung der ``setOptions()``
Optionen für die Konfiguration definiert werden, oder es können auch individuelle Optionen mit der
``setOption()`` Methode verwendet werden.

.. note::

   **Klarstellung des Ausdrucks "Option"**

   Der Ausdruck "Option" wird für die Konfiguration der ``Zend_Console_Getopt`` Klasse verwendet um der
   Terminologie zu folgen die überall im Zend Framework benutzt wird. Das ist nicht das selbe wie die
   Kommandozeilen Optionen die von der ``Zend_Console_Getopt`` Klasse analysiert werden.

Die aktuell unterstützten Optionen sind durch Konstanten in der Klasse definiert. Diese Optionen, bzw deren
konstanter Bezeichner (mit wörtlichem Wert in Großschreibweise) sind anbei gelistet:

- ``Zend_Console_Getopt::CONFIG_DASHDASH`` ("dashDash"), wenn es ``TRUE`` ist, ermöglicht dieses spezielle Flag
  ``--`` das Ende von Flags zu signieren. Kommendozeilen Argumente welche dem Doppel-Bindestrich Zeichen folgen
  werden nicht als Option interpretiert selbst wenn das Argument mit einem Bindestrich beginnt. Diese
  Konfigurationsoption ist standardmäßig ``TRUE``.

- ``Zend_Console_Getopt::CONFIG_IGNORECASE`` ("ignoreCase"), wenn es ``TRUE`` ist, werden Flags als Aliase
  voneinander betrachtet wenn Sie sich nur in der Groß- oder Kleinschreibung unterscheiden. Das bedeutet das
  ``-a`` und ``-A`` als gleiche Flags angesehen werden. Diese Konfigurationsoption ist standardmäßig ``FALSE``.

- ``Zend_Console_Getopt::CONFIG_RULEMODE`` ("ruleMode") kann die Werte ``Zend_Console_Getopt::MODE_ZEND`` ("zend")
  und ``Zend_Console_Getopt::MODE_GNU`` ("gnu") haben. Diese Option sollte nicht verwendet werden ausser die Klasse
  wird erweiter um zusätzliche Syntax Formen zu unterstützen. Die zwei Modi die in der Basisklasse
  ``Zend_Console_Getopt`` unterstützt werden sind eindeutig. Wenn die Angabe eine Zeichenkette ist, nimmt die
  Klasse ``MODE_GNU`` an, sonst wird ``MODE_ZEND`` angenommen. Aber wenn die Klasse erweitert wird, und
  zusätzliche Syntaxformen hinzugefügt werden, kann der Modus durch Verwendung dieser Option definiert werden.

Zusätzliche Konfigurationsoptionen können in zukünftigen Versionen dieser Klasse hinzugefügt werden.

Die zwei Argumente der ``setOption()`` Methode sind ein Name einer Konfigurationsoption und ein Wert für die
Option.

.. _zend.console.getopt.configuration.config.example.setoption:

.. rubric:: Verwenden von setOption()

.. code-block:: php
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->setOption('ignoreCase', true);

Das Argument für die ``setOptions()`` Methode ist ein assoziatives Array. Die Schlüssel dieses Arrays sind die
Namen der Konfigurationsoptionen, und die Werte sind die Konfigurationswerte. Das ist also das Array Format welches
auch im Constructor der Klasse verwendet wird. Die definierten Konfigurationswerte werden mit der aktuellen
Konfiguration zusammengefügt; es müssen also nicht alle Optionen angegeben werden.

.. _zend.console.getopt.configuration.config.example.setoptions:

.. rubric:: Verwenden von setOptions()

.. code-block:: php
   :linenos:

   $opts = new Zend_Console_Getopt('abp:');
   $opts->setOptions(
       array(
           'ignoreCase' => true,
           'dashDash'   => false
       )
   );


