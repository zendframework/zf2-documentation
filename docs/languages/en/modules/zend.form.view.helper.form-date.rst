.. _zend.form.view.helper.form-date:

FormDate
^^^^^^^^

The ``FormDate`` view helper can be used to render a ``<input type="date">``
HTML5 form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Date <zend.form.element.date>`
element, which provides a default input specification for validating HTML5 date values.

``FormDate`` extends from :ref:`Zend\\Form\\View\\Helper\\FormDateTime <zend.form.view.helper.form-date-time>`.

.. _zend.form.view.helper.form-date.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Date('my-date');

   // Within your view...

   echo $this->formDate($element);
   // <input type="date" name="my-date" value="">

