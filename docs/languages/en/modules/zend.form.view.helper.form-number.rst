:orphan:

.. _zend.form.view.helper.form-number:

FormNumber
^^^^^^^^^^

The ``FormNumber`` view helper can be used to render a ``<input type="number">`` HTML
form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Number <zend.form.element.number>`
element, which provides a default input specification for validating numerical values.

``FormNumber`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input.methods>`.

.. _zend.form.view.helper.form-number.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Number('my-number');

   // Within your view...
   echo $this->formNumber($element);

Output:

.. code-block:: html
   :linenos:

   <input type="number" name="my-number" value="">

.. _zend.form.view.helper.form-number.usage.min-max-step-attributes:

Usage of ``min``, ``max`` and ``step`` attributes:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Number('my-number');
   $element->setAttributes(
       array(
           'min'  => 5,
           'max'  => 20,
           'step' => 0.5,
       )
   );
   $element->setValue(12);

   // Within your view...
   echo $this->formNumber($element);

Output:

.. code-block:: html
   :linenos:

   <input type="number" name="my-number" min="5" max="20" step="0.5" value="12">
