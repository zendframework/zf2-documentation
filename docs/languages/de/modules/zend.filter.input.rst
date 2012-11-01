.. EN-Revision: none
.. _zend.filter.input:

Zend\Filter\Input
=================

``Zend\Filter\Input`` bietet ein ausgezeichnetes Interface um mehrere Filter und Prüfer zu assoziieren, Sie
Kollektionen von Daten hinzuzufügen, und Eingabewerte zu empfangen nachdem diese durch die Filter und Prüfer
bearbeitet wurden. Werte werden standardmäßig in kommentiertem Format zurückgegeben für sichere *HTML* Ausgabe.

Angenommen das diese Klasse ein Käfig für externe Daten ist. Daten betreten die Anwendung von externen Quellen,
wie *HTTP* Anfrageparameter, *HTTP* Header, ein Web Service, oder sogar durch Lesen von eine Datenbank oder anderen
Dateien. Daten werden zuerst in den Käfig gesperrt, und die Anwendung kann diese Daten nur dann Stück für Stück
empfangen wenn dem Käfig gesagt wird, was diese Daten sein sollten und wie geplant ist diese zu verwenden. Der
Käfig inspiziert die Daten auf Gültigkeit. Es kann passieren das er die Datenwerte kommentiert für den
entsprechenden Kontext. Der Käfig entlässt die Daten nur wen diese alle Notwendigkeiten komplett erfüllen. Mit
einem einzigen und bequemen Interface, wird gutes Programmierverhalten ermöglicht und es lässt Entwickler
darüber nachdenken wie die Daten verwendet werden.

- **Filter** wandeln Eingabewerte um, inden Sie Zeichen in dem Wert entfernen oder Ändern. Das Ziel ist es
  Eingabewerte zu "normalisieren" bis diese einem erwarteten Format entsprechen. Zum Beispiel, wenn ein String von
  nummerischen Zeichen benötigt wird, und der Eingabewert "abc123" ist dann könnte eine erwartete Umwandlung die
  Änderung des Wertes in den String "123" sein.

- **Prüfer** prüfen Eingabewerte gegenüber Kriterien und melden ob diese den Test bestanden haben oder nicht.
  Der Wert wird nicht geändert, aber die Prüfung kann fehlschlagen. Zum Beispiel, wenn ein String wie eine Email
  Adresse aussehen muß, und der Eingabewert "abc123" ist, dann wird der Wert als nicht gültig angenommen.

- **Auskommentierer** wandeln einen Wert um indem Sie magisches Verhalten von bestimmten Zeichen entfernen. In
  einigen Ausgabekontexten haben speziellen Zeichen eine Bedeutung. Zum Beispiel das Zeichen '<' und '>' begrenzen
  *HTML* Tags, und wenn ein String diese Zeichen enthält und in einem *HTML* Kontext ausgegeben wird, könnte der
  Inhalt zwischen Ihnen die Ausgabe oder Funktionalität der *HTML* Präsentation beeinflussen. Das auskommentieren
  der Zeichen entfernt die spezielle Bedeutung, damit Sie als literale Zeichen ausgegeben werden.

Um ``Zend\Filter\Input`` zu verwenden, müssen die folgenden Schritte unternommen werden:

. Filter und Prüfregeln deklarieren

. Filter und Prüfbearbeiter erstellen

. Eingabedaten bereitstellen

. Geprüfte Felder und andere Reports erhalten

Die folgenden Sektionen beschreiben die Schritte für die Verwendung dieser Klasse.

.. _zend.filter.input.declaring:

Filter und Prüfregeln deklarieren
---------------------------------

Vor der Erstellung einer Instanz von ``Zend\Filter\Input``, muß ein Array von Filterregeln deklariert werden und
auch ein Array von Prüfregeln. Dieses assoziative Array verbindet einen Regelnamen mit einem Filter oder Prüfer
oder einer Kette von Filtern oder Prüfern.

Das folgende Beispiel eines Sets von Filterregeln deklariert, daß das Feld 'month' von ``Zend\Filter\Digits``
gefiltert wird, und das Feld 'account' von ``Zend\Filter\StringTrim`` gefiltert wird. Anschließend wird ein Set
von Prüfregeln deklariert welches prüft dass das Feld 'account' nur dann gültig ist wenn es nur alphabetische
Zeichen enthält.

.. code-block:: php
   :linenos:

   $filters = array(
       'month'   => 'Digits',
       'account' => 'StringTrim'
   );

   $validators = array(
       'account' => 'Alpha'
   );

