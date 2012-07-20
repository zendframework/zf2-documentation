.. _zend.form.standardDecorators:

Standard Formular Dekoratoren die mit dem Zend Framework ausgeliefert werden
============================================================================

``Zend_Form`` wird mit verschiedenen Standard Dekoratoren ausgeliefert. Für weitere Informationen über die
generelle Verwendung von Dekoratoren, siehe das :ref:`Kapitel über Dekoratoren <zend.form.decorators>`.

.. _zend.form.standardDecorators.callback:

Zend_Form_Decorator_Callback
----------------------------

Der Callback Dekorator kann einen gewünschten Callback ausführen, um Inhalte darzustellen. Callbacks sollten
über die 'callback' Option spezifiziert werden, die dem Dekorator in der Konfiguration übergeben wird, und die
jeder gültige *PHP* Callback Typ sein kann. Callbacks sollten drei Argumente akzeptieren, ``$content`` (den
originalen Inhalt der dem Dekorator übergeben wird), ``$element`` (das Element das dekoriert werden soll), und ein
Array von ``$options``. Ein Beispiel Callback:

.. code-block:: php
   :linenos:

   class Util
   {
       public static function label($content, $element, array $options)
       {
           return '<span class="label">' . $element->getLabel() . '</span>';
       }
   }

Dieser Callback kann mit ``array('Util', 'label')`` spezifiziert werden, und würde einige (falsche) *HTML* Markups
für das Label erzeugen. Der Callback Dekorator würde entweder ersetzen, voranstellen, oder dem originalen Inhalt
den zurückgegebenen Wert anhängen.

Der Callback Dekorator erlaubt es, einen ``NULL`` Wert für die 'placement' Option zu spezifizieren, welche den
originalen Inhalt, mit dem, vom Callback zurückgegebenen Wert, ersetzt; 'prepend' und 'append' sind genauso
gültig.

.. _zend.form.standardDecorators.captcha:

Zend_Form_Decorator_Captcha
---------------------------

Der Captcha Dekorator ist für die Verwendung mit dem :ref:`CAPTCHA Formularelement
<zend.form.standardElements.captcha>`. Es verwendet die ``render()`` Methode des CAPTCHA Adapters um die Ausgabe zu
erzeugen.

Eine Variante des Captcha Dekorators, 'Captcha_Word', wird auch üblicherweise verwendet, und erstellt zwei
Elemente, eine Id und eine Eingabe. Die Id zeigt den Identifikator der Session gegen den verglichen wird, und die
Eingabe ist für die Benutzerverifikation des CAPTCHA. Beide werden als einzelnes Element geprüft.

.. _zend.form.standardDecorators.description:

Zend_Form_Decorator_Description
-------------------------------

Der Description Dekorator kann verwendet werden, um eine Beschreibung in einem ``Zend_Form``,
``Zend_Form_Element``, oder ``Zend_Form_DisplayGroup`` Element anzuzeigen; es holt die Beschreibung, indem es die
``getDescription()`` Methode des Objektes verwendet. Übliche Anwendungsfälle sind das Anbieten von UI Hinweisen
für Elemente.

Standardmäßig, wenn keine Beschreibung vorhanden ist, wird keine Ausgabe erzeugt. Wenn die Beschreibung vorhanden
ist, wird sie standardmäßig in ein *HTML* **p** Tag eingebunden, es kann aber ein Tag durch die Übergabe einer
``tag`` Option spezifiziert werden, bei der Erstellung des Dekorators, oder durch Aufruf von ``setTag()``.
Zusätzlich kann eine Klasse für das Tag spezifiziert werden, indem die ``class`` Option verwendet wird, oder
durch den Aufruf von ``setClass()``; standardmäßig wird die Klasse 'hint' verwendet.

Die Beschreibung wird escaped, indem der Escaping Mechanismus vom View Objekt standardmäßig verwendet wird. Das
kann, durch die Übergabe eines ``FALSE`` an die 'escape' Option des Dekorators, ausgeschaltet werden, oder durch
die ``setEscape()`` Methode.

