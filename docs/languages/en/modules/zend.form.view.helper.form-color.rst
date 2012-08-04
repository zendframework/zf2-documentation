.. _zend.form.view.helper.form-color:

FormColor
^^^^^^^^^

The ``FormColor`` view helper can be used to render a ``<input type="color"...>`` HTML5 element.
It is meant to work with the :ref:`Zend\\Form\\Element\\Color <zend.form.element.color>`
element, which provides a default input specification for validating HTML5 color values.

All methods are inherited from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input.methods>`.

.. _zend.form.view.helper.form-color.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Color('my-color');

   // Within your view
   echo $this->formColor($element);

   // Returns: <input type="color" name="my-color" value="">

