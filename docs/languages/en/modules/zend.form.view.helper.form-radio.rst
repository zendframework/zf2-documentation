.. _zend.form.view.helper.form-radio:

FormRadio
^^^^^^^^^

The ``FormRadio`` view helper can be used to render a group ``<input type="radio">`` HTML
form inputs. It is meant to work with the :ref:`Zend\\Form\\Element\\Radio <zend.form.element.radio>`
element, which provides a default input specification for validating a radio.

``FormRadio`` extends from :ref:`Zend\\Form\\View\\Helper\\FormMultiCheckbox <zend.form.view.helper.form-multicheckbox.methods>`.

.. _zend.form.view.helper.form-radio.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Radio('gender');
   $element->setValueOptions(array(
      '0' => 'Male',
      '1' => 'Female',
   ));

   // Within your view...

   /**
    * Example #1: using the default label placement
    */
   echo $this->formRadio($element);
   // <label><input type="radio" name="gender[]" value="0">Male</label>
   // <label><input type="radio" name="gender[]" value="1">Female</label>
   
   /**
    * Example #2: using the prepend label placement
    */
   echo $this->formRadio($element, 'prepend');
   // <label>Male<input type="checkbox" name="gender[]" value="0"></label>
   // <label>Female<input type="checkbox" name="gender[]" value="1"></label>

