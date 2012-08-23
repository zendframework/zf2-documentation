.. EN-Revision: none
.. _coding-standard:

**************************************
Zend Framework Coding Standard für PHP
**************************************

.. _coding-standard.overview:

Übersicht
---------

.. _coding-standard.overview.scope:

Geltungsbereich
^^^^^^^^^^^^^^^

Dieses Dokument bietet Richtlinien für die Formatierung von Code und Dokumentation für Individuen und Teams die
im Zend Framework mitarbeiten. Viele Entwickler die den Zend Framework verwenden haben diese Code Standards als
nützlich empfunden weil Ihr Code Stil mit jedem Zend Framework Code konsistent bleibt. Es ist auch anzumerken das
es signifikant viel Arbeit erfordert einen kompletten Coding Standard zu definieren.

.. note::

   Manchmal entscheiden Entwickler das die Verfügbarkeit eines Standards wichtiger ist als was der Standard
   aktuell im höchsten Level des Designs empfiehlt. Diese Richtlinien im Zend Framework Coding Standard
   beschreiben die Praxis die im Zend Framework Projekt sehr gut funktionieren. Diese Standard können geändert
   oder so wie sie sind verwendet werden solange Sie sich an unsere `Lizenz`_ halten.

Die Bereiche die im Zend Framework Coding Standard abgedeckt werden enthalten:

- *PHP* Dateiformatierung

- Namens Konventionen

- Code Stil

- Inline Dokumentation

.. _coding-standard.overview.goals:

Ziele
^^^^^

Coding Standards sind in jedem Entwicklungs Projekt wichtig, aber sie sind speziell dann wichtig wenn viele
Entwickler an dem gleichen Projekt arbeiten. Coding Standards helfen sicherzustellen das der Code von hoher
Qualität ist, weniger Fehler hat, und einfach zu warten ist.

.. _coding-standard.php-file-formatting:

PHP Dateiformatierung
---------------------

.. _coding-standard.php-file-formatting.general:

Allgemein
^^^^^^^^^

Für Dateien, welche nur *PHP* Code beinhalten ist der schliessende Tag ("?>") nicht zugelassen. Er wird von *PHP*
nicht benötigt, und das Weglassen verhindert das versehentlich Leerzeilen in die Antwort eingefügt werden.

.. note::

   **Wichtig**: Einbeziehen von beliebigen binärischen Daten durch ``__HALT_COMPILER()`` ist in den *PHP* Dateien
   im Zend Framework oder abgeleiteten Datei verboten. Das Benutzen ist nur für einige Installationsskirpte
   erlaubt.

.. _coding-standard.php-file-formatting.indentation:

Einrücken
^^^^^^^^^

Ein Einzug sollte aus 4 Leerzeichen bestehen. Tabulatoren sind nicht erlaubt.

.. _coding-standard.php-file-formatting.max-line-length:

Maximale Zeilenlänge
^^^^^^^^^^^^^^^^^^^^

Die Zielzeilenlänge ist 80 Zeichen. Entwickler sollten jede Zeile Ihres Codes unter 80 Zeichen halten, soweit dies
möglich und praktikabel ist. Trotzdem sind längere Zeilen in einigen Fällen erlaubt. Die maximale Länge einer
*PHP* Codezeile beträgt 120 Zeichen.

.. _coding-standard.php-file-formatting.line-termination:

Zeilenbegrenzung
^^^^^^^^^^^^^^^^

Die Zeilenbegrenzung folgt der Unix Textdatei Konvention. Zeilen müssen mit einem einzelnen Zeilenvorschubzeichen
(LF) enden. Zeilenvorschub Zeicen werden duch eine ordinale 10, oder durch 0x0A (hexadecimal) dargestellt.

Beachte: Benutze nicht den Wagenrücklauf (CR) wie in den Konventionen von Apple's OS (0x0D) oder die Kombination
aus Wagenrücklauf und Zeilenvorschub (*CRLF*) wie im Standard für das Windows OS (0x0D, 0x0A).

.. _coding-standard.naming-conventions:

Namens Konventionen
-------------------

.. _coding-standard.naming-conventions.classes:

Klassen
^^^^^^^

Zend Framework standartisiert eine Klassennamen Konvention wobei die Namen der Klassen direkt mit den
Verzeichnissen übereinstimmen muß in welchen Sie gespeichert sind. Das Basisverzeichnis der Zend Framework
Standard Bibliothek ist das "Zend/" Verzeichnis, wobei das Basisverzeichnis der Zend Framework Extras Bibliothek im
"ZendX/" Verzeichnis ist. Alle Zend Framework Klassen werden hierarchisch unter dem gleichen Basisverzeichnis
gespeichert.