Jeder Schlüssel im obigen ``$filters`` Array ist der Name einer Regel die auf einen Filter für ein spezielles
Datenfeld angewendet wird. Standardmäßig, ist der Name der Regel auch der Name des Feldes der Eingabedaten auf
welche die Regel angewendet werden soll.

Eine Regel kann in verschiedenen Formaten deklariert werden:

- Ein einfacher skalarer String, der einem Klassennamen entspricht:

  .. code-block:: php
     :linenos:

     $validators = array(
         'month'   => 'Digits',
     );

- Die Instanz eines Objektes einer der Klassen die ``Zend\Filter\Interface`` oder ``Zend\Validate\Interface``
  implementieren.

  .. code-block:: php
     :linenos:

     $digits = new Zend\Validate\Digits();

     $validators = array(
         'month'   => $digits
     );

- Ein Array um eine Kette von Filtern oder Prüfern zu deklarieren. Die Elemente dieses Arrays können Strings sein
  die Klassennamen entsprechen oder Filter/Prüfobjekte, wie in den oben beschriebenen Fällen. Zusätzlich kann
  eine dritte Wahl verwendet werden: Ein Array das einen String enthält der dem Klassennamen entspricht gefolgt
  von Argumenten die dessen Konstruktor übergeben werden.

  .. code-block:: php
     :linenos:

     $validators = array(
         'month'   => array(
             'Digits',                // String
             new Zend\Validate\Int(), // Objekt Instanz
             array('Between', 1, 12)  // String mit Konstruktor Argumenten
         )
     );

.. note::

   Wenn ein Filter oder Prüfer mit Konstruktor Argumenten in einem Array deklariert wird, muß ein Array für die
   Regel erstellt werden, selbst wenn die Regel nur einen Filter oder Prüfer enthält.

Es kann ein spezieller "Wildcard" Regelschlüssel **'*'**, entweder im Array des Filters oder im Array des
Prüfers, verwendet werden. Das bedeutet das der Filter oder Prüfer der in dieser Regel deklariert wird allen
Feldern der Eingabedaten zugewiesen wird. Es gilt zu beachten das die Reihenfolge der Einträge im Array des
Filters oder im Array des Prüfers bedeutend ist; die Regeln werden in der gleichen Reihenfolge zugewiesen in dem
diese deklariert wurden.

.. code-block:: php
   :linenos:

   $filters = array(
       '*'     => 'StringTrim',
       'month' => 'Digits'
   );

.. _zend.filter.input.running:

Filter und Prüfbearbeiter erstellen
-----------------------------------

Nachdem die Filter und Prüfarrays deklariert wurden, können diese als Argumente im Konstruktor von
``Zend\Filter\Input`` verwendet werden. Das gibt ein Objekt zurück welches alle Filter- und Prüfregeln kennt, und
das verwendet werden kann um ein oder mehrere Sets von Eingabedaten zu bearbeiten.

.. code-block:: php
   :linenos:

   $input = new Zend\Filter\Input($filters, $validators);

Man kann Eingabedaten als drittes Argument im Konstruktor spezifizieren. Die Datenstruktur ist ein assoziatives
Array. Die superglobalen Standardvariablen in *PHP*, ``$_GET`` und ``$_POST``, sind Beispiele für dieses Format.
Man kann jede dieser Variablen als Eingabedaten für ``Zend\Filter\Input`` verwenden.

.. code-block:: php
   :linenos:

   $data = $_GET;

   $input = new Zend\Filter\Input($filters, $validators, $data);

Alternativ kann die ``setData()`` Methode verwendet werden, indem ein assoziatives Array von Schlüssel/Werte
Paaren, im selben Format wie oben beschrieben, übergeben wird.

.. code-block:: php
   :linenos:

   $input = new Zend\Filter\Input($filters, $validators);
   $input->setData($newData);

Die ``setData()`` Methode definiert Daten nocheinmal, in einem existierenden ``Zend\Filter\Input`` Objekt ohne die
Filter- und Prüfregeln zu verändern. Wenn diese Methode verwendet wird können die selben Regeln, an anderen Sets
von Eingabedaten, wieder verwendet werden.

.. _zend.filter.input.results:

Geprüfte Felder und andere Reporte empfangen
--------------------------------------------

Nachdem Filter und Prüfer deklariert wurden und der Eingabeprozessor erstellt wurde, können Reporte von
fehlenden, unbekannten und ungültigen Feldern empfangen werden. Man kann auch die Werte der Felder erhalten,
nachdem die Filter angewendet wurden.

.. _zend.filter.input.results.isvalid:

Abfragen ob die Eingabe gültig ist
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wenn alle Eingabedaten die Prüfregeln bestanden haben, gibt die ``isValid()`` Methode ``TRUE`` zurück. Wenn
irgendein Feld ungültig ist oder ein benötigtes Feld fehlt, gibt die ``isValid()`` Methode ``FALSE`` zurück.

