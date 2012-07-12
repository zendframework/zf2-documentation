
Writing Validators
==================

``Zend\Validator\AbstractValidator`` supplies a set of commonly needed validators, but inevitably, developers will wish to write custom validators for their particular needs. The task of writing a custom validator is described in this section.

``Zend\Validator\ValidatorInterface`` defines two methods, ``isValid()`` and ``getMessages()`` , that may be implemented by user classes in order to create custom validation objects. An object that implements ``Zend\Validator\AbstractValidator`` interface may be added to a validator chain with ``Zend\Validator\ValidatorChain::addValidator()`` . Such objects may also be used with :ref:`Zend\\Filter\\Input <zend.filter.input>` .

As you may already have inferred from the above description of ``Zend\Validator\ValidatorInterface`` , validation classes provided with Zend Framework return a boolean value for whether or not a value validates successfully. They also provide information aboutwhya value failed validation. The availability of the reasons for validation failures may be valuable to an application for various purposes, such as providing statistics for usability analysis.

Basic validation failure message functionality is implemented in ``Zend\Validator\AbstractValidator`` . To include this functionality when creating a validation class, simply extend ``Zend\Validator\AbstractValidator`` . In the extending class you would implement the ``isValid()`` method logic and define the message variables and message templates that correspond to the types of validation failures that can occur. If a value fails your validation tests, then ``isValid()`` should return ``FALSE`` . If the value passes your validation tests, then ``isValid()`` should return ``TRUE`` .

In general, the ``isValid()`` method should not throw any exceptions, except where it is impossible to determine whether or not the input value is valid. A few examples of reasonable cases for throwing an exception might be if a file cannot be opened, an *LDAP* server could not be contacted, or a database connection is unavailable, where such a thing may be required for validation success or failure to be determined.


