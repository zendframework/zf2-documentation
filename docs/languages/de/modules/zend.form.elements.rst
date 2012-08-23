.. EN-Revision: none
.. _zend.form.elements:

Erstellen von Form Elementen mit Hilfe von Zend_Form_Element
============================================================

Ein Formular ist aus Elementen gemacht, die typischerweise mit einer *HTML* Form Eingabe korrespondieren.
``Zend_Form_Element`` kapselt einzelne Formularelemente mit den folgenden Bereichen die erfüllt werden sollen:

- Prüfung (ist der übertragene Wert gültig?)

  - Fangen von Fehlercodes und Nachrichten von Prüfungen

- Filtern (wie wird das Element in Anführungsstriche gesetzt oder normalisiert bevor die Prüfung stattfinden
  und/oder für die Ausgabe?)

- Darstellung (wie wird das Element angezeigt?)

- Metadaten und Attribute (welche Informationen qualifizieren das Element näher?)

Die Basisklasse, ``Zend_Form_Element``, hat begründete Standardwerte für viele Fälle, aber es ist am besten die
Klasse zu erweitern für oft verwendete speziell benötigte Elemente. Zusätzlich wird Zend Framework mit einer
Anzahl an Standard *XHTML* Elementen ausgeliefert; über diese kann im :ref:`Kapitel über Standard Elemente
<zend.form.standardElements>` nachgelesen werden.

.. _zend.form.elements.loaders:

Plugin Loader
-------------

``Zend_Form_Element`` verwendet :ref:`Zend_Loader_PluginLoader <zend.loader.pluginloader>` um es Entwicklern zu
erlauben Orte für alternative Prüfungen, Filter und Dekoratoren zu definieren. Jeder hat seinen eigenen Plugin
Loader assoziiert, und generelle Zugriffspunkte werden verwendet um jeden zu empfangen oder zu ändern.

Die folgenden Ladetypen werden mit den verschiedenen Plugin Loader Methoden verwendet: 'validate', 'filter', und
'decorator'. Die Typnamen sind unabhängig von der Schreibweise.

Die Methoden die für die Interaktion mit Plugin Loadern verwendet werden, sind die folgenden:

- ``setPluginLoader($loader, $type)``: ``$loader`` ist das Plugin Loader Objekt selbst, während ``$type`` eine der
  oben spezifizierten Typen ist. Das setzt den Plugin Loader für den gegebenen Typ auf das neu spezifizierte
  Loader Objekt.

- ``getPluginLoader($type)``: Empfängt den mit ``$type`` assoziierten Plugin Loader.

- ``addPrefixPath($prefix, $path, $type = null)``: Fügt eine Präfix/Pfad Assoziation hinzu, Wenn ``$type``
  ``FALSE`` ist, wird versucht den Pfad zu allen Loadern hinzuzufügen durch anhängen des Präfix von jedem
  "\_Validate", "\_Filter", und "\_Decorator"; und anhängen des Pfades an "Validate/", "Filter/", und
  "Decorator/". Wenn alle extra Formular Elementklassen unter einer üblichen Hirarchie stehen, ist das die
  bequemste Methode für das Setzen von grundsätzlichen Präfixen.

- ``addPrefixPaths(array $spec)``: Erlaubt es viele Pfade auf einmal zu einem oder mehreren Plugin Loadern
  hinzuzufügen. Sie erwartet das jedes Arrayelement ein Array mit den Sclüsseln 'path', 'prefix' und 'type' ist.

Eigene Prüfungen, Filter und Dekoratoren sind ein einfacher Weg um Funktionalität zwischen Forms zu teilen und
eigene Funktionalitäten zu kapseln.

.. _zend.form.elements.loaders.customLabel:

.. rubric:: Eigenes Label

Ein üblicher Verwendungszweck ist es Ersetzungen für Standardklassen anzubieten. Zum Beispiel wenn man eine
andere Implementation des 'Label' Dekorators anbieten will -- zum Beispiel um immer einen Bindestrich anzufügen --
dann könnte man einen eigenen 'Label' Dekorator mit einem eigenen Klassenpräfix erstellen, und diesen zum eigenen
Präfix Pfad hinzufügen.

Beginnen wir mit einem eigenen Label Dekorator. Wir geben ihm den Klassenpräfix "My_Decorator", und die Klasse
selbst wird in der Datei "My/Decorator/Label.php" sein.

.. code-block:: php
   :linenos:

   class My_Decorator_Label extends Zend_Form_Decorator_Abstract
   {
       protected $_placement = 'PREPEND';

       public function render($content)
       {
           if (null === ($element = $this->getElement())) {
               return $content;
           }
           if (!method_exists($element, 'getLabel')) {
               return $content;
           }

           $label = $element->getLabel() . ':';

           if (null === ($view = $element->getView())) {
               return $this->renderLabel($content, $label);
           }

           $label = $view->formLabel($element->getName(), $label);

           return $this->renderLabel($content, $label);
       }

       public function renderLabel($content, $label)
       {
           $placement = $this->getPlacement();
           $separator = $this->getSeparator();

           switch ($placement) {
               case 'APPEND':
                   return $content . $separator . $label;
               case 'PREPEND':
               default:
                   return $label . $separator . $content;
           }
       }
   }

Jetzt kann dem Element mitgeteilt werden diesen Plugin Pfad zu verwenden wenn nach Dekoratoren gesucht wird:

.. code-block:: php
   :linenos:

   $element->addPrefixPath('My_Decorator', 'My/Decorator/', 'decorator');

Alternativ kann das bei der Form gemacht werden um sicherzustellen das alle Dekoratore diesen Pfad verwenden:

.. code-block:: php
   :linenos:

   $form->addElementPrefixPath('My_Decorator', 'My/Decorator/', 'decorator');

Wird dieser Pfad hinzugefügt, wenn ein Dekorator hinzugefügt wird, wird der Pfad 'My/Decorator/' zuerst
durchsucht um zu sehen ob der Dekorator dort existiert. Als Ergebnis wird 'My_Decorator_Label' jetzt verwendet wenn
der 'Labe' Dekorator angefragt wird.

.. _zend.form.elements.filters:

Filter
------

Es ist oft nützlich und/oder notwendig einige Normalisierungen an Eingaben vorzunehmen, bevor diese geprüft
werden - zum Beispiel kann es gewünscht sein alles an *HTML* zu entfernen, aber die Prüfungen auf dem
verbleibenden durchzuführen um sicherzustellen, dass die Übertragung gültig ist. Oder man will Leerzeichen bei
Eingaben entfernen, damit eine StringLength Prüfung kein falsches "Korrekt" zurückgibt. Diese Operationen können
durchgeführt werden indem ``Zend_Filter`` verwendet wird, und ``Zend_Form_Element`` unterstützt Filterketten, was
es erlaubt mehrere, sequentielle Filter zu spezifizieren und anzupassen. Das Filtern geschieht während der
Prüfung und wenn der Wert des Elements über ``getValue()`` geholt wird:

.. code-block:: php
   :linenos:

   $filtered = $element->getValue();

Filter können der Kette auf zwei Wegen hinzugefügt werden:

- Übergabe einer konkreten Filterinstanz

- Angabe eines kurzen Filternamens

Sehen wir uns einige Beispiele an:

.. code-block:: php
   :linenos:

   // Konkrete Filterinstanz:
   $element->addFilter(new Zend_Filter_Alnum());

   // Kurzname des Filters:
   $element->addFilter('Alnum');
   $element->addFilter('alnum');

Kurznamen sind typischerweise der Filtername ohne den Präfix. Im Standardfall bedeutet das keinen 'Zend_Filter\_'
Präfix. Zusätzlich muss der erste Buchstabe nicht großgeschrieben werden.

.. note::

   **Eigene Filterklassen verwenden**

   Wenn man sein eigenes Set an Filterklassen hat, kann man ``Zend_Form_Element`` mitteilen diese zu verwenden
   indem ``addPrefixPath()`` verwendet wird. Wenn man zum Beispiel eigene Filter unter dem 'My_Filter' Präfix hat,
   kann ``Zend_Form_Element`` dies auf dem folgenden Weg mitgeteilt werden:

   .. code-block:: php
      :linenos:

      $element->addPrefixPath('My_Filter', 'My/Filter/', 'filter');

   (Beachten Sie, dass das dritte Agument indiziert welcher Plugin Loader auf welcher Aktion durchgeführt werden
   soll.)

Wenn man zu irgendeiner Zeit den ungefilterten Wert benötigt, kann die ``getUnfilteredValue()`` Methode verwendet
werden:

.. code-block:: php
   :linenos:

   $unfiltered = $element->getUnfilteredValue();

Für weitere Informationen über Filter, siehe die :ref:`Dokumentation über Zend_Filter
<zend.filter.introduction>`.

Die Methoden die mit Filtern assoziiert sind, beinhalten:

- ``addFilter($nameOfFilter, array $options = null)``

- ``addFilters(array $filters)``

- ``setFilters(array $filters)`` (Überschreibt alle Filter)

- ``getFilter($name)`` (Empfängt ein Filterobjekt durch seinen Namen)

- ``getFilters()`` (Empfängt alle Filter)

- ``removeFilter($name)`` (Entfernt einen Filter durch seinen Namen)

- ``clearFilters()`` (Entfernt alle Filter)

.. _zend.form.elements.validators:

Prüfungen
---------

Wenn man das Sicherheits-Mantra von "Eingabe filtern, Ausgabe escapen" unterschreibt dann wird man die Eingabe des
Formulars prüfen ("Eingabefilterung") wollen. In ``Zend_Form`` enthält jedes Element seine eigene Prüfkette, die
aus ``Zend_Validate_*`` Prüfungen besteht.

Prüfungen können der Kette auf zwei Wegen hinzugefügt werden:

- Übergabe einer konkreten Prüfinstanz

- Anbieten eines kurzen Prüfnamens

Einige Beispiele:

.. code-block:: php
   :linenos:

   // Konkrete Prüfinstanz:
   $element->addValidator(new Zend_Validate_Alnum());

   // Kurzer Prüfname:
   $element->addValidator('Alnum');
   $element->addValidator('alnum');

Kurznamen sind typischerweise der Prüfname ohne den Präfix. Im Standardfall bedeutet das, keinen
'Zend_Validate\_' Präfix. Zusätzlich muss der erste Buchstabe nicht großgeschrieben werden.

.. note::

   **Eigene Prüfklassen verwenden**

   Wenn man sein eigenes Set an Prüfklassen hat, kann man ``Zend_Form_Element`` mitteilen diese zu verwenden indem
   ``addPrefixPath()`` verwendet wird. Wenn man zum Beispiel eigene Prüfungen unter dem 'My_Validator' Präfix
   hat, kann ``Zend_Form_Element`` dies auf dem folgenden Weg mitgeteilt werden:

   .. code-block:: php
      :linenos:

      $element->addPrefixPath('My_Validator', 'My/Validator/', 'validate');

   (Beachten Sie dass das dritte Agument zeigt welcher Plugin Loader auf welcher Aktion durchgeführt werden soll)

Wenn eine bestimmte Prüfung fehlschlägt, und die Ausführung von späteren Prüfungen verhindert werden soll,
kann ein ``TRUE`` als zweiter Parameter übergeben werden:

.. code-block:: php
   :linenos:

   $element->addValidator('alnum', true);

Wenn ein Stringname verwendet wird, um eine Prüfung hinzuzufügen und die Prüfklasse Argumente in ihrem
Konstruktor akzeptiert, können diese als dritter Parameter an ``addValidator()`` als Array übergeben werden:

.. code-block:: php
   :linenos:

   $element->addValidator('StringLength', false, array(6, 20));

Argumente die auf diesem Weg übergeben werden, sollten in der Reihenfolge sein in der sie im Konstruktor definiert
sind. Das obige Beispiel instanziert die ``Zend_Validate_StringLenth`` Klasse mit den ``$min`` und ``$max``
Parametern:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength(6, 20);

.. note::

   **Eigene Fehlermeldungen für Prüfungen anbieten**

   Einige Entwickler wollen eigene Fehlermeldungen für eine Prüfung anbieten.
   ``Zend_Form_Element::addValidator()``'s ``$options`` Argument erlaubt es das zu tun, indem der Schlüssel
   'messages' angegeben wird und ein Array mit Schlüssel/Wert Paaren genutzt wird für das Setzen der Nachrichten
   Templates. Man muss die Fehlermeldungen der betreffenden Prüfung für die verschiedenen Fehlertypen von
   Prüfungen kennen.

   Eine bessere Option ist es ``Zend_Translator_Adapter`` in Formular zu verwenden. Fehlercodes werden automatisch
   dem Adapter durch den Standardmäßigen Fehlerdekorator übergeben; man kann durch die Erstellung von
   Übersetzungen eigene Fehlermeldungen für die verschiedenen Fehlercodes der Prüfung definieren.

Es können auch viele Prüfungen auf einmal gesetzt werden, indem ``addValidators()`` verwendet wird. Die
grundsätzliche Verwendung ist es ein Array von Arrays zu übergeben, wobei jedes Array ein bis drei Werte
enthält, die dem Konstruktor von ``addValidator()`` entsprechen:

.. code-block:: php
   :linenos:

   $element->addValidators(array(
       array('NotEmpty', true),
       array('alnum'),
       array('stringLength', false, array(6, 20)),
   ));

Wenn man wortreicher oder expliziter sein will, dann können die Arrayschlüssel 'validator',
'breakChainOnFailure', und 'options' verwendet werden:

.. code-block:: php
   :linenos:

   $element->addValidators(array(
       array(
           'validator'           => 'NotEmpty',
           'breakChainOnFailure' => true),
       array('validator' => 'alnum'),
       array(
           'validator' => 'stringLength',
           'options'   => array(6, 20)),
   ));

Die Verwendung ist gut für die Illustration wie Prüfungen in einer Konfigurationsdatei definiert werden können:

.. code-block:: ini
   :linenos:

   element.validators.notempty.validator = "NotEmpty"
   element.validators.notempty.breakChainOnFailure = true
   element.validators.alnum.validator = "Alnum"
   element.validators.strlen.validator = "StringLength"
   element.validators.strlen.options.min = 6
   element.validators.strlen.options.max = 20

Es ist zu beachten, dass jedes Element einen Schlüssel hat, egal ob er benötigt wird oder nicht; das ist eine
Einschränkung bei der Verwendung von Konfigurationsdateien -- aber es macht auch klar, für was die Argumente
stehen. Es ist einfach zu beachten das jede Prüfungsoption in der richtigen Reihenfolge spezifiziert werden muss.

Um ein Element zu prüfen, muss der Wert an ``isValid()`` übergeben werden:

.. code-block:: php
   :linenos:

   if ($element->isValid($value)) {
       // gülig
   } else {
       // ungültig
   }

.. note::

   **Die Prüfung findet an gefilterten Werte statt**

   ``Zend_Form_Element::isValid()`` filtert Werte durch die angegebene Filterkette vor der Überprüfung. Siehe das
   :ref:`Kapitel über Filter <zend.form.elements.filters>` für weitere Informationen.

.. note::

   **Prüfungskontext**

   ``Zend_Form_Element::isValid()`` unterstützt ein zusätzliches Argument ``$context``. ``Zend_Form::isValid()``
   übergibt ein komplettes Array von Daten die bearbeitet werden an ``$context``, wenn ein Formular geprüft wird
   und ``Zend_Form_Element::isValid()`` übergibt es an jede Prüfung. Das bedeutet, dass man Prüfungen schreiben
   kann, die auf die Daten die an andere Formulare übergeben werden acht geben. Als Beispiel nehmen wir ein
   Anmeldeformular, welches die Felder für Passwort und Passwort Wiederholung hat; eine Prüfung würde sein, dass
   beide Felder den selben Wert beinhalten. So eine Prüfung könnte wie folgt aussehen:

   .. code-block:: php
      :linenos:

      class My_Validate_PasswordConfirmation extends Zend_Validate_Abstract
      {
          const NOT_MATCH = 'notMatch';

          protected $_messageTemplates = array(
              self::NOT_MATCH => 'Die Passwortüberprüfung war nicht erfolgreich'
          );

          public function isValid($value, $context = null)
          {
              $value = (string) $value;
              $this->_setValue($value);

              if (is_array($context)) {
                  if (isset($context['password_confirm'])
                      && ($value == $context['password_confirm']))
                  {
                      return true;
                  }
              } elseif (is_string($context) && ($value == $context)) {
                  return true;
              }

              $this->_error(self::NOT_MATCH);
              return false;
          }
      }