.. code-block:: php
   :linenos:

   if ($input->isValid()) {
     echo "OK\n";
   }

Diese Methode akzeptiert ein optionales String Argument, das ein individuelles Feld benennt. Wenn das spezifizierte
Feld die Prüfung passiert und bereit ist um abgeholt zu werden, gibt ``isValid('fieldName')`` den Wert ``TRUE``
zurück.

.. code-block:: php
   :linenos:

   if ($input->isValid('month')) {
     echo "Feld 'month' ist OK\n";
   }

.. _zend.filter.input.results.reports:

Ungültige, fehlende oder unbekannte Felder erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Ungültige** Felder sind jene, die einen oder mehrere Ihrer Prüfungen nicht bestehen.

- **Fehlende** Felder sind jene die nicht in den Eingabedaten vorhanden sind, aber im Metakommando
  ``'presence'=>'required'`` (Siehe die :ref:`spätere Sektion <zend.filter.input.metacommands.presence>` über
  Metakommandos) deklariert wurden.

- **Unbekannte** Felder sind jene die in keiner einzigen Regel, im Array der Prüfer, deklariert wurden, aber in
  den Eingabedaten vorkommen.

.. code-block:: php
   :linenos:

   if ($input->hasInvalid() || $input->hasMissing()) {
     $messages = $input->getMessages();
   }

   // getMessages() gibt einfach die Zusammenfassung von getInvalid()
   // und getMissing() zurück

   if ($input->hasInvalid()) {
     $invalidFields = $input->getInvalid();
   }

   if ($input->hasMissing()) {
     $missingFields = $input->getMissing();
   }

   if ($input->hasUnknown()) {
     $unknownFields = $input->getUnknown();
   }

Das Ergebnis der ``getMessages()`` Methode ist ein assoziatives Array, das die Regelnamen einem Array von
Fehlermeldungen, relativ zu diesen Regeln, zuordnet. Es ist anzumerken das der Index dieses Arrays der Name der
Regel ist die in der Regeldeklaration verwendet wird, und welche von den Namen der Felder, die von der Regel
geprüft werden, unterschiedlich sein kann.

Die ``getMessages()`` Methode gibt eine Zusammenfassung der Arrays zurück die von ``getInvalid()`` und
``getMissing()`` retourniert werden. Diese Methoden geben Subsets der Nachrichten zurück, relativ zu den
Prüffehlern, oder Felder die als benötigt deklariert wurden aber in der Eingabe fehlen.

Die ``getErrors()`` Methode gibt ein assoziatives Array zurück, in dem die Regelnamen einem Array von Fehler
Identifizierern entsprechen. Fehler Identifizierer sind fixe Strings, um Gründe für eine fehlgeschlagene
Prüfung, zu identifizieren, wobei Nachrichten selbst geändert werden können. Siehe :ref:`dieses Kapitel
<zend.validate.introduction.using>` für mehr Informationen.

Die Nachricht die von ``getMissing()`` zurückgegeben wird kann als Argument beim ``Zend\Filter\Input``
Konstruktor, oder durch verwenden der ``setOptions()`` Methode, spezifiziert werden.

.. code-block:: php
   :linenos:

   $options = array(
       'missingMessage' => "Feld '%field%' wird benötigt"
   );

   $input = new Zend\Filter\Input($filters, $validators, $data, $options);

   // alternative Methode:

   $input = new Zend\Filter\Input($filters, $validators, $data);
   $input->setOptions($options);

Und man kann auch einen Übersetzer hinzufügen der einem die Möglichkeit bietet mehrere Sprachen für die
Meldungen anzubieten welche von ``Zend\Filter\Input`` zurückgegeben werden.

