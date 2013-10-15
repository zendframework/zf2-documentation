.. EN-Revision: none
.. _zend.console.getopt.fetching:

Holen von Optionen und Argumenten
=================================

Nach dem Erstellen der Optionen welche das ``Zend\Console\Getopt`` Objekt erkennen sollte, und der Übergabe von
Argumenten von der Kommandozeile oder einem Array, kann das Objekt abgefragt werden um herauszufinden welche
Optionen durch den Benutzer mit einem gegebenen Kommandozeilena Aufruf des Programms angegeben wurden. Die Klasse
implementiert magische Methoden damit Optionen anhand Ihres Namens abgefragt werden können.

Das Analysieren der Daten wird verzögert, bis zur ersten Abfrage die am ``Zend\Console\Getopt`` Objekt
durchgeführt wird um herauszufinden ob eine Option angegeben wurde. Das erlaubt die Anwendung einiger
Methodenaufrufe zur Konfiguration der Optionen, Argumente, Hilfstexte und Konfigurationsoptionen bevor das
Analysieren durchgeführt wird.

.. _zend.console.getopt.fetching.exceptions:

Handhaben von Getopt Ausnahmen
------------------------------

Wenn ein Benutzer irgendeine ungültige Option auf der Kommandozeile angibt, wirft die analysierende Funktion eine
``Zend\Console\Getopt\Exception``. Diese Ausnahme kann im Code der Anwendung abgefangen werden. Die ``parse()``
Methode kann verwendet werden um das Objekt dazu zu zwingen die Argumente zu analysieren. Das ist deswegen
nützlich weil ``parse()`` in einen **try** Block eingebettet werden kann. Wenn es erfolgreich ist, kann man sicher
sein das die Analyse keine weiteren Ausnahmen werfen wird. Die geworfene Ausnahme hat eine eigene Methode
``getUsageMessage()``, welche die formatierten Hinweise für die Verwendung aller definierten Optionen zurückgibt.

.. _zend.console.getopt.fetching.exceptions.example:

.. rubric:: Getopt Ausnahmen auffangen

.. code-block:: php
   :linenos:

   try {
       $opts = new Zend\Console\Getopt('abp:');
       $opts->parse();
   } catch (Zend\Console\Getopt\Exception $e) {
       echo $e->getUsageMessage();
       exit;
   }

Die Fälle in denen die Analyse eine Ausnahme werden sind unter anderem:

- Die gegebene Option wird nicht erkannt.

- Die Option benötigt einen Parameter, aber es wurde keiner angegeben.

- Der Parameter der Option ist vom falschen Typ. Z.B. eine nicht nummerische Zeichenkette obwohl ein Integer
  benötigt wird.

.. _zend.console.getopt.fetching.byname:

Optionen durch Ihren Namen finden
---------------------------------

Die ``getOption()`` Methode kann verwendet werden um den Wert einer Option abzufragen. Wenn die Option einen
Parameter hatte, wird diese Methode den Wert dieses Parameters zurückgeben. Wenn die Option keinen Parameter
hatte, aber der Benutzer ihn auf der Kommandozeile definiert hat, gibt die Methode ``TRUE`` zurück. Andernfalls
gibt die Methode ``NULL`` zurück.

.. _zend.console.getopt.fetching.byname.example.setoption:

.. rubric:: Verwenden von getOption()

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   $b = $opts->getOption('b');
   $p_parameter = $opts->getOption('p');

Alternativ kann die magische ``__get()`` Funktion verwendet werden um der Wert einer Option zu erhalten wie wenn
dieser eine Variable der Klasse wäre. Die magische ``__isset()`` Methode ist auch implementiert.

.. _zend.console.getopt.fetching.byname.example.magic:

.. rubric:: Verwenden der magischen \__get() und \__isset() Methoden

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   if (isset($opts->b)) {
       echo "Die Option b ist da.\n";
   }
   $p_parameter = $opts->p; // Null wenn nicht gesetzt

Wenn die Optionen mit Aliasen definiert wurden, kann jeder der Aliase für eine Option in den obigen Methoden
verwendet werden.

.. _zend.console.getopt.fetching.reporting:

Optionen berichten
------------------

Es gibt einige Methoden um das komplette Set an Optionen welches ein Benutzer an der Kommandozeile angegeben hat zu
berichten.

- Als Zeichenkette: verwenden der ``toString()`` Methode. Die Optionen werden als Leerzeichen-getrennte
  Zeichenkette von ``Flag=Wert`` Paaren zurückgegeben. Der Wert einer Option welche keinen Parameter hat, ist die
  wörtliche Zeichenkette "``TRUE``".

- Als Array: verwenden der ``toArray()`` Methode. Die Optionen werden in einem einfachen Integer-Indizierten Array
  von Zeichenketten zurückgegeben, die Flag-Zeichenketten gefolgt von den Parameter-Zeichenketten, wenn vorhanden.

- Als Zeichenkette welche *JSON* Daten enthält: verwenden der ``toJson()`` Methode.

- Als Zeichenkette welche *XML* Daten enthält: verwenden der ``toXml()`` Methode.

In allen obigen Auflistungsmethoden, ist die Flag-Zeichenkette die erste Zeichenkette in der entsprechenden Liste
von Aliasen. Wenn zum Beispiel die Aliase der Option als ``verbose|v`` definiert sind, wird die erste Zeichenkette
``verbose`` als kanonischer Name der Option verwendet. Der Name des Optionsflags enthält nicht die vorangestellten
Bindestriche.

.. _zend.console.getopt.fetching.remainingargs:

Nicht-Options Argumente erhalten
--------------------------------

Nachdem die Argumente der Option und deren Parameter von der Kommandozeile analysiert wurden, können zusätzliche
Argumente zurück bleiben. Diese Argumente können abgefragt werden durch Verwendung der ``getRemainingArgs()``
Methode. Diese Methode gibt ein Array von Zeichenketten zurück welche nicht Teil irgendeiner Option waren.

.. _zend.console.getopt.fetching.remainingargs.example:

.. rubric:: Verwenden von getRemainingArgs()

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');
   $opts->setArguments(array('-p', 'p_parameter', 'filename'));
   $args = $opts->getRemainingArgs(); // Rückgabe array('filename')

``Zend\Console\Getopt`` unterstützt die *GNU* Konvention das ein Argument welches auf einem Doppelten Bindestrich
besteht das Ende der Optionen bezeichnet. Jedes Argument welches diesem Bezeichner folgt, muß als
Nicht-Options-Argument behandelt werden. Das ist nützlich wenn ein Nicht-Options-Argument vorhanden ist welches
mit einem Bindestrich anfängt. Zum Beispiel: "``rm -- -filename-with-dash``".


