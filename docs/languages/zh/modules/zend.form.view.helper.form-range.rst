:orphan:

.. _zend.form.view.helper.form-range:

FormRange
^^^^^^^^^

The ``FormRange`` view helper can be used to render a ``<input type="range">`` HTML
form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Range <zend.form.element.range>`
element, which provides a default input specification for validating numerical values.

``FormRange`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input.methods>`.

.. _zend.form.view.helper.form-range.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Range('my-range');

   // Within your view...
   echo $this->formRange($element);

Output:

.. code-block:: html
   :linenos:

   <input type="range" name="my-range" value="">

.. _zend.form.view.helper.form-range.usage.min-max-step-attributes:

Usage of ``min``, ``max`` and ``step`` attributes:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Range('my-range');
   $element->setAttributes(
       array(
           'min'  => 0,
           'max'  => 100,
           'step' => 5,
       )
   );
   $element->setValue(20);

   // Within your view...
   echo $this->formRange($element);

Output:

.. code-block:: html
   :linenos:

   <input type="range" name="my-range" min="0" max="100" step="5" value="20">
