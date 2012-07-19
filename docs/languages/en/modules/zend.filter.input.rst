.. _zend.filter.input:

Zend_Filter_Input
=================

``Zend_Filter_Input`` provides a declarative interface to associate multiple filters and validators, apply them to
collections of data, and to retrieve input values after they have been processed by the filters and validators.
Values are returned in escaped format by default for safe *HTML* output.

Consider the metaphor that this class is a cage for external data. Data enter the application from external
sources, such as *HTTP* request parameters, *HTTP* headers, a web service, or even read from a database or another
file. Data are first put into the cage, and subsequently the application can access data only by telling the cage
what the data should be and how they plan to use it. The cage inspects the data for validity. It might apply
escaping to the data values for the appropriate context. The cage releases data only if it can fulfill these
responsibilities. With a simple and convenient interface, it encourages good programming habits and makes
developers think about how data are used.

- **Filters** transform input values, by removing or changing characters within the value. The goal is to
  "normalize" input values until they match an expected format. For example, if a string of numeric digits is
  needed, and the input value is "abc123", then it might be a reasonable transformation to change the value to the
  string "123".

- **Validators** check input values against criteria and report whether they passed the test or not. The value is
  not changed, but the check may fail. For example, if a string must look like an email address, and the input
  value is "abc123", then the value is not considered valid.

- **Escapers** transform a value by removing magic behavior of certain characters. In some output contexts, special
  characters have meaning. For example, the characters '<' and '>' delimit *HTML* tags, and if a string containing
  those characters is output in an *HTML* context, the content between them might affect the output or
  functionality of the *HTML* presentation. Escaping the characters removes the special meaning, so they are output
  as literal characters.

To use ``Zend_Filter_Input``, perform the following steps:

. Declare filter and validator rules

. Create the filter and validator processor

. Provide input data

. Retrieve validated fields and other reports

The following sections describe the steps for using this class.

.. _zend.filter.input.declaring:

Declaring Filter and Validator Rules
------------------------------------

Before creating an instance of ``Zend_Filter_Input``, declare an array of filter rules and an array of validator
rules. This associative array maps a rule name to a filter or validator or a chain of filters or validators.

The following example filter rule set that declares the field 'month' is filtered by ``Zend_Filter_Digits``, and
the field 'account' is filtered by ``Zend_Filter_StringTrim``. Then a validation rule set declares that the field
'account' is valid only if it contains only alphabetical characters.

.. code-block:: php
   :linenos:

   $filters = array(
       'month'   => 'Digits',
       'account' => 'StringTrim'
   );

   $validators = array(
       'account' => 'Alpha'
   );

Each key in the ``$filters`` array above is the name of a rule for applying a filter to a specific data field. By
default, the name of the rule is also the name of the input data field to which to apply the rule.

You can declare a rule in several formats:

- A single string scalar, which is mapped to a class name.

  .. code-block:: php
     :linenos:

     $validators = array(
         'month'   => 'Digits',
     );

- An object instance of one of the classes that implement ``Zend_Filter_Interface`` or ``Zend_Validate_Interface``.

  .. code-block:: php
     :linenos:

     $digits = new Zend_Validate_Digits();

     $validators = array(
         'month'   => $digits
     );

- An array, to declare a chain of filters or validators. The elements of this array can be strings mapping to class
  names or filter/validator objects, as in the cases described above. In addition, you can use a third choice: an
  array containing a string mapping to the class name followed by arguments to pass to its constructor.

  .. code-block:: php
     :linenos:

     $validators = array(
         'month'   => array(
             'Digits',                // string
             new Zend_Validate_Int(), // object instance
             array('Between', 1, 12)  // string with constructor arguments
         )
     );

.. note::

   If you declare a filter or validator with constructor arguments in an array, then you must make an array for the
   rule, even if the rule has only one filter or validator.

You can use a special "wildcard" rule key **'*'** in either the filters array or the validators array. This means
that the filters or validators declared in this rule will be applied to all input data fields. Note that the order
of entries in the filters array or validators array is significant; the rules are applied in the same order in
which you declare them.

.. code-block:: php
   :linenos:

   $filters = array(
       '*'     => 'StringTrim',
       'month' => 'Digits'
   );

