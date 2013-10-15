.. _zend.form.element.select:

Select
^^^^^^

``Zend\Form\Element\Select`` is meant to be paired with the ``Zend\Form\View\Helper\FormSelect`` for HTML inputs
with type select. This element adds an ``InArray`` validator to its input filter specification in order to validate
on the server if the selected value belongs to the values. This element can be used as a multi-select element by adding
the "multiple" HTML attribute to the element.

.. _zend.form.element.select.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"select"``.

.. code-block:: php
   :linenos:

   	use Zend\Form\Element;
   	use Zend\Form\Form;

   	$select = new Element\Select('language');
   	$select->setLabel('Which is your mother tongue?');
   	$select->setValueOptions(array(
   		'0' => 'French',
   		'1' => 'English',
   		'2' => 'Japanese',
   		'3' => 'Chinese',
   	));

   	$form = new Form('language');
   	$form->add($select);
   
Using the array notation:

.. code-block:: php
   :linenos:
   
    use Zend\Form\Form;
    
   	$form = new Form('my-form');   	
   	$form->add(array(
   		'type' => 'Zend\Form\Element\Select',
   		'name' => 'language',
   		'options' => array(
   			'label' => 'Which is your mother tongue?',
   			'value_options' => array(
   				'0' => 'French',
   				'1' => 'English',
   				'2' => 'Japanese',
   				'3' => 'Chinese',
   			),
   		)
   	));
   
You can add an empty option (option with no value) using the ``"empty_option"`` option:

.. code-block:: php
   :linenos:
   
    use Zend\Form\Form;
    
   	$form = new Form('my-form');   	
   	$form->add(array(
   		'type' => 'Zend\Form\Element\Select',
   		'name' => 'language',
   		'options' => array(
   			'label' => 'Which is your mother tongue?',
   			'empty_option' => 'Please choose your language',
   			'value_options' => array(
   				'0' => 'French',
   				'1' => 'English',
   				'2' => 'Japanese',
   				'3' => 'Chinese',
   			),
   		)
   	));
   
Option groups are also supported. You just need to add an 'options' key to the value options.

.. code-block:: php
   :linenos:

   	use Zend\Form\Element;
   	use Zend\Form\Form;

   	$select = new Element\Select('language');
   	$select->setLabel('Which is your mother tongue?');
   	$select->setValueOptions(array(
         'european' => array(
            'label' => 'European languages',
            'options' => array(
               '0' => 'French',
               '1' => 'Italian',
            ),
         ),
         'asian' => array(
            'label' => 'Asian languages',
            'options' => array(
               '2' => 'Japanese',
               '3' => 'Chinese',
            ),
         ),
   	));

   	$form = new Form('language');
   	$form->add($select);

.. _zend.form.element.select.methods:

.. rubric:: Public Methods

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element <zend.form.element.methods>` .

.. function:: setOptions(array $options)
   :noindex:

   Set options for an element of type Checkbox. Accepted options, in addition to the inherited :ref:`options of Zend\\Form\\Element\\Checkbox <zend.form.element.checkbox.methods.set-options>` , are: ``"value_options"`` and ``"empty_option"``, which call ``setValueOptions`` and ``setEmptyOption``, respectively.
   
.. function:: setValueOptions(array $options)
   :noindex:

   Set the value options for the select element. The array must contain key => value pairs.

.. function:: getValueOptions()
   :noindex:

   Return the value options.

   :rtype: array
   
.. function:: setEmptyOption($emptyOption)
   :noindex:

   Optionally set a label for an empty option (option with no value). It is set to "null" by default, which means that no empty option will be rendered.

.. function:: getEmptyOption()
   :noindex:

   Get the label for the empty option (null if none).

   :rtype: string|null
