.. _zend.input-filter.intro:

Introduction
============

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

The ``merge()`` method may be used on an ``InputFilterInterface`` in order to add two or more filters to each other, effectively
allowing you to create chains of filters. This is especially useful in object hierarchies whereby we may define a generic
set of validation rules on the base object and build these up to more specific rules along the way.

In the example below an ``InputFilter`` is built up for the name property as well as for the email property allowing them to
be re-used elsewhere. When the ``isValid()`` method is called on the object, all of the merged filters are run against
the calling object in order to validate the internal properties based on our compound set of filters.

.. code-block:: php
   :linenos:

        use Zend\InputFilter\InputFilterInterface;
        use Zend\InputFilter\Factory as InputFactory;
        use Zend\InputFilter\InputFilter;
        use Zend\InputFilter\InputFilterAwareInterface;
        use Zend\InputFilter\InputFilterInterface;

       /**
        * Filter to ensure a name property is set and > 8 characters
        */
        class NameInputFilter extends InputFilter
        {
            /** @var InputFactory */
            protected $inputFactory;

            public function __construct()
            {
                $this->inputFactory = new InputFactory();
                $this->setValidators();
            }

            /**
             * Loads the validators
             */
            protected function setValidators()
            {
                $this->setNameValidator();
            }

            /**
             * Creates a validator to check the name property
             */
            protected function setNameValidator()
            {
                $this->add(
                    $this->inputFactory->createInput(
                        array(
                            'name'       => 'name',
                            'required'   => true,
                            'validators' => array(
                                array(
                                    'name' => 'not_empty',
                                ),
                                array(
                                    'name' => 'string_length',
                                    'options' => array(
                                        'min' => 8
                                    )
                                ),
                            )
                        )
                    )
                );
            }
        }

        /**
         * Filter to ensure an email property is set and > 8 characters and is valid
         */
        class EmailInputFilter extends InputFilter
        {
            /** @var InputFactory */
            protected $inputFactory;

            public function __construct()
            {
                $this->inputFactory = new InputFactory();
                $this->setValidators();
            }

            /**
             * Loads the validators
             */
            protected function setValidators()
            {
                $this->setEmailValidator();
            }

            /**
             * Creates a validator to check the name property
             */
            protected function setEmailValidator()
            {
                $this->add(
                    $this->inputFactory->createInput(
                        array(
                            'name'       => 'email',
                            'required'   => true,
                            'validators' => array(
                                array(
                                    'name' => 'not_empty',
                                ),
                                array(
                                    'name'    => 'string_length',
                                    'options' => array(
                                    'min'     => 8
                                ),
                                array(
                                    'name'    => 'email_address',
                                )
                            )
                        )
                    )
                );
            }
        }

        class SimplePerson implements InputFilterAwareInterface
        {
            /** @var string */
            protected $name;

            /** @var string */
            protected $email;

            /** @var InputFilter */
            protected $inputFilter;

            /**
             * @return string
             */
            public function getName()
            {
                return $this->name;
            }

            /**
             * @param string $name
             */
            public function setName($name)
            {
                $this->name = $name;
            }

            /**
             * @return string
             */
            public function getEmail()
            {
                return $this->email;
            }

            /**
             * @param string $email
             */
            public function setEmail($email)
            {
                $this->email = $email;
            }

             /**
              * Retrieve input filter
              *
              * @return InputFilterInterface
              */
            public function getInputFilter()
            {
                if (!$this->inputFilter) {
                    // Create a new input filter
                    $this->inputFilter = new InputFilter();
                    // Merge our inputFilter in for the email property
                    $this->inputFilter->merge(new EmailInputFilter());
                    // Merge our inputFilter in for the name property
                    $this->inputFilter->merge(new NameInputFilter());
                }
                return $this->inputFilter;
            }

            /**
             * Set input filter
             *
             * @param  InputFilterInterface $inputFilter
             * @return InputFilterAwareInterface
             */
            public function setInputFilter(InputFilterInterface $inputFilter)
            {
                $this->inputFilter = $inputFilter;

                return $this;
            }
        }

Also see

- :ref:`Zend\\Filter<zend.filter.introduction>`
- :ref:`Zend\\Validator<zend.validator.introduction>`
