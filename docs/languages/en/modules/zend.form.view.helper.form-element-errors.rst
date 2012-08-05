.. _zend.form.view.helper.form-element-errors:

FormElementErrors
^^^^^^^^^^^^^^^^^

The ``FormElementErrors`` view helper is used to render the validation
error messages of an element.

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Form;
   use Zend\Form\Element;
   use Zend\InputFilter\InputFilter;
   use Zend\InputFilter\Input;

   // Create a form
   $form    = new Form();
   $element = new Element\Text('my-text');
   $form->add($element);

   // Create a input
   $input = new Input('my-text');
   $input->setRequired(true);

   $inputFilter = new InputFilter();
   $inputFilter->add($input);
   $form->setInputFilter($inputFilter);

   // Force a failure
   $form->setData(array()); // Empty data
   $form->isValid();        // Not valid

   // Within your view...

   /**
    * Example #1: Default options
    */
   echo $this->formElementErrors($element);
   // <ul><li>Value is required and can&#039;t be empty</li></ul>

   /**
    * Example #2: Add attributes to open format
    */
   echo $this->formElementErrors($element, array('class' => 'help-inline'));
   // <ul class="help-inline"><li>Value is required and can&#039;t be empty</li></ul>

   /**
    * Example #3: Custom format
    */
   echo $this->formElementErrors()
                   ->setMessageOpenFormat('<div class="help-inline">')
                   ->setMessageSeparatorString('</div><div class="help-inline">')
                   ->setMessageCloseString('</div>')
                   ->render($element);
   // <div class="help-inline">Value is required and can&#039;t be empty</div>



.. _zend.form.view.helper.form-element-errors.methods:

The following public methods are in addition to those inherited from
:ref:`Zend\\Form\\View\\Helper\\AbstractHelper <zend.form.view.helper.abstract-helper.methods>`.

.. function:: setMessageOpenFormat(string $messageOpenFormat)
   :noindex:

   Set the formatted string used to open message representation.

   :param $messageOpenFormat: The formatted string to use to open the messages. Uses ``'<ul%s><li>'`` by default. Attributes are inserted here.

.. function:: getMessageOpenFormat()
   :noindex:

   Returns the formatted string used to open message representation.

   :rtype: string

.. function:: setMessageSeparatorString(string $messageSeparatorString)
   :noindex:

   Sets the string used to separate messages.

   :param $messageSeparatorString: The string to use to separate the messages. Uses ``'</li><li>'`` by default.

.. function:: getMessageSeparatorString()
   :noindex:

   Returns the string used to separate messages.

   :rtype: string

.. function:: setMessageCloseString(string $messageCloseString)
   :noindex:

   Sets the string used to close message representation.

   :param $messageCloseString: The string to use to close the messages. Uses ``'</li></ul>'`` by default.

.. function:: getMessageCloseString()
   :noindex:

   Returns the string used to close message representation.

   :rtype: string

.. function:: setAttributes(array $attributes)
   :noindex:

   Set the attributes that will go on the message open format.

   :param $attributes: Key value pairs of attributes.

.. function:: getAttributes()
   :noindex:

   Returns the attributes that will go on the message open format.

   :rtype: array

.. function:: render(ElementInterface $element [, array $attributes = array()])
   :noindex:

   Renders validation errors for the provided ``$element``.

   :param $element: The element.
   :param $attributes: Additional attributes that will go on the message open format. These are merged with those set via ``setAttributes()``.
   :rtype: string