.. code-block:: php
   :linenos:

   $translate = new Zend\Translator_Adapter\Array(array(
       'content' => array(
           Zend\Filter\Input::MISSING_MESSAGE => "Wo ist das Feld?"
       )
   );

   $input = new Zend\Filter\Input($filters, $validators, $data);
   $input->setTranslator($translate);

Wenn man einen anwendungsweiten Übersetzer verwendet, dann wird dieser von ``Zend\Filter\Input`` verwendet. In
diesem Fall muss man den Übersetzer nicht manuell setzen.

Das Ergebnis der ``getUnknown()`` Methode ist ein assoziatives Array, in dem die Feldnamen den Feldwerten
zugeordnet werden. Feldnamen werden in diesem Fall als Arrayschlüssel verwendet, statt als Regelnamen, weil keine
Regel die Feld erwähnt die unbekannte Felder sind.

.. _zend.filter.input.results.escaping:

Gültige Felder bekommen
^^^^^^^^^^^^^^^^^^^^^^^

Alle Felder die entweder ungültig, fehlend oder unbekannt sind, werden als gültig angenommen. Man kann Werte für
diese Felder erhalten indem ein magischer Accessor verwendet wird. Es gibt auch die nicht-magische Accessor
Methoden ``getEscaped()`` und ``getUnescaped()``.

.. code-block:: php
   :linenos:

   $m = $input->month;                 // Ausgabe vom magischen Accessor kommentieren
   $m = $input->getEscaped('month');   // Ausgabe kommentieren
   $m = $input->getUnescaped('month'); // nicht kommentieren

Standardmäßig, wenn ein Wert empfangen wird, wird er mit ``Zend\Filter\HtmlEntities`` gefiltert. Das ist der
Standard weil angenommen wird, das die am meisten übliche Verwendung, die Ausgabe von Werten von einem Feld in
*HTML* ist. Der HtmlEntities Filter hilft ungewollten Ausgaben von Code vorzubeugen, welche zu Sicherheitsproblemen
führen könnten.

.. note::

   Wie oben gezeigt, kann man unkommentierte Werte erhalten undem die ``getUnescaped()`` Methode verwendet wird,
   aber man muß dafür Code schreiben um die Werte sicher zu verwenden, und Sicherheitsprobleme, wie
   Verletzbarkeit für Seitenübergreifende Skript Attacken zu vermeiden.

.. warning::

   **Ungeprüfte Felder escapen**

   Wie vorher erwähnt gibt ``getEscaped()`` nur geprüfte Felder zurück. Felder die keine zugeordnete Prüfung
   haben können auf diesem Weg nicht empfangen werden. Trotzdem gibt es einen möglichen Weg. Man kann eine leere
   Prüfung für alle Felder hinzufügen.

   .. code-block:: php
      :linenos:

      $validators = array('*' => array());

      $input = new Zend\Filter\Input($filters, $validators, $data, $options);

   Aber es sei gewarnt das die Verwendung dieser Schreibweise eine Sicherheitslücke eröffnet welche für
   Cross-Site Scripting Attacken verwendet werden könnte. Deswegen sollte man immer individuelle Prüfungen für
   jedes Feld setzen.

Es kann ein anderer Filter für das auskommentieren von Werten definiert werden, durch seine Spezifikation im Array
der Optionen des Konstruktors:

.. code-block:: php
   :linenos:

   $options = array('escapeFilter' => 'StringTrim');
   $input = new Zend\Filter\Input($filters, $validators, $data, $options);

Alternativ kann die ``setDefaultEscapeFilter()`` Methode verwendet werden:

.. code-block:: php
   :linenos:

   $input = new Zend\Filter\Input($filters, $validators, $data);
   $input->setDefaultEscapeFilter(new Zend\Filter\StringTrim());

Bei jeder Verwendung, kann der Kommentarfilter als String Basisname der Filterklasse, oder als Objektinstanz einer
Filterklasse, spezifiziert werden. Der Kommentarfilter kann eine Instanz einer Filterkette, oder ein Objekt der
``Zend_Filter`` Klasse sein.

Filter die Ausgaben kommentieren sollen auf diesen Weg ausgeführt werden, um sicherzustellen das Sie nach der
Prüfung ausgeführt werden. Andere Filter, die im Array der Filterregeln deklariert werden, werden bei den
Eingabedaten angewendet bevor diese Daten geprüft werden. Wenn Kommentarfilter vor der Prüfung ausgeführt
werden, würde der Prozess der Prüfung viel komplexer sein um sowohl kommentierte als auch unkommentierte
Versionen der Daten anzubieten. Deswegen wird empfohlen, Filter die Ausgaben mit ``setDefaultEscapeFilter()``
kommentieren, nicht im ``$filters`` Array zu deklarieren.

Es gibt nur eine ``getEscaped()`` Methode, und deswegen kann nur ein Filter für das kommentieren spezifiziert
werden (trotzdem kann dieser Filter eine Filterkette sein). Wenn eine einzelne Instanz von ``Zend\Filter\Input``
benötigt wird, um kommentierte Ausgaben zu erhalten, und mehr als eine Filtermethode angewendet werden soll,
sollte ``Zend\Filter\Input`` erweitert werden und neue Methoden in der Subklasse implementiert werden um Wert auf
unterschiedlichen Wegen zu erhalten.

.. _zend.filter.input.metacommands:

Metakommandos verwenden um Filter oder Prüfregeln zu kontrollieren
------------------------------------------------------------------

Zusätzlich zum deklarieren der Übereinstimmungen von Feldern zu Filtern oder Prüfer, können einige
"Metakommandos" in der Array Deklaration spezifiziert werden um einige optionale Verhaltensweisen von
``Zend\Filter\Input`` zu kontrollieren. Metakommandos treten als String-indizierte Einträge in einem gegebenen
Filter- oder Prüfarray Wert auf.

.. _zend.filter.input.metacommands.fields:

Das FIELDS Metakommando
^^^^^^^^^^^^^^^^^^^^^^^

Wenn der Name der Regel für einen Filter oder Prüfer anders lautet als das Feld in welchem er angewendet werden
soll, kann der Feldname mit dem 'fields' Metakommando spezifiziert werden.

Dieses Metakommando kann durch Verwendung der Klassenkonstanten ``Zend\Filter\Input::FIELDS`` statt der Angabe
eines Strings spezifiziert werden.

.. code-block:: php
   :linenos:

   $filters = array(
       'month' => array(
           'Digits',        // Namen als Integer Index [0] filtern
           'fields' => 'mo' // Namen als String Index ['fields'] filtern
       )
   );

Im obigen Beispiel wendet die Filterregel den 'digits' Filter am Eingabefeld, das 'mo' heißt, an. Der String
'month' wird einfach ein mnemonischer Schlüsselfür diese Filterregel; er wird nicht als Filtername verwendet wenn
der Filter mit dem 'fields' Metakommando spezifiziert wird, aber er wird als Regelname verwendet.

Der Standardwert des 'fields' Metakommandos ist der Index der aktuellen Regel. Im obigen Beispiel wird die Regel,
wenn das 'fields' Metakommando nicht spezifiziert wird, auf das Eingabefeld das 'month' heißt, angewendet.

Eine weitere Verwendung des 'fields' Metakommandos ist es Felder für Filter oder Prüfer zu spezifizieren die
mehrere Felder als Eingabe benötigen. Wenn das 'fields' Metakommando ein Array ist, ist das Argument des
korrespondierenden Filters oder Prüfers ein Array mit den Werten dieser Felder. Zum Beispiel ist es für Benutzer
üblich einen Passwort String in zwei Feldern zu spezifizieren, und diese müssen den selben String in beide Felder
eingeben. Man kann zum Beispiel eine Prüfklasse implmentieren die ein Array Argument annimmt, und ``TRUE``
zurückgibt wenn alle Werte im Array identisch zum jeweils anderen sind.

.. code-block:: php
   :linenos:

   $validators = array(
       'password' => array(
           'StringEquals',
           'fields' => array('password1', 'password2')
       )
   );
   //  Inkludiert die hypotetische Klasse Zend\Validate\StringEquals,
   // übergibt dieser ein Array Argument das den Wert der beiden Eingabe
   // Datenfelder enthält die 'password1' und 'password2' heißen.

Wenn die Prüfung dieser Regel fehlschlägt wird der Schlüssel der Regel ('password') im Rückgabewert von
``getInvalid()`` verwendet und nicht eine der benannten Felder im 'fields' Metakommando.

.. _zend.filter.input.metacommands.presence:

Das PRESENCE Metakommando
^^^^^^^^^^^^^^^^^^^^^^^^^

Jeder Eintrag im Prüfarray kann ein Metakommando haben das 'presence' heißt. Wenn der Wert dieses Metakommandos
'required' ist muß dieses Feld in den Eingabedaten existieren, andernfalls wird es als fehlendes Feld gemeldet.

Das Metakommando kann auch spezifiziert werden indem die Klassenkonstante ``Zend\Filter\Input::PRESENCE`` statt dem
String verwendet wird.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           'presence' => 'required'
       )
   );

