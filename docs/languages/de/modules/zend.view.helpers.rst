.. EN-Revision: none
.. _zend.view.helpers:

View Helfer
===========

In deinen View Skripten ist es oft notwendig, bestimmte komplexe Funktionen immer wieder auszuführen, z.B. Datum
formatieren, Formularelemente erstellen oder Links für Aktionen anzuzeigen. Du kannst Helferklassen verwenden, um
diese Aufgaben für dich durchführen zu lassen.

Ein Helfer ist einfach eine Klasse. Nehmen wir an wir wollen einen Helfer der 'fooBar' heißt. Standardmäßig wird
der Klasse 'Zend\View\Helper\_' vorangestellt (Es kann ein eigener Prefix definiert werden wenn ein Pfad für die
Helfer definiert wird), und das letzte Segment des Klassennamens ist der Name des Helfers; Dieses Segment sollte
Titel Großgeschrieben sein; der volle Klassenname ist dann: ``Zend\View_Helper\FooBar``. Diese Klasse sollte
mindestens eine einzelne Methode enthalten, die nach dem Helfer benannt und camelCased ist: ``fooBar()``.

.. note::

   **Betrachte den Fall**

   Namen von Helfern sind immer camelCased, bzw. beginnen Sie nie mit einem großgeschriebenen Zeichen. Der
   Klassenname selbst ist MixedCased, aber die Methode die aktuell ausgeführt wird ist camelCased.

.. note::

   **Standard Helfer Pfad**

   Der Standard Helfer Pfad zeigt immer zu den View Helfern des Zend Frameworks, normalerweise 'Zend/View/Helper/'.
   Selbst wenn ``setHelperPath()`` ausgerufen wird um den existierenden Pfad zu überschreiben, wird dieser Pfad
   gesetzt um sicherzustellen das die Standard Helfer arbeiten.

Um einen Helfer in deinem View Skript zu verwenden, rufe ihn mittels ``$this->helperName()`` auf. Im Hintergrund
wird ``Zend_View`` die Klasse ``Zend\View_Helper\HelperName`` laden, eine Objektinstanz der Klasse erstellen und
deren Methode ``helperName()`` aufrufen. Die Objektinstanz bleibt innerhalb der ``Zend_View`` Instanz bestehen und
wird bei allen weiteren Aufrufen von ``$this->helperName()`` wiederverwendet.

.. _zend.view.helpers.initial:

Vorhandene Helfer
-----------------

``Zend_View`` enthält bereits einige vorhandene Helferklassen, die sich alle auf die Erstellung von
Formularelementen beziehen und die notwendige Maskierung der Ausgaben automatisch vornehmen. Zusätzlich gibt es
Helfer zum Erstellen Routen-basierter *URL*\ S and *HTML* Listen, genauso wie für das Deklarieren von Variablen.
Die aktuell gelieferten Helfer beinhalten:

- ``declareVars()``: Primär benutzt mit ``strictVars()``, kann dieser Helfer verwendet werden um template
  Variablen zu deklarieren welche bereits, oder noch nicht, im View Objekt bereits gesetzt sind, sowie auch
  Standard Werte. Arrays welche als Argument dieser Methode übergeben werden, werden verwendet um Standard Werte
  zu setzen; Andernfalls, wenn die Variable nicht existiert, wird diese mit einem leeren String gesetzt.

- ``fieldset($name, $content, $attribs)``: Erstellt ein *XHTML* Fieldset. Wenn ``$attribs`` einen 'legend'
  Schlüssel enthält, wird der Wert für die Fieldset Beschriftung verwendet. Das Fieldset wird ``$content``
  umfassen wie vom Helfer angeboten.

- ``form($name, $attribs, $content)``: Erzeugt eine *XHTML* Form. Alle ``$attribs`` werden als *XHTML* Attribute
  des Form Tags escaped und dargestellt. Wenn ``$content`` vorhanden und kein boolsches ``FALSE`` ist, dann wird
  dieser Inhalt innerhalb der Start und End Form Tags dargestellt werden; wenn ``$content`` ein boolsches ``FALSE``
  ist (der Standard), wird nur das beginnende Formtag erzeugt.

- ``formButton($name, $value, $attribs)``: Erstellt ein <button /> Element.

