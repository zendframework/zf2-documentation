.. _zend.form.view.helper.form-tel:

FormTel
^^^^^^^

The ``FormTel`` view helper can be used to render a ``<input type="tel">``
HTML5 form input.

``FormTel`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input>`.

.. _zend.form.view.helper.form-tel.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element('my-tel');

   // Within your view...
   echo $this->formTel($element);

Output:

.. code-block:: html
   :linenos:

   <input type="tel" name="my-tel" value="">