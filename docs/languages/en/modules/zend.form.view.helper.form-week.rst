.. _zend.form.view.helper.form-week:

FormWeek
^^^^^^^^

The ``FormWeek`` view helper can be used to render a ``<input type="week">``
HTML5 form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Week <zend.form.element.week>`
element, which provides a default input specification for validating HTML5 week values.

``FormWeek`` extends from :ref:`Zend\\Form\\View\\Helper\\FormDateTime <zend.form.view.helper.form-date-time>`.

.. _zend.form.view.helper.form-week.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Week('my-week');

   // Within your view...

   echo $this->formWeek($element);
   // <input type="week" name="my-week" value="">