- ``formCheckbox($name, $value, $attribs, $options)``: Erstellt ein <input type="checkbox" /> Element.

  Standardmäßig, wenn kein $value angegeben und keine $options vorhanden sind, wird '0' als ungecheckter Wert,
  und '1' als gecheckter Wert angenommen. Wenn ein $value übergeben wird, aber keine $options vorhanden sind, wird
  der gecheckte Wert and der übergebene Wert angenommen.

  $options sollte ein Array sein. Wenn das Array indiziert ist, ist der erste Wert der gecheckte Wert, und der
  zweite der ungecheckte Wert; alle anderen Werte werden ignoriert. Es kann auch ein assoziatives Array mit den
  Schlüsseln 'checked' und 'unChecked' übergeben werden.

  Wenn $options übergeben wurden und $value mit dem gecheckten Wert übereinstimmt, dann wird das Element als
  gecheckt markiert. Das Element kann auch als gecheckt oder ungecheckt markiert werden indem ein boolscher Wert
  für das Attribut 'checked' übergeben wird.

  Das obige wird möglicherweise am besten mit einigen Beispielen zusammengefasst:

  .. code-block:: php
     :linenos:

     // '1' und '0' als gecheckte/ungecheckte Optionen; nicht gecheckt
     echo $this->formCheckbox('foo');

     // '1' und '0' als gecheckte/ungecheckte Optionen; gecheckt
     echo $this->formCheckbox('foo', null, array('checked' => true));

     // 'bar' und '0' als gecheckte/ungecheckte Optionen; nicht gecheckt
     echo $this->formCheckbox('foo', 'bar');

     // 'bar' und '0' als gecheckte/ungecheckte Optionen; gecheckt
     echo $this->formCheckbox('foo', 'bar', array('checked' => true));

     // 'bar' und 'baz' als gecheckte/ungecheckte Optionen; nicht gecheckt
     echo $this->formCheckbox('foo', null, null, array('bar', 'baz'));

     // 'bar' und 'baz' als gecheckte/ungecheckte Optionen; nicht gecheckt
     echo $this->formCheckbox('foo', null, null, array(
         'checked' => 'bar',
         'unChecked' => 'baz'
     ));

     // 'bar' und 'baz' als gecheckte/ungecheckte Optionen; gecheckt
     echo $this->formCheckbox('foo', 'bar', null, array('bar', 'baz'));
     echo $this->formCheckbox('foo',
                              null,
                              array('checked' => true),
                              array('bar', 'baz'));

     // 'bar' und 'baz' als gecheckte/ungecheckte Optionen; nicht gecheckt
     echo $this->formCheckbox('foo', 'baz', null, array('bar', 'baz'));
     echo $this->formCheckbox('foo',
                              null,
                              array('checked' => false),
                              array('bar', 'baz'));

  In allen Fällen, wird das Markup einem versteckten Element mit dem nicht gecheckten Wert vorangestellt; auf
  diesem Weg erhält man trotzdem einen gültigen Wert von der Form selbst wenn der Wert nicht gecheckt wird.

- ``formErrors($errors, $options)``: Erzeugt eine ungeordnete *XHTML* Liste und zeigt Fehler an. ``$errors`` sollte
  ein String oder ein Array von Strings sein; ``$options`` sollte irgendein Attribut sein das im beginnenden List
  Tag platziert werden soll.

  Es kann alternativer beginnender, schließender und seperierter Inhalt spezifiziert werden wenn Fehler
  dargestellt werden durch aufruf von verschiedenen Methoden auf dem Helfer:

  - ``setElementStart($string)``; Standard ist '<ul class="errors"%s"><li>', wobei %s mit den in ``$options``
    spezifizierten Attributen ersetzt wird.

  - ``setElementSeparator($string)``; Standard ist '</li><li>'.

  - ``setElementEnd($string)``; Standard ist '</li></ul>'.

- ``formFile($name, $attribs)``: Erstellt ein <input type="file" /> Element.

- ``formHidden($name, $value, $attribs)``: Erstellt ein <input type="hidden" /> Element.

- ``formLabel($name, $value, $attribs)``: Erstellt ein <label> Element, setzt das ``for`` Attribut auf ``$name``,
  und den aktuellen Labeltext auf ``$value``. Wenn **disable** an ``attribs`` übergeben wird, wird nichts
  zurückgegeben.

- ``formMultiCheckbox($name, $value, $attribs, $options, $listsep)``: Erstellt eine Liste von Checkboxen.
  ``$options`` sollte ein assoziatives Array sein und kann beliebig tief werden. ``$value`` kann ein einzelner Wert
  oder ein Array von ausgewählten Werten sein die Schlüsseln im ``$options`` Array entsprechen. ``$listsep`` ist
  standardmäßig ein *HTML* Break ("<br />"). Standardmäßig wird dieses Element als Array behandelt; alle
  Checkboxen teilen den gleichen Namen, und werden als Array übertragen.

