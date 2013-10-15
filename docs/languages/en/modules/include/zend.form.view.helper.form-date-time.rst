.. _zend.form.view.helper.form-date-time:

FormDateTime
^^^^^^^^^^^^

The ``FormDateTime`` view helper can be used to render a ``<input type="datetime">``
HTML5 form input. It is meant to work with the :ref:`Zend\\Form\\Element\\DateTime <zend.form.element.date-time>`
element, which provides a default input specification for validating HTML5 datetime values.

``FormDateTime`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input.methods>`.

.. _zend.form.view.helper.form-date-time.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\DateTime('my-datetime');

   // Within your view...

   echo $this->formDateTime($element);
   // <input type="datetime" name="my-datetime" value="">

