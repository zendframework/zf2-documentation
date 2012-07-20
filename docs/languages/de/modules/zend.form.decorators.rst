.. _zend.form.decorators:

Erstellen von eigenem Form Markup durch Zend_Form_Decorator
===========================================================

Die Darstellung eines Form Objektes ist komplett optional --``Zend_Form``'s render() Methoden müssen nicht einmal
verwendet werden. Wenn es trotzdem so gemacht wird, dann werden Dekoratoren verwendet, um die verschiedenen Form
Objekte darzustellen.

Eine Vielzahl an Dekoratoren kann jedem Teil angefügt werden (Elemente, Anzeigegruppen, Unterformulare, oder das
Form Objekt selbst); trotzdem kann nur ein Dekorator eines bestimmten Typs jedem Teil engefügt werden. Dekoratoren
werden in der Reihenfolge aufgerufen in der sie registriert werden. Abhängig vom Dekorator, kann dieser den Inhalt
ersetzen, der Ihm übergeben wurde, oder Inhalt anhängen oder voranstellen.

Der Objektstatus wird durch Konfigurationsoptionen gesetzt die dem Konstruktor oder der ``setOptions()`` Methode
des Dekorators übergeben werden. Wenn Dekoratoren, über ``addDecorator()`` oder ähnliche Methoden erstellt
werden, können der Methode Optionen als Argument übergeben werden. Diese können verwendet werden um eine
Platzierung zu spezifizieren, einen Separator festzulegen, der zwischen übergebenem Inhalt und neu erstelltem
Inhalt verwendet wird, oder welche Option der Dekorator sonst noch unterstützt.

Bevor jede ``render()`` Methode der Dekoratoren aufgerufen wird, wird das aktuelle Element im Dekorator mit
``setElement()`` gesetzt, was dem Dekorator zeigt welches Element dargestellt werden soll. Das erlaubt es
Dekoratoren zu erstellen, die nur spezielle Abschnitte eines Elements darstellen -- wie das Label, den Wert,
Fehlermeldungen, usw. Durch die Verbindung von verschiedenen Dekoratoren, die ein spezielles Segment des Elements
darstellen, kann ein komplexes Markup gebaut werden, das das komplette Element repräsentiert.

.. _zend.form.decorators.operation:

Operationen
-----------

Um einen Dekorator zu konfigurieren, kann ein Array von Optionen, oder ein ``Zend_Config`` Objekt an dessen
Konstruktor übergeben werden, ein Array an ``setOptions()``, oder ein ``Zend_Config`` Objekt an ``setConfig()``.

Die Standard Optionen beinhalten:

- ``placement``: Die Platzierung kann entweder 'append' oder 'prepend' sein (unabhängig von der Schreibweise), und
  definiert ob der Inhalt der ``render()`` übergeben wird, angehängt oder vorangestellt wird. Im Fall das ein
  Dekorator den Inhalt ersetzt wird diese Einstellung ignoriert. Der Standardwert ist anhängen (append).

- ``separator``: Der Separator wird zwischen dem Inhalt der an ``render()`` übergeben wird und durch den Dekorator
  neu erstelltem Inhalt verwendet, oder zwischen Teilen die durch den Dekorator dargestellt werden (z.B.
  FormElements verwenden Separatoren zwischen jedem dargestellten Element). Im Fall das ein Dekorator den Inhalt
  ersetzt, wird diese Einstellung ignoriert. Der Standardwert ist ``PHP_EOL``.

Das Dekorator Interface spezifiziert Methoden für die Interaktion mit Optionen. Diese beinhalten:

- ``setOption($key, $value)``: Setzt eine einzelne Option.

- ``getOption($key)``: Einen einzelnen Optionswert erhalten.

- ``getOptions()``: Alle Optionen erhalten.

- ``removeOption($key)``: Eine einzelne Option entfernen.

- ``clearOptions()``: Alle Optionen entfernen.

Dekoratoren sollen mit den verschiedenen ``Zend_Form`` Klassentypen interagieren: ``Zend_Form``,
``Zend_Form_Element``, ``Zend_Form_DisplayGroup``, und allen von ihnen abgeleiteten Klassen. Die Methode
``setElement()`` erlaubt es, das Objekt des Dekorators, mit den aktuell gearbeitet wird, zu setzen und
``getElement()`` wird verwendet um es zu Empfangen.

