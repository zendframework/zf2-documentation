.. _zend.form.element.week:

Week
^^^^

``Zend\Form\Element\Week`` is meant to be paired with the ``Zend\Form\View\Helper\FormWeek`` for `HTML5 inputs with type
week`_. This element adds filters and validators to it's input filter specification in order to validate HTML5 week
input values on the server.

.. _zend.form.element.week.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"week"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $week = new Element\Week('week');
   $week
       ->setLabel('Week')
       ->setAttributes(array(
           'min'  => '2012-W01',
           'max'  => '2020-W01',
           'step' => '1', // weeks; default step interval is 1 week
       ));

   $form = new Form('my-form');
   $form->add($week);

Here is the same example using the array notation:

.. code-block:: php
   :linenos:

    use Zend\Form\Form;

    $form = new Form('my-form');
    $form->add(array(
    	'type' => 'Zend\Form\Element\Week',
    	'name' => 'week',
    	'options' => array(
    		'label' => 'Week'
    	),
    	'attributes' => array(
    		'min' => '2012-W01',
    		'max' => '2020-W01',
    		'step' => '1', // weeks; default step interval is 1 week
    	)
    ));
    
.. note::

   Note: the ``min``, ``max``, and ``step`` attributes should be set prior to calling Zend\\Form::prepare().
   Otherwise, the default input specification for the element may not contain the correct validation rules.

.. _zend.form.element.week.methods:

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
   the ``step`` attribute to use an interval of weeks (default is 1 week).

   :rtype: array



.. _`HTML5 inputs with type week`: http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#week-state-(type=week)
