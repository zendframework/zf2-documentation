.. _zend.form.element.range:

Zend\\Form\\Element\\Range
==========================

The ``Range`` element is meant to be paired with the ``Zend/Form/View/Helper/FormRange`` for `HTML5 inputs with type range`_. This element adds filters and validators to it's input filter specification in order to validate HTML5 range values on the server.

.. _zend.form.element.range.usage:

.. rubric:: Basic Usage of Zend\\Form\\Element\\Range

This element automatically adds a ``"type"`` attribute of value ``"range"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $range = new Element\Range('range');
   $range
       ->setLabel('Minimum and Maximum Amount')
       ->setAttributes(array(
           'min'  => '0',   // default minimum is 0
           'max'  => '100', // default maximum is 100
           'step' => '1',   // default interval is 1
       ));

   $form = new Form('my-form');
   $form->add($range);

.. note::

   Note: the ``min``, ``max``, and ``step`` attributes should be set prior to calling Zend\\Form::prepare(). Otherwise, the default input specification for the element may not contain the correct validation rules.

.. _zend.form.element.range.methods:

Available Methods
-----------------

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element\\Number <zend.form.element.number.methods>`.

.. _zend.form.element.range.methods.get-input-specification:

**getInputSpecification**
   ``getInputSpecification()``
   Returns a input filter specification, which includes ``Zend\Filter\StringTrim`` and will add the appropriate validators based on the values from the ``min``, ``max``, and ``step`` attributes. See :ref:`getInputSpecification in Zend\\Form\\Element\\Number <zend.form.element.number.methods.get-input-specification>` for more information.

   The ``Range`` element differs from ``Zend\Form\Element\Number`` in that the ``Zend\Validator\GreaterThan`` and ``Zend\Validator\LessThan`` validators will always be present. The default minimum is 1, and the default maximum is 100.

   Returns array



.. _`HTML5 inputs with type range`: http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#range-state-(type=range)