.. _zend.filter.input.running:

Creating the Filter and Validator Processor
-------------------------------------------

After declaring the filters and validators arrays, use them as arguments in the constructor of
``Zend_Filter_Input``. This returns an object that knows all your filtering and validating rules, and you can use
this object to process one or more sets of input data.

.. code-block:: php
   :linenos:

   $input = new Zend_Filter_Input($filters, $validators);

You can specify input data as the third constructor argument. The data structure is an associative array. The keys
are field names, and the values are data values. The standard ``$_GET`` and ``$_POST`` superglobal variables in
*PHP* are examples of this format. You can use either of these variables as input data for ``Zend_Filter_Input``.

.. code-block:: php
   :linenos:

   $data = $_GET;

   $input = new Zend_Filter_Input($filters, $validators, $data);

Alternatively, use the ``setData()`` method, passing an associative array of key/value pairs the same format as
described above.

.. code-block:: php
   :linenos:

   $input = new Zend_Filter_Input($filters, $validators);
   $input->setData($newData);

The ``setData()`` method redefines data in an existing ``Zend_Filter_Input`` object without changing the filtering
and validation rules. Using this method, you can run the same rules against different sets of input data.

.. _zend.filter.input.results:

Retrieving Validated Fields and other Reports
---------------------------------------------

After you have declared filters and validators and created the input processor, you can retrieve reports of
missing, unknown, and invalid fields. You also can get the values of fields after filters have been applied.

.. _zend.filter.input.results.isvalid:

Querying if the input is valid
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If all input data pass the validation rules, the ``isValid()`` method returns ``TRUE``. If any field is invalid or
any required field is missing, ``isValid()`` returns ``FALSE``.

.. code-block:: php
   :linenos:

   if ($input->isValid()) {
     echo "OK\n";
   }

This method accepts an optional string argument, naming an individual field. If the specified field passed
validation and is ready for fetching, ``isValid('fieldName')`` returns ``TRUE``.

.. code-block:: php
   :linenos:

   if ($input->isValid('month')) {
     echo "Field 'month' is OK\n";
   }

.. _zend.filter.input.results.reports:

Getting Invalid, Missing, or Unknown Fields
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Invalid** fields are those that don't pass one or more of their validation checks.

- **Missing** fields are those that are not present in the input data, but were declared with the metacommand
  ``'presence'=>'required'`` (see the :ref:`later section <zend.filter.input.metacommands.presence>` on
  metacommands).

- **Unknown** fields are those that are not declared in any rule in the array of validators, but appear in the
  input data.

.. code-block:: php
   :linenos:

   if ($input->hasInvalid() || $input->hasMissing()) {
     $messages = $input->getMessages();
   }

   // getMessages() simply returns the merge of getInvalid() and
   // getMissing()

   if ($input->hasInvalid()) {
     $invalidFields = $input->getInvalid();
   }

   if ($input->hasMissing()) {
     $missingFields = $input->getMissing();
   }

   if ($input->hasUnknown()) {
     $unknownFields = $input->getUnknown();
   }

The results of the ``getMessages()`` method is an associative array, mapping a rule name to an array of error
messages related to that rule. Note that the index of this array is the rule name used in the rule declaration,
which may be different from the names of fields checked by the rule.

The ``getMessages()`` method returns the merge of the arrays returned by the ``getInvalid()`` and ``getMissing()``.
These methods return subsets of the messages, related to validation failures, or fields that were declared as
required but missing from the input.

The ``getErrors()`` method returns an associative array, mapping a rule name to an array of error identifiers.
Error identifiers are fixed strings, to identify the reason for a validation failure, while messages can be
customized. See :ref:`this section <zend.validator.introduction.using>` for more information.

You can specify the message returned by ``getMissing()`` using the 'missingMessage' option, as an argument to the
``Zend_Filter_Input`` constructor or using the ``setOptions()`` method.

.. code-block:: php
   :linenos:

   $options = array(
       'missingMessage' => "Field '%field%' is required"
   );

   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

   // alternative method:

   $input = new Zend_Filter_Input($filters, $validators, $data);
   $input->setOptions($options);

