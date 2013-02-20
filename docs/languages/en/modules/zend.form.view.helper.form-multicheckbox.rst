.. _zend.form.view.helper.form-multicheckbox:

FormMultiCheckbox
^^^^^^^^^^^^^^^^^

The ``FormMultiCheckbox`` view helper can be used to render a group ``<input type="checkbox">`` HTML
form inputs. It is meant to work with the :ref:`Zend\\Form\\Element\\MultiCheckbox <zend.form.element.multicheckbox>`
element, which provides a default input specification for validating a multi checkbox.

``FormMultiCheckbox`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input.methods>`.

.. _zend.form.view.helper.form-multicheckbox.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\MultiCheckbox('my-multicheckbox');
   $element->setValueOptions(array(
      '0' => 'Apple',
      '1' => 'Orange',
      '2' => 'Lemon',
   ));

   // Within your view...

   /**
    * Example #1: using the default label placement
    */
   echo $this->formMultiCheckbox($element);
   // <label><input type="checkbox" name="my-multicheckbox[]" value="0">Apple</label>
   // <label><input type="checkbox" name="my-multicheckbox[]" value="1">Orange</label>
   // <label><input type="checkbox" name="my-multicheckbox[]" value="2">Lemon</label>

   /**
    * Example #2: using the prepend label placement
    */
   echo $this->formMultiCheckbox($element, 'prepend');
   // <label>Apple<input type="checkbox" name="my-multicheckbox[]" value="0"></label>
   // <label>Orange<input type="checkbox" name="my-multicheckbox[]" value="1"></label>
   // <label>Lemon<input type="checkbox" name="my-multicheckbox[]" value="2"></label>

