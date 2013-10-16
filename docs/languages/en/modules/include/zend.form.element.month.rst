.. _zend.form.element.month:

Month
^^^^^

``Zend\Form\Element\Month`` is meant to be paired with the ``Zend\Form\View\Helper\FormMonth`` for `HTML5 inputs with
type month`_. This element adds filters and validators to it's input filter specification in order to validate
HTML5 month input values on the server.

.. _zend.form.element.month.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"month"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $month = new Element\Month('month');
   $month
       ->setLabel('Month')
       ->setAttributes(array(
           'min'  => '2012-01',
           'max'  => '2020-01',
           'step' => '1', // months; default step interval is 1 month
       ));

   $form = new Form('my-form');
   $form->add($month);
   
Here is with the array notation:

.. code-block:: php
   :linenos:

    use Zend\Form\Form;

    $form = new Form('my-form');
    $form->add(array(
    	'type' => 'Zend\Form\Element\Month',
    	'name' => 'month',
    	'options' => array(
    		'label' => 'Month'
    	),
    	'attributes' => array(
    		'min' => '2012-12',
    		'max' => '2020-01',
    		'step' => '1', // months; default step interval is 1 month
    	)
    ));

.. note::

   Note: the ``min``, ``max``, and ``step`` attributes should be set prior to calling Zend\\Form::prepare().
   Otherwise, the default input specification for the element may not contain the correct validation rules.

.. _zend.form.element.month.methods:

.. rubric:: Public Methods

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element\\DateTime
<zend.form.element.date-time.methods>`.

.. function:: getInputSpecification()
   :noindex:

   Returns a input filter specification, which includes ``Zend\Filter\StringTrim`` and will add the appropriate
   validators based on the values from the ``min``, ``max``, and ``step`` attributes. See
   :ref:`getInputSpecification in Zend\\Form\\Element\\DateTime
   <zend.form.element.date-time.methods.get-input-specification>` for more information.

   One difference from ``Zend\Form\Element\DateTime`` is that the ``Zend\Validator\DateStep`` validator will expect
   the ``step`` attribute to use an interval of months (default is 1 month).

   :rtype: array



.. _`HTML5 inputs with type month`: http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#month-state-(type=month)