Klassennamen dürfen nur alphanumerische Zeichen enthalten. Nummern sind in Klassennamen gestattet es wird aber von
Ihnen in den meisten Fällen abgeraten. Unterstriche sind nur gestattet im Platz des Pfadseparators -- der
Dateiname "``Zend/Db/Table.php``" muß übereinstimmen mit dem Klassennamen "``Zend_Db_Table``".

Wenn ein Klassenname aus mehr als einem Wort besteht, muß der erste Buchstabe von jedem neuen Wort
großgeschrieben werden. Durchgehende Großbuchstaben sind nicht erlaubt, z.B. eine Klasse "Zend_PDF" ist nicht
erlaubt, aber "``Zend_Pdf``" ist akzeptierbar.

Diese Konventionen definieren einen Pseudo-Namespace Mechanismus für Zend Framework. Zend Framework wird das *PHP*
Namespace Feature einbauen sobald es verfügbar ist und es für unsere Entwickler in deren Anwendungen ohne
Bedenken verwendbar ist.

Siehe die Klassennamen in der Standard und Extra Bibliothek für Beispiel dieser Klassennamen Konvention.

.. note::

   **Wichtig**: Code welcher mit dem Framework ausgeliefert werden muß, aber nicht Teil der Standard oder Extras
   Bibliothek ist (z.B. Anwendungscode oder Bibliotheken die nicht von Zend ausgeliefert werden), dürfen nie mit
   "Zend\_" oder "ZendX\_" beginnen.

.. _coding-standard.naming-conventions.abstracts:

Abstrakte Klassen
^^^^^^^^^^^^^^^^^

Generell folgen abstrakte Klassen der gleichen Konvention wie :ref:`Klassen
<coding-standard.naming-conventions.classes>`, mit einer zusätzlichen Regel: Die Namen von abstrakten Klassen
müssen mit derm Term "Abstract" enden, und dem Term darf kein Unterstrich vorangestellt sein. Als Beispiel wird
``Zend_Controller_Plugin_Abstract`` als ungültig angenommen, aber ``Zend_Controller_PluginAbstract`` oder
``Zend_Controller_Plugin_PluginAbstract`` wären gültige Namen.

.. note::

   Diese Namens Konvention ist neu mit Version 1.9.0 des Zend Frameworks. Bei Klassen vor dieser Version kann es
   sein das sie dieser Regel nicht folgen, aber Sie werden in Zukunft umbenannt um zu entsprechen.

   Der Hintergrund dieser Änderung ist die Verwendung von Namespaces. Da wir auf Zend Framework 2.0 und die
   Verwendung von *PHP* 5.3 zugehen, werden wir Namespaces verwenden. Der einfachste Weg die Konvertierung zu
   Namespaces zu automatisieren besteht darin die Unterstriche in Namespace Separatoren zu konvertieren -- aber in
   der alten Namenskonvention, lässt dies den Klassennamen einfach als "Abstract" oder "Interface" zurück" --
   beide sind reservierte Schlüsselwörter in *PHP*. Wenn wir den Namen der (Unter)Komponente dem Klassennamen
   voranstellen können wir diese Probleme vermeiden.

   Um die Situation zu illustrieren, nehmen wir an dass die Klasse ``Zend_Controller_Request_Abstract`` konvertiert
   wird um Namespaces zu verwenden:

   .. code-block:: php
      :linenos:

      namespace Zend\Controller\Request;

      abstract class Abstract
      {
          // ...
      }

   Natürlich wird das nicht funktionieren. In der neuen Namenskonvention würde dies aber trotzdem zu folgendem
   werden:

   .. code-block:: php
      :linenos:

      namespace Zend\Controller\Request;

      abstract class RequestAbstract
      {
          // ...
      }

   Wir bleiben trotzdem bei der Semantik und der Trennung auf Namespaces, wärend wir die Probleme mit den
   Schlüsselworten vermeiden; simultan beschreibt dies abstrakte Klassen besser.

.. _coding-standard.naming-conventions.interfaces:

Interfaces
^^^^^^^^^^

Generell folgen Interfaces der gleichen Konvention wie :ref:`Klassen <coding-standard.naming-conventions.classes>`,
mit einer zusätzlichen Regel: Die Namen von Interfaces können optional mit dem Term "Interface" enden, aber dem
Term darf kein Unterstrich vorangestellt sein. Als Beispiel wird ``Zend_Controller_Plugin_Interface`` als ungültig
angenommen, aber ``Zend_Controller_PluginInterface`` oder ``Zend_Controller_Plugin_PluginInterface`` wären
gültige Namen.

Wärend diese Regel nicht benötigt wird, wird Sie stark empfohlen, da Sie Entwicklern einen guten visuellen
Hinweis gibt welche Dateien ein Interface enthalten und welche Klassen.

.. note::

   Diese Namens Konvention ist neu mit Version 1.9.0 des Zend Frameworks. Bei Klassen vor dieser Version kann es
   sein das sie dieser Regel nicht folgen, aber Sie werden in Zukunft umbenannt um zu entsprechen. Siehe :ref:`den
   vorhergehenden Abschnitt <coding-standard.naming-conventions.abstracts>` für weitere Informationen über die
   Hintergründe für diese Änderung.

