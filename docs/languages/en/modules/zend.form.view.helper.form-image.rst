.. _zend.form.view.helper.form-image:

FormImage
^^^^^^^^^

The ``FormImage`` view helper can be used to render a ``<input type="image">``
HTML form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Image <zend.form.element.image>`
element.

``FormImage`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input>`.

.. _zend.form.view.helper.form-image.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Image('my-image');
   $element->setAttribute('src', '/img/my-pic.png');

   // Within your view...

   echo $this->formImage($element);
   // <input type="image" name="my-image" src="/img/my-pic.png">

