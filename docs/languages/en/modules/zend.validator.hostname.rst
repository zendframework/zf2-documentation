.. _zend.validator.hostname:

Hostname Validator
==================

``Zend\Validator\Hostname`` allows you to validate a hostname against a set of known specifications. It is possible
to check for three different types of hostnames: a *DNS* Hostname (i.e. ``domain.com``), IP address (i.e. 1.2.3.4),
and Local hostnames (i.e. localhost). By default only *DNS* hostnames are matched.

.. _zend.validator.hostname.options:

Supported options for Zend\\Validator\\Hostname
-----------------------------------------------

The following options are supported for ``Zend\Validator\Hostname``:

- **allow**: Defines the sort of hostname which is allowed to be used. See :ref:`Hostname types
  <zend.validator.hostname.types>` for details.

- **idn**: Defines if *IDN* domains are allowed or not. This option defaults to ``TRUE``.

- **ip**: Allows to define a own IP validator. This option defaults to a new instance of ``Zend\Validator\Ip``.

- **tld**: Defines if *TLD*\ s are validated. This option defaults to ``TRUE``.

.. _zend.validator.hostname.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Hostname();
   if ($validator->isValid($hostname)) {
       // hostname appears to be valid
   } else {
       // hostname is invalid; print the reasons
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

This will match the hostname ``$hostname`` and on failure populate ``getMessages()`` with useful error messages.

.. _zend.validator.hostname.types:

Validating different types of hostnames
---------------------------------------

You may find you also want to match IP addresses, Local hostnames, or a combination of all allowed types. This can
be done by passing a parameter to ``Zend\Validator\Hostname`` when you instantiate it. The parameter should be an
integer which determines what types of hostnames are allowed. You are encouraged to use the
``Zend\Validator\Hostname`` constants to do this.

The ``Zend\Validator\Hostname`` constants are: ``ALLOW_DNS`` to allow only *DNS* hostnames, ``ALLOW_IP`` to allow
IP addresses, ``ALLOW_LOCAL`` to allow local network names, ``ALLOW_URI`` to allow `RFC3986`_-compliant addresses,
and ``ALLOW_ALL`` to allow all four above types.

.. note::

   **Additional Information on ALLOW_URI**

   ``ALLOW_URI`` allows to check hostnames according to `RFC3986`_. These are registered names which are used by
   *WINS*, NetInfo and also local hostnames like those defined within your ``.hosts`` file.

To just check for IP addresses you can use the example below:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Hostname(Zend\Validator\Hostname::ALLOW_IP);
   if ($validator->isValid($hostname)) {
       // hostname appears to be valid
   } else {
       // hostname is invalid; print the reasons
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

As well as using ``ALLOW_ALL`` to accept all common hostnames types you can combine these types to allow for
combinations. For example, to accept *DNS* and Local hostnames instantiate your ``Zend\Validator\Hostname`` class
as so:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Hostname(Zend\Validator\Hostname::ALLOW_DNS |
                                           Zend\Validator\Hostname::ALLOW_IP);

.. _zend.validator.hostname.idn:

Validating International Domains Names
--------------------------------------

Some Country Code Top Level Domains (ccTLDs), such as 'de' (Germany), support international characters in domain
names. These are known as International Domain Names (*IDN*). These domains can be matched by
``Zend\Validator\Hostname`` via extended characters that are used in the validation process.

.. note::

   **IDN domains**

   Until now more than 50 ccTLDs support *IDN* domains.

To match an *IDN* domain it's as simple as just using the standard Hostname validator since *IDN* matching is
enabled by default. If you wish to disable *IDN* validation this can be done by either passing a parameter to the
``Zend\Validator\Hostname`` constructor or via the ``setValidateIdn()`` method.

You can disable *IDN* validation by passing a second parameter to the ``Zend\Validator\Hostname`` constructor in
the following way.

.. code-block:: php
   :linenos:

   $validator =
       new Zend\Validator\Hostname(
           array(
               'allow' => Zend\Validator\Hostname::ALLOW_DNS,
               'useIdnCheck'   => false
           )
       );

Alternatively you can either pass ``TRUE`` or ``FALSE`` to ``setValidateIdn()`` to enable or disable *IDN*
validation. If you are trying to match an *IDN* hostname which isn't currently supported it is likely it will fail
validation if it has any international characters in it. Where a ccTLD file doesn't exist in
``Zend/Validator/Hostname`` specifying the additional characters a normal hostname validation is performed.

.. note::

   **IDN validation**

   Please note that *IDN*\ s are only validated if you allow *DNS* hostnames to be validated.

.. _zend.validator.hostname.tld:

Validating Top Level Domains
----------------------------

By default a hostname will be checked against a list of known *TLD*\ s. If this functionality is not required it
can be disabled in much the same way as disabling *IDN* support. You can disable *TLD* validation by passing a
third parameter to the ``Zend\Validator\Hostname`` constructor. In the example below we are supporting *IDN*
validation via the second parameter.

.. code-block:: php
   :linenos:

   $validator =
       new Zend\Validator\Hostname(
           array(
               'allow' => Zend\Validator\Hostname::ALLOW_DNS,
               'useIdnCheck'   => true,
               'useTldCheck'   => false
           )
       );

Alternatively you can either pass ``TRUE`` or ``FALSE`` to ``setValidateTld()`` to enable or disable *TLD*
validation.

.. note::

   **TLD validation**

   Please note *TLD*\ s are only validated if you allow *DNS* hostnames to be validated.



.. _`RFC3986`: http://tools.ietf.org/html/rfc3986
