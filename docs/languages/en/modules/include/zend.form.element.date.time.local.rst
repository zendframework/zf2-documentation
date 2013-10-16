.. _zend.form.element.date-time-local:

DateTimeLocal
^^^^^^^^^^^^^

``Zend\Form\Element\DateTimeLocal`` is meant to be paired with the ``Zend\Form\View\Helper\FormDateTimeLocal`` for `HTML5
inputs with type datetime-local`_. This element adds filters and validators to it's input filter specification in
order to validate HTML5 a local datetime input values on the server.

.. _zend.form.element.date-time-local.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"datetime-local"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $dateTimeLocal = new Element\DateTimeLocal('appointment-date-time');
   $dateTimeLocal
       ->setLabel('Appointment Date')
       ->setAttributes(array(
           'min'  => '2010-01-01T00:00:00',
           'max'  => '2020-01-01T00:00:00',
           'step' => '1', // minutes; default step interval is 1 min
       ))
       ->setOptions(array(
           'format' => 'Y-m-d\TH:i'
       ));

   $form = new Form('my-form');
   $form->add($dateTimeLocal);

Here is with the array notation:

.. code-block:: php
   :linenos:

    use Zend\Form\Form;

    $form = new Form('my-form');
    $form->add(array(
    	'type' => 'Zend\Form\Element\DateTimeLocal',
    	'name' => 'appointment-date-time',
    	'options' => array(
    		'label'  => 'Appointment Date',
    		'format' => 'Y-m-d\TH:i'
    	),
    	'attributes' => array(
    		'min' => '2010-01-01T00:00:00',
    		'max' => '2020-01-01T00:00:00',
    		'step' => '1', // minutes; default step interval is 1 min
    	)
    ));

.. note::

   Note: the ``min``, ``max``, and ``step`` attributes should be set prior to calling Zend\\Form::prepare().
   Otherwise, the default input specification for the element may not contain the correct validation rules.

.. _zend.form.element.date-time-local.methods:

.. rubric:: Public Methods

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element\\DateTime
<zend.form.element.date-time.methods>`.

.. function:: getInputSpecification()
   :noindex:

   Returns a input filter specification, which includes ``Zend\Filter\StringTrim`` and will add the appropriate
   validators based on the values from the ``min``, ``max``, and ``step`` attributes and ``format`` option. See
   :ref:`getInputSpecification in Zend\\Form\\Element\\DateTime
   <zend.form.element.date-time.methods.get-input-specification>` for more information.

   :rtype: array



.. _`HTML5 inputs with type datetime-local`: http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#local-date-and-time-state-(type=datetime-local)
