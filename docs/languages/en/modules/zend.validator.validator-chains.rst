.. _zend.validator.validator_chains:

Validator Chains
================

.. _zend.validator.validator_chains.overview:

Overview
--------

Often multiple validations should be applied to some value in a particular order. The following code demonstrates a
way to solve the example from the :ref:`introduction <zend.validator.introduction>`, where a username must be
between 6 and 12 alphanumeric characters:

.. code-block:: php
   :linenos:

   // Create a validator chain and add validators to it
   $validatorChain = new Zend\Validator\ValidatorChain();
   $validatorChain->attach(
                       new Zend\Validator\StringLength(array('min' => 6,
                                                            'max' => 12)))
                  ->attach(new Zend\I18n\Validator\Alnum());

   // Validate the username
   if ($validatorChain->isValid($username)) {
       // username passed validation
   } else {
       // username failed validation; print reasons
       foreach ($validatorChain->getMessages() as $message) {
           echo "$message\n";
       }
   }

Validators are run in the order they were added to ``Zend\Validator\ValidatorChain``. In the above example, the
username is first checked to ensure that its length is between 6 and 12 characters, and then it is checked to
ensure that it contains only alphanumeric characters. The second validation, for alphanumeric characters, is
performed regardless of whether the first validation, for length between 6 and 12 characters, succeeds. This means
that if both validations fail, ``getMessages()`` will return failure messages from both validators.

In some cases it makes sense to have a validator break the chain if its validation process fails.
``Zend\Validator\ValidatorChain`` supports such use cases with the second parameter to the ``attach()``
method. By setting ``$breakChainOnFailure`` to ``TRUE``, the added validator will break the chain execution upon
failure, which avoids running any other validations that are determined to be unnecessary or inappropriate for the
situation. If the above example were written as follows, then the alphanumeric validation would not occur if the
string length validation fails:

.. code-block:: php
   :linenos:

   $validatorChain->attach(
                       new Zend\Validator\StringLength(array('min' => 6,
                                                            'max' => 12)),
                       true)
                  ->attach(new Zend\I18n\Validator\Alnum());

Any object that implements ``Zend\Validator\ValidatorInterface`` may be used in a validator chain.


