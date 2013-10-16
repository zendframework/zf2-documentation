.. _zend.form.element.date:

Date
^^^^

``Zend\Form\Element\Date`` is meant to be paired with the ``Zend\Form\View\Helper\FormDate`` for `HTML5 inputs with type
date`_. This element adds filters and validators to it's input filter specification in order to validate HTML5 date
input values on the server.

.. _zend.form.element.date.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"date"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $date = new Element\Date('appointment-date');
   $date
       ->setLabel('Appointment Date')
       ->setAttributes(array(
           'min'  => '2012-01-01',
           'max'  => '2020-01-01',
           'step' => '1', // days; default step interval is 1 day
       ))
       ->setOptions(array(
           'format' => 'Y-m-d'
       ));

   $form = new Form('my-form');
   $form->add($date);

Here is with the array notation:

.. code-block:: php
   :linenos:

    use Zend\Form\Form;

    $form = new Form('my-form');
    $form->add(array(
    	'type' => 'Zend\Form\Element\Date',
    	'name' => 'appointment-date',
    	'options' => array(
    		'label' => 'Appointment Date',
    		'format' => 'Y-m-d'
    	),
    	'attributes' => array(
    		'min' => '2012-01-01',
    		'max' => '2020-01-01',
    		'step' => '1', // days; default step interval is 1 day
    	)
    ));

.. note::

   Note: the ``min``, ``max``, and ``step`` attributes should be set prior to calling Zend\\Form::prepare().
   Otherwise, the default input specification for the element may not contain the correct validation rules.

.. _zend.form.element.date.methods:

.. rubric:: Public Methods

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element\\DateTime
<zend.form.element.date-time.methods>`.

.. function:: getInputSpecification()
   :noindex:

   Returns a input filter specification, which includes ``Zend\Filter\StringTrim`` and will add the appropriate
   validators based on the values from the ``min``, ``max``, and ``step`` attributes and ``format`` option. See
   :ref:`getInputSpecification in Zend\\Form\\Element\\DateTime
   <zend.form.element.date-time.methods.get-input-specification>` for more information.

   One difference from ``Zend\Form\Element\DateTime`` is that the ``Zend\Validator\DateStep`` validator will expect
   the ``step`` attribute to use an interval of days (default is 1 day).

   :rtype: array



.. _`HTML5 inputs with type date`: http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#date-state-(type=date)
