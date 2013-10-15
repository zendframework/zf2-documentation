.. _zend.form.element.radio:

Radio
^^^^^

``Zend\Form\Element\Radio`` is meant to be paired with the ``Zend\Form\View\Helper\FormRadio`` for HTML inputs
with type radio. This element adds an ``InArray`` validator to its input filter specification in order to validate
on the server if the value is contains within the radio value elements.

.. _zend.form.element.radio.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"radio"`` for every radio.

.. code-block:: php
   :linenos:

   	use Zend\Form\Element;
   	use Zend\Form\Form;

   	$radio = new Element\Radio('gender');
   	$radio->setLabel('What is your gender ?');
   	$radio->setValueOptions(array(
   			'0' => 'Female',
   			'1' => 'Male',
   	));

   	$form = new Form('my-form');
   	$form->add($radio);

Using the array notation:

.. code-block:: php
   :linenos:

    use Zend\Form\Form;

   	$form = new Form('my-form');
   	$form->add(array(
   		'type' => 'Zend\Form\Element\Radio',
   		'name' => 'gender',
   		'options' => array(
   			'label' => 'What is your gender ?',
   			'value_options' => array(
   				'0' => 'Female',
   				'1' => 'Male',
   			),
   		)
   	));


.. _zend.form.element.radio.methods:

.. rubric:: Public Methods

All the methods from the inherited :ref:`methods of Zend\\Form\\Element\\MultiCheckbox <zend.form.element.multicheckbox.methods>` are also available for this element.