Prüfungen werden in der Reihenfolge ausgeführt. Jede Prüfung wird ausgeführt solange bis eine Prüfung die mit
einem ``TRUE`` Wert für ``$breakChainOnFailure`` bei Ihrer Prüfung fehlschlägt. Man sollte sichergehen, dass
Prüfungen in einer begründeten Reihenfolge definiert werden.

Nach einer fehlgeschlagenen Prüfung können Fehlercodes und Nachrichten von der Prüfkette empfangen werden:

.. code-block:: php
   :linenos:

   $errors   = $element->getErrors();
   $messages = $element->getMessages();

(Achtung: zurückgegebene Fehlermeldungen sind ein assoziatives Array von Fehlercode/Fehlermeldung Paaren.)

Zusätzlich zu Prüfungen, kann spezifiziert werden, dass ein Element benötigt wird, indem ``setRequired($flag)``
verwendet wird. Standardmäßig ist dieses Flag ``FALSE``. In Kombination mit ``setAllowEmpty($flag)``
(Standardmäßig ``TRUE``) und ``setAutoInsertNotEmptyValidator($flag)`` (standardmäßig ``TRUE``), kann das
Verhalten der Prüfkette auf unterschiedliche Art und Weise verändert werden:

- Bei Verwendung der Standardwerte werden beim Prüfen eines Elements ohne der Übergabe eines Werts, oder der
  Übergabe eines leeren Strings, alle Prüfungen übersprungen und ``TRUE`` zurückgegeben.

- ``setAllowEmpty(false)`` prüft, wenn die anderen zwei erwähnten Flags unberührt bleiben, gegen die Prüfkette
  welche für dieses Element definiert wurde, unabhängig von dem an ``isValid()`` übergebenen Wert.

- ``setRequired(true)`` fügt, wenn die anderen zwei erwähnten Flags unberührt bleiben, eine 'NotEmpty' Prüfung
  an den Beginn der Prüfkette (wenn nicht bereits eine gesetzt wurde) wobei das ``$breakChainOnFailure`` Flag
  gesetzt wird. Das heißt, dass das Flag folgende semantische Bedeutung bekommt: Wenn kein Wert übergeben wird,
  wird die Übertragung sofort ungülig und der Benutzer wird informiert, was die anderen Prüfungen davon abhält,
  ausgeführt zu werden, auf Daten, von denen wir bereits wissen, dass sie ungültig sind.

  Wenn dieses Verhalten nicht gewünscht ist kann es durch die Übergabe eines ``FALSE`` Wert an
  ``setAutoInsertNotEmptyValidator($flag)`` ausgeschaltet werden; das verhindert, dass ``isValid()`` die 'NotEmpty'
  Prüfung in der Prüfkette platziert.

Für weitere Informationen über Prüfungen kann in die :ref:`Zend_Validate Dokumentation
<zend.validate.introduction>` gesehen werden.

.. note::

   **Verwenden von Zend_Form_Elements als generell-eingesetzte Prüfung**

   ``Zend_Form_Element`` implementiert ``Zend_Validate_Interface`` was bedeutet das ein Element auch als Prüfung
   füreinander verwendet werden kann, bezüglich nicht-Formular Prüfketten.

.. note::

   **Wann wird ein Element als leer erkannt?**

   Wie erwähnt wird der 'NotEmpty' Prüfer verwendet um zu erkennen ob ein Element leer ist oder nicht. Aber
   ``Zend_Validate_NotEmpty`` arbeitet standardmäßig nicht wie *PHP*'s ``empty()`` Methode.

   Das bedeutet, wenn ein Element ein Integer **0** oder einen **'0'** String enthält dann wird dieses Element als
   nicht leer engesehen. Wenn man ein anderes Verhalten will, muss man seine eigene Instanz von
   ``Zend_Validate_NotEmpty`` erstellen. Dort kann man das Verhalten dieser Prüfung definieren. Siehe
   `Zend_Validate_NotEmpty`_ für Details.

Die mit der Prüfung assoziierten Methoden sind:

- ``setRequired($flag)`` und ``isRequired()`` erlauben es den Status des 'required' Flag zu setzen und zu
  empfangen. Wenn der Wert auf ``TRUE`` gesetzt wird, erzwingt dieses Flag, dass das Element, in den Daten die von
  ``Zend_Form`` bearbeitet werden, vorhanden ist.

- ``setAllowEmpty($flag)`` und ``getAllowEmpty()`` erlauben es das Verhalten von optionalen Elementen (z.B.
  Elementen in denen das 'required' Flag ``FALSE`` ist) zu ändern. Wenn das 'allowEmpty' Flag ``TRUE`` ist, werden
  leere Werte nicht an die Prüfkette übergeben.

- ``setAutoInsertNotEmptyValidator($flag)`` erlaubt es zu definieren ob eine 'NotEmpty' Prüfung der Prüfkette
  vorangestellt wird wenn das Element benötigt wird. Standardmäßig ist dieses Flag ``TRUE``.

- ``addValidator($nameOrValidator, $breakChainOnFailure = false, array $options = null)``

- ``addValidators(array $validators)``

- ``setValidators(array $validators)`` (Überschreibt alle Prüfer)

- ``getValidator($name)`` (Empfängt ein Prüfobjekt durch seinen Namen)

- ``getValidators()`` (Empfängt alle Prüfer)

- ``removeValidator($name)`` (Entfernt einen Prüfer durch seinen Namen)

- ``clearValidators()`` (Entfernt alle Prüfer)

.. _zend.form.elements.validators.errors:

Eigene Fehlermeldungen
^^^^^^^^^^^^^^^^^^^^^^

Von Zeit zu Zeit ist es gewünscht ein oder mehrere spezielle Fehlermeldungen zu spezifizieren, die statt der
Fehlermeldungen verwendet werden sollen, die von den Validatoren verwendet werden, die dem Element angehängt sind.
Zusätzlich will man von Zeit zu Zeit ein Element selbst als ungültig markieren. Ab Version 1.6.0 des Zend
Frameworks ist diese Funktionalität über die folgenden Methoden möglich.

