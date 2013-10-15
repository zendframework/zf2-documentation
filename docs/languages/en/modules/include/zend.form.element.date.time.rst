.. _zend.form.element.date-time:

DateTime
^^^^^^^^

``Zend\Form\Element\DateTime`` is meant to be paired with the ``Zend\Form\View\Helper\FormDateTime`` for `HTML5 inputs
with type datetime`_. This element adds filters and validators to it's input filter specification in order to
validate HTML5 datetime input values on the server.

.. _zend.form.element.date-time.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"datetime"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $dateTime = new Element\DateTime('appointment-date-time');
   $dateTime
       ->setLabel('Appointment Date/Time')
       ->setAttributes(array(
           'min'  => '2010-01-01T00:00:00Z',
           'max'  => '2020-01-01T00:00:00Z',
           'step' => '1', // minutes; default step interval is 1 min
       ))
       ->setOptions(array(
           'format' => 'Y-m-d\TH:iP'
       ));

   $form = new Form('my-form');
   $form->add($dateTime);

Here is with the array notation:

.. code-block:: php
   :linenos:

    use Zend\Form\Form;

    $form = new Form('my-form');
    $form->add(array(
    	'type' => 'Zend\Form\Element\DateTime',
    	'name' => 'appointment-date-time',
    	'options' => array(
    		'label' => 'Appointment Date/Time',
    		'format' => 'Y-m-d\TH:iP'
    	),
    	'attributes' => array(
    		'min' => '2010-01-01T00:00:00Z',
    		'max' => '2020-01-01T00:00:00Z',
    		'step' => '1', // minutes; default step interval is 1 min
    	)
    ));

.. note::

   Note: the ``min``, ``max``, and ``step`` attributes should be set prior to calling Zend\\Form::prepare().
   Otherwise, the default input specification for the element may not contain the correct validation rules.

.. _zend.form.element.date-time.methods:

.. rubric:: Public Methods

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element
<zend.form.element.methods>`.

.. _zend.form.element.date-time.methods.get-input-specification:

.. function:: getInputSpecification()
   :noindex:

   Returns a input filter specification, which includes ``Zend\Filter\StringTrim`` and will add the appropriate
   validators based on the values from the ``min``, ``max``, and ``step`` attributes and ``format`` option.

   If the ``min`` attribute is set, a ``Zend\Validator\GreaterThan`` validator will be added to ensure the date
   value is greater than the minimum value.

   If the ``max`` attribute is set, a ``Zend\Validator\LessThanValidator`` validator will be added to ensure the
   date value is less than the maximum value.

   If the ``step`` attribute is set to "any", step validations will be skipped. Otherwise, a
   ``Zend\Validator\DateStep`` validator will be added to ensure the date value is within a certain interval of
   minutes (default is 1 minute).
   
   The input filter specification also includes a ``Zend\Validator\Date`` validator to ensure the format of the
   value. If the ``format`` option is set, that format will be used. Otherwise the default format will be used.

   :rtype: array

.. function:: setOptions(array $options)
   :noindex:

   Set options for an element of type DateTime. The accepted option, in addition to the inherited options of :ref:`Zend\\Form\\Element <zend.form.element.methods.set-options>` , is: ``"format"``, which calls
   ``setFormat``.

.. function:: setFormat(string $format)
   :noindex:
   
   Sets the format used to validate the value. Accepts a ``\DateTime`` compatible string.

.. function:: getFormat()
   :noindex:
   
   Return the DateTime format used to validate the value.
   
   :rtype: String



.. _`HTML5 inputs with type datetime`: http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#date-and-time-state-(type=datetime)
