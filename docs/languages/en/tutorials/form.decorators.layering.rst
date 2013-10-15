.. _learning.form.decorators.layering:

Layering Decorators
===================

If you were following closely in :ref:`the previous section <learning.form.decorators.simplest>`, you may have
noticed that a decorator's ``render()`` method takes a single argument, ``$content``. This is expected to be a
string. ``render()`` will then take this string and decide to either replace it, append to it, or prepend it. This
allows you to have a chain of decorators -- which allows you to create decorators that render only a subset of the
element's metadata, and then layer these decorators to build the full markup for the element.

Let's look at how this works in practice.

For most form element types, the following decorators are used:

- ``ViewHelper`` (render the form input using one of the standard form view helpers).

- ``Errors`` (render validation errors via an unordered list).

- ``Description`` (render any description attached to the element; often used for tooltips).

- ``HtmlTag`` (wrap all of the above in a **<dd>** tag.

- ``Label`` (render the label preceding the above, wrapped in a **<dt>** tag.

You'll notice that each of these decorators does just one thing, and operates on one specific piece of metadata
stored in the form element: the ``Errors`` decorator pulls validation errors and renders them; the ``Label``
decorator pulls just the label and renders it. This allows the individual decorators to be very succinct,
repeatable, and, more importantly, testable.

It's also where that ``$content`` argument comes into play: each decorator's ``render()`` method is designed to
accept content, and then either replace it (usually by wrapping it), prepend to it, or append to it.

So, it's best to think of the process of decoration as one of building an onion from the inside out.

To simplify the process, we'll take a look at the example from :ref:`the previous section
<learning.form.decorators.simplest>`. Recall:

.. code-block:: php
   :linenos:

   class My_Decorator_SimpleInput extends Zend\Form\Decorator\Abstract
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

Let's now remove the label functionality, and build a separate decorator for that.

.. code-block:: php
   :linenos:

   class My_Decorator_SimpleInput extends Zend\Form\Decorator\Abstract
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

   class My_Decorator_SimpleLabel extends Zend\Form\Decorator\Abstract
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

Now, this may look all well and good, but here's the problem: as written currently, the last decorator to run wins,
and overwrites everything. You'll end up with just the input, or just the label, depending on which you register
last.

To overcome this, simply concatenate the passed in ``$content`` with the markup somehow:

.. code-block:: php
   :linenos:

   return $content . $markup;

The problem with the above approach comes when you want to programmatically choose whether the original content
should precede or append the new markup. Fortunately, there's a standard mechanism for this already;
``Zend\Form\Decorator\Abstract`` has a concept of placement and defines some constants for matching it.
Additionally, it allows specifying a separator to place between the two. Let's make use of those:

.. code-block:: php
   :linenos:

   class My_Decorator_SimpleInput extends Zend\Form\Decorator\Abstract
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

   class My_Decorator_SimpleLabel extends Zend\Form\Decorator\Abstract
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

Notice in the above that I'm switching the default case for each; the assumption will be that labels prepend
content, and input appends.

Now, let's create a form element that uses these:

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

How will this work? When we call ``render()``, the element will iterate through the various attached decorators,
calling ``render()`` on each. It will pass an empty string to the very first, and then whatever content is created
will be passed to the next, and so on:

- Initial content is an empty string: ''.

- '' is passed to the ``SimpleInput`` decorator, which then generates a form input that it appends to the empty
  string: **<input id="bar-foo" name="bar[foo]" type="text" value="test"/>**.

- The input is then passed as content to the ``SimpleLabel`` decorator, which generates a label and prepends it to
  the original content; the default separator is a ``PHP_EOL`` character, giving us this: **<label
  for="bar-foo">\n<input id="bar-foo" name="bar[foo]" type="text" value="test"/>**.

But wait a second! What if you wanted the label to come after the input for some reason? Remember that "placement"
flag? You can pass it as an option to the decorator. The easiest way to do this is to pass an array of options with
the decorator during element creation:

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

Notice that when passing options, you must wrap the decorator within an array; this hints to the constructor that
options are available. The decorator name is the first element of the array, and options are passed in an array to
the second element of the array.

The above results in the markup **<input id="bar-foo" name="bar[foo]" type="text" value="test"/>\n<label
for="bar-foo">**.

Using this technique, you can have decorators that target specific metadata of the element or form and create only
the markup relevant to that metadata; by using multiple decorators, you can then build up the complete element
markup. Our onion is the result.

There are pros and cons to this approach. First, the cons:

- More complex to implement. You have to pay careful attention to the decorators you use and what placement you
  utilize in order to build up the markup in the correct sequence.

- More resource intensive. More decorators means more objects; multiply this by the number of elements you have in
  a form, and you may end up with some serious resource usage. Caching can help here.

The advantages are compelling, though:

- Reusable decorators. You can create truly re-usable decorators with this technique, as you don't have to worry
  about the complete markup, but only markup for one or a few pieces of element or form metadata.

- Ultimate flexibility. You can theoretically generate any markup combination you want from a small number of
  decorators.

While the above examples are the intended usage of decorators within ``Zend_Form``, it's often hard to wrap your
head around how the decorators interact with one another to build the final markup. For this reason, some
flexibility was added in the 1.7 series to make rendering individual decorators possible -- which gives some
Rails-like simplicity to rendering forms. We'll look at that in the next section.


