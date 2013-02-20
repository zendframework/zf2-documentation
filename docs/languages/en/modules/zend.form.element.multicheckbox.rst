.. _zend.form.element.multicheckbox:

MultiCheckbox
^^^^^^^^^^^^^

``Zend\Form\Element\MultiCheckbox`` is meant to be paired with the ``Zend\Form\View\Helper\FormMultiCheckbox``
for HTML inputs with type checkbox. This element adds an ``InArray`` validator to its input filter specification
in order to validate on the server if the checkbox contains values from the multiple checkboxes.

.. _zend.form.element.multicheckbox.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"checkbox"`` for every checkboxes.

.. code-block:: php
   :linenos:

   	use Zend\Form\Element;
   	use Zend\Form\Form;

   	$multiCheckbox = new Element\MultiCheckbox('multi-checkbox');
   	$multiCheckbox->setLabel('What do you like ?');
   	$multiCheckbox->setValueOptions(array(
   			'0' => 'Apple',
   			'1' => 'Orange',
   			'2' => 'Lemon'
   	));

   	$form = new Form('my-form');
   	$form->add($multiCheckbox);

Using the array notation:

.. code-block:: php
   :linenos:

    use Zend\Form\Form;

   	$form = new Form('my-form');
   	$form->add(array(
   		'type' => 'Zend\Form\Element\MultiCheckbox',
   		'name' => 'multi-checkbox',
   		'options' => array(
   			'label' => 'What do you like ?',
   			'value_options' => array(
   				'0' => 'Apple',
   				'1' => 'Orange',
   				'2' => 'Lemon',
   			),
   		)
   	));


.. _zend.form.element.multicheckbox.methods:

.. rubric:: Public Methods

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element\\Checkbox <zend.form.element.checkbox.methods>` .

.. function:: setOptions(array $options)
   :noindex:

   Set options for an element of type Checkbox. Accepted options, in addition to the inherited :ref:`options of Zend\\Form\\Element\\Checkbox <zend.form.element.checkbox.methods.set-options>` , are: ``"value_options"``, which call ``setValueOptions``.

.. function:: setValueOptions(array $options)
   :noindex:

   Set the value options for every checkbox of the multi-checkbox. The array must contain a key => value for every checkbox.

.. function:: getValueOptions()
   :noindex:

   Return the value options.

   :rtype: array
