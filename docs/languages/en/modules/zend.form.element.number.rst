.. _zend.form.element.number:

Number
^^^^^^

``Zend\Form\Element\Number`` is meant to be paired with the ``Zend\Form\View\Helper\FormNumber`` for `HTML5 inputs with
type number`_. This element adds filters and validators to it's input filter specification in order to validate
HTML5 number input values on the server.

.. _zend.form.element.number.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"number"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $number = new Element\Number('quantity');
   $number
       ->setLabel('Quantity')
       ->setAttributes(array(
           'min'  => '0',
           'max'  => '10',
           'step' => '1', // default step interval is 1
       ));

   $form = new Form('my-form');
   $form->add($number);

Here is with the array notation:

.. code-block:: php
   :linenos:

    use Zend\Form\Form;

    $form = new Form('my-form');
    $form->add(array(
    	'type' => 'Zend\Form\Element\Number',
    	'name' => 'quantity',
    	'options' => array(
    		'label' => 'Quantity'
    	),
    	'attributes' => array(
    		'min' => '0',
    		'max' => '10',
    		'step' => '1', // default step interval is 1
    	)
    ));

.. note::

   Note: the ``min``, ``max``, and ``step`` attributes should be set prior to calling Zend\\Form::prepare().
   Otherwise, the default input specification for the element may not contain the correct validation rules.

.. _zend.form.element.number.methods:

.. rubric:: Public Methods

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element
<zend.form.element.methods>`.

.. _zend.form.element.number.methods.get-input-specification:

.. function:: getInputSpecification()
   :noindex:

   Returns a input filter specification, which includes ``Zend\Filter\StringTrim`` and will add the appropriate
   validators based on the values from the ``min``, ``max``, and ``step`` attributes.

   If the ``min`` attribute is set, a ``Zend\Validator\GreaterThan`` validator will be added to ensure the number
   value is greater than the minimum value. The ``min`` value should be a `valid floating point number`_.

   If the ``max`` attribute is set, a ``Zend\Validator\LessThan`` validator will be added to ensure the
   number value is less than the maximum value. The ``max`` value should be a `valid floating point number`_.

   If the ``step`` attribute is set to "any", step validations will be skipped. Otherwise, a
   ``Zend\Validator\Step`` validator will be added to ensure the number value is within a certain interval (default
   is 1). The ``step`` value should be either "any" or a `valid floating point number`_.

   :rtype: array



.. _`HTML5 inputs with type number`: http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#number-state-(type=number)
.. _`valid floating point number`: http://www.whatwg.org/specs/web-apps/current-work/multipage/common-microsyntaxes.html#valid-floating-point-number
