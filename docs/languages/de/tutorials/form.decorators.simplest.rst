.. EN-Revision: none
.. _learning.form.decorators.simplest:

Decorator Grundlagen
====================

.. _learning.form.decorators.simplest.decorator-overview:

Übersicht über das Decorator Pattern
------------------------------------

Am Beginn behandeln wir einige Hintergründe des `Decorator Design Patterns`_. Eine verbreitetere Technik ist die
Definition eines gemeinsamen Interfaces welche sowohl das originale Objekt als auch alle von Ihm abhängigen
implementieren; der Decorator akzeptiert dann das originale Objekt als abhängiges, und wird entweder darauf
verweisen oder seine Methoden überschreiben. Schreiben wir etwas Code damit es leichter verständlich wird:

.. code-block:: php
   :linenos:

   interface Window
   {
       public function isOpen();
       public function open();
       public function close();
   }

   class StandardWindow implements Window
   {
       protected $_open = false;

       public function isOpen()
       {
           return $this->_open;
       }

       public function open()
       {
           if (!$this->_open) {
               $this->_open = true;
           }
       }

       public function close()
       {
           if ($this->_open) {
               $this->_open = false;
           }
       }
   }

   class LockedWindow implements Window
   {
       protected $_window;

       public function __construct(Window $window)
       {
           $this->_window = $window;
           $this->_window->close();
       }

       public function isOpen()
       {
           return false;
       }

       public function open()
       {
           throw new Exception('Cannot open locked windows');
       }

       public function close()
       {
           $this->_window->close();
       }
   }

Wir haben ein Objekt vom Typ ``StandardWindow`` erstellt, es dem Contructor von ``LockedWindow`` übergeben, und
die eigene Fenster Instanz hat jetzt ein anderes Verhalten. Das Schöne daran ist, das man keine Art von "Locking"
Funktionalität in der standardmäßigen Fenster Klasse implementieren muss -- der Decorator passt für einen
darauf auf. In der Zwischenzeit kann das gesperrte Fenster herum übergeben wie wenn ein nur ein anderes Fenster
wäre.

Ein spezieller Platz an dem das Decorator Pattern nützlich ist, ist die Erstellung von textuellen
Repräsentationen von Objekten. Als Beispiel könnte man ein "Person" Objekt haben welches, aus sich selbst heraus,
keine textuelle Repräsentation hat. Durch Verwendung des Decorator Patterns arbeitet es als wäre es eine Peron,
bietet aber auch die Möglichkeit diese Person textuell darzustellen.

In diesem speziellen Beispiel, werden wir ein sogenanntes `Duck Typing`_ verwenden statt einem expliziten
Interface. Das erlaubt unserer Implementation etwas flexibler zu sein, wärend es dem Decorator Pattern trotzdem
noch erlaubt so exakt zu arbeiten als wäre es ein Personen Objekt.

.. code-block:: php
   :linenos:

   class Person
   {
       public function setFirstName($name) {}
       public function getFirstName() {}
       public function setLastName($name) {}
       public function getLastName() {}
       public function setTitle($title) {}
       public function getTitle() {}
   }

   class TextPerson
   {
       protected $_person;

       public function __construct(Person $person)
       {
           $this->_person = $person;
       }

       public function __call($method, $args)
       {
           if (!method_exists($this->_person, $method)) {
               throw new Exception('Ungültige Methode bei HtmlPerson aufgerufen: '
                   .  $method);
           }
           return call_user_func_array(array($this->_person, $method), $args);
       }

       public function __toString()
       {
           return $this->_person->getTitle() . ' '
               . $this->_person->getFirstName() . ' '
               . $this->_person->getLastName();
       }
   }