Der Standardwert dieses Metakommandos ist 'optional'.

.. _zend.filter.input.metacommands.default:

Das DEFAULT_VALUE Metakommando
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wenn ein Feld, für das ein Wert mit dem 'default' Metakommando für diese Regel, in den Eigabedaten vorhanden ist,
nimmt das Feld den Wert dieses Metakommandos.

Dieses Metakommando kann auch spezifiziert werden indem die Klassenkonstante ``Zend\Filter\Input::DEFAULT_VALUE``
statt einem String verwendet wird.

Der Standardwert wird dem Feld zugeordnet bevor irgendeiner der Prüfungen stattfindet. Der Standardwert wird dem
Feld nur für die aktuelle Regel zugeordnet; wenn das selbe Weld in einer folgenden Regel referenziert wird, hat
dieses Feld keinen Wert wenn diese Regel evaluiert wird. Deshalb können verschiedene Regeln auch verschiedene
Standardwerte für ein gegebenes Feld deklarieren.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           'default' => '1'
       )
   );

   // kein Wert für das 'month' Feld
   $data = array();

   $input = new Zend\Filter\Input(null, $validators, $data);
   echo $input->month; // gibt 1 aus

Wenn eine Regel das ``FIELDS`` Metakommando verwendet um ein Array mit mehrfachen Feldern zu definieren, kann ein
Array für das ``DEFAULT_VALUE`` Metakommando definiert werden und der Standard der korrespondierenden Schlüssel
wird für alle fehlenden Felder verwendet. Wenn ``FIELDS`` mehrfache Felder definiert aber ``DEFAULT_VALUE`` nur
ein skalarer Wert ist, dann wird dieser Standardwert als Wert für alle fehlenden Feldern im Array verwendet.

