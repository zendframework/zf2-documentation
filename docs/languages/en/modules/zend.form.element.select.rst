.. _zend.form.element.select:

Select Element
^^^^^^^^^^^^^^

``Zend\Form\Element\Select`` is meant to be paired with the ``Zend/Form/View/Helper/FormSelect`` for HTML inputs with type select. This element adds an ``InArray`` validator to its input filter specification in order to validate on the server if the selected value belongs to the values. This element can be used as a multi-select element by adding the "multiple" HTML attribute to the element.

.. _zend.form.element.select.usage:

Basic Usage
"""""""""""

This element automatically adds a ``"type"`` attribute of value ``"select"``.

.. code-block:: php
   :linenos:

   	use Zend\Form\Element;
   	use Zend\Form\Form;

   	$select = new Element\Select('language');
   	$select->setLabel('Which is your mother tongue?');
   	$select->setValueOptions(array(
   		'options' => array(
   			'European languages' => array(
   				'0' => 'French',
   				'1' => 'Italian',
   			),
   			'Asian languages' => array(
   				'2' => 'Japanese',
   				'3' => 'Chinese',
   			)
   		)   		
   	));

   	$form = new Form('language');
   	$form->add($select);

.. _zend.form.element.select.methods:

Public Methods
""""""""""""""

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element <zend.form.element.methods>` .

.. function:: setOptions(array $options)
   :noindex:

   Set options for an element of type Checkbox. Accepted options, in addition to the inherited options of Zend\\Form\\Element\\Checkbox <zend.form.element.checkbox.methods.set-options>` , are: ``"value_options"`` and ``"empty_option"``, which call ``setValueOptions`` and ``setEmptyOption``, respectively.
   
.. function:: setValueOptions(array $options)
   :noindex:

   Set the value options for every checkbox of the multi-checkbox. The array must contain a key => value for every checkbox.

.. function:: getValueOptions()
   :noindex:

   Return the value options.

   :rtype: array
   
.. function:: setEmptyOption($emptyOption)
   :noindex:

   Optionally set a label for an empty option (option with no value). It is set to "null" by default, which means that no empty option will be rendered.

.. function:: setEmptyOption()
   :noindex:

   Get the label for the empty option (null if none).

   :rtype: string
