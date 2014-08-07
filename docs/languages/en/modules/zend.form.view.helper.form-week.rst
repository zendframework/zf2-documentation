:orphan:

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

Output:

.. code-block:: html
   :linenos:

   <input type="week" name="my-week" value="">

.. _zend.form.view.helper.form-week.usage.min-max-step-attributes:

Usage of ``min``, ``max`` and ``step`` attributes:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Week('my-week');
   $element->setAttributes(
       array(
           'min'  => '2012-W01',
           'max'  => '2020-W01',
           'step' => 2, // weeks; default step interval is 1 week
       )
   );
   $element->setValue('2014-W10');

   // Within your view...
   echo $this->formWeek($element);

Output:

.. code-block:: html
   :linenos:

   <input type="week" name="my-week" min="2012-W01" max="2020-W01" step="2" value="2014-W10">