And you can also add a translator which gives you the ability to provide multiple languages for the messages which
are returned by ``Zend_Filter_Input``.

.. code-block:: php
   :linenos:

   $translate = new Zend_Translator_Adapter_Array(array(
       'content' => array(
           Zend_Filter_Input::MISSING_MESSAGE => "Where is the field?"
       )
   );

   $input = new Zend_Filter_Input($filters, $validators, $data);
   $input->setTranslator($translate);

When you are using an application wide translator, then it will also be used by ``Zend_Filter_Input``. In this case
you will not have to set the translator manually.

The results of the ``getUnknown()`` method is an associative array, mapping field names to field values. Field
names are used as the array keys in this case, instead of rule names, because no rule mentions the fields
considered to be unknown fields.

.. _zend.filter.input.results.escaping:

Getting Valid Fields
^^^^^^^^^^^^^^^^^^^^

All fields that are neither invalid, missing, nor unknown are considered valid. You can get values for valid fields
using a magic accessor. There are also non-magic accessor methods ``getEscaped()`` and ``getUnescaped()``.

.. code-block:: php
   :linenos:

   $m = $input->month;                 // escaped output from magic accessor
   $m = $input->getEscaped('month');   // escaped output
   $m = $input->getUnescaped('month'); // not escaped

By default, when retrieving a value, it is filtered with the ``Zend_Filter_HtmlEntities``. This is the default
because it is considered the most common usage to output the value of a field in *HTML*. The HtmlEntities filter
helps prevent unintentional output of code, which can result in security problems.

.. note::

   As shown above, you can retrieve the unescaped value using the ``getUnescaped()`` method, but you must write
   code to use the value safely, and avoid security issues such as vulnerability to cross-site scripting attacks.

.. warning:: Escaping unvalidated fields

   As mentioned before ``getEscaped()`` returns only validated fields. Fields which do not have an associated
   validator can not be received this way. Still, there is a possible way. You can add a empty validator for all
   fields.

   .. code-block:: php
      :linenos:

      $validators = array('*' => array());

      $input = new Zend_Filter_Input($filters, $validators, $data, $options);

   But be warned that using this notation introduces a security leak which could be used for cross-site scripting
   attacks. Therefor you should always set individual validators for each field.

You can specify a different filter for escaping values, by specifying it in the constructor options array:

.. code-block:: php
   :linenos:

   $options = array('escapeFilter' => 'StringTrim');
   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

Alternatively, you can use the ``setDefaultEscapeFilter()`` method:

.. code-block:: php
   :linenos:

   $input = new Zend_Filter_Input($filters, $validators, $data);
   $input->setDefaultEscapeFilter(new Zend_Filter_StringTrim());

In either usage, you can specify the escape filter as a string base name of the filter class, or as an object
instance of a filter class. The escape filter can be an instance of a filter chain, an object of the class
``Zend_Filter``.

Filters to escape output should be run in this way, to make sure they run after validation. Other filters you
declare in the array of filter rules are applied to input data before data are validated. If escaping filters were
run before validation, the process of validation would be more complex, and it would be harder to provide both
escaped and unescaped versions of the data. So it is recommended to declare filters to escape output using
``setDefaultEscapeFilter()``, not in the ``$filters`` array.

There is only one method ``getEscaped()``, and therefore you can specify only one filter for escaping (although
this filter can be a filter chain). If you need a single instance of ``Zend_Filter_Input`` to return escaped output
using more than one filtering method, you should extend ``Zend_Filter_Input`` and implement new methods in your
subclass to get values in different ways.

.. _zend.filter.input.metacommands:

Using Metacommands to Control Filter or Validator Rules
-------------------------------------------------------

In addition to declaring the mapping from fields to filters or validators, you can specify some "metacommands" in
the array declarations, to control some optional behavior of ``Zend_Filter_Input``. Metacommands appear as
string-indexed entries in a given filter or validator array value.

.. _zend.filter.input.metacommands.fields:

The FIELDS metacommand
^^^^^^^^^^^^^^^^^^^^^^

If the rule name for a filter or validator is different than the field to which it should apply, you can specify
the field name with the 'fields' metacommand.

You can specify this metacommand using the class constant ``Zend_Filter_Input::FIELDS`` instead of the string.

.. code-block:: php
   :linenos:

   $filters = array(
       'month' => array(
           'Digits',        // filter name at integer index [0]
           'fields' => 'mo' // field name at string index ['fields']
       )
   );

In the example above, the filter rule applies the 'digits' filter to the input field named 'mo'. The string 'month'
simply becomes a mnemonic key for this filtering rule; it is not used as the field name if the field is specified
with the 'fields' metacommand, but it is used as the rule name.

The default value of the 'fields' metacommand is the index of the current rule. In the example above, if the
'fields' metacommand is not specified, the rule would apply to the input field named 'month'.

Another use of the 'fields' metacommand is to specify fields for filters or validators that require multiple fields
as input. If the 'fields' metacommand is an array, the argument to the corresponding filter or validator is an
array of the values of those fields. For example, it is common for users to specify a password string in two
fields, and they must type the same string in both fields. Suppose you implement a validator class that takes an
array argument, and returns ``TRUE`` if all the values in the array are equal to each other.

.. code-block:: php
   :linenos:

   $validators = array(
       'password' => array(
           'StringEquals',
           'fields' => array('password1', 'password2')
       )
   );
   // Invokes hypothetical class Zend_Validate_StringEquals,
   // passing an array argument containing the values of the two input
   // data fields named 'password1' and 'password2'.

If the validation of this rule fails, the rule key ('password') is used in the return value of ``getInvalid()``,
not any of the fields named in the 'fields' metacommand.

.. _zend.filter.input.metacommands.presence:

The PRESENCE metacommand
^^^^^^^^^^^^^^^^^^^^^^^^

Each entry in the validator array may have a metacommand called 'presence'. If the value of this metacommand is
'required' then the field must exist in the input data, or else it is reported as a missing field.

You can specify this metacommand using the class constant ``Zend_Filter_Input::PRESENCE`` instead of the string.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           'presence' => 'required'
       )
   );