- ``formPassword($name, $value, $attribs)``: Erstellt ein <input type="password" /> Element.

- ``formRadio($name, $value, $attribs, $options)``: Erstellt eine Reihe von <input type="radio" /> Elementen, eine
  für jeden der $options Elemente. Im $options Array ist der Elementschlüssel der Wert und der Elementwert die
  Bezeichnung des Radio-Buttons. Der $value Radiobutton wird für dich vorgewählt.

- ``formReset($name, $value, $attribs)``: Erstellt ein <input type="reset" /> Element.

- ``formSelect($name, $value, $attribs, $options)``: Erstellt einen <select>...</select> block mit einer
  <option>one für jedes $options Element. Im $options Array ist der Elementschlüssel der Optionswert und der
  Elementwert die Optionsbezeichnung. Die $value Optionen werden für dich vorgewählt.

- ``formSubmit($name, $value, $attribs)``: Erstellt ein <input type="submit" /> Element.

- ``formText($name, $value, $attribs)``: Erstellt ein <input type="text" /> Element.

- ``formTextarea($name, $value, $attribs)``: Erstellt einen <textarea>...</textarea> Block.

- ``url($urlOptions, $name, $reset)``: Erstellt einen *URL* String basierend auf dem Namen der Route.
  ``$urlOptions`` sollte ein assoziatives Array von Schlüßel/Werte Paaren sein, welche bon der speziellen Route
  verwendet wird.

- ``htmlList($items, $ordered, $attribs, $escape)``: erzeugt ungeordnete und geordnete Listen welche auf den
  ``$items`` basieren die übergeben wurden. Wenn ``$items`` ein multidimensionales Array ist, wird eine
  verschachtelte Liste gebaut. Wenn das ``$escape`` Flag ``TRUE`` ist (standard), werden individuelle Abschnitte
  escaped durch Verwendung des Escaping Mechanismus der im View Objekt registriert wurde; ein ``FALSE`` Wert wird
  übergeben wenn Markups in den Listen gewünscht werden.

Die Verwendung dieser Helfer in deinem View Skript ist sehr einfach, hier ist ein Beispiel. Beachte, dass du diese
Helfer nur aufzurufen brauchst; sie werden automatisch geladen und instanziiert, sobald sie benötigt werden.

.. code-block:: php
   :linenos:

   // Innerhalb deines View Skriptes, verweist $this auf die Zend_View
   // Instanz.
   //
   // Sagen wir, dass du bereits eine Serie von Auswahlwerten der Variable
   // $countries in Form eines Arrays zugewiesen hast
   // ('us' => 'United States', 'il' => 'Israel', 'de' => 'Germany')
   ?>
   <form action="action.php" method="post">
       <p><label>Deine Email:
   <?php echo $this->formText('email', 'you@example.com', array('size' => 32)) ?>
       </label></p>
       <p><label>Dein Land:
   <?php echo $this->formSelect('country', 'us', null, $this->countries) ?>
       </label></p>
       <p><label>Möchtest Du hinzugefügt werden?
   <?php echo $this->formCheckbox('opt_in', 'yes', null, array('yes', 'no')) ?>
       </label></p>
   </form>

Die Ausgabe des View Skriptes wird in etwa so aussehen:

.. code-block:: php
   :linenos:

   <form action="action.php" method="post">
       <p><label>Deine Email:
           <input type="text" name="email" value="you@example.com" size="32" />
       </label></p>
       <p><label>Dein Land:
           <select name="country">
               <option value="us" selected="selected">Amerika</option>
               <option value="il">Israel</option>
               <option value="de">Deutschland</option>
           </select>
       </label></p>
       <p><label>Möchtest Du hinzugefügt werden?
           <input type="hidden" name="opt_in" value="no" />
           <input type="checkbox" name="opt_in" value="yes" checked="checked" />
       </label></p>
   </form>

.. include:: zend.view.helpers.action.rst
.. include:: zend.view.helpers.base-url.rst
.. include:: zend.view.helpers.currency.rst
.. include:: zend.view.helpers.cycle.rst
.. include:: zend.view.helpers.partial.rst
.. include:: zend.view.helpers.placeholder.rst
.. include:: zend.view.helpers.doctype.rst
.. include:: zend.view.helpers.head-link.rst
.. include:: zend.view.helpers.head-meta.rst
.. include:: zend.view.helpers.head-script.rst
.. include:: zend.view.helpers.head-style.rst
.. include:: zend.view.helpers.head-title.rst
.. include:: zend.view.helpers.html-object.rst
.. include:: zend.view.helpers.inline-script.rst
.. include:: zend.view.helpers.json.rst
.. include:: zend.view.helpers.navigation.rst
.. include:: zend.view.helpers.translator.rst
.. _zend.view.helpers.paths:

Helfer Pfade
------------

Wie bei den View Skripten kann der Controller für ``Zend_View`` auch einen Stapel an Pfaden festlegen, in dem nach
Hilfsklassen gesucht werden soll. Standardmäßig sucht ``Zend_View`` in "Zend/View/Helper/\*" nach Hilfsklassen.
Du kannst ``Zend_View`` mit Hilfe der Methoden ``setHelperPath()`` und ``addHelperPath()`` mitteilen, auch in
anderen Verzeichnissen zu suchen. Zusätzlich kann man einen Klassenpräfix angeben, um Helfer in dem bereit
gestellten Pfad verwenden zu können, um eigene Namensräume für die Helferklassen zu verwenden. Standardmäßig
wird 'Zend\View\Helper\_' angenommen, wenn kein Präfix angegeben wird.

.. code-block:: php
   :linenos:

   $view = new Zend\View\View();

   // Setze den Pfad auf /path/to/more/helpers, mit dem Präfix 'My_View_Helper'
   $view->setHelperPath('/path/to/more/helpers', 'My_View_Helper');

Durch Verwendung der ``addHelperPath()`` Methode können die Pfade "gestapelt" werden. Wenn du Pfade zu diesem
Stapelspeicher hinzufügst, wird ``Zend_View`` im zuletzt hinzugefügten Pfad nach der angeforderten Hilfsklasse
schauen. Dies erlaubt dir, zu den vorhandenen Helfern weitere hinzufügen oder diese durch eigene zu ersetzen.

.. code-block:: php
   :linenos:

   $view = new Zend\View\View();
   // Füge /path/to/some/helpers mit Klassenpräfix 'My_View_Helper' hinzu
   $view->addHelperPath('/path/to/some/helpers', 'My_View_Helper');
   // Füge /other/path/to/helpers mit Klassenpräfix 'Your_View_Helper' hinzu
   $view->addHelperPath('/other/path/to/helpers', 'Your_View_Helper');

   // wenn nun $this->helperName() aufgerufen wird, wird Zend_View zuerst nach
   // "/path/to/some/helpers/HelperName" mit dem Klassennamen
   // "Your_View_Helper_HelperName", dann nach
   // "/other/path/to/helpers/HelperName.php" mit dem Klassennamen
   // "My_View_Helper_HelperName", und zuletzt nach
   // "Zend/View/Helpers/HelperName.php" mit dem Klassennamen
   // "Zend\View_Helper\HelperName" schauen.

.. _zend.view.helpers.custom:

Eigene Helfer schreiben
-----------------------

Eigene Helfer zu schreiben ist einfach; du mußt nur diese Regeln befolgen:

- Wärend das nicht strikt notwendig ist, ist es empfohlen entweder ``Zend\View_Helper\Interface`` zu
  implementieren oder ``Zend\View_Helper\Abstract`` zu erweitern wenn eigene Helfer erstellt werden. Eingeführt
  mit 1.6.0, definieren diese einfach die ``setView()`` Methode; trotzdem, in kommenden Releases, ist es geplant
  ein Strategy Pattern zu implementieren das vieles der Namensschemas einfacher mach wie anbei beschrieben. Wenn
  darauf aufgebaut wird hilft das, das der eigene Code Zukunftssicher ist.

- Der Klassenname muss mindestens auf den Helfernamen unter Verwendung der MixedCaps selber enden. Wenn du z.B.
  einen Helfer mit Namen "specialPurpose" schreibst, muss der Klassenname mindestens "SpecialPurpose" lauten. Man
  kann, und sollte, dem Klassennamen einen Präfix geben und es wird empfohlen, 'View_Helper' als Teil des Präfix
  zu verwenden: "My_View_Helper_SpecialPurpose" (man muss den Präfix mit oder oder abschließenden Unterstrich an
  ``addHelperPath()`` oder ``setHelperPath()`` übergeben).

- Die Klasse muss eine öffentliche Methode mit dem Namen des Helfers haben. Dies ist die Methode, welche vom View
  Skript durch "$this->specialPurpose()" aufgerufen wird. In unserem "specialPurpose" Beispiel, würde die
  notwendige Deklaration dieser Methode "public function specialPurpose()" lauten.