- ``addErrorMessage($message)``: Fügt eine Fehlermeldung hinzu, die bei Formular-Überprüfungs-Fehlern angezeigt
  wird. Sie kann mehr als einmal aufgerufen werden, und neue Meldungen werden dem Stack angehängt.

- ``addErrorMessages(array $messages)``: Fügt mehrere Fehlermeldungen hinzu, die bei
  Formular-Überprüfungs-Fehlern angezeigt werden.

- ``setErrorMessages(array $messages)``: Fügt mehrere Fehlermeldungen hinzu, die bei
  Formular-Überprüfungs-Fehlern angezeigt werden, und überschreibt alle vorher gesetzten Fehlermeldungen.

- ``getErrorMessages()``: Empfängt eine Liste von selbstdefinierten Fehlermeldungen, die vorher definiert wurden.

- ``clearErrorMessages()``: Entfernt alle eigenen Fehlermeldungen, die vorher definiert wurden.

- ``markAsError()``: Markiert das Element, wie, wenn die Überprüfung fehlgeschlagen wäre.

- ``hasErrors()``: Erkennt, ob ein Element eine Überprüfung nicht bestanden hat oder, ob es als ungültig
  markiert wurde.

- ``addError($message)``: Fügt einen Fehler zum eigenen Stack der Fehlermeldungen hinzu und markiert das Element
  als ungültig.

- ``addErrors(array $messages)``: Fügt mehrere Nachrichten zum eigenen Stack der Fehlermeldungen hinzu und
  markiert das Element als ungültig.

- ``setErrors(array $messages)``: Überschreibt den eigenen Stack der Fehlermeldungen mit den angegebenen Meldungen
  und markiert das Element als ungültig.

Alle Fehler die auf diesem Weg gesetzt werden, können übersetzt werden. Zusätzlich kann der Platzhalter
"%value%" eingefügt werden um den Wert des Elements zu repräsentieren; dieser aktuelle Wert des Element wird
eingefügt wenn die Fehlermeldung empfangen wird.

.. _zend.form.elements.decorators:

Dekoratoren
-----------

Ein möglicher Schmerzpunkt für viele Webentwickler, ist die Erstellung von *XHTML* Formularen selbst. Für jedes
Element muss der Entwickler das Markup für das Element selbst erstellen, typischerweise ein Label und, wenn sie
nett zu den Benutzern sind, das Markup für die Anzeige von Fehlermeldungen von Prüfungen. Je mehr Elemente auf
einer Seite sind, desto weniger trivial wird diese Aufgabe.

``Zend_Form_Element`` versucht dieses Problem durch die Verwendung von "Dekoratoren" zu lösen. Dekoratoren sind
Klassen die Zugriff auf das Element haben und eine Methode zur Darstellung des Inhalts bieten. Für weitere
Informationen darüber wie Dekoratoren arbeiten, kann im Kapitel über :ref:`Zend_Form_Decorator
<zend.form.decorators>` eingesehen werden.

Die von ``Zend_Form_Element`` verwendeten Standarddekoratoren sind:

- **ViewHelper**: Spezifiziert einen View Helfer der verwendet wird, um das Element darzustellen. Das 'helper'
  Attribut des Elements kann verwendet werden, um zu spezifizieren welcher View Helfer verwendet werden soll.
  Standardmäßig spezifiziert ``Zend_Form_Element`` den 'formText' View Helfer, aber individuelle Unterklassen
  spezifizieren unterschiedliche Helfer.

- **Errors**: Fügt Fehlermeldungen an das Element an, indem es ``Zend_View_Helper_FormErrors`` verwendet. Wenn
  keine vorhanden sind, wird nichts hinzugefügt.

- **Description**: Fügt dem Element eine Beschreibung hinzu. Wenn keine vorhanden ist, wird nichts angehängt.
  Standardmäßig wird die Beschreibung in einem <p> Tag dargestellt mit einer CSS Klasse namens 'description'.

- **HtmlTag**: Umschliesst das Element und Fehler in einem *HTML* <dd> Tag.

- **Label**: Stellt ein Label vor das Element, indem es ``Zend_View_Helper_FormLabel`` verwendet, und umschliesst
  es in einem <dt> Tag. Wenn kein Label angegeben wurde, wird nur das <dt> Tag dargestellt.

.. note::

   **Standard Dekoratoren müssen nicht geladen werden**

   Standardmäßig werden die Standarddekoratoren während der Initialisierung des Objekts geladen. Das kann durch
   die Übergabe der 'disableLoadDefaultDecorators' Option an den Konstruktor ausgeschaltet werden:

   .. code-block:: php
      :linenos:

      $element = new Zend_Form_Element('foo',
                                       array('disableLoadDefaultDecorators' =>
                                           true)
                                      );

   Diese Option kann mit jeder anderen Option gemischt werden die übergeben wird, sowohl als Array Option oder in
   einem ``Zend_Config`` Objekt.

Da die Reihenfolge, in der die Dekoratoren registriert werden, von Bedeutung ist -- der zuerst registrierte
Dekorator wird als erstes ausgeführt -- muss man sicherstellen, dass eigene Dekoratoren in der richtigen
Reihenfolge registriert werden, oder sicherstellen, dass die Platzierungs-Optionen in einem ausgewogenen Weg
gesetzt werden. Um ein Beispiel zu geben, ist hier ein Code der den Standarddekorator registriert:

