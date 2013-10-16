.. _zend.form.element.email:

Email
^^^^^

``Zend\Form\Element\Email`` is meant to be paired with the ``Zend\Form\View\Helper\FormEmail`` for `HTML5 inputs with
type email`_. This element adds filters and validators to it's input filter specification in order to validate
`HTML5 valid email address`_ on the server.

.. _zend.form.element.email.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"email"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $form = new Form('my-form');

   // Single email address
   $email = new Element\Email('email');
   $email->setLabel('Email Address')
   $form->add($email);

   // Comma separated list of emails
   $emails = new Element\Email('emails');
   $emails
       ->setLabel('Email Addresses')
       ->setAttribute('multiple', true);
   $form->add($emails);

Here is with the array notation:

.. code-block:: php
   :linenos:

    use Zend\Form\Form;

    $form = new Form('my-form');
    $form->add(array(
    	'type' => 'Zend\Form\Element\Email',
    	'name' => 'email',
    	'options' => array(
            'label' => 'Email Address'
    	),
    ));
    
    $form->add(array(
    	'type' => 'Zend\Form\Element\Email',
    	'name' => 'emails',
    	'options' => array(
    		'label' => 'Email Addresses'
    	),
    	'attributes' => array(
            'multiple' => true
    	)
    ));
    
.. note::

   Note: the ``multiple`` attribute should be set prior to calling Zend\\Form::prepare(). Otherwise, the default
   input specification for the element may not contain the correct validation rules.

.. _zend.form.element.email.methods:

.. rubric:: Public Methods

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element
<zend.form.element.methods>`.

.. function:: getInputSpecification()
   :noindex:

   Returns a input filter specification, which includes a ``Zend\Filter\StringTrim`` filter, and a validator based
   on the ``multiple`` attribute.

   If the ``multiple`` attribute is unset or false, a ``Zend\Validator\Regex`` validator will be added to validate
   a single email address.

   If the ``multiple`` attribute is true, a ``Zend\Validator\Explode`` validator will be added to ensure the input
   string value is split by commas before validating each email address with ``Zend\Validator\Regex``.

   :rtype: array

.. function:: setValidator(ValidatorInterface $validator)
   :noindex:

   Sets the primary validator to use for this element

.. function:: getValidator()
   :noindex:

   Get the primary validator

   :rtype: ValidatorInterface

.. function:: setEmailValidator(ValidatorInterface $validator)
   :noindex:

   Sets the email validator to use for multiple or single email addresses.

.. function:: getEmailValidator()
   :noindex:

   Get the email validator to use for multiple or single
   email addresses.

   The default Regex validator in use is to match that of the
   browser validation, but you are free to set a different
   (more strict) email validator such as ``Zend\Validator\Email``
   if you wish.


.. _`HTML5 inputs with type email`: http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#e-mail-state-(type=email)
.. _`HTML5 valid email address`: http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#valid-e-mail-address
