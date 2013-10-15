.. _zend.form.view.helper.form-date-time-local:

FormDateTimeLocal
^^^^^^^^^^^^^^^^^

The ``FormDateTimeLocal`` view helper can be used to render a ``<input type="datetime-local">``
HTML5 form input. It is meant to work with the :ref:`Zend\\Form\\Element\\DateTimeLocal <zend.form.element.date-time-local>`
element, which provides a default input specification for validating HTML5 datetime values.

``FormDateTimeLocal`` extends from :ref:`Zend\\Form\\View\\Helper\\FormDateTime <zend.form.view.helper.form-date-time>`.

.. _zend.form.view.helper.form-date-time-local.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\DateTimeLocal('my-datetime');

   // Within your view...

   echo $this->formDateTimeLocal($element);
   // <input type="datetime-local" name="my-datetime" value="">