Die ``render()`` Methode jedes Dekorators akzeptiert einen String ``$content``. Wenn der erste Dekorator aufgerufen
wird, ist dieser String typischerweise leer, wärend er bei nachfolgenden Aufrufen bekannt sein wird. Basierend auf
dem Typ des Dekorators und den ihm übergebenen Optionen, wird der Dekorator entweder diesen String ersetzen,
voranstellen oder anfügen; ein optionaler Separator wird in den späteren zwei Situationen verwendet.

.. _zend.form.decorators.standard:

Standard Dekoratoren
--------------------

``Zend_Form`` wird mit vielen Standard Dekoratoren ausgeliefert; siehe :ref:`das Kapitel über Standard Dekoratoren
<zend.form.standardDecorators>` für Details.

.. _zend.form.decorators.custom:

Eigene Dekoratoren
------------------

Wenn man der Meinung ist, dass die Notwendigkeiten der Darstellung sehr komplex sind, oder starke Anpassungen
benötigt, sollte man sich überlegen einen eigenen Dekorator zu erstellen.

Dekoratoren implementieren nur ``Zend_Form_Decorator_Interface``. Das Interface spezifiziert folgendes:

.. code-block:: php
   :linenos:

   interface Zend_Form_Decorator_Interface
   {
       public function __construct($options = null);
       public function setElement($element);
       public function getElement();
       public function setOptions(array $options);
       public function setConfig(Zend_Config $config);
       public function setOption($key, $value);
       public function getOption($key);
       public function getOptions();
       public function removeOption($key);
       public function clearOptions();
       public function render($content);
   }

Um es sich einfacher zu machen, kann man ``Zend_Form_Decorator_Abstract`` erweitern, welches alle Methoden ausser
``render()`` implementiert.

Als Beispiel nehmen wir an, dass wir die Anzahl an verwendeten Dekoratoren verringern wollen, und einen
"gemeinsamen" Dekorator erstellen der die Darstellung von Label, Element, jeglicher Fehlermeldungen, und
Beschreibung in einem *HTML*'div' übernimmt. So ein 'gemeinsamer' Dekorator kann wie folgt erstellt werden:

.. code-block:: php
   :linenos:

   class My_Decorator_Composite extends Zend_Form_Decorator_Abstract
   {
       public function buildLabel()
       {
           $element = $this->getElement();
           $label = $element->getLabel();
           if ($translator = $element->getTranslator()) {
               $label = $translator->translate($label);
           }
           if ($element->isRequired()) {
               $label .= '*';
           }
           $label .= ':';
           return $element->getView()
                          ->formLabel($element->getName(), $label);
       }

       public function buildInput()
       {
           $element = $this->getElement();
           $helper  = $element->helper;
           return $element->getView()->$helper(
               $element->getName(),
               $element->getValue(),
               $element->getAttribs(),
               $element->options
           );
       }

       public function buildErrors()
       {
           $element  = $this->getElement();
           $messages = $element->getMessages();
           if (empty($messages)) {
               return '';
           }
           return '<div class="errors">' .
                  $element->getView()->formErrors($messages) . '</div>';
       }

       public function buildDescription()
       {
           $element = $this->getElement();
           $desc    = $element->getDescription();
           if (empty($desc)) {
               return '';
           }
           return '<div class="description">' . $desc . '</div>';
       }

       public function render($content)
       {
           $element = $this->getElement();
           if (!$element instanceof Zend_Form_Element) {
               return $content;
           }
           if (null === $element->getView()) {
               return $content;
           }

           $separator = $this->getSeparator();
           $placement = $this->getPlacement();
           $label     = $this->buildLabel();
           $input     = $this->buildInput();
           $errors    = $this->buildErrors();
           $desc      = $this->buildDescription();

           $output = '<div class="form element">'
                   . $label
                   . $input
                   . $errors
                   . $desc
                   . '</div>';

           switch ($placement) {
               case (self::PREPEND):
                   return $output . $separator . $content;
               case (self::APPEND):
               default:
                   return $content . $separator . $output;
           }
       }
   }

