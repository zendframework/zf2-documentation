.. _zend.form.view.helper.form-email:

FormEmail
^^^^^^^^^

The ``FormEmail`` view helper can be used to render a ``<input type="email">``
HTML5 form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Email <zend.form.element.email>`
element, which provides a default input specification with an email validator.

``FormEmail`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input>`.

.. _zend.form.view.helper.form-email.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Email('my-email');

   // Within your view...

   echo $this->formEmail($element);
   // <input type="email" name="my-email" value="">