In diesem Beispiel übergeben wir unsere Instanz von ``Person`` an den Constructor von ``TextPerson``. Durch
Verwendung von Methoden Überladung sind wir in der Lage weiterzumachen und alle Methoden von ``Person`` auf Ihr
aufzurufen -- um den Vornamen, den Nachnamen, oder den Titel zu setzen -- aber man erhält jetzt auch eine String
Repräsentation über die ``__toString()`` Methode.

Das letztere Beispiel kommt der Arbeitsweise der Decorators von ``Zend_Form`` schon nahe. Der eigentliche
Unterschied besteht darin, das statt den Decorator in einem Element einzubetten, das Element ein oder mehrere
Decorators angehängt haben kann welche es dann in sich selbst injiziert und weiterhin Eigenschaften um eine
Repräsentation des Elements -- oder einem Subset von sich -- zu erstellen.

.. _learning.form.decorators.simplest.first-decorator:

Den ersten Decorator erstellen
------------------------------

``Zend_Form`` Decorators implementieren alle ein gemeinsames Interface ``Zend\Form_Decorator\Interface``. Dieses
Interface bietet die Fähigkeit decorator-spezifische Optionen zu setzen, das Element zu registrieren und zu
empfangen, und darzustellen. Der Basis Decorator, ``Zend\Form_Decorator\Abstract``, bietet die jede Funktionalität
welche man irgendwann verwenden wird, mit Ausnahme der Logik für die Darstellung.

Nehmen wir eine Situation an in der wir einfach ein Element als Standard Formular Texteinfabe mit einer
Überschrift darstellen wollen. Wir denken jetzt nicht an Fehlerbehandlung oder ob das Element mit anderen Tags
umhüllt werden soll oder nicht -- nur die Grundlagen. Solch ein Decorator könnte wie folgt aussehen:

.. code-block:: php
   :linenos:

   class My_Decorator_SimpleInput extends Zend\Form_Decorator\Abstract
   {
       protected $_format = '<label for="%s">%s</label><input id="%s" name="%s" type="text" value="%s"/>';

       public function render($content)
       {
           $element = $this->getElement();
           $name    = htmlentities($element->getFullyQualifiedName());
           $label   = htmlentities($element->getLabel());
           $id      = htmlentities($element->getId());
           $value   = htmlentities($element->getValue());

           $markup  = sprintf($this->_format, $name, $label, $id, $name, $value);
           return $markup;
       }
   }

Erstellen wir ein Element welches diesen Decorator verwendet:

.. code-block:: php
   :linenos:

   $decorator = new My_Decorator_SimpleInput();
   $element   = new Zend\Form\Element('foo', array(
       'label'      => 'Foo',
       'belongsTo'  => 'bar',
       'value'      => 'test',
       'decorators' => array($decorator),
   ));

Die Darstellung dieses Elements führt zum folgenden Markup:

.. code-block:: html
   :linenos:

   <label for="bar[foo]">Foo</label>
   <input id="bar-foo" name="bar[foo]" type="text" value="test"/>

Man könnte diese Klasse auch irgendwo in die eigene Bibliothek geben, das Element über den Pfad informieren, und
auf den Decorator genauso einfach als "SimpleInput" verweisen:

.. code-block:: php
   :linenos:

   $element = new Zend\Form\Element('foo', array(
       'label'      => 'Foo',
       'belongsTo'  => 'bar',
       'value'      => 'test',
       'prefixPath' => array('decorator' => array(
           'My_Decorator' => 'path/to/decorators/',
       )),
       'decorators' => array('SimpleInput'),
   ));

Das gibt den Vorteil das er auch in anderen Projekten wiederverwendet werden kann, und öffnet die Türen damit
später alternative Implementationen dieses Decorators angeboten werden können.

Im nächsten Abschnitt schauen wir uns an wie Decorators kombiniert werden können um kombinierte Ausgaben zu
erstellen.



.. _`Decorator Design Patterns`: http://en.wikipedia.org/wiki/Decorator_pattern
.. _`Duck Typing`: http://en.wikipedia.org/wiki/Duck_typing