- Im Allgemeinen sollte die Klasse keine Ausgaben durch echo(), print() oder auf andere Weise erstellen.
  Stattdessen sollte es die auszugebenen Werte zurückgeben. Die zurückgegebenen Werte sollten entsprechend
  maskiert werden.

- Diese Klasse muss sich in einer Datei befinden, die nach der Helfermethode benannt ist. Bezogen auf unser
  "specialPurpose" Beispiel, muss der Dateiname "SpecialPurpose.php" lauten.

Platziere die Hilfsklasse irgendwo in deinem Stapelspeicher für Hilfspfade und ``Zend_View`` wird den Helfer
automatisch für dich laden, instanziieren, speichern und ausführen.

Hier ist ein Beispiel für unseren ``SpecialPurpose`` Helfer:

.. code-block:: php
   :linenos:

   class My_View_Helper_SpecialPurpose extends Zend\View_Helper\Abstract
   {
       protected $_count = 0;
       public function specialPurpose()
       {
           $this->_count++;
           $output = "Ich habe 'The Jerk' {$this->_count} Mal(e) gesehen.";
           return htmlspecialchars($output);
       }
   }

Dann rufst du in einem View Skript den ``SpecialPurpose`` Helfer so oft auf, wie du möchtest; er wird einmal
instanziiert und bleibt für die Lebensdauer der ``Zend_View`` Instanz bestehen.

.. code-block:: php
   :linenos:

   // denke daran, dass $this in deinem View Skript auf die
   // Zend_View Instanz verweist.
   echo $this->specialPurpose();
   echo $this->specialPurpose();
   echo $this->specialPurpose();

Die Ausgabe wird in etwa so aussehen:

.. code-block:: php
   :linenos:

   Ich habe 'The Jerk' 1 Mal(e) gesehen.
   Ich habe 'The Jerk' 2 Mal(e) gesehen.
   Ich habe 'The Jerk' 3 Mal(e) gesehen.

Hier und da ist es notwendig das aufrufende ``Zend_View`` Objekt aufzurufen -- zum Beispiel, wenn es notwendig ist
die registrierte Verschöüsselung zu verwenden, oder wenn ein anderes View Skript gerendert werden soll, als Teil
des eigenen Helfers. Um Zugriff zum View Objekt zu erhalten, sollte die eigene Helfer Klasse eine
``setView($view)`` Methode wie folgt besitzen:

.. code-block:: php
   :linenos:

   class My_View_Helper_ScriptPath
   {
       public $view;

       public function setView(Zend\View\Interface $view)
       {
           $this->view = $view;
       }

       public function scriptPath($script)
       {
           return $this->view->getScriptPath($script);
       }
   }

Wenn die Helfer Klasse eine ``setView()`` Methode hat, wird diese aufgerufen wenn die Helfer Klasse das erste Mal
instanziert wird, und das aktuelle View Objekt übergeben wird. Es liegt an einem selbst das Objekt in der Klasse
zu fixieren, genau so wie herauszufinden wie auf dieses zugegriffen werden sollte.

Wenn ``Zend\View_Helper\Abstract`` erweitert wird, muß diese Methode nicht selbst definiert werden da Sie schon
vordefiniert ist.

.. _zend.view.helpers.registering-concrete:

Konkrete Helper registrieren
----------------------------

Manchmal ist es bequem einen View Helfer zu instanzieren, und diesen dann in der View zu registrieren. Ab Version
1.10.0 ist es jetzt möglich die Methode ``registerHelper()`` zu verwenden, welche zwei Argumente erwartet: das
Helfer Objekt, und den Namen mit dem es registriert wird.

.. code-block:: php
   :linenos:

   $helper = new My_Helper_Foo();
   // ...etwas konfigurieren oder dependency injection durchführen...

   $view->registerHelper($helper, 'foo');

Wenn der Helfer eine ``setView()`` Methode hat, wird das View Objekt diese aufrufen und sich selbst bei der
Registrierung in den Helfer injizieren.

.. note::

   **Helfer-Namen sollten einer Methode entsprechen**

   Das zweite Argument von ``registerHelper()`` ist der Name des Helfers. Eine entsprechender Methodenname sollte
   im Helfer existieren; andernfalls ruft ``Zend_View`` eine nicht existierende Methode aus wenn der Helfer
   ausgeführt wird, was einen fatalen *PHP* Fehler verursacht.