.. _coding-standard.naming-conventions.filenames:

Dateinamen
^^^^^^^^^^

Für alle anderen Dateien sind nur alphanummerische Zeichen, Unterstriche, und der Bindestrich ("-") gestattet.
Leerzeichen sind völlig verboten.

Jede Datei die irgendeinen *PHP* Code enthält sollte mit der Endung "``.php``" enden, mit Ausnahme der View
Skripte. Die folgenden Beispiele zeigen akzeptierbare Dateinamen für Zend Framework Klassen:

.. code-block:: php
   :linenos:

   Zend/Db.php

   Zend/Controller/Front.php

   Zend/View/Helper/FormRadio.php

Dateinamen müssen den Klassennamen wie oben beschrieben entsprechen.

.. _coding-standard.naming-conventions.functions-and-methods:

Funktionen und Methoden
^^^^^^^^^^^^^^^^^^^^^^^

Funktionsnamen dürfen nur Alphanummerische Zeichen enthalten. Unterstriche sind nicht gestattet. Nummern sind in
Funktionsnamen gestattet aber in den meisten Fällen nicht empfohlen.

Funktionsnamen müssen immer mit einem Kleinbuchstaben anfangen. Wenn Funktionsnamen aus mehr als einem Wort
bestehen, muß der erste Buchstabe jeden Wortes großgeschrieben werden. Das wird normalerweise "camelCase"
Formatierung genannt.

Wortreichtum wird generell befürwortet. Funktionsnamen sollten so wortreich wie möglich sein um deren Zweck und
Verhalten zu erklären.

Das sind Beispiele akzeptierbarer Namen für Funktionen:

.. code-block:: php
   :linenos:

   filterInput()

   getElementById()

   widgetFactory()

Für objekt-orientiertes Programmieren, sollten Zugriffspunkte für Instanzen oder statische Variablen immer mit
"get" oder "set" beginnen. Wenn Design-Pattern implementiert werden, wie Singleton oder das Factory Pattern, sollte
der Name der Methode den Namen des Pattern enthalten wo es praktikabel ist, um das Verhalten besser zu beschreiben.

Für Methoden in Objekten die mit dem "private" oder "protected" Modifikator deklariert sind, muß das erste
Zeichen des Namens der Methode ein einzelner Unterstrich sein. Das ist die einzige akzeptable Anwendung von einem
Unterstrich im Namen einer Methode. Methoden die als "public" deklariert sind sollten nie einem Unterstrich
enthalten.

Funktionen im globalen Bereich (auch "floating functions" genannt) sind gestattet aber es wird von Ihnen in den
meisten Fällen abgeraten. Diese Funktionen sollten in einer statischen Klasse gewrappt werden.

.. _coding-standard.naming-conventions.variables:

Variablen
^^^^^^^^^

Variablennamen dürfen nur Alphanummerische Zeichen enthalten. Unterstriche sind nicht gestattet. Nummern sind in
Variablen gestattet in den meisten Fällen aber nicht empfohlen.

Für Instanzvariablen die mit dem "private" oder "protected" Modifikator deklariert werden, muß das erste Zeichen
des Funktionsnamens ein einzelner Unterstrich sein. Das ist die einzige akzeptierte Anwendung eines Unterstriches
in einem variablen Namen. Klassenvariablen welche als "public" deklariert werden sollten nie mit einem Unterstrich
beginnen.

Wie bei Funktionsnamen (siehe Abschnitt 3.3) müssen Variablennamen immer mit einem Kleinbuchstaben starten und der
"camelCaps" Schreibweise folgen.

Wortreichtum wird generell befürwortet. Variablen sollen immer so wortreich wie möglich sein um die Daten zu
beschreiben die der Entwickler in Ihnen zu speichern gedenkt. Von gedrängte Variablennamen wie "``$i``" und
"``$n``" wird abgeraten für alles außer die kleinsten Schleifen. Wenn eine Schleife mehr als 20 Codezeilen
enthält sollten die Index-Variablen einen ausführlicheren Namen haben.

.. _coding-standard.naming-conventions.constants:

Konstanten
^^^^^^^^^^

Konstanten können beides enthalten, sowohl Alphanummerische Zeichen als auch Unterstriche. Nummern sind in
Konstantennamen gestattet.

Alle Buchstaben die in Konstantenname verwendet werden müssen großgeschrieben haben, wärend Wörter in einem
Konstantennamen durch Unterstriche getrennt werden müssen.

Zum Beispiel ist ``EMBED_SUPPRESS_EMBED_EXCEPTION`` gestattet aber ``EMBED_SUPPRESSEMBEDEXCEPTION`` nicht.

