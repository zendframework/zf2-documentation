.. _zend.form.element.color:

Color Element
-------------

``Zend\Form\Element\Color`` is meant to be paired with the ``Zend/Form/View/Helper/FormColor`` for `HTML5 inputs with
type color`_. This element adds filters and a ``Regex`` validator to it's input filter specification in order to
validate a `HTML5 valid simple color`_ value on the server.

.. _zend.form.element.color.usage:

**Basic Usage**

This element automatically adds a ``"type"`` attribute of value ``"color"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $color = new Element\Color('color');
   $color->setLabel('Background color');

   $form = new Form('my-form');
   $form->add($color);

.. _zend.form.element.color.methods:

**Public Methods**

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element
<zend.form.element.methods>`.

.. function:: getInputSpecification()
   :noindex:

   Returns a input filter specification, which includes ``Zend\Filter\StringTrim`` and
   ``Zend\Filter\StringToLower`` filters, and a ``Zend\Validator\Regex`` to validate the RGB hex format.

   Returns array



.. _`HTML5 inputs with type color`: http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#color-state-(type=color)
.. _`HTML5 valid simple color`: http://www.whatwg.org/specs/web-apps/current-work/multipage/common-microsyntaxes.html#valid-simple-color
