.. _zend.form.view.helper.form-file:

FormFile
^^^^^^^^

The ``FormFile`` view helper can be used to render a ``<input type="file">``
form input. It is meant to work with the :ref:`Zend\\Form\\Element\\File <zend.form.element.file>`
element.

``FormFile`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input>`.

.. _zend.form.view.helper.form-file.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\File('my-file');

   // Within your view...

   echo $this->formFile($element);
   // <input type="file" name="my-file">


For HTML5 multiple file uploads, the ``multiple`` attribute can be used.
Browsers that do not support HTML5 will default to a single upload input.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\File('my-file');
   $element->setAttribute('multiple', true);

   // Within your view...

   echo $this->formFile($element);
   // <input type="file" name="my-file" multiple="multiple">

