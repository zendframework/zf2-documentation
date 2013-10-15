.. _zend.form.view.helper.form-reset:

FormReset
^^^^^^^^^

The ``FormReset`` view helper can be used to render a ``<input type="reset">``
HTML form input.

``FormText`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input>`.

.. _zend.form.view.helper.form-reset.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element('my-reset');
   $element->setAttribute('value', 'Reset');

   // Within your view...
   echo $this->formReset($element);

Output:

.. code-block:: html
   :linenos:

   <input type="reset" name="my-reset" value="Reset">