The default value of this metacommand is 'optional'.

.. _zend.filter.input.metacommands.default:

The DEFAULT_VALUE metacommand
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If a field is not present in the input data, and you specify a value for the 'default' metacommand for that rule,
the field takes the value of the metacommand.

You can specify this metacommand using the class constant ``Zend_Filter_Input::DEFAULT_VALUE`` instead of the
string.

This default value is assigned to the field before any of the validators are invoked. The default value is applied
to the field only for the current rule; if the same field is referenced in a subsequent rule, the field has no
value when evaluating that rule. Thus different rules can declare different default values for a given field.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           'default' => '1'
       )
   );

   // no value for 'month' field
   $data = array();

   $input = new Zend_Filter_Input(null, $validators, $data);
   echo $input->month; // echoes 1

If your rule uses the ``FIELDS`` metacommand to define an array of multiple fields, you can define an array for the
``DEFAULT_VALUE`` metacommand and the defaults of corresponding keys are used for any missing fields. If ``FIELDS``
defines multiple fields but ``DEFAULT_VALUE`` is a scalar, then that default value is used as the value for any
missing fields in the array.

There is no default value for this metacommand.

.. _zend.filter.input.metacommands.allow-empty:

The ALLOW_EMPTY metacommand
^^^^^^^^^^^^^^^^^^^^^^^^^^^

By default, if a field exists in the input data, then validators are applied to it, even if the value of the field
is an empty string (**''**). This is likely to result in a failure to validate. For example, if the validator
checks for digit characters, and there are none because a zero-length string has no characters, then the validator
reports the data as invalid.

If in your case an empty string should be considered valid, you can set the metacommand 'allowEmpty' to ``TRUE``.
Then the input data passes validation if it is present in the input data, but has the value of an empty string.

You can specify this metacommand using the class constant ``Zend_Filter_Input::ALLOW_EMPTY`` instead of the string.

.. code-block:: php
   :linenos:

   $validators = array(
       'address2' => array(
           'Alnum',
           'allowEmpty' => true
       )
   );

The default value of this metacommand is ``FALSE``.