Es gibt keinen Standardwert für dieses Metakommando.

.. _zend.filter.input.metacommands.allow-empty:

Das ALLOW_EMPTY Metakommando
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Standardmäßig, wenn ein Feld in den Eingabedaten existiert, wird Ihm der Prüfer zugeordnet selbst wenn der Wert
des Feldes ein leerer String ist (**''**). Das kann zu einem Fehler in der Prüfung führen. Zum Beispiel, wenn ein
Prüfer auf Ziffern prüft und es keine gibt weil ein leerer String keine Zeichen hat, weil der Prüfer dann die
Daten als fehlerhaft meldet.

Wenn, in eigenen Fällen, ein leerer String als gültig angenommen werden soll, kann das Metakommando 'allowEmpty'
auf ``TRUE`` gesetzt werden. Dann passieren die Eingabedaten die Prüfung wenn sie in den Eingabedaten vorhanden
sind, aber der Wert ein leerer String ist.

Dieses Metakommando kann spezifiziert werden indem die Klassenkonstante ``Zend\Filter\Input::ALLOW_EMPTY`` statt
einem String verwendet wird.

.. code-block:: php
   :linenos:

   $validators = array(
       'address2' => array(
           'Alnum',
           'allowEmpty' => true
       )
   );

Der Standardwert dieses Metakommandos ist ``FALSE``.

Im unüblichen Fall das eine Prüfregel mit keinem Prüfer definiert wird, aber das 'allowEmpty' Metakommando
``FALSE`` ist (was bedeutet, dass das Feld als ungültig angenommen wird wenn es leer ist), gibt
``Zend\Filter\Input`` eine Standard Fehlermeldung zurück die mit ``getMessages()`` empfangen werden kann. Diese
Meldung kann spezifiziert werden indem die 'notEmptyMessage' als Argument für den ``Zend\Filter\Input``
Constructor verwendet wird oder indem die ``setOptions()`` Methode verwendet wird.

.. code-block:: php
   :linenos:

   $options = array(
       'notEmptyMessage' => "Ein nicht-leerer Wert wird für das Feld '%field%' benötigt"
   );

   $input = new Zend\Filter\Input($filters, $validators, $data, $options);

   // alternative Methode:

   $input = new Zend\Filter\Input($filters, $validators, $data);
   $input->setOptions($options);

.. _zend.filter.input.metacommands.break-chain:

Das BREAK_CHAIN Metakommando
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Standardmäßig, wenn eine Regel mehr als einen Prüfer hat werden alle Prüfer auf die Eingabe angewendet, und die
resultierende Nachricht enthält alle Fehlermeldungen die durch die Eingabe verursacht wurden.

Alternativ, wenn der Wert des 'breakChainOnFailure' Metakommandos ``TRUE`` ist, terminiert die Prüfkette nachdem
der erste Prüfer fehlschlägt. Die Eingabedaten werden nicht gegen nachfolgende Prüfer in der Kette geprüft. Sie
können also weitere Fehlschläge verursachen selbst wenn der eine, der gemeldet wurde, korrigiert wird.

Dieses Metakommando kann spezifiziert werden indem die Klassenkonstante ``Zend\Filter\Input::BREAK_CHAIN`` statt
einem String verwendet wird.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'Digits',
           new Zend\Validate\Between(1,12),
           new Zend\Validate\GreaterThan(0),
           'breakChainOnFailure' => true
       )
   );
   $input = new Zend\Filter\Input(null, $validators);

Der Standardwert dieses Metakommandos ist ``FALSE``.

