.. _learning.form.decorators.simplest:

Decorator Basics
================

.. _learning.form.decorators.simplest.decorator-overview:

Overview of the Decorator Pattern
---------------------------------

To begin, we'll cover some background on the `Decorator design pattern`_. One common technique is to define a
common interface that both your originating object and decorator will implement; your decorator than accepts the
originating object as a dependency, and will either proxy to it or override its methods. Let's put that into code
to make it more easily understood:

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

You then create an object of type ``StandardWindow``, pass it to the constructor of ``LockedWindow``, and your
window instance now has different behavior. The beauty is that you don't have to implement any sort of "locking"
functionality on your standard window class -- the decorator takes care of that for you. In the meantime, you can
pass your locked window around as if it were just another window.

One particular place where the decorator pattern is useful is for creating textual representations of objects. As
an example, you might have a "Person" object that, by itself, has no textual representation. By using the Decorator
pattern, you can create an object that will act as if it were a Person, but also provide the ability to render that
Person textually.

In this particular example, we're going to use `duck typing`_ instead of an explicit interface. This allows our
implementation to be a bit more flexible, while still allowing the decorator object to act exactly as if it were a
Person object.

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
               throw new Exception('Invalid method called on HtmlPerson: '
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

In this example, you pass your ``Person`` instance to the ``TextPerson`` constructor. By using method overloading,
you are able to continue to call all the methods of ``Person``-- to set the first name, last name, or title -- but
you also now gain a string representation via the ``__toString()`` method.

This latter example is getting close to how ``Zend_Form`` decorators work. The key difference is that instead of a
decorator wrapping the element, the element has one or more decorators attached to it that it then injects itself
into in order to render. The decorator then can access the element's methods and properties in order to create a
representation of the element -- or a subset of it.

.. _learning.form.decorators.simplest.first-decorator:

Creating Your First Decorator
-----------------------------

``Zend_Form`` decorators all implement a common interface, ``Zend\Form\Decorator\Interface``. That interface
provides the ability to set decorator-specific options, register and retrieve the element, and render. A base
decorator, ``Zend\Form\Decorator\Abstract``, provides most of the functionality you will ever need, with the
exception of the rendering logic.

Let's consider a situation where we simply want to render an element as a standard form text input with a label. We
won't worry about error handling or whether or not the element should be wrapped within other tags for now -- just
the basics. Such a decorator might look like this:

.. code-block:: php
   :linenos:

   class My_Decorator_SimpleInput extends Zend\Form\Decorator\Abstract
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

Let's create an element that uses this decorator:

.. code-block:: php
   :linenos:

   $decorator = new My_Decorator_SimpleInput();
   $element   = new Zend\Form\Element('foo', array(
       'label'      => 'Foo',
       'belongsTo'  => 'bar',
       'value'      => 'test',
       'decorators' => array($decorator),
   ));

Rendering this element results in the following markup:

.. code-block:: html
   :linenos:

   <label for="bar[foo]">Foo</label>
   <input id="bar-foo" name="bar[foo]" type="text" value="test"/>

You could also put this class in your library somewhere, inform your element of that path, and refer to the
decorator as simply "SimpleInput" as well:

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

This gives you the benefit of re-use in other projects, and also opens the door for providing alternate
implementations of that decorator later.

In the next section, we'll look at how to combine decorators in order to create composite output.



.. _`Decorator design pattern`: http://en.wikipedia.org/wiki/Decorator_pattern
.. _`duck typing`: http://en.wikipedia.org/wiki/Duck_typing