Konstanten müssen als Klassenkonstanten definiert werden mit dem "const" Modifikator. Die Definition von
Konstanten im globalen Bereich mit der "define" Funktion ist gestattet aber es wird es wird stärkstens davon
abgeraten.

.. _coding-standard.coding-style:

Code Stil
---------

.. _coding-standard.coding-style.php-code-demarcation:

PHP Code Abgrenzung
^^^^^^^^^^^^^^^^^^^

*PHP* Code muß immer mit der kompletten Form des Standard-*PHP* Tags abgegrenzt sein:

.. code-block:: php
   :linenos:

   <?php

   ?>

Kurze Tags sind nie erlaubt. Für Dateien die nur *PHP* Code enthalten, darf das schließende Tag nie angegeben
werden (Siehe :ref:`generelle Standards <coding-standard.php-file-formatting.general>`).

.. _coding-standard.coding-style.strings:

Strings
^^^^^^^

.. _coding-standard.coding-style.strings.literals:

String Literale
^^^^^^^^^^^^^^^

Wenn ein String ein Literal ist (er also keine Variablenvertreter enthält), sollte immer das Apostroph oder
"einzelne Anführungszeichen" verwendet werden um den String abzugrenzen:

.. code-block:: php
   :linenos:

   $a = 'Beispiel String';

.. _coding-standard.coding-style.strings.literals-containing-apostrophes:

String Literale die Apostrophe enthalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wenn ein literaler String selbst Apostrophe enthält, ist es gestattet den String mit Anführungszeichen oder
"doppeltes Anführungszeichen" abzugrenzen. Das ist speziell für ``SQL`` Anweisungen nützlich:

.. code-block:: php
   :linenos:

   $sql = "SELECT `id`, `name` from `people` "
        . "WHERE `name`='Fred' OR `name`='Susan'";

Diese Syntax ist zu bevorzugen, im Gegensatz zum Ausbruch von Apostrophs, da Sie viel einfacher lesbar ist.

.. _coding-standard.coding-style.strings.variable-substitution:

Variabler Austausch
^^^^^^^^^^^^^^^^^^^

Variabler Austausch ist gestatten bei Verwendung einer der Formen:

.. code-block:: php
   :linenos:

   $greeting = "Halle $name, willkommen zurück!";

   $greeting = "Hallo {$name}, willkommen zurück!";

Aus Gründen der Konstistenz ist folgende Form nicht gestattet:

.. code-block:: php
   :linenos:

   $greeting = "Hallo ${name}, willkommen zurück!";

.. _coding-standard.coding-style.strings.string-concatenation:

Verbinden von Strings
^^^^^^^^^^^^^^^^^^^^^

Strings müssen verbunden werden indem man den "." Operator verwendet. Ein Leerzeichen muß immer vor und nach dem
"." Operator hinzugefügt werden um die Lesbarkeit zu erhöhen:

.. code-block:: php
   :linenos:

   $company = 'Zend' . ' ' . 'Technologies';

Wenn Strings mit dem "." Operator verbunden werden, ist es empfohlen die Anweisung in mehrere Zeilen umzubrechen um
die Lesbarkeit zu erhöhen. In diesen Fällen sollte jede folgende Zeile mit Leerraum aufgefüllt werden so das der
"." Operator genau unterhalb des "=" Operators ist:

.. code-block:: php
   :linenos:

   $sql = "SELECT `id`, `name` FROM `people` "
        . "WHERE `name` = 'Susan' "
        . "ORDER BY `name` ASC ";

.. _coding-standard.coding-style.arrays:

Arrays
^^^^^^

.. _coding-standard.coding-style.arrays.numerically-indexed:

Nummerisch indizierte Arrays
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Negative Nummern sind in Indezes nicht gestattet.

Ein indiziertes Array kann mit mit irgendeiner nicht-negativen Nummer beginnen, trotzdem sind alle BasisIndex neben
0 nicht erlaubt.

Wenn indizierte Arrays mit dem ``Array`` Funktion deklariert werden, muß ein folgendes Leerzeichen nach jeder
Kommabegrenzung hinzugefügt werden um die Lesbarkeit zu erhöhen:

.. code-block:: php
   :linenos:

   $sampleArray = array(1, 2, 3, 'Zend', 'Studio');

Es ist gestattet mehrzeilige indizierte Arrays zu definieren bei Verwendung des "array" Konstrukts. In diesem Fall,
muß jede folgende Zeile mit Leerzeichen aufgefüllt werden so das der Beginn jeder Zeile ausgerichtet ist:

.. code-block:: php
   :linenos:

   $sampleArray = array(1, 2, 3, 'Zend', 'Studio',
                        $a, $b, $c,
                        56.44, $d, 500);

