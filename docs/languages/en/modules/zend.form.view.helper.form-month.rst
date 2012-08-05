.. _zend.form.view.helper.form-month:

FormMonth
^^^^^^^^^

The ``FormMonth`` view helper can be used to render a ``<input type="month">``
HTML5 form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Month <zend.form.element.month>`
element, which provides a default input specification for validating HTML5 date values.

``FormMonth`` extends from :ref:`Zend\\Form\\View\\Helper\\FormDateTime <zend.form.view.helper.form-date-time>`.

.. _zend.form.view.helper.form-month.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Month('my-month');

   // Within your view...

   echo $this->formMonth($element);
   // <input type="month" name="my-month" value="">