.. code-block:: php
   :linenos:

   $this->addDecorators(array(
       array('ViewHelper'),
       array('Errors'),
       array('Description', array('tag' => 'p', 'class' => 'description')),
       array('HtmlTag', array('tag' => 'dd')),
       array('Label', array('tag' => 'dt')),
   ));

Der anfängliche Inhalt wird vom 'ViewHelper' Dekorator erstellt, welche das Formular Element selbst erstellt. Als
nächstes fängt der 'Errors' Dekorator Fehlermeldungen vom Element und, wenn welche vorhanden sind, übergibt er
sie an den 'FormErrors' View Helfer zur Darstellung. Wenn eine Beschreibung vorhanden ist, wird der 'Description'
Dekorator einen Paragraph der Klasse 'description' anhängen, der den beschreibenden Text für den betreffenden
Inhalt enthält. Der nächste Dekorator, 'HtmlTag', umschliesst das Element und die Fehler in ein *HTML* <dd> Tag.
Letztendlich, empfängt der letzte Dekorator, 'label' das Label des Elements und übergibt es an den 'FormLabel'
View Helfer, und umschliesst es in einen *HTML* <dt> Tag; der Wert wird dem Inhalt standardmäßig vorangestellt.
Die resultierende Ausgabe sieht grundsätzlich wie folgt aus:

.. code-block:: html
   :linenos:

   <dt><label for="foo" class="optional">Foo</label></dt>
   <dd>
       <input type="text" name="foo" id="foo" value="123" />
       <ul class="errors">
           <li>"123" ist kein alphanumerischer Wert</li>
       </ul>
       <p class="description">
           Das ist etwas beschreibender Text betreffend dem Element.
       </p>
   </dd>

Für weitere Informationen über Dekoratoren gibt es das :ref:`Kapitel über Zend_Form_Decorator
<zend.form.decorators>`.

.. note::

   **Mehrere Dekoratoren des gleichen Typs verwenden**

   Intern verwendet ``Zend_Form_Element`` eine Dekoratorklasse als Mechanismus für das Nachschauen wenn Dekoratore
   empfangen werden. Als Ergebnis, können mehrere Dekratoren nicht zur gleichen Zeit registriert werden;
   nachgeordnete Dekoratoren überschreiben jene, die vorher existiert haben.

   Um das zu umgehen, können **Aliase** verwendet werden. Statt der Übergabe eines Dekorators oder
   Dekoratornamens als erstes Argument an ``addDecorator()``, kann ein Array mit einem einzelnen Element übergeben
   werden, mit dem Alias der auf das Dekoratorobjekt oder -namen zeigt:

   .. code-block:: php
      :linenos:

      // Alias zu 'FooBar':
      $element->addDecorator(array('FooBar' => 'HtmlTag'),
                             array('tag' => 'div'));

      // Und es später erhalten:
      $decorator = $element->getDecorator('FooBar');

   In den ``addDecorators()`` und ``setDecorators()`` Methoden muss die 'decorator' Option im Array übergeben
   werden, welche den Dekorator repräsentiert:

   .. code-block:: php
      :linenos:

      // Zwei 'HtmlTag' Dekoratore hinzufügen, einen Alias auf 'FooBar' setzen:
      $element->addDecorators(
          array('HtmlTag', array('tag' => 'div')),
          array(
              'decorator' => array('FooBar' => 'HtmlTag'),
              'options' => array('tag' => 'dd')
          ),
      );

      // Und sie später empfangen:
      $htmlTag = $element->getDecorator('HtmlTag');
      $fooBar  = $element->getDecorator('FooBar');

Die folgenden Methoden sind mit Dekoratoren assoziiert:

- ``addDecorator($nameOrDecorator, array $options = null)``

- ``addDecorators(array $decorators)``

- ``setDecorators(array $decorators)`` (Überschreibt alle Dekoratoren)

- ``getDecorator($name)`` (Empfängt ein Dekoratorobjekt durch seinen Namen)

- ``getDecorators()`` (Empfängt alle Dekoratoren)

- ``removeDecorator($name)`` (Entfernt einen Dekorator durch seinen Namen)

- ``clearDecorators()`` (Entfernt alle Dekoratoren)

``Zend_Form_Element`` verwendet auch Überladung um die Darstellung von speziellen Dekoratoren zu erlauben.
``__call()`` interagiert mit Methoden auf mit dem Text 'render' anfangen und verwendet den Rest des Methodennamens
dazu um nach einen Dekorator zu suchen; wenn er gefunden wird, wird er diesen **einzelnen** Dekorator darstellen.
Jedes Argument das dem Methodenaufruf übergeben wird, wird als Inhalt für die Übergabe an die ``render()``
Methode des Dekorators verwendet. Als Beispiel:

.. code-block:: php
   :linenos:

   // Stellt nur den ViewHelper Dekorator dar:
   echo $element->renderViewHelper();

   // Nur den HtmlTag Dekorator darstellen, und Inhalt übergeben:
   echo $element->renderHtmlTag("Das ist der Inhalt des HTML Tags");

Wenn der Dekorator nicht existiert, wird eine Exception geworfen.

.. _zend.form.elements.metadata:

Metadaten und Attribute
-----------------------

``Zend_Form_Element`` behandelt eine Vielzahl von Attributen und Metadaten des Elements. Basisattribute sind:

- **name**: Der Name des Elements. Verwendet die Zugriffsmethoden ``setName()`` und ``getName()``.

- **label**: Das Label des Elements. Verwendet die Zugriffsmethoden ``setLabel()`` und ``getLabel()``.

- **order**: Der Index bei dem ein Element im Formular erscheinen soll. Verwendet die Zugriffsmethoden
  ``setOrder()`` und ``getOrder()``.

