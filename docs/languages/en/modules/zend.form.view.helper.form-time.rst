.. _zend.form.view.helper.form-time:

FormTime
^^^^^^^^

The ``FormTime`` view helper can be used to render a ``<input type="time">``
HTML5 form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Time <zend.form.element.time>`
element, which provides a default input specification for validating HTML5 time values.

``FormTime`` extends from :ref:`Zend\\Form\\View\\Helper\\FormDateTime <zend.form.view.helper.form-date-time>`.

.. _zend.form.view.helper.form-time.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Time('my-time');

   // Within your view...

   echo $this->formTime($element);
   // <input type="time" name="my-time" value="">

