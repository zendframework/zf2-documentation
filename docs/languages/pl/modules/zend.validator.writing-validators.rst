.. EN-Revision: none
.. _zend.validator.writing_validators:

Pisanie weryfikatorów
=====================

Zend_Validate zapewnia zestaw najczęściej potrzebnych weryfikatorów, ale programiści często potrzebują
napisać własne weryfikatory dla ich szczególnych zastosowań. Zadanie pisania własnego filtru jest opisane w
tej sekcji.

Interfejs *Zend_Validate_Interface* definiuje trzy metody, *isValid()*, *getMessages()* oraz *getErrors()*, które
mogą być zaimplementowane przez klasę użytkownika w celu utworzenia własnych obiektów weryfikujących.
Obiekt, który implementuje interfejs *Zend_Validate_Interface* może być dodany do łańcucha weryfikatorów za
pomocą metody *Zend_Validate::addValidator()*. Taki obiekt może być także użyty przez klasę
:ref:`Zend_Filter_Input <zend.filter.input>`.

As you may already have inferred from the above description of *Zend_Validate_Interface*, validation classes
provided with Zend Framework return a boolean value for whether or not a value validates successfully. They also
provide information about **why** a value failed validation. The availability of the reasons for validation
failures may be valuable to an application for various purposes, such as providing statistics for usability
analysis.

Basic validation failure message functionality is implemented in *Zend_Validate_Abstract*. To include this
functionality when creating a validation class, simply extend *Zend_Validate_Abstract*. In the extending class you
would implement the *isValid()* method logic and define the message variables and message templates that correspond
to the types of validation failures that can occur. If a value fails your validation tests, then *isValid()* should
return *false*. If the value passes your validation tests, then *isValid()* should return *true*.

In general, the *isValid()* method should not throw any exceptions, except where it is impossible to determine
whether or not the input value is valid. A few examples of reasonable cases for throwing an exception might be if a
file cannot be opened, an LDAP server could not be contacted, or a database connection is unavailable, where such a
thing may be required for validation success or failure to be determined.

.. _zend.validator.writing_validators.example.simple:

.. rubric:: Creating a Simple Validation Class

The following example demonstrates how a very simple custom validator might be written. In this case the validation
rules are simply that the input value must be a floating point value.

   .. code-block:: php
      :linenos:

      class MyValid_Float extends Zend_Validate_Abstract
      {
          const FLOAT = 'float';

          protected $_messageTemplates = array(
              self::FLOAT => "'%value%' is not a floating point value"
          );

          public function isValid($value)
          {
              $this->_setValue($value);

              if (!is_float($value)) {
                  $this->_error(self::FLOAT);
                  return false;
              }

              return true;
          }
      }


The class defines a template for its single validation failure message, which includes the built-in magic
parameter, *%value%*. The call to *_setValue()* prepares the object to insert the tested value into the failure
message automatically, should the value fail validation. The call to *_error()* tracks a reason for validation
failure. Since this class only defines one failure message, it is not necessary to provide *_error()* with the name
of the failure message template.

.. _zend.validator.writing_validators.example.conditions.dependent:

.. rubric:: Writing a Validation Class having Dependent Conditions

The following example demonstrates a more complex set of validation rules, where it is required that the input
value be numeric and within the range of minimum and maximum boundary values. An input value would fail validation
for exactly one of the following reasons:



   - The input value is not numeric.

   - The input value is less than the minimum allowed value.

   - The input value is more than the maximum allowed value.



These validation failure reasons are then translated to definitions in the class:

   .. code-block:: php
      :linenos:

      class MyValid_NumericBetween extends Zend_Validate_Abstract
      {
          const MSG_NUMERIC = 'msgNumeric';
          const MSG_MINIMUM = 'msgMinimum';
          const MSG_MAXIMUM = 'msgMaximum';

          public $minimum = 0;
          public $maximum = 100;

          protected $_messageVariables = array(
              'min' => 'minimum',
              'max' => 'maximum'
          );

          protected $_messageTemplates = array(
              self::MSG_NUMERIC => "'%value%' is not numeric",
              self::MSG_MINIMUM => "'%value%' must be at least '%min%'",
              self::MSG_MAXIMUM => "'%value%' must be no more than '%max%'"
          );

          public function isValid($value)
          {
              $this->_setValue($value);

              if (!is_numeric($value)) {
                  $this->_error(self::MSG_NUMERIC);
                  return false;
              }

              if ($value < $this->minimum) {
                  $this->_error(self::MSG_MINIMUM);
                  return false;
              }

              if ($value > $this->maximum) {
                  $this->_error(self::MSG_MAXIMUM);
                  return false;
              }

              return true;
          }
      }


The public properties *$minimum* and *$maximum* have been established to provide the minimum and maximum
boundaries, respectively, for a value to successfully validate. The class also defines two message variables that
correspond to the public properties and allow *min* and *max* to be used in message templates as magic parameters,
just as with *value*.

Note that if any one of the validation checks in *isValid()* fails, an appropriate failure message is prepared, and
the method immediately returns *false*. These validation rules are therefore sequentially dependent. That is, if
one test should fail, there is no need to test any subsequent validation rules. This need not be the case, however.
The following example illustrates how to write a class having independent validation rules, where the validation
object may return multiple reasons why a particular validation attempt failed.

.. _zend.validator.writing_validators.example.conditions.independent:

.. rubric:: Validation with Independent Conditions, Multiple Reasons for Failure

Consider writing a validation class for password strength enforcement - when a user is required to choose a
password that meets certain criteria for helping secure user accounts. Let us assume that the password security
criteria enforce that the password:



   - is at least 8 characters in length,

   - contains at least one uppercase letter,

   - contains at least one lowercase letter,

   - and contains at least one digit character.



The following class implements these validation criteria:

   .. code-block:: php
      :linenos:

      class MyValid_PasswordStrength extends Zend_Validate_Abstract
      {
          const LENGTH = 'length';
          const UPPER  = 'upper';
          const LOWER  = 'lower';
          const DIGIT  = 'digit';

          protected $_messageTemplates = array(
              self::LENGTH => "'%value%' must be at least 8 characters in length",
              self::UPPER  => "'%value%' must contain at least one uppercase letter",
              self::LOWER  => "'%value%' must contain at least one lowercase letter",
              self::DIGIT  => "'%value%' must contain at least one digit character"
          );

          public function isValid($value)
          {
              $this->_setValue($value);

              $isValid = true;

              if (strlen($value) < 8) {
                  $this->_error(self::LENGTH);
                  $isValid = false;
              }

              if (!preg_match('/[A-Z]/', $value)) {
                  $this->_error(self::UPPER);
                  $isValid = false;
              }

              if (!preg_match('/[a-z]/', $value)) {
                  $this->_error(self::LOWER);
                  $isValid = false;
              }

              if (!preg_match('/\d/', $value)) {
                  $this->_error(self::DIGIT);
                  $isValid = false;
              }

              return $isValid;
          }
      }


Note that the four criteria tests in *isValid()* do not immediately return *false*. This allows the validation
class to provide **all** of the reasons that the input password failed to meet the validation requirements. If, for
example, a user were to input the string "*#$%*" as a password, *isValid()* would cause all four validation failure
messages to be returned by a subsequent call to *getMessages()*.


