.. _zend.form.view.helper.form-color:

FormColor
---------

The ``FormColor`` view helper can be used to render a ``<input type="color"...>`` HTML5 element.
It works well with the ``Zend/Form/Element/Color`` element, which provides a default input specification for
validating HTML5 color values.

.. _zend.form.view.helper.form-color.usage:

Basic Usage
^^^^^^^^^^^

.. code-block:: php
   :linenos:
   use Zend\Form\Element;

   $colorElement = new Element\Color('my-color');

   // Within your view
   echo $this->formColor($colorElement);
   // Returns: <input type="color" name="my-color" value="">

Public Methods
^^^^^^^^^^^^^^

All methods are inherited from
 :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input.methods>`.

