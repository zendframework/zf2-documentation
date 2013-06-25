.. _zend.form.view.helper.form-text:

FormText
^^^^^^^^

The ``FormText`` view helper can be used to render a ``<input type="text">``
HTML form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Text <zend.form.element.text>`
element.

``FormText`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input>`.

.. _zend.form.view.helper.form-text.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Text('my-text');

   // Within your view...
   echo $this->formText($element);

Output:

.. code-block:: html
   :linenos:

   <input type="text" name="my-text" value="">