.. _zend.validator.regex:

Regex Validator
===============

This validator allows you to validate if a given string conforms a defined regular expression.

.. _zend.validator.regex.options:

Supported options for Zend\\Validator\\Regex
--------------------------------------------

The following options are supported for ``Zend\Validator\Regex``:

- **pattern**: Sets the regular expression pattern for this validator.

.. _zend.validator.regex.basic:

Validation with Zend\\Validator\\Regex
--------------------------------------

Validation with regular expressions allows to have complicated validations being done without writing a own
validator. The usage of regular expression is quite common and simple. Let's look at some examples:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Regex(array('pattern' => '/^Test/'));

   $validator->isValid("Test"); // returns true
   $validator->isValid("Testing"); // returns true
   $validator->isValid("Pest"); // returns false

As you can see, the pattern has to be given using the same syntax as for ``preg_match()``. For details about
regular expressions take a look into `PHP's manual about PCRE pattern syntax`_.

.. _zend.validator.regex.handling:

Pattern handling
----------------

It is also possible to set a different pattern afterwards by using ``setPattern()`` and to get the actual set
pattern with ``getPattern()``.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Regex(array('pattern' => '/^Test/'));
   $validator->setPattern('ing$/');

   $validator->isValid("Test"); // returns false
   $validator->isValid("Testing"); // returns true
   $validator->isValid("Pest"); // returns false



.. _`PHP's manual about PCRE pattern syntax`: http://php.net/manual/en/reference.pcre.pattern.syntax.php