In the uncommon case that you declare a validation rule with no validators, but the 'allowEmpty' metacommand is
``FALSE`` (that is, the field is considered invalid if it is empty), ``Zend_Filter_Input`` returns a default error
message that you can retrieve with ``getMessages()``. You can specify this message using the 'notEmptyMessage'
option, as an argument to the ``Zend_Filter_Input`` constructor or using the ``setOptions()`` method.

.. code-block:: php
   :linenos:

   $options = array(
       'notEmptyMessage' => "A non-empty value is required for field '%field%'"
   );

   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

   // alternative method:

   $input = new Zend_Filter_Input($filters, $validators, $data);
   $input->setOptions($options);

.. _zend.filter.input.metacommands.break-chain:

The BREAK_CHAIN metacommand
^^^^^^^^^^^^^^^^^^^^^^^^^^^

By default if a rule has more than one validator, all validators are applied to the input, and the resulting
messages contain all error messages caused by the input.

Alternatively, if the value of the 'breakChainOnFailure' metacommand is ``TRUE``, the validator chain terminates
after the first validator fails. The input data is not checked against subsequent validators in the chain, so it
might cause more violations even if you correct the one reported.

You can specify this metacommand using the class constant ``Zend_Filter_Input::BREAK_CHAIN`` instead of the string.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'Digits',
           new Zend_Validate_Between(1,12),
           new Zend_Validate_GreaterThan(0),
           'breakChainOnFailure' => true
       )
   );
   $input = new Zend_Filter_Input(null, $validators);

The default value of this metacommand is ``FALSE``.

The validator chain class, ``Zend_Validate``, is more flexible with respect to breaking chain execution than
``Zend_Filter_Input``. With the former class, you can set the option to break the chain on failure independently
for each validator in the chain. With the latter class, the defined value of the 'breakChainOnFailure' metacommand
for a rule applies uniformly for all validators in the rule. If you require the more flexible usage, you should
create the validator chain yourself, and use it as an object in the validator rule definition:

.. code-block:: php
   :linenos:

   // Create validator chain with non-uniform breakChainOnFailure
   // attributes
   $chain = new Zend_Validate();
   $chain->addValidator(new Zend_Validate_Digits(), true);
   $chain->addValidator(new Zend_Validate_Between(1,12), false);
   $chain->addValidator(new Zend_Validate_GreaterThan(0), true);

   // Declare validator rule using the chain defined above
   $validators = array(
       'month' => $chain
   );
   $input = new Zend_Filter_Input(null, $validators);

.. _zend.filter.input.metacommands.messages:

The MESSAGES metacommand
^^^^^^^^^^^^^^^^^^^^^^^^

You can specify error messages for each validator in a rule using the metacommand 'messages'. The value of this
metacommand varies based on whether you have multiple validators in the rule, or if you want to set the message for
a specific error condition in a given validator.

You can specify this metacommand using the class constant ``Zend_Filter_Input::MESSAGES`` instead of the string.

Below is a simple example of setting the default error message for a single validator.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           'messages' => 'A month must consist only of digits'
       )
   );

If you have multiple validators for which you want to set the error message, you should use an array for the value
of the 'messages' metacommand.

Each element of this array is applied to the validator at the same index position. You can specify a message for
the validator at position **n** by using the value **n** as the array index. Thus you can allow some validators to
use their default message, while setting the message for a subsequent validator in the chain.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits',
           new Zend_Validate_Between(1, 12),
           'messages' => array(
               // use default message for validator [0]
               // set new message for validator [1]
               1 => 'A month value must be between 1 and 12'
           )
       )
   );

If one of your validators has multiple error messages, they are identified by a message key. There are different
keys in each validator class, serving as identifiers for error messages that the respective validator class might
generate. Each validate class defines constants for its message keys. You can use these keys in the 'messages'
metacommand by passing an associative array instead of a string.

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           'digits', new Zend_Validate_Between(1, 12),
           'messages' => array(
               'A month must consist only of digits',
               array(
                   Zend_Validate_Between::NOT_BETWEEN =>
                       'Month value %value% must be between ' .
                       '%min% and %max%',
                   Zend_Validate_Between::NOT_BETWEEN_STRICT =>
                       'Month value %value% must be strictly between ' .
                       '%min% and %max%'
               )
           )
       )
   );