- **value**: Der aktuelle Wert des Elements. Verwendet die Zugriffsmethoden ``setValue()`` und ``getValue()``.

- **description**: Eine Beschreibung des Elements; wird oft verwendet um Tooltips oder Javascript mäßige Hinweise
  anzubieten die den Zweck des Elements beschreiben. Verwendet die Zugriffsmethoden ``setDescription()`` und
  ``getDescription()``.

- **required**: Ein Flag, das anzeigt ob ein Element benötigt wird wenn eine Prüfung des Formulars durchgeführt
  wird, oder nicht. Verwendet die Zugriffsmethoden ``setRequired()`` und ``getRequired()``. Dieses Flag ist
  standardmäßig ``FALSE``.

- **allowEmpty**: Ein Flag, das indiziert ob ein nicht benötigtes (optionales) Element versuchen soll leere Werte
  zu prüfen. Wenn es ``TRUE`` ist, und das 'required' Flag ``FALSE``, dann werden leere Werte nicht an die
  Prüfkette übergeben, und es wird ``TRUE`` angenommen. Verwendet die Zugriffsmethoden ``setAllowEmpty()`` und
  ``getAllowEmpty()``. Dieses Flag ist standardmäßig ``TRUE``.

- **autoInsertNotEmptyValidator**: Ein Flag, das indiziert, ob eine 'NotEmpty' Prüfung eingefügt werden soll,
  wenn das Element benötigt wird, oder nicht. Standardmäßig ist dieses Flag ``TRUE``. Das Flag kann mit
  ``setAutoInsertNotEmptyValidator($flag)`` gesetzt und der Wert mit ``autoInsertNotEmptyValidator()`` ermittelt
  werden.

Formular Elemente können zusätzliche Metadaten benötigen. Für *XHTML* Form Elemente zum Beispiel, kann es
gewünscht sein, Attribute wie die Klasse oder die Id zu spezifizieren. Für die Durchführung gibt es ein Set von
Zugriffsmethoden:

- **setAttrib($name, $value)**: Fügt ein Attribut hinzu

- **setAttribs(array $attribs)**: Wie addAttribs(), aber überschreibend

- **getAttrib($name)**: Empfägt einen einzelnen Attributwert

- **getAttribs()**: Empfängt alle Attribute als Schlüssel/Wert Paare

Die meiste Zeit kann auf sie, trotzdem, einfach als Objekteigenschaften zugegriffen werden, da
``Zend_Form_Element`` das Überladen realisiert und den Zugriff zu ihnen erlaubt:

.. code-block:: php
   :linenos:

   // Gleichbedeutend mit $element->setAttrib('class', 'text'):
   $element->class = 'text;

Standardmäßig werden alle Attribute, die an den View Helfer übergeben werden, auch vom Element während der
Darstellung verwendet, und als *HTML* Attribute des Element Tags dargestellt.

.. _zend.form.elements.standard:

Standard Elemente
-----------------

``Zend_Form`` wird mit einer Anzahl an Standardelementen ausgeliefert; lesen Sie das Kapitel über :ref:`Standard
Elemente <zend.form.standardElements>` für vollständige Details.

.. _zend.form.elements.methods:

Zend_Form_Element Methoden
--------------------------

``Zend_Form_Element`` hat viele, viele Methoden. Was folgt, ist eine kurze Zusammenfassung ihrer Signatur -
gruppiert nach Typ:

- Konfiguration:

  - ``setOptions(array $options)``

  - ``setConfig(Zend_Config $config)``

- I18n:

  - ``setTranslator(Zend_Translator_Adapter $translator = null)``

  - ``getTranslator()``

  - ``setDisableTranslator($flag)``

  - ``translatorIsDisabled()``

- Eigenschaften:

  - ``setName($name)``

  - ``getName()``

  - ``setValue($value)``

  - ``getValue()``

  - ``getUnfilteredValue()``

  - ``setLabel($label)``

  - ``getLabel()``

  - ``setDescription($description)``

  - ``getDescription()``

  - ``setOrder($order)``

  - ``getOrder()``

  - ``setRequired($flag)``

  - ``getRequired()``

  - ``setAllowEmpty($flag)``

  - ``getAllowEmpty()``

  - ``setAutoInsertNotEmptyValidator($flag)``

  - ``autoInsertNotEmptyValidator()``

  - ``setIgnore($flag)``

  - ``getIgnore()``

  - ``getType()``

  - ``setAttrib($name, $value)``

  - ``setAttribs(array $attribs)``

  - ``getAttrib($name)``

  - ``getAttribs()``

- Plugin Loader und Pfade:

  - ``setPluginLoader(Zend_Loader_PluginLoader_Interface $loader, $type)``

  - ``getPluginLoader($type)``

  - ``addPrefixPath($prefix, $path, $type = null)``

  - ``addPrefixPaths(array $spec)``

- Prüfung:

  - ``addValidator($validator, $breakChainOnFailure = false, $options = array())``

  - ``addValidators(array $validators)``

  - ``setValidators(array $validators)``

  - ``getValidator($name)``

  - ``getValidators()``

  - ``removeValidator($name)``

  - ``clearValidators()``

  - ``isValid($value, $context = null)``

  - ``getErrors()``

  - ``getMessages()``

- Filter:

  - ``addFilter($filter, $options = array())``

  - ``addFilters(array $filters)``

  - ``setFilters(array $filters)``

  - ``getFilter($name)``

  - ``getFilters()``

  - ``removeFilter($name)``

  - ``clearFilters()``

- Darstellung:

  - ``setView(Zend_View_Interface $view = null)``

  - ``getView()``

  - ``addDecorator($decorator, $options = null)``

  - ``addDecorators(array $decorators)``

  - ``setDecorators(array $decorators)``

  - ``getDecorator($name)``

  - ``getDecorators()``

  - ``removeDecorator($name)``

  - ``clearDecorators()``

  - ``render(Zend_View_Interface $view = null)``

