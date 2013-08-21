.. _zend.input-filter.intro:

Introduction to Zend\\InputFilter
=================================

The ``Zend\InputFilter`` component can be used to filter and validate generic sets of input data. For instance, you
could use it to filter ``$_GET`` or ``$_POST`` values, CLI arguments, etc.

To pass input data to the ``InputFilter``, you can use the ``setData()`` method. The data must be specified using
an associative array. Below is an example on how to validate the data coming from a form using the *POST* method.

.. code-block:: php
   :linenos:

   use Zend\InputFilter\InputFilter;
   use Zend\InputFilter\Input;
   use Zend\Validator;

   $email = new Input('email');
   $email->getValidatorChain()
         ->attach(new Validator\EmailAddress());

   $password = new Input('password');
   $password->getValidatorChain()
            ->attach(new Validator\StringLength(8));

   $inputFilter = new InputFilter();
   $inputFilter->add($email)
               ->add($password)
               ->setData($_POST);

   if ($inputFilter->isValid()) {
       echo "The form is valid\n";
   } else {
       echo "The form is not valid\n";
       foreach ($inputFilter->getInvalidInput() as $error) {
           print_r($error->getMessages());
       }
   }

In this example we validated the email and password values. The email must be a valid address and the password must
be composed with at least 8 characters. If the input data are not valid, we report the list of invalid input using
the ``getInvalidInput()`` method.

You can add one or more validators to each input using the ``attach()`` method for each validator. It is also
possible to specify a "validation group", a subset of the data to be validated; this may be done using the
``setValidationGroup()`` method. You can specify the list of the input names as an array or as individual
parameters.

.. code-block:: php
   :linenos:

   // As individual parameters
   $inputFilter->setValidationGroup('email', 'password');

   // or as an array of names
   $inputFilter->setValidationGroup(array('email', 'password'));

You can validate and/or filter the data using the ``InputFilter``. To filter data, use the ``getFilterChain()``
method of individual ``Input`` instances, and attach filters to the returned filter chain. Below is an example that
uses filtering without validation.

.. code-block:: php
   :linenos:

   use Zend\InputFilter\Input;
   use Zend\InputFilter\InputFilter;

   $input = new Input('foo');
   $input->getFilterChain()
         ->attachByName('stringtrim')
         ->attachByName('alpha');

   $inputFilter = new InputFilter();
   $inputFilter->add($input)
               ->setData(array(
                   'foo' => ' Bar3 ',
               ));

   echo "Before:\n";
   echo $inputFilter->getRawValue('foo') . "\n"; // the output is ' Bar3 '
   echo "After:\n";
   echo $inputFilter->getValue('foo') . "\n"; // the output is 'Bar'

The ``getValue()`` method returns the filtered value of the 'foo' input, while ``getRawValue()`` returns the
original value of the input.

We provide also ``Zend\InputFilter\Factory``, to allow initialization of the ``InputFilter`` based on a
configuration array (or ``Traversable`` object). Below is an example where we create a password input value with
the same constraints proposed before (a string with at least 8 characters):

.. code-block:: php
   :linenos:

   use Zend\InputFilter\Factory;

   $factory = new Factory();
   $inputFilter = $factory->createInputFilter(array(
       'password' => array(
           'name'       => 'password',
           'required'   => true,
           'validators' => array(
               array(
                   'name' => 'not_empty',
               ),
               array(
                   'name' => 'string_length',
                   'options' => array(
                       'min' => 8
                   ),
               ),
           ),
       ),
   ));

   $inputFilter->setData($_POST);
   echo $inputFilter->isValid() ? "Valid form" : "Invalid form";

The factory may be used to create not only ``Input`` instances, but also nested ``InputFilter``\ s, allowing you to
create validation and filtering rules for hierarchical data sets.

Finally, the default ``InputFilter`` implementation is backed by a ``Factory``. This means that when calling
``add()``, you can provide a specification that the ``Factory`` would understand, and it will create the
appropriate object. You may create either ``Input`` or ``InputFilter`` objects in this fashion.

.. code-block:: php
   :linenos:

   use Zend\InputFilter\InputFilter;

   $filter = new InputFilter();

   // Adding a single input
   $filter->add(array(
       'name' => 'username',
       'required' => true,
       'validators' => array(
           array(
               'name' => 'not_empty',
           ),
           array(
               'name' => 'string_length',
               'options' => array(
                   'min' => 5
               ),
           ),
       ),
   ));

   // Adding another input filter what also contains a single input. Merging both.
   $filter->add(array(
       'type' => 'Zend\InputFilter\InputFilter',
       'password' => array(
           'name' => 'password',
           'required' => true,
           'validators' => array(
               array(
                   'name' => 'not_empty',
               ),
               array(
                   'name' => 'string_length',
                   'options' => array(
                       'min' => 8
                   ),
               ),
           ),
       ),
   ));