You should refer to documentation for each validator class to know if it has multiple error messages, the keys of
these messages, and the tokens you can use in the message templates.

If you have only one validator in validation rule or all used validators has the same messages set, then they can
be referenced without additional array construction:

.. code-block:: php
   :linenos:

   $validators = array(
       'month' => array(
           new Zend_Validate_Between(1, 12),
           'messages' => array(
                           Zend_Validate_Between::NOT_BETWEEN =>
                               'Month value %value% must be between ' .
                               '%min% and %max%',
                           Zend_Validate_Between::NOT_BETWEEN_STRICT =>
                               'Month value %value% must be strictly between ' .
                               '%min% and %max%'
           )
       )
   );

.. _zend.filter.input.metacommands.global:

Using options to set metacommands for all rules
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The default value for 'allowEmpty', 'breakChainOnFailure', and 'presence' metacommands can be set for all rules
using the ``$options`` argument to the constructor of ``Zend_Filter_Input``. This allows you to set the default
value for all rules, without requiring you to set the metacommand for every rule.

.. code-block:: php
   :linenos:

   // The default is set so all fields allow an empty string.
   $options = array('allowEmpty' => true);

   // You can override this in a rule definition,
   // if a field should not accept an empty string.
   $validators = array(
       'month' => array(
           'Digits',
           'allowEmpty' => false
       )
   );

   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

The 'fields', 'messages', and 'default' metacommands cannot be set using this technique.

.. _zend.filter.input.namespaces:

Adding Filter Class Namespaces
------------------------------

By default, when you declare a filter or validator as a string, ``Zend_Filter_Input`` searches for the
corresponding classes under the ``Zend_Filter`` or ``Zend_Validate`` namespaces. For example, a filter named by the
string 'digits' is found in the class ``Zend_Filter_Digits``.

If you write your own filter or validator classes, or use filters or validators provided by a third-party, the
classes may exist in different namespaces than ``Zend_Filter`` or ``Zend_Validate``. You can tell
``Zend_Filter_Input`` to search more namespaces. You can specify namespaces in the constructor options:

.. code-block:: php
   :linenos:

   $options = array('filterNamespace' => 'My_Namespace_Filter',
                    'validatorNamespace' => 'My_Namespace_Validate');
   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

Alternatively, you can use the ``addValidatorPrefixPath($prefix, $path)`` or ``addFilterPrefixPath($prefix,
$path)`` methods, which directly proxy to the plugin loader that is used by ``Zend_Filter_Input``:

.. code-block:: php
   :linenos:

   $input->addValidatorPrefixPath('Other_Namespace', 'Other/Namespace');
   $input->addFilterPrefixPath('Foo_Namespace', 'Foo/Namespace');

   // Now the search order for validators is:
   // 1. My_Namespace_Validate
   // 2. Other_Namespace
   // 3. Zend_Validate

   // The search order for filters is:
   // 1. My_Namespace_Filter
   // 2. Foo_Namespace
   // 3. Zend_Filter

You cannot remove ``Zend_Filter`` and ``Zend_Validate`` as namespaces, you only can add namespaces. User-defined
namespaces are searched first, Zend namespaces are searched last.

.. note::

   As of version 1.5 the function ``addNamespace($namespace)`` was deprecated and exchanged with the plugin loader
   and the ``addFilterPrefixPath()`` and ``addValidatorPrefixPath()`` were added. Also the constant
   ``Zend_Filter_Input::INPUT_NAMESPACE`` is now deprecated. The constants
   ``Zend_Filter_Input::VALIDATOR_NAMESPACE`` and ``Zend_Filter_Input::FILTER_NAMESPACE`` are available in releases
   after 1.7.0.

.. note::

   As of version 1.0.4, ``Zend_Filter_Input::NAMESPACE``, having value ``namespace``, was changed to
   ``Zend_Filter_Input::INPUT_NAMESPACE``, having value ``inputNamespace``, in order to comply with the *PHP* 5.3
   reservation of the keyword ``namespace``.