Alternativ kann das beginnende Array Element in der folgenden Zeile beginnen. Wenn das so ist, sollte es um ein
Einrückungslevel tiefer stehen als die Zeile welche die Array Deklaration enthält und alle folgenden Zeilen
sollten die gleiche Einrückung haben; der schließende Teil sollte in einer eigenen Zeile stehen und das gleiche
Einrückungslevel haben wie die Zeile welche die Array Deklaration enthält:

.. code-block:: php
   :linenos:

   $sampleArray = array(
       1, 2, 3, 'Zend', 'Studio',
       $a, $b, $c,
       56.44, $d, 500,
   );

Wenn die letztere Deklaration verwendet wird, empfehlen wir ein endendes Komma für das letzte Element im Array zu
verwenden; das minimiert das Problem beim Hinzufügen von neuen Elements bei zusätzlichen Zeilen, und hilft
sicherzustellen das durch ein fehlendes Komma keine Parsing Fehler auftreten.

.. _coding-standard.coding-style.arrays.associative:

Assoziative Arrays
^^^^^^^^^^^^^^^^^^

Wenn assoziative Arrays mit dem ``Array`` Konstrukt deklariert werden, ist das Umbrechen der Anweisung in mehrere
Zeilen gestattet. In diesem Fall muß jede folgende Linie mit Leerraum aufgefüllt werden so das beide, der
Schlüssel und der Wert untereinander stehen:

.. code-block:: php
   :linenos:

   $sampleArray = array('firstKey'  => 'firstValue',
                        'secondKey' => 'secondValue');

Alternativ kann das beginnende Array Element in der folgenden Zeile beginnen. Wenn das so ist, sollte es um ein
Einrückungslevel tiefer stehen als die Zeile welche die Array Deklaration enthält und alle folgenden Zeilen
sollten die gleiche Einrückung haben; der schließende Teil sollte in einer eigenen Zeile stehen und das gleiche
Einrückungslevel haben wie die Zeile welche die Array Deklaration enthält. Wegen der Lesbarkeit sollten die
verschiedenen "=>" Operatoren so eingerückt werden das Sie untereinander stehen.

.. code-block:: php
   :linenos:

   $sampleArray = array(
       'firstKey'  => 'firstValue',
       'secondKey' => 'secondValue',
   );

Wenn die letztere Deklaration verwendet wird, empfehlen wir ein endendes Komma für das letzte Element im Array zu
verwenden; das minimiert das Problem beim Hinzufügen von neuen Elements bei zusätzlichen Zeilen, und hilft
sicherzustellen das durch ein fehlendes Komma keine Parsing Fehler auftreten.

.. _coding-standard.coding-style.classes:

Klassen
^^^^^^^

.. _coding-standard.coding-style.classes.declaration:

Klassen Deklarationen
^^^^^^^^^^^^^^^^^^^^^

Klassen müssen entsprechend der Zend Framework Namenskonvention benannt werden.

Die Klammer sollte immer in der Zeile unter dem Klassennamen geschrieben werden.

Jede Klasse muß einen Dokumentationsblock haben der dem PHPDocumentor Standard entspricht.

Jeder Code in der Klasse muß mit vier Leerzeichen eingerückt sein.

Nur eine Klasse ist in jeder *PHP* Datei gestattet.

Das Platzieren von zusätzlichem Code in Klassendateien ist gestattet aber es wird davon abgeraten. In solchen
Dateien müssen zwei leere Zeilen die Klasse von jedem zusätzlichen *PHP* Code in der Datei seperieren.

Das folgende ist ein Beispiel einer akzeptierbaren Klassendeklaration:

.. code-block:: php
   :linenos:

   /**
    * Dokumentations Block hier
    */
   class SampleClass
   {
       // gesamter Inhalt der Klasse
       // muss mit vier Leerzeichen eingerückt sein
   }

Klassen die andere Klassen erweitern oder welche Interfaces implementieren sollen Ihre Abhängigkeit auf der
gleichen Zeile deklarieren wenn das möglich ist.

.. code-block:: php
   :linenos:

   class SampleClass extends FooAbstract implements BarInterface
   {
   }

Wenn als Ergebnis so einer Deklaration, die Länge der Zeile die :ref:`Maximale Zeilenlänge
<coding-standard.php-file-formatting.max-line-length>` überschreitet, ist die Zeile vor dem "extends" und oder
"implements" Schlüsselwort umzubrechen und diese Zeilen um ein Einrückungslevel einzurücken.

.. code-block:: php
   :linenos:

   class SampleClass
       extends FooAbstract
       implements BarInterface
   {
   }

Wenn die Klasse mehrere Interfaces implementiert und die Deklaration die maximale Zeilenlänge übersteigt, ist
nach jedem Komma umzubrechen und die Interfaces zu separieren, und die Namen des Interfaces so einzurücken das Sie
untereinander stehen.

.. code-block:: php
   :linenos:

   class SampleClass
       implements BarInterface,
                  BazInterface
   {
   }

.. _coding-standard.coding-style.classes.member-variables:

Klassenvariablen
^^^^^^^^^^^^^^^^

