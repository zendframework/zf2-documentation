.. _zend.form.view.helper.form-password:

FormPassword
^^^^^^^^^^^^

The ``FormPassword`` view helper can be used to render a ``<input type="password">``
HTML form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Password <zend.form.element.password>`
element.

``FormPassword`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input>`.

.. _zend.form.view.helper.form-password.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Password('my-password');

   // Within your view...
   echo $this->formPassword($element);

Output:

.. code-block:: html
   :linenos:

   <input type="password" name="my-password" value="">