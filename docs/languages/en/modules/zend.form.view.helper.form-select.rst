.. _zend.form.view.helper.form-select:

FormSelect
^^^^^^^^^^

The ``FormSelect`` view helper can be used to render a group ``<input type="select">`` HTML
form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Select <zend.form.element.select>`
element, which provides a default input specification for validating a select.

``FormSelect`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input.methods>`.

.. _zend.form.view.helper.form-select.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Select('language');
   $element->setValueOptions(array(
      '0' => 'French',
      '1' => 'English',
      '2' => 'Japanese',
      '3' => 'Chinese'
   ));

   // Within your view...

   /**
    * Example
    */
   echo $this->formSelect($element);