.. _zend.form.standardDecorators.dtDdWrapper:

Zend_Form_Decorator_DtDdWrapper
-------------------------------

Der Standarddekorator verwendet Definitionslisten (**<dl>**) um Formularelemente darzustellen. Da Formularelemente
in jeder Reihenfolge vorkommen können, werden Gruppen und Unterformulare angezeigt und können mit anderen
Formularelementen interagieren. Um diese speziellen Elementtypen in der Definitionsliste zu behalten, erstellt der
DtDdWrapper einen neuen, leeren Definitionsausdruck (**<dt>**) und bettet dessen Inhalt in ein neues
Definitionsdatum (**<dd>**) ein. Die Ausgabe sieht dann wie folgt aus:

.. code-block:: html
   :linenos:

   <dt></dt>
   <dd><fieldset id="subform">
       <legend>Benutzer Information</legend>
       ...
   </fieldset></dd>

Dieser Dekorator ersetzt den, ihm angebotenen, Inhalt durch dessen Einbettung in das **<dd>** Element.

.. _zend.form.standardDecorators.errors:

Zend_Form_Decorator_Errors
--------------------------

Element Fehler erhalten ihren eigenen Dekorator mit dem Errors Dekorator. Dieser Dekorator ruft den FormErrors View
Helfer auf, welcher Fehlermeldungen in einer, ungeordneten, Liste (**<ul>**) als Listenelement darstellt. Das
**<ul>** Element empfängt eine Klasse von "errors".

Der Errors Dekorator kann entwedet vorangestellt oder dem Kontext, der Ihm übergeben wurde, angehängt werden.

.. _zend.form.standardDecorators.fieldset:

Zend_Form_Decorator_Fieldset
----------------------------

Anzeigegruppen und Unterformulare zeigen ihren Inhalt standardmäßig in einem Fieldset an. Der Fieldset Dekorator
prüft, ob entweder eine 'legend' Option oder eine ``getLegend()`` Methode in dem registrierten Element vorhanden
ist, und verwendet dieses als Legende, wenn es nicht leer ist. Jeder Inhalt der übergeben wird, wird in ein *HTML*
Fieldset eingebettet, wobei der originale Inhalt ersetzt wird. Alle Attribute die in den angezeigten Elementen
gesetzt sind, werden dem Fieldset als *HTML* Attribute übergeben.

.. _zend.form.standardDecorators.file:

Zend_Form_Decorator_File
------------------------

File Elemente haben eine spezielle Schreibweise wenn man mehrere File Elemente oder Unterformulare verwendet. Der
File Decorator wird von ``Zend_Form_Element_File`` verwendet und erlaubt es mehrere File Elemente, mit einem
einzelnen Methodenaufruf, zu setzen. Er wird automatisch verwendet und bestimmt den Namen des Elements.

.. _zend.form.standardDecorators.form:

Zend_Form_Decorator_Form
------------------------

``Zend_Form`` Objekte müssen typischerweise ein *HTML* *<form>* Tag darstellen. Der Formular Dekorator verweist
auf den Formular View Helfer. Er bettet jeden angebotenen Inhalt in ein *HTML* Formular Element ein, indem die
Aktionen und Methoden des ``Zend_Form`` Objektes verwendet werden, und jedes Attribut als *HTML* Attribut.

.. _zend.form.standardDecorators.formElements:

Zend_Form_Decorator_FormElements
--------------------------------

Formulare, Anzeigegruppen, und Unterformulare sind Sammlungen von Elementen. Um diese Elemente darzustellen,
verwenden sie den FormElements Dekorator, welche durch alle Elemente iteriert, ``render()`` auf jedem aufruft und
diese mit dem registrierten Trennzeichen verbindet. Es kann an Ihm übergebenen Inhalt entweder anhängen oder
voranstellen.

