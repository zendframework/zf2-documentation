.. _zend.form.view.helper.form-hidden:

FormHidden
^^^^^^^^^^

The ``FormHidden`` view helper can be used to render a ``<input type="hidden">``
HTML form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Hidden <zend.form.element.hidden>`
element.

``FormHidden`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input>`.

.. _zend.form.view.helper.form-hidden.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Hidden('my-hidden');
   $element->setValue('foo');

   // Within your view...

   echo $this->formHidden($element);
   // <input type="hidden" name="my-hidden" value="foo">

