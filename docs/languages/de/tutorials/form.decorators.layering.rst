.. EN-Revision: none
.. _learning.form.decorators.layering:

Layeraufbau von Decorators
==========================

Wenn man :ref:`dem vorigen Abschnitt <learning.form.decorators.simplest>` gut gefolgt ist, hat man festgestellt das
die ``render()`` Methode eines Decorators ein einzelnes ``$content`` Argument entgegen nimmt. Es wird erwartet das
dies ein String ist. ``render()`` nimmt dann diesen String und entscheidet ob er ersetzt, vorangestellt, oder
angehängt wird. Das erlaubt es eine Kette von Decorators zu haben -- was es erlaubt Decorators zu erstellen welche
nur ein Subset der Metadaten des Elements darstellt, und diese Decorators übereinander legt um das volle Markup
des Elements zu bauen.

Schauen wir uns an wie das in der Praxis arbeitet.

Für die meisten Typen an Formularelementen werden die folgenden Decorators verwendet:

- ``ViewHelper`` (stellt die Formulareingabe dar indem einer der standardmäßige View Helfer für Formulare
  verwendet wird).

- ``Errors`` (stellt Prüffehler durch eine unsortierte Liste dar).

- ``Description`` (stellt alle dem Element zugeordneten Beschreibungen dar; wird oft für Tooltips verwendet).

- ``HtmlTag`` (umhüllt alle oben stehenden mit einem **<dd>** Tag).

- ``Label`` (stellt das Label dar indem es dem oben stehenden vorangestellt wird und umhüllt es mit einem **<dt>**
  Tag).

Man wird feststellen das jeder dieser Decorators nur ein Ding tut, und auf einem speziellen Teil der Metadaten
arbeitet die im Formularelement gespeichert sind: der ``Errors`` Decorator holt Prüffehler und stellt Sie dar; der
``Label`` Decorator holt die Überschrift und stellt Sie dar. Das erlaubt einzelnen Decorators sehr bündig,
wiederholbar, und viel wichtiger, testbar zu sein.

Hier kommt auch das ``$content`` Argument zum Einsatz: Jede ``render()`` Methode eines Decorators ist designt um
Inhalte zu akzeptieren, und diesen dann entweder zu ersetzen (normalerweise indem er umhüllt wird), hinten
anzuhängen, oder voranzustellen.

Es ist also am Besten vom Prozess der Dekoration als Erstellung einer Zwiebel zu denken, von Innen nach Außen.

Um den Prozess zu vereinfachen sehen wir in der Beispiel :ref:`des vorherigen Abschnitts
<learning.form.decorators.simplest>`. Nochmals:

.. code-block:: php
   :linenos:

   class My_Decorator_SimpleInput extends Zend\Form_Decorator\Abstract
   {
       protected $_format = '<label for="%s">%s</label>'
                          . '<input id="%s" name="%s" type="text" value="%s"/>';

       public function render($content)
       {
           $element = $this->getElement();
           $name    = htmlentities($element->getFullyQualifiedName());
           $label   = htmlentities($element->getLabel());
           $id      = htmlentities($element->getId());
           $value   = htmlentities($element->getValue());

           $markup  = sprintf($this->_format, $id, $label, $id, $name, $value);
           return $markup;
       }
   }

Jetzt entfernen wir die Funktionalität des Labels und bauen einen eigenen Decorator dafür.

.. code-block:: php
   :linenos:

   class My_Decorator_SimpleInput extends Zend\Form_Decorator\Abstract
   {
       protected $_format = '<input id="%s" name="%s" type="text" value="%s"/>';

       public function render($content)
       {
           $element = $this->getElement();
           $name    = htmlentities($element->getFullyQualifiedName());
           $id      = htmlentities($element->getId());
           $value   = htmlentities($element->getValue());

           $markup  = sprintf($this->_format, $id, $name, $value);
           return $markup;
       }
   }

   class My_Decorator_SimpleLabel extends Zend\Form_Decorator\Abstract
   {
       protected $_format = '<label for="%s">%s</label>';

       public function render($content)
       {
           $element = $this->getElement();
           $id      = htmlentities($element->getId());
           $label   = htmlentities($element->getLabel());

           $markup = sprintf($this->_format, $id, $label);
           return $markup;
       }
   }

Das könnte jetzt schön und gut aussehen, aber da ist ein Problem: wie gerade geschrieben gewinnt der letzte
Decorator und überschreibt alles. Man endet nur mit der Eingabe oder nur dem Label, abhängig davon was als
letztes registriert wurde.

Um das zu verhindern, muss dass in ``$content`` übergebene irgendwie mit dem Markup verbunden werden:

.. code-block:: php
   :linenos:

   return $content . $markup;

Das Problem mit dem obigen Ansatz kommt dann wenn man programmtechnisch wählen will ob der originale Inhalt das
neue Markup angehängt oder vorangestellt werden soll. Glücklicherweise gibt es hierfür bereits einen
Standardmechanismus; ``Zend\Form_Decorator\Abstract`` hat ein Konzept der Platzierung und definiert einige
Konstanten um es anzusprechen. Zusätzlich erlaubt es die Spezifikation eines Separators der zwischen beide
platziert wird. Verwenden wir Sie:

.. code-block:: php
   :linenos:

   class My_Decorator_SimpleInput extends Zend\Form_Decorator\Abstract
   {
       protected $_format = '<input id="%s" name="%s" type="text" value="%s"/>';

       public function render($content)
       {
           $element = $this->getElement();
           $name    = htmlentities($element->getFullyQualifiedName());
           $id      = htmlentities($element->getId());
           $value   = htmlentities($element->getValue());

           $markup  = sprintf($this->_format, $id, $name, $value);

           $placement = $this->getPlacement();
           $separator = $this->getSeparator();
           switch ($placement) {
               case self::PREPEND:
                   return $markup . $separator . $content;
               case self::APPEND:
               default:
                   return $content . $separator . $markup;
           }
       }
   }

   class My_Decorator_SimpleLabel extends Zend\Form_Decorator\Abstract
   {
       protected $_format = '<label for="%s">%s</label>';

       public function render($content)
       {
           $element = $this->getElement();
           $id      = htmlentities($element->getId());
           $label   = htmlentities($element->getLabel());

           $markup = sprint($this->_format, $id, $label);

           $placement = $this->getPlacement();
           $separator = $this->getSeparator();
           switch ($placement) {
               case self::APPEND:
                   return $markup . $separator . $content;
               case self::PREPEND:
               default:
                   return $content . $separator . $markup;
           }
       }
   }

Es sollte beachtet werden das wir das Standardverhalten für jeden verändern; die Annahme besteht darin das die
Überschrift dem Inhalt folgt und die Eingabe vorangestellt wird.

Erstellen wir jetzt ein Formularelement das Sie verwendet:

.. code-block:: php
   :linenos:

   $element = new Zend\Form\Element('foo', array(
       'label'      => 'Foo',
       'belongsTo'  => 'bar',
       'value'      => 'test',
       'prefixPath' => array('decorator' => array(
           'My_Decorator' => 'path/to/decorators/',
       )),
       'decorators' => array(
           'SimpleInput',
           'SimpleLabel',
       ),
   ));

Wie arbeitet das? Wenn wir ``render()`` aufrufen, wird das Element durch die verschiedenen angehängten Decorators
iterieren, indem auf jedem ``render()`` aufgerufen wird. Er übergibt einen leeren String zu dem allerersten, und
was auch immer für ein Inhalt erstellt wird, wird dieser an den nächsten übergeben, und so weiter:

- Der initiale Inhalt ist ein leerer String: ''.

- '' wird an den ``SimpleInput`` Decorator übergeben welcher dann eine Formulareingabe erstellt und diese an den
  leeren String anhängt: **<input id="bar-foo" name="bar[foo]" type="text" value="test"/>**.

- Die Eingabe wird dann als Inhalt an den ``SimpleLabel`` Decorator übergeben, welche eine Überschrift erzeugt
  und diese dem originalen Inhalt voranstellt; der standardmäßige Separator ist ein ``PHP_EOL`` Zeichen, was uns
  folgendes gibt: **<label for="bar-foo">\n<input id="bar-foo" name="bar[foo]" type="text" value="test"/>**.

Einen Moment! Wenn wir wollen das aus irgendeinem Grund die Überschrift nach der Eingabe kommt, was dann? Erinnern
wir uns an das "placement" Flag? Man kann es als Option an den Decorator übergeben. Der einfachste Weg das zu tun
ist die Übergabe eines Arrays an Optionen an den Decorator wärend der Erstellung des Elements:

.. code-block:: php
   :linenos:

   $element = new Zend\Form\Element('foo', array(
       'label'      => 'Foo',
       'belongsTo'  => 'bar',
       'value'      => 'test',
       'prefixPath' => array('decorator' => array(
           'My_Decorator' => 'path/to/decorators/',
       )),
       'decorators' => array(
           'SimpleInput'
           array('SimpleLabel', array('placement' => 'append')),
       ),
   ));

Es sollte beachtet werden das der Decorator bei der Übergabe von Optionen in einem Array umhüllt werden muss; das
zeigt dem Constructor das Optionen vorhanden sind. Der Name des Decorators ist das erste Element des Arraqs, und
optionen welche in einem Array an das zweite Element des Arrays übergeben werden.

Das oben stehende führt zum Markup **<input id="bar-foo" name="bar[foo]" type="text" value="test"/>\n<label
for="bar-foo">**.

Bei Verwendung dieser Technik kann man Decorators haben welche auf spezifische Metadaten eines Elements oder einem
Formular abzielen und nur das für diese Metadaten relevante Markup erstellt; indem mehrere Decorators verwendet
werden kann das komplette Markup des Elements gebaut werden. Unsere Zwiebel ist das Ergebnis.

Es gibt Vor- und Nachteile für diesen Ansatz. Erst die Nachteile:

- Komplexer zu implementieren. Man muss bei den Decorators und der Platzierung die man verwendet gut aufpassen um
  das Markup in der richtigen Sequenz zu erstellen.

- Ressourcenintensiver. Mehr Decorators bedeuten auch mehr Objekte; das muss mit der Anzahl der Elemente
  multipliziert werden die man im Formular hat, und man könnte in einer schweren Ressourcenverwendung enden.
  Caching kann hierbei helfen.

Die Vorteile sind wirklich überwältigend:

- Wiederverwendbare Decorators. Man kann mit dieser Technik echte wiederverwendbare Decorators erstellen da man
  sich keine Sorgen über das komplette Markup machen muss, sondern nur ein oder ein paar Teile des Elements oder
  der Metadaten des Formulars.

- Ultimative Flexibilität. Man kann theoretisch jede Markupkombination die man will von einer kleinen Anzahl an
  Decorators erzeugen.

Wärend die oben stehenden Beispiele die geplante Verwendung der Decorators in ``Zend_Form`` zeigen, ist es oft
hart zu erkennen wie Decorators untereinander interagieren um das endgültige Markup er bauen. Aus diesem Grund
wurde in der Serie 1.7 etwas Flexibilität hinzugefügt um die Darstellung individueller Decorators zu ermöglichen
-- das gibt eine Rails-artige Einfachheit der Darstellung von Formularen. Wir sehen uns das im nächsten Abschnitt
an.