Klassenvariablen müssen entsprechend den Variablen-Benennungs-Konventionen des Zend Frameworks benannt werden.

Jede Variable die in der Klasse deklariert wird muß am Beginn der Klasse ausgelistet werden, vor der Deklaration
von allen Methoden.

Das **var** Konstrukt ist nicht gestattet. Klassenvariablen definieren Ihre Sichtbarkeit durch die Verwendung des
``private``, ``protected``, oder ``public`` Modifikatoren. Das gestatten von direktem Zugriff auf Klassenvariablen
durch deren Deklaration als public ist gestattet aber es wird davon abgeraten da hierfür Zugriffsmethoden
verwendet werden sollten (set & get).

.. _coding-standard.coding-style.functions-and-methods:

Funktionen und Methoden
^^^^^^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.functions-and-methods.declaration:

Deklaration von Funktionen und Methoden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Funktionen müssen nach der Funktions-Namenskonvention des Zend Frameworks benannt werden.

Methoden innerhalb von Klassen müssen immer Ihre Sichtbarkeit durch Verwendung einer der ``private``,
``protected``, oder ``public`` Modifikatoren definieren.

Wie bei Klassen, sollte die Klammer immer in der Zeile unterhalb des Funktionsnamens geschrieben werden.
Leerzeichen zwischen dem Funktionsnamen und der öffnenden Klammer für die Argumente sind nicht erlaubt.

Von Funktionen im globalen Raum wird komplett abgeraten.

Das folgende ist ein Beispiel einer akzeptierbaren Funktionsdeklaration in einer Klasse:

.. code-block:: php
   :linenos:

   /**
    * Dokumentations Block hier
    */
   class Foo
   {
       /**
        * Dokumentations Block hier
        */
       public function bar()
       {
           // gesamter Inhalt der Funktion
           // muss durch view Leerzeichen eingerückt sein
       }
   }

In den Fällen wo die Liste der Argumente die :ref:`maximale Zeilenlänge
<coding-standard.php-file-formatting.max-line-length>` überschreitet, sollten Zeilenumbrüche eingeführt werden.
Zusätzliche Argumente der Funktion oder Methode müssen durch einen zusätzlichen Einrückungslevel nach der
Funktion oder Methodendeklaration eingerückt werden. Ein Zeilenumbruch sollte dann vor dem schließenden Argument
stattfinden, welcher in der gleichen Zeile platziert werden sollte wie die öffnende Klammer der Funktion oder
Methode mit einem einzelnen Leerzeichen das die zwei trennt, und mit dem gleichen Einrückungslevel wie die
Deklaration der Funktion oder Methode. Das folgende ist ein Beispiel so einer Situation:

.. code-block:: php
   :linenos:

   /**
    * Dokumentations Block Hier
    */
   class Foo
   {
       /**
        * Dokumentations Block Hier
        */
       public function bar($arg1, $arg2, $arg3,
           $arg4, $arg5, $arg6
       ) {
           // gesamter Inhalt der Funktion
           // muss durch view Leerzeichen eingerückt sein
       }
   }

.. note::

   **Notiz**: Die Übergabe per Referenz ist die einzige erlaubt Mechanismus für die Übergabe von Parametern in
   der Deklaration einer Funktion:

.. code-block:: php
   :linenos:

   /**
    * Dokumentations Block hier
    */
   class Foo
   {
       /**
        * Dokumentations Block hier
        */
       public function bar(&$baz)
       {}
   }

Der Aufruf durch Referenz ist nicht gestattet.

Der Rückgabewert darf nicht in Klammern stehen. Das kann die Lesbarkeit behindern und zusätzlich den Code
unterbrechen wenn eine Methode später auf Rückgabe durch Referenz geändert wird.

.. code-block:: php
   :linenos:

   /**
    * Dokumentations Block hier
    */
   class Foo
   {
       /**
        * FALSCH
        */
       public function bar()
       {
           return($this->bar);
       }

       /**
        * RICHTIG
        */
       public function bar()
       {
           return $this->bar;
       }
   }

.. _coding-standard.coding-style.functions-and-methods.usage:

Verwendung von Funktionen und Methoden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Funktionsargumente sollten durch ein einzelnes trennendes Leerzeichen nach dem Komma Trennzeichen getrennt werden.
Das folgende ist ein Beispiel für einen akzeptierbaren Aufruf einer Funktion die drei Argumente benötigt:

.. code-block:: php
   :linenos:

   threeArguments(1, 2, 3);

Übergabe von Referenzen zur Laufzeit ist strengstens verboten. Siehe die Sektion für Funktions Deklarationen für
den richtigen Weg um Funktionsargumente per Referenz zu übergeben.

Durch die Übergabe von Arrays als Argument für eine Funktion, kann der Funktionsaufruf den "array" Hinweis
enthalten und kann in mehrere Zeilen geteilt werden um die Lesbarkeit zu erhöhen. In solchen Fällen sind die
normalen Richtlinien für das Schreiben von Arrays trotzdem noch anzuwenden:

.. code-block:: php
   :linenos:

   threeArguments(array(1, 2, 3), 2, 3);

   threeArguments(array(1, 2, 3, 'Zend', 'Studio',
                        $a, $b, $c,
                        56.44, $d, 500), 2, 3);

   threeArguments(array(
       1, 2, 3, 'Zend', 'Studio',
       $a, $b, $c,
       56.44, $d, 500
   ), 2, 3);

.. _coding-standard.coding-style.control-statements:

Kontrollanweisungen
^^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.control-statements.if-else-elseif:

If/Else/Elseif
^^^^^^^^^^^^^^

Kontrollanweisungen die auf den **if** und **elseif** Konstrukten beruhen müssen ein einzelnes Leerzeichen vor der
öffnenden Klammer der bedingten Anweisung und ein einzelnes Leerzeichen nach der schließenden Klammer.

Innerhalb der bedingten Anweisungen zwischen den Klammern, müssen die Operationen, für die Lesbarkeit, durch
Leerzeichen getrennt werden. Innere Klammern sind zu befürworten um die logische Gruppierung für größeren
bedingte Anweisungen zu erhöhen.

Die öffnende Klammer wird in der selben Zeile geschrieben wie die Bedingungsanweisung. Die schließende Klammer
wird immer in einer eigenen Zeile geschrieben. Jeder Inhalt innerhalb der Klammer muß durch Verwendung von vier
Leerzeichen eingerückt werden.

.. code-block:: php
   :linenos:

   if ($a != 2) {
       $a = 2;
   }

Wenn die Kontrollanweisung die Ursache für eine Überschreitung der :ref:`maximalen Zeilenlänge
<coding-standard.php-file-formatting.max-line-length>` ist, und sie mehrere Anweisungen hat, kann die
Kontrollanweisung in mehrere Zeilen gebrochen werden. In solchen Fällen, ist die Zeile vor dem logischen Operator
zu brechen und die Zeile so einzurücken das Sie unter dem ersten Zeichen der Kontrollanweisung steht. Der
schließende Teil der Kontrollanweisung ist mit der öffnenden Klammer in einer eigenen Zeile zu platzieren, wobei
ein einzelnes Leerzeichen die zwei trennen muß, und der Einrückungslevel identisch mit der öffenden
Kontrollanweisung sein ist.

.. code-block:: php
   :linenos:

   if (($a == $b)
       && ($b == $c)
       || (Foo::CONST == $d)
   ) {
       $a = $d;
   }

Die Einrückung des späteren Deklarationsformats dient der Vorbeugung von Problemen beim Hinzufügen oder
entfernen von Klauseln von der Kontrollanweisung bei späteren Revisionen.

Für "if" Anweisungen die "elseif" oder "else" beinhalten, sind die Konventionen der Formatierung ähnlich dem "if"
Konstrukt. Das folgende Beispiel zeigt gültige Formatierungen für "if" Anweisungen mit "else" und/oder "elseif"
Konstrukten:

.. code-block:: php
   :linenos:

   if ($a != 2) {
       $a = 2;
   } else {
       $a = 7;
   }

   if ($a != 2) {
       $a = 2;
   } elseif ($a == 3) {
       $a = 4;
   } else {
       $a = 7;
   }

   if (($a == $b)
       && ($b == $c)
       || (Foo::CONST == $d)
   ) {
       $a = $d;
   } elseif (($a != $b)
             || ($b != $c)
   ) {
       $a = $c;
   } else {
       $a = $b;
   }

*PHP* erlaubt das Anweisungen in einigen Fällen auch ohne Klammern zu schreiben. Dieser Coding Standard macht
keine Unterscheidungen und es müssen alle "if", "elseif" oder "else" Anweisungen in Klammern geschrieben werden.

.. _coding-standards.coding-style.control-statements.switch:

Switch
^^^^^^

Kontrollanweisungen die mit der "switch" Anweisung geschrieben werden müssen ein einzelnes Leerzeichen vor der
öffnenden Klammer der Bedingten Anweisung besitzen, und auch nach der schließenden Klammer.

Jeglicher Inhalt innerhalb der "switch" Anweisung muß durch Verwendung von vier Leerzeichen eingerückt sein. Der
Inhalt unter jeder "case" Anweisung muß durch Verwendung von vier zusätzlichen Leerzeichen eingerückt werden.

.. code-block:: php
   :linenos:

   switch ($numPeople) {
       case 1:
           break;

       case 2:
           break;

       default:
           break;
   }

Das ``default`` Konstrukt darf nie bei der ``switch`` Anweisung vergessen werden.