.. _zend.form.elements.config:

Konfiguration
-------------

Der Konstruktor von ``Zend_Form_Element`` akzeptiert entweder einen Array von Optionen oder ein ``Zend_Config``
Objekt das Optionen enthält, und es kann auch durch Verwendung von ``setOptions()`` oder ``setConfig()``
konfiguriert werden. Generell, werden die Schlüssel wie folgt benannt:

- Wenn 'set' + Schlüssel auf eine ``Zend_Form_Element`` Methode zeigt, dann wird der angebotene Wert zu dieser
  Methode übermittelt.

- Andernfalls wird der Wert verwendet um ein Attribut zu setzen.

Ausnahmen zu dieser Regel sind die folgenden:

- ``prefixPath`` wird an ``addPrefixPaths()`` übergeben

- Die folgenden Setzer können nicht auf diesem Weg gesetzt werden:

  - ``setAttrib`` (über ``setAttribs`` **wird** es funktionieren)

  - ``setConfig``

  - ``setOptions``

  - ``setPluginLoader``

  - ``setTranslator``

  - ``setView``

Als Beispiel ist hier eine Konfigurationsdatei die eine Konfiguration für jeden Typ von konfigurierbaren Daten
übergibt:

.. code-block:: ini
   :linenos:

   [element]
   name = "foo"
   value = "foobar"
   label = "Foo:"
   order = 10
   required = true
   allowEmpty = false
   autoInsertNotEmptyValidator = true
   description = "Foo Elemente sind für Beispiele"
   ignore = false
   attribs.id = "foo"
   attribs.class = "element"
   ; Setzt das 'onclick' Attribut
   onclick = "autoComplete(this, '/form/autocomplete/element')"
   prefixPaths.decorator.prefix = "My_Decorator"
   prefixPaths.decorator.path = "My/Decorator/"
   disableTranslator = 0
   validators.required.validator = "NotEmpty"
   validators.required.breakChainOnFailure = true
   validators.alpha.validator = "alpha"
   validators.regex.validator = "regex"
   validators.regex.options.pattern = "/^[A-F].*/$"
   filters.ucase.filter = "StringToUpper"
   decorators.element.decorator = "ViewHelper"
   decorators.element.options.helper = "FormText"
   decorators.label.decorator = "Label"

.. _zend.form.elements.custom:

Eigene Elemente
---------------

Es können eigene Elemente durch die Erweiterung der ``Zend_Form_Element`` Klasse erstellt werden. Übliche Gründe
hierfür sind:

- Elemente, die eine gemeinsame Prüfung und/oder Filter teilen

- Elemente die eine eigene Dekoratoren Funktionalität haben

Es gibt zwei Methoden die typischerweise verwendet werden, um ein Element zu erweitern: ``init()``, was verwendet
werden kannm um eine eigene Initialisierungs-Logik zum Element hinzuzufügen, und ``loadDefaultDecorators()``, was
verwendet werden kann um eine Liste von Standard Dekoratoren zu setzen, die vom Element verwendet werden sollen.

Als Beispiel nehmen wir an, dass alle Text Elemente eines Formulars die erstellt werden mit ``StringTrim``
gefiltert werden müssen, mit einem gemeinsamen Regulären Ausdruck und das ein eigener Dekorator
'My_Decorator_TextItem' verwendet werden soll, der für die Darstellung von ihnen erstellt wurde; zusätzlich gibt
es eine Anzahl an Standardattributen, wie 'size', 'maxLength', und 'class', die spezifiziert werden sollen. So ein
Element könnte wie folgt definiert werden:

.. code-block:: php
   :linenos:

   class My_Element_Text extends Zend_Form_Element
   {
       public function init()
       {
           $this->addPrefixPath('My_Decorator', 'My/Decorator/', 'decorator')
                ->addFilters('StringTrim')
                ->addValidator('Regex', false, array('/^[a-z0-9]{6,}$/i'))
                ->addDecorator('TextItem')
                ->setAttrib('size', 30)
                ->setAttrib('maxLength', 45)
                ->setAttrib('class', 'text');
       }
   }

Man könnte dann das Formular Objekt über den Präfix Pfad für diese Elemente informieren, und die Erstellung der
Elemente beginnen:

.. code-block:: php
   :linenos:

   $form->addPrefixPath('My_Element', 'My/Element/', 'element')
        ->addElement('text', 'foo');

Das 'foo' Element wird vom Typ ``My_Element_Text`` sein, und dem beschriebenen Verhalten entsprechen.

Eine andere Methode, die man überschreiben sollte, wenn ``Zend_Form_Element`` erweitert wird, ist die
``loadDefaultDecorators()`` Methode. Diese Methode lädt fallweise ein Set von Standarddekoratoren für das
Element; es kann gewünscht sein, eigene Dekoratoren in der erweiterten Klasse zu verwenden:

.. code-block:: php
   :linenos:

   class My_Element_Text extends Zend_Form_Element
   {
       public function loadDefaultDecorators()
       {
           $this->addDecorator('ViewHelper')
                ->addDecorator('DisplayError')
                ->addDecorator('Label')
                ->addDecorator('HtmlTag',
                               array('tag' => 'div', 'class' => 'element'));
       }
   }

Es gibt viele Wege, Elemente anzupassen; man sollte sicherstellen die *API* Dokumentation von ``Zend_Form_Element``
zu lesen um alle vorhandenen Methoden zu kennen.



.. _`Zend_Validate_NotEmpty`: zend.validate.set.notempty