Die Klasse der Prüfketten, ``Zend_Validate``, ist flexibler was das Durchbrechen von ausgeführten Ketten betrifft
als ``Zend\Filter\Input``. Mit der ersten Klasse, kann eine Option gesetzt werden um die Kette, für jeden Prüfer
in der Kette, bei Fehlern unabhängig von jedem anderen Prüfer abzubrechen. Mit der anderen Klasse wird der
definierte Wert des 'breakChainOnFailure' Metakommandos für eine Regel, einheitlich für alle Regeln in der Regel,
angewendet. Wenn eine flexiblere Verwendung benötigt wird, sollte die Prüfkette selbst erstellt werden und diese
als Objekt in der Definition der Prüfregel verwendet werden:

.. code-block:: php
   :linenos:

   // Prüfkette mit nicht einheitlichen breakChainOnFailure Attributen
   // erstellen
   $chain = new Zend\Validate\Validate();
   $chain->addValidator(new Zend\Validate\Digits(), true);
   $chain->addValidator(new Zend\Validate\Between(1,12), false);
   $chain->addValidator(new Zend\Validate\GreaterThan(0), true);

   // Prüfregeln deklarieren welche die oben definierte Kette verwenden
   $validators = array(
       'month' => $chain
   );
   $input = new Zend\Filter\Input(null, $validators);

.. _zend.filter.input.metacommands.messages:

Das MESSAGES Metakommando
^^^^^^^^^^^^^^^^^^^^^^^^^

Man kann Fehlermeldungen für jeden Prüfer in einer Regel spezifizieren indem das 'messages' Metakommando
verwendet wird. Der Wert dieses Metakommandos variiert, je nachdem ob man mehrere Prüfer in der Regel hat, oder ob
man die Nachricht für eine spezielles Fehlerereignis in einem angegebenen Prüfer setzen will.

Dieses Metakommando kann spezifiziert werden indem die Klassenkonstante ``Zend\Filter\Input::MESSAGES`` statt einem
String verwendet wird.

Anbei ist ein einfaches Beispiel wie eine Standard fehlermeldung für einen einzelnen Prüfer gesetzt wird.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           'messages' => 'Ein Monat darf nur aus Ziffern bestehen'
       )
   );

Wenn mehrere Prüfer vorhanden sind für die eine Fehlermeldung gesetzt werden soll, sollte ein Array für dem Wert
des 'messages' Metakommandos verwendet werden.

Jedes Element dieses Array wird dem Prüfer an der gleichen Indexposition zugeordnet. Man kann eine Nachricht für
die Prüfung an der Position **n** spezifizieren indem der Wert von **n** als Array Index verwendet wird. So kann
einigen Prüfern erlaubt werden Ihre eigenen Standardnachrichten zu verwenden, wärend die Nachricht für einen
nachfolgenden Prüfer in der Kette gesetzt wird.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           new Zend\Validate\Between(1, 12),
           'messages' => array(
               // Standardnachricht für Prüfer [0] verwenden
               // Neue Nachricht für Prüfer [1] setzen
               1 => 'Der Wert für Monat muß zwischen 1 und 12 sein'
           )
       )
   );

Wenn einer der Prüfer mehrere Fehlermeldungen besitzt, werden diese durch Nachrichten Schlüssel identifiziert. Es
gibt verschiedene Schlüssel in jeder Prüfklasse, welche als Identifizierer für Fehlernachrichten fungieren, die
die entsprechende Prüfklasse erstellen kann. Jede Prüfklasse definiert Konstanten für Ihre
Nachrichtenschlüssel. Diese Schlüssel können im 'messages' Metakommando verwendet werden indem Sie als
assoziatives Array übergeben werden statt als String.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits', new Zend\Validate\Between(1, 12),
           'messages' => array(
               'Ein Monat darf nur aus Ziffern bestehen',
               array(
                   Zend\Validate\Between::NOT_BETWEEN =>
                       'Der Wert %value% vom Monat sollte zwischen ' .
                       '%min% und %max% sein',
                   Zend\Validate\Between::NOT_BETWEEN_STRICT =>
                       'Der Wert %value% vom Monat darf nur zwischen ' .
                       '%min% und %max% sein'
               )
           )
       )
   );

Es sollte für jede Prüfklasse in die Dokumentation gesehen werden, um zu wissen ob diese mehrere
Fehlernachrichten hat, welche Schlüssel die Nachrichten haben und welche Token im Nachrichtentemplate verwendet
werden können.

Wenn man nur eine Prüfung in der Prüfregel hat, oder aller verwendeten Prüfungen die gleiche Nachricht gesetzt
haben, dann kann auf Sie ohne zusätzliche Erstellung eines Arrays referiert werden:

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           new Zend\Validate\Between(1, 12),
           'messages' => array(
                           Zend\Validate\Between::NOT_BETWEEN =>
                               'Month value %value% must be between ' .
                               '%min% and %max%',
                           Zend\Validate\Between::NOT_BETWEEN_STRICT =>
                               'Month value %value% must be strictly between ' .
                               '%min% and %max%'
           )
       )
   );

