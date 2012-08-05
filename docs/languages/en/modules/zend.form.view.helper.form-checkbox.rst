.. _zend.form.view.helper.form-checkbox:

FormCheckbox
^^^^^^^^^^^^

The ``FormCheckbox`` view helper can be used to render a ``<input type="checkbox">`` HTML
form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Checkbox <zend.form.element.checkbox>`
element, which provides a default input specification for validating the checkbox values.

``FormCheckbox`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input.methods>`.

.. _zend.form.view.helper.form-checkbox.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Checkbox('my-checkbox');

   // Within your view...

   /**
    * Example #1: Default options
    */
   echo $this->formCheckbox($element);
   // <input type="hidden" name="my-checkbox" value="0">
   // <input type="checkbox" name="my-checkbox" value="1">

   /**
    * Example #2: Disable hidden element
    */
   $element->setUseHiddenElement(false);
   echo $this->formCheckbox($element);
   // <input type="checkbox" name="my-checkbox" value="1">

   /**
    * Example #3: Change checked/unchecked values
    */
   $element->setUseHiddenElement(true)
           ->setUncheckedValue('no')
           ->setCheckedValue('yes');
   echo $this->formCheckbox($element);
   // <input type="hidden" name="my-checkbox" value="no">
   // <input type="checkbox" name="my-checkbox" value="yes">