Danach kannst du ihn in den Dekoratoren Pfad platzieren:

.. code-block:: php
   :linenos:

   // für ein Element:
   $element->addPrefixPath('My_Decorator',
                           'My/Decorator/',
                           'decorator');

   // für alle Elemente:
   $form->addElementPrefixPath('My_Decorator',
                               'My/Decorator/',
                               'decorator');

Man kann dann diesen Dekorator als 'gemeinsam' spezifizieren und diesen an ein Element anfügen:

.. code-block:: php
   :linenos:

   // Überschreibe existierende Dekoratoren mit diesem einzelnen:
   $element->setDecorators(array('Composite'));

Während dieses Beispiel zeigt, wie ein Dekorator erstellt werden kann, der komplexe Ausgaben von verschiedenen
Element-Eigenschaften darstellt, können auch Dekoratoren erstellt werden die einzelne Aspekte eines Elements
handhaben; die 'Decorator' und 'Label' Dekoratoren sind exzellente Beispiele dieser Praxis. Das erlaubt es
Dekotatoren zu mischen und anzupassen, um komplexe Ausgaben zu erhalten -- und auch die Überladung von einzelnen
Aspekten der Dekoration für die Anpassung an eigene Bedürfnisse.

Wenn man, zum Beispiel, eine einfache Anzeige benötigt, welche die, während der Validierung aufgetretenen,
Fehlermeldungen ignoriert und dafür eine eigene Fehlermeldung anzeigt, kann man sich einen eigenen 'Errors'
Dekorator erstellen:

.. code-block:: php
   :linenos:

   class My_Decorator_Errors
   {
       public function render($content = '')
       {
           $output = '<div class="errors">Der angegebene Wert war ungültig;
               bitte nochmals versuchen</div>';

           $placement = $this->getPlacement();
           $separator = $this->getSeparator();

           switch ($placement) {
               case 'PREPEND':
                   return $output . $separator . $content;
               case 'APPEND':
               default:
                   return $content . $separator . $output;
           }
       }
   }

In diesem speziellen Beispiel, weil das letzte Segment 'Errors' des Dekorators auf ``Zend_Form_Decorator_Errors``
passt, wird er **statt** diesem Dekorator dargestellt -- was bedeutet, dass kein Dekorator verändert werden muß
um die Ausgabe anzupassen. Durch die Benennung des Dekorators nach dem bestehenden Standard Dekorator, kann die
Dekoration verändert werden ohne, dass der Dekorator des Elements verändert werden muss.

.. _zend.form.decorators.individual:

Darstellung individueller Dekoratoren
-------------------------------------

Da Dekoratoren verschiedene Metadaten, eines Elements oder Formulars das sie darstellen, ansprechen, ist es oft
nützlich zu bestimmten Zeiten nur einen individuellen Dekorator darzustellen. Erfreulicherweise ist dieses Feature
über Methodenüberladung in jeder der grundsätzlichen Klassen der Formulartypen möglich (Formulare,
Unterformulare, Anzeigegruppen, Elemente).

Um das zu tun muss einfach ``render[DecoratorName]()`` aufgerufen werden, wobei "[DecoratorName]" der "Kurzname"
des eigenen Dekorators ist; optional kann Inhalt eingefügt werden der dargestellt werden soll. Zum Beispiel:

.. code-block:: php
   :linenos:

   // Nur den Label Dekorator des Elements darstellen:
   echo $element->renderLabel();

   //Nur die Anzeigegruppe Fieldset mit Inhalt darstellen:
   echo $group->renderFieldset('fieldset content');

   // Nur das HTML Tag des Forumars mit Inhalt darstellen:
   echo $form->renderHtmlTag('wrap this content');

Wenn der Dekorator nicht existiert, wird eine Exception geworfen.

Das kann speziell dann nützlich sein, wenn ein Formular mit dem ViewScript Dekorator dargestellt wird; jedes
Element kann seine angehängten Dekoratoren verwenden um Inhalte darzustellen, aber mit fein-abgestimmter
Kontrolle.


