.. _zend.form.view.helper.form-submit:

FormSubmit
^^^^^^^^^^

The ``FormSubmit`` view helper can be used to render a ``<input type="submit">``
HTML form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Submit <zend.form.element.submit>`
element.

``FormSubmit`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input>`.

.. _zend.form.view.helper.form-submit.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Submit('my-submit');

   // Within your view...
   echo $this->formSubmit($element);

Output:

.. code-block:: html
   :linenos:

   <input type="submit" name="my-submit" value="">