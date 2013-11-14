.. _zend.validator.creditcard:

CreditCard Validator
====================

``Zend\Validator\CreditCard`` allows you to validate if a given value could be a credit card number.

A credit card contains several items of metadata, including a hologram, account number, logo, expiration date,
security code and the card holder name. The algorithms for verifying the combination of metadata are only known to
the issuing company, and should be verified with them for purposes of payment. However, it's often useful to know
whether or not a given number actually falls within the ranges of possible numbers **prior** to performing such
verification, and, as such, ``Zend\Validator\CreditCard`` simply verifies that the credit card number provided is
well-formed.

For those cases where you have a service that can perform comprehensive verification, ``Zend\Validator\CreditCard``
also provides the ability to attach a service callback to trigger once the credit card number has been deemed
valid; this callback will then be triggered, and its return value will determine overall validity.

The following issuing institutes are accepted:

- **American Express**

- **China UnionPay**

- **Diners Club Card Blanche**

- **Diners Club International**

- **Diners Club US & Canada**

- **Discover Card**

- **JCB**

- **Laser**

- **Maestro**

- **MasterCard**

- **Solo**

- **Visa**

- **Visa Electron**

.. note::

   **Invalid institutes**

   The institutes **Bankcard** and **Diners Club enRoute** do not exist anymore. Therefore they are treated as
   invalid.

   **Switch** has been rebranded to **Visa** and is therefore also treated as invalid.

.. _zend.validator.creditcard.options:

Supported options for Zend\\Validator\\CreditCard
-------------------------------------------------

The following options are supported for ``Zend\Validator\CreditCard``:

- **service**: A callback to an online service which will additionally be used for the validation.

- **type**: The type of credit card which will be validated. See the below list of institutes for details.

.. _zend.validator.creditcard.basic:

Basic usage
-----------

There are several credit card institutes which can be validated by ``Zend\Validator\CreditCard``. Per default, all
known institutes will be accepted. See the following example:

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\CreditCard();
   if ($valid->isValid($input)) {
       // input appears to be valid
   } else {
       // input is invalid
   }

The above example would validate against all known credit card institutes.

.. _zend.validator.creditcard.institute:

Accepting defined credit cards
------------------------------

Sometimes it is necessary to accept only defined credit card institutes instead of all; e.g., when you have a
webshop which accepts only Visa and American Express cards. ``Zend\Validator\CreditCard`` allows you to do exactly
this by limiting it to exactly these institutes.

To use a limitation you can either provide specific institutes at initiation, or afterwards by using ``setType()``.
Each can take several arguments.

You can provide a single institute:

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\CreditCard(
       Zend\Validator\CreditCard::AMERICAN_EXPRESS
   );

When you want to allow multiple institutes, then you can provide them as array:

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\CreditCard(array(
       Zend\Validator\CreditCard::AMERICAN_EXPRESS,
       Zend\Validator\CreditCard::VISA
   ));

And as with all validators, you can also pass an associative array of options or an instance of ``Traversable``. In
this case you have to provide the institutes with the ``type`` array key as simulated here:

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\CreditCard(array(
       'type' => array(Zend\Validator\CreditCard::AMERICAN_EXPRESS)
   ));

.. _zend.validator.creditcard.institute.table:

.. table:: Constants for credit card institutes

   +-------------------------+-------------------------------------------+
   |Institute                |Constant                                   |
   +=========================+===========================================+
   |American Express         |Zend\Validator\CreditCard::AMERICAN_EXPRESS|
   +-------------------------+-------------------------------------------+
   |China UnionPay           |Zend\Validator\CreditCard::UNIONPAY        |
   +-------------------------+-------------------------------------------+
   |Diners Club Card Blanche |Zend\Validator\CreditCard::DINERS_CLUB     |
   +-------------------------+-------------------------------------------+
   |Diners Club International|Zend\Validator\CreditCard::DINERS_CLUB     |
   +-------------------------+-------------------------------------------+
   |Diners Club US & Canada  |Zend\Validator\CreditCard::DINERS_CLUB_US  |
   +-------------------------+-------------------------------------------+
   |Discover Card            |Zend\Validator\CreditCard::DISCOVER        |
   +-------------------------+-------------------------------------------+
   |JCB                      |Zend\Validator\CreditCard::JCB             |
   +-------------------------+-------------------------------------------+
   |Laser                    |Zend\Validator\CreditCard::LASER           |
   +-------------------------+-------------------------------------------+
   |Maestro                  |Zend\Validator\CreditCard::MAESTRO         |
   +-------------------------+-------------------------------------------+
   |MasterCard               |Zend\Validator\CreditCard::MASTERCARD      |
   +-------------------------+-------------------------------------------+
   |Solo                     |Zend\Validator\CreditCard::SOLO            |
   +-------------------------+-------------------------------------------+
   |Visa                     |Zend\Validator\CreditCard::VISA            |
   +-------------------------+-------------------------------------------+
   |Visa Electron            |Zend\Validator\CreditCard::VISA            |
   +-------------------------+-------------------------------------------+

You can also set or add institutes afterward instantiation by using the methods ``setType()``, ``addType()`` and
``getType()``.

.. code-block:: php
   :linenos:

   $valid = new Zend\Validator\CreditCard();
   $valid->setType(array(
       Zend\Validator\CreditCard::AMERICAN_EXPRESS,
       Zend\Validator\CreditCard::VISA
   ));

.. note::

   **Default institute**

   When no institute is given at initiation then ``ALL`` will be used, which sets all institutes at once.

   In this case the usage of ``addType()`` is useless because all institutes are already added.

.. _zend.validator.creditcard.servicecheck:

Validation by using foreign APIs
--------------------------------

As said before ``Zend\Validator\CreditCard`` will only validate the credit card number. Fortunately, some
institutes provide online *API*\ s which can validate a credit card number by using algorithms which are not
available to the public. Most of these services are paid services. Therefore, this check is deactivated per
default.

When you have access to such an *API*, then you can use it as an add on for ``Zend\Validator\CreditCard`` and
increase the security of the validation.

To do so, you simply need to give a callback which will be called when the generic validation has passed. This
prevents the *API* from being called for invalid numbers, which increases the performance of the application.

``setService()`` sets a new service, and ``getService()`` returns the set service. As a configuration option, you
can give the array key '``service``' at initiation. For details about possible options take a look into
:ref:`Callback <zend.validator.callback>`.

.. code-block:: php
   :linenos:

   // Your service class
   class CcService
   {
       public function checkOnline($cardnumber, $types)
       {
           // some online validation
       }
   }

   // The validation
   $service = new CcService();
   $valid   = new Zend\Validator\CreditCard(Zend\Validator\CreditCard::VISA);
   $valid->setService(array($service, 'checkOnline'));

As you can see the callback method will be called with the credit card number as the first parameter, and the
accepted types as the second parameter.