.. _zend.form.standardDecorators.formErrors:

Zend_Form_Decorator_FormErrors
------------------------------

Einige Entwickler und Designer bevorzugen es, alle Fehlermeldungen am Beginn des Formulars zu gruppieren. Der
FormErrors Dekorator erlaubt dies zu tun.

Standardmäßig hat die erzeugte Liste von Fehlern das folgende Markup:

.. code-block:: html
   :linenos:

   <ul class="form-errors>
       <li><b>[Element Überschrift oder Name]</b><ul>
               <li>[Fehlermeldung]</li>
               <li>[Fehlermeldung]</li>
           </ul>
       </li>
       <li><ul>
           <li><b>[Label oder Name des Unterformular-Elements</b><ul>
                   <li>[Fehlermeldung]</li>
                   <li>[Fehlermeldung]</li>
               </ul>
           </li>
       </ul></li>
   </ul>

Man kann eine Vielzahl von Optionen übergeben, um die erzeugte Ausgabe zu konfigurieren:

- ``ignoreSubForms``: Ob die Rekursion im Unterformular ausgeschaltet werden soll oder nicht. Standardwert:
  ``FALSE`` (erlaubt Rekursion).

- ``markupElementLabelEnd``: Markup welcher der Elementüberschrift angehängt wird. Standardwert: '</b>'

- ``markupElementLabelStart``: Markup welcher der Elementüberschrift vorangestellt wird. Standardwert: '<b>'

- ``markupListEnd``: Markup welcher der Nachrichtenliste angehängt wird. Standardwert: '</ul>'.

- ``markupListItemEnd``: Markup der individuellen Fehlermeldungen angehängt wird. Standardwert: '</li>'

- ``markupListItemStart``: Markup der individuellen Fehlermeldungen vorangestellt wird. Standardwert: '<li>'

- ``markupListStart``: Markup welcher der Nachrichtenliste vorangestellt wird. Standardwert: '<ul
  class="form-errors">'

Der FormErrors Dekorator kann entweder angehängt oder dem Inhalt, dem er angehört, vorangestellt werden.

.. _zend.form.standardDecorators.htmlTag:

Zend_Form_Decorator_HtmlTag
---------------------------

Der HtmlTag Dekorator erlaubt es *HTML* Tags anzupassen, um Inhalt zu dekorieren; das angepasste Tag wird in der
'tag' Option übergeben, und jede andere Option wird als *HTML* Attribut für dieses Tag verwendet. Das Tag nimmt
standardmäßig an, dass es Blocklevel ist, und ersetzt den Inhalt durch dessen Einbettung in das gegebene Tag.
Trotzdem kann eine Platzierung spezifiziert werden um das Tag genauso anzuhängen oder voranzustellen.

.. _zend.form.standardDecorators.image:

Zend_Form_Decorator_Image
-------------------------

Der Image Dekorator erlaubt es eine *HTML* Bildeingabe (**<input type="image" ... />**) zu erstellen, und es
optional in einem anderen *HTML* Tag darzustellen.

Standardmäßig verwendet der Dekorator die 'src' Eigenschaft des Elements als Bildquelle, welche mit der
``setImage()`` Methode als Bildquelle gesetzt werden kann. Zusätzlich wird das Label des Elements als 'alt'
Attribute verwendet, und ``imageValue`` (welches mit den ``setImageValue()`` und ``getImageValue()``
Zugriffsmethoden des Bildes manipuliert werden kann) wird für den Wert verwendet.

Um ein *HTML* Tag zu spezifizieren, dass das Element einbetten soll, kann entweder die 'tag' Option an den
Dekorator übergeben, oder explizit ``setTag()`` aufgerufen werden.

.. _zend.form.standardDecorators.label:

Zend_Form_Decorator_Label
-------------------------

Formularlemente haben tyischerweise ein Label und der Label Dekorator wird verwendet, um diese Labels darzustellen.
Er ruft den FormLabel View Helfer auf und holt das Label des Elements, indem die ``getLabel()`` Methode des
Elements verwendet wird. Wenn kein Label vorhanden ist, wird es auch nicht darstellt. Standardmäßig werden Labels
übersetzt, wenn ein Übersetzungsadapter existiert und eine Übersetzung für das Label existiert.

Optional kann die 'tag' Option spezifiziert werden; wenn vorhanden, bettet sie das Label in das Block-Level Tag
ein. Wenn die 'tag' Option aber kein Label vorhanden ist, wird das Tag ohne Inhalt dargestellt. Es kann definiert
werden, dass die Klasse das Tag mit der 'class' Option verwendet, oder durch Aufruf von ``setClass()``.

Zusätzlich können Präfixe und Suffixe für die Verwendung spezifiziert werden, wenn die Elemente angezeigt
werden, basierend darauf, ob das Label für ein optionales oder benötigtes Element ist. Übliche Verwendungszwecke
würden sein, ein ':' dem Label anzufügen, oder ein '\*' um anzuzeigen, dass das Element benötigt wird. Das kann
mit den folgenden Optionen und Methoden gemacht werden:

- ``optionalPrefix``: Setzt den Text, der dem Label vorangestellt wird, wenn das Element optional ist. Kann mit den
  Zugriffsmethoden ``setOptionalPrefix()`` und ``getOptionalPrefix()`` manipuliert werden.

- ``optionalSuffix``: Setzt den Text, der dem Label angehängt wird, wenn das Element optional ist. Kann mit den
  Zugriffsmethoden ``setOptionalSuffix()`` und ``getOptionalSuffix()`` manipuliert werden.

- ``requiredPrefix``: Setzt den Text, der dem Label vorangestellt wird, wenn das Element benötigt wird. Kann mit
  den Zugriffsmethoden ``setRequiredPrefix()`` und ``getRequiredPrefix()`` manipuliert werden.

- ``requiredSuffix``: Setzt den Text, der dem Label angehängt wird, wenn das Element benötigt wird. Kann mit den
  Zugriffsmethoden ``setRequiredSuffix()`` und ``getRequiredSuffix()`` manipuliert werden.

Standardmäßig stellt der Label Dekorator, dem angegebenen Inhalt, voran; es kann die 'placement' Option mit
'append' spezifiziert werden, um es nach dem Inhalt zu platzieren.

.. _zend.form.standardDecorators.prepareElements:

Zend_Form_Decorator_PrepareElements
-----------------------------------

Formulare, Anzeigegruppen, und Unterformulare sind Kollektionen von Elementen. Wenn der :ref:`ViewScript Dekorator
<zend.form.standardDecorators.viewScript>` verwendet wird, ist es nützlich die Möglichkeit zu haben, das View
Objekt, die Übersetzung, und alle komplett qualifizierten Namen (wie sie von der Array Schreibweise der
Unterformulare erkannt werden), rekursiv setzen zu können. Der 'PrepareElements' Dekorator kann das für einen
erledigen. Typischerweise setzt man ihn als ersten Dekorator in der Liste.

.. code-block:: php
   :linenos:

   $form->setDecorators(array(
       'PrepareElements',
       array('ViewScript', array('viewScript' => 'form.phtml')),
   ));

.. _zend.form.standardDecorators.viewHelper:

Zend_Form_Decorator_ViewHelper
------------------------------

Die meisten Elemente verwenden ``Zend_View`` Helfer für die Darstellung und das wird mit dem View Helfer Dekorator
getan. Mit ihm kann ein 'helper' Tag spezifiziert werden der explizit den View Helfer setzt, der anzupassen ist;
wenn keiner angegeben wird, verwendet er das letzte Segment des Klassennamens des Elements um den Helfer zu
ermitteln, und stellt den String 'form' voran: z.B. 'Zend_Form_Element_Text' würde nach einem View Helfer
'formText' schauen.

Alle Attribute des angegebenen Elements werden dem View Helfer als Attribute des Elements übergeben.

Standardmäßig fügt dieser Dekorator Inhalt hinten an; es kann die 'placement' Option verwendet werden um eine
alternative Platzierung zu spezifizieren.

.. _zend.form.standardDecorators.viewScript:

Zend_Form_Decorator_ViewScript
------------------------------

Manchmal ist es gewünscht, ein View Skript für die Erstellung eigener Elemente zu verwenden; auf diesem Weg hat
man eine sehr detailierte Kontrolle über die Elemente, und wandelt das View Skript zu einem Designer um, oder
erstellt einfach einen Weg, um Einstellungen zu überladen, die auf Modulen basieren (jedes Modul könnte optional
die View Skripte des Elements überladen um seinen eigenen Zwecken zu entsprechen). Der ViewScript Dekorator löst
dieses Problem.

Der ViewScript Dekorator benötigt eine 'viewScript' Option, entweder angeboten vom Dekorator, oder als Attribut
des Elements. Er stellt dann das View Skript als teilweises Skript, was bedeutet, dass jeder Aufruf von ihm, seinen
eigenen Geltungsbereich der Variablen hat; keine Variablen von der View werden im Element enthalten sein, ausser
denen des Elements selbst. Verschiedene Variablen werden dann bekannt gegeben:

- ``element``: Das Element, welches dekoriert wird

- ``content``: Der Inhalt, der an den Dekorator übergeben wird

- ``decorator``: Das Dekorator Objekt selbst

- Zusätzlich werden, alle Optionen, die an den Dekorator mit ``setOptions()`` übergeben und nicht intern
  verwendet werden, an das View Skript als View Variablen übergeben.

Als Beispiel, kann das folgende Element hergenommen werden:

.. code-block:: php
   :linenos:

   // Setzt den Dekorator für das Element zu einem einzelnen, ViewScript,
   // Dekorator spezifiziert das viewScript als Option, und einige extra
   // Optionen:
   $element->setDecorators(array(array('ViewScript', array(
       'viewScript' => '_element.phtml',
       'class'      => 'form element'
   ))));

   // ODER das viewScript als Attribut des Elements spezifizieren:
   $element->viewScript = '_element.phtml';
   $element->setDecorators(array(array('ViewScript',
                                       array('class' => 'form element'))));

Dann könne ein View Skript die das folgende existieren:

.. code-block:: php
   :linenos:

   <div class="<?php echo $this->class ?>">
       <?php echo $this->formLabel($this->element->getName(),
                            $this->element->getLabel()) ?>
       <?php echo $this->{$this->element->helper}(
           $this->element->getName(),
           $this->element->getValue(),
           $this->element->getAttribs()
       ) ?>
       <?php echo $this->formErrors($this->element->getMessages()) ?>
       <div class="hint"><?php echo $this->element->getDescription() ?></div>
   </div>

.. note::

   **Inhalte mit einem View Skript ersetzen**

   Es kann für das View Skript nützlich sein, den Inhalt der dem Dekorator angeboten wird, zu ersetzen -- zum
   Beispiel wenn man ihn umschliessen will. Das kann man erreichen, indem ein ``FALSE`` für die 'placement' Option
   des Dekorators spezifiziert wird:

   .. code-block:: php
      :linenos:

      // Bei Erstellung des Dekorators:
      $element->addDecorator('ViewScript', array('placement' => false));

      // Zu einer existierenden Dekorator Instanz hinzufügen:
      $decorator->setOption('placement', false);

      // Zu einem Dekorator hinzufügen, der bereits bei einem Element hinzugefügt ist:
      $element->getDecorator('ViewScript')->setOption('placement', false);

      // In einem View Skript, das von einem Dekorator verwendet wird:
      $this->decorator->setOption('placement', false);

Die Verwendung des ViewScript Dekorators wird empfohlen, wenn man eine sehr feinkörnige Kontrolle darüber
benötigt, wie Elemente dargestellt werden.