.. _zend.filter.input.metacommands.global:

Verwenden von Optionen um Metakommandos für alle Regeln zu setzen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Der Standardwert für die 'allowEmpty', 'breakChainOnFailure', und 'presence' Metakommandos kann für alle Regeln
gesetzt werden indem das ``$options`` Argument für den Konstruktor von ``Zend\Filter\Input`` verwendet wird. Das
erlaubt das Setzen des Standardwertes für alle Regeln, ohne dass das Metakommando für jede Regel gesetzt werden
muß.

.. code-block:: php
   :linenos:

   // Der Standard wird bei allen Feldern gesetzt und erlaubt einen leeren String.
   $options = array('allowEmpty' => true);

   // Diese Regeldefinition kann überschrieben werden, wenn ein Feld keinen leeren
   // String akzeptieren soll
   $validators = array(
       'month' => array(
           'Digits',
           'allowEmpty' => false
       )
   );

   $input = new Zend\Filter\Input($filters, $validators, $data, $options);

Die 'fields', 'messages', und 'default' Metakommandos können nicht mit dieser Technik gesetzt werden.

.. _zend.filter.input.namespaces:

Namensräume für Filterklassen hinzufügen
----------------------------------------

Standardmäßig, wenn ein Filter oder Prüfer als String deklariert wird, sucht ``Zend\Filter\Input`` nach der
korrespondierenden Klasse unter dem ``Zend_Filter`` oder ``Zend_Validate`` Namensraum. Ein Filter der zum Beispiel
nach dem String 'digits' benannt ist wird in der Klasse ``Zend\Filter\Digits`` gefunden.

Wenn eigene Filter oder Prüfklassen geschrieben werden, oder Filter oder Prüfer von Drittanbietern verwendet
werden, können diese Klassen in einem anderen Namensraum als ``Zend_Filter`` oder ``Zend_Validate`` existieren.
``Zend\Filter\Input`` kann mitgeteilt werden, das in zusätzlichen Namensräumen gesucht werden soll. Namensräume
können in den Konstruktor Optionen spezifiziert werden:

.. code-block:: php
   :linenos:

   $options = array('filterNamespace' => 'My_Namespace_Filter',
                    'validatorNamespace' => 'My_Namespace_Validate');
   $input = new Zend\Filter\Input($filters, $validators, $data, $options);

Alternativ kann die ``addValidatorPrefixPath($prefix, $path)`` oder die ``addFilterPrefixPath($prefix, $path)``
Methoden verwendet werden, welche direkt auf den Plugin Lader verweisen der von ``Zend\Filter\Input`` verwendet
wird:

.. code-block:: php
   :linenos:

   $input->addValidatorPrefixPath('Other_Namespace', 'Other/Namespace');
   $input->addFilterPrefixPath('Foo_Namespace', 'Foo/Namespace');

   // Die Suchrichtung für die Prüfungen ist jetzt:
   // 1. My_Namespace_Validate
   // 1. My_Namespace
   // 3. Zend_Validate

   // Die Suchrichtung für die Filter ist jetzt:
   // 1. My_Namespace_Filter
   // 2. Foo_Namespace
   // 3. Zend_Filter

``Zend_Filter`` ``und Zend_Validate`` können als Namensraum nicht entfernt werden, es können nur Namensräume
hinzugefügt werden. Benutzerdefinierte Namensräume werden zuerst durchsucht, Zend Namensräume werden zuletzt
durchsucht.

.. note::

   Ab der Version 1.5 sollte die Funktion ``addNamespace($namespace)`` nicht mehr verwendet werden und wurde durch
   den Plugin Lader getauscht. Und ``addFilterPrefixPath()`` sowie ``addValidatorPrefixPath()`` wurden
   hinzugefügt. Auch die Konstante ``Zend\Filter\Input::INPUT_NAMESPACE`` sollte jetzt nicht mehr verwendet
   werden. Die Konstanten ``Zend\Filter\Input::VALIDATOR_NAMESPACE`` und ``Zend\Filter\Input::FILTER_NAMESPACE``
   sind seit den Releases nach 1.7.0 vorhanden.

.. note::

   Seit Version 1.0.4 wurde ``Zend\Filter\Input::NAMESPACE``, der den Wert ``namespace`` hatte, auf
   ``Zend\Filter\Input::INPUT_NAMESPACE``, mit dem Wert ``inputNamespace`` geändert, um der Reservierung des
   Schlüsselwortes ``namespace`` ab *PHP* 5.3 gerecht zu werden.