.. note::

   **Notiz**: Es ist machmal nützlich eine ``case`` Anweisung zu schreiben, die durch das nächste case fällt
   indem innerhalb solcher Fälle kein ``break`` oder ``return`` angegeben wird. Um diese Fälle von Fehlern zu
   unterscheiden, sollte jede ``case`` Anweisung in der ``break`` oder ``return`` unterlassen werden einen
   Kommentar enthalten der anzeigt dass das break gewünschtermaßen unterdrückt wurde.

.. _coding-standards.inline-documentation:

Inline Dokumentation
^^^^^^^^^^^^^^^^^^^^

.. _coding-standards.inline-documentation.documentation-format:

Dokumentations Format
^^^^^^^^^^^^^^^^^^^^^

Alle Dokumentations Blöcke ("DocBlock") müssel mit dem phpDocumentor Format kompatibel sein. Die Beschreibung des
phpDocumentor Formats is jenseits der Reichweite dieses Dokuments. Für weiterführende Informationen siehe:
`http://phpdoc.org">`_

Alle Klassen Dateien müssen einen "file-level" Docblock am Beginn jeder Datei und einen "class-level" Docblock
direkt überhalb jeder Klasse enthalten. Beispiele solcher Docblocks können anbei gefunden werden.

.. _coding-standards.inline-documentation.files:

Dateien
^^^^^^^

Jede Datei die *PHP* Code enthält muß einen Docblock am Beginn der Datei besitzen welcher mindestens diese
phpDocumentor Tags enthält:

.. code-block:: php
   :linenos:

   /**
    * Kurze Beschreibung der Datei
    *
    * Lange Beschreibung der Datei (wenn vorhanden)...
    *
    * LICENSE: Einige Lizenz Informationen
    *
    * @category   Zend
    * @package    Zend_Magic
    * @subpackage Wand
    * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
    * @license    http://framework.zend.com/license   BSD License
    * @version    $Id:$
    * @link       http://framework.zend.com/package/PackageName
    * @since      Datei vorhanden seit Release 1.2.0
   */

Das ``@category`` Tag muß den Wert "Zend" haben.

Das ``@package`` Tag muß hinzugefügt sein, und sollte mit dem Namen der Komponente identisch sein dessen Klasse
in der Datei enthalten ist; typischerweise wird dieser zwei Segmente haben, den Präfix "Zend", und den Namen der
Komponente.

Das ``@subpackage`` Tag ist optional. Wenn es angegeben wird, sollte es der Name der Subkomponente sein, ohne den
Präfix der Klasse. Im obigen Beispiel ist die Annahme das die Klasse in der Datei entweder "``Zend_Magic_Wand``"
ist oder den Klassennamen als Teil seines Präfixes verwendet.

.. _coding-standards.inline-documentation.classes:

Klassen
^^^^^^^

Jede Klasse muß einen Docblock haben welche mindestens diese phpDocumentor Tags enthält:

.. code-block:: php
   :linenos:

   /**
    * Kurze Beschreibung für die Klasse
    *
    * Lange Beschreibung für die Klasse (wenn vorhanden)...
    *
    * @category   Zend
    * @package    Zend_Magic
    * @subpackage Wand
    * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
    * @license    http://framework.zend.com/license   BSD License
    * @version    Release: @package_version@
    * @link       http://framework.zend.com/package/PackageName
    * @since      Klasse vorhanden seit Release 1.5.0
    * @deprecated Klasse abgeraten ab Release 2.0.0
    */

Das ``@category`` Tag muß den Wert "Zend" haben.

Das ``@package`` Tag muß hinzugefügt sein, und sollte mit der Komponente identisch sein der die Klasse gehört;
typischerweise wird dieser zwei Segmente haben, den Präfix "Zend", und den Namen der Komponente.

Das ``@subpackage`` Tag ist optional. Wenn es angegeben wird, sollte es der Name der Subkomponente sein, ohne den
Präfix der Klasse. Im obigen Beispiel ist die Annahme das die Klasse in der Datei entweder "``Zend_Magic_Wand``"
ist oder den Klassennamen als Teil seines Präfixes verwendet.

.. _coding-standards.inline-documentation.functions:

Funktionen
^^^^^^^^^^

Jede Funktion, auch Objekt Methoden, müssen einen Docblock haben welcher mindestens folgendes enthält:

- Eine Beschreibung der Funktion

- Alle Argumente

- Alle möglichen Rückgabewerte

Es ist nicht notwendig das "@access" Tag zu verwenden, weil das Accesslevel bereits vom "public", "private" oder
"protected" Modifikator bekannt ist wenn die Funktion deklariert wird.

Wenn eine Funktion oder Methode eine Ausnahme werfen könnte, muß @throws für alle bekannten Exception Klassen
verwendet werden:

.. code-block:: php
   :linenos:

   @throws exceptionclass [Beschreibung]



.. _`Lizenz`: http://framework.zend.com/license
.. _`http://phpdoc.org">`: http://phpdoc.org/
