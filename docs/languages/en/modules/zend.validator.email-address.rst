.. _zend.validator.email_address:

EmailAddress Validator
======================

``Zend\Validator\EmailAddress`` allows you to validate an email address. The validator first splits the email
address on local-part @ hostname and attempts to match these against known specifications for email addresses and
hostnames.

.. _zend.validator.email_address.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\EmailAddress();
   if ($validator->isValid($email)) {
       // email appears to be valid
   } else {
       // email is invalid; print the reasons
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

This will match the email address ``$email`` and on failure populate ``getMessages()`` with useful error messages.

.. _zend.validator.email_address.options:

Options for validating Email Addresses
--------------------------------------

``Zend\Validator\EmailAddress`` supports several options which can either be set at initiation, by giving an array
with the related options, or afterwards, by using ``setOptions()``. The following options are supported:

- **allow**: Defines which type of domain names are accepted. This option is used in conjunction with the hostname
  option to set the hostname validator. For more information about possible values of this option, look at
  :ref:`Hostname <zend.validator.hostname>` and possible ``ALLOW``\ * constants. This option defaults to
  ``ALLOW_DNS``.

- **deep**: Defines if the servers MX records should be verified by a deep check. When this option is set to
  ``TRUE`` then additionally to MX records also the A, A6 and ``AAAA`` records are used to verify if the server
  accepts emails. This option defaults to ``FALSE``.

- **domain**: Defines if the domain part should be checked. When this option is set to ``FALSE``, then only the
  local part of the email address will be checked. In this case the hostname validator will not be called. This
  option defaults to ``TRUE``.

- **hostname**: Sets the hostname validator with which the domain part of the email address will be validated.

- **mx**: Defines if the MX records from the server should be detected. If this option is defined to ``TRUE`` then
  the MX records are used to verify if the server accepts emails. This option defaults to ``FALSE``.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\EmailAddress();
   $validator->setOptions(array('domain' => false));

.. _zend.validator.email_address.complexlocal:

Complex local parts
-------------------

``Zend\Validator\EmailAddress`` will match any valid email address according to RFC2822. For example, valid emails
include **bob@domain.com**, **bob+jones@domain.us**, **"bob@jones"@domain.com** and **"bob jones"@domain.com**

Some obsolete email formats will not currently validate (e.g. carriage returns or a "\\" character in an email
address).

.. _zend.validator.email_address.purelocal:

Validating only the local part
------------------------------

If you need ``Zend\Validator\EmailAddress`` to check only the local part of an email address, and want to disable
validation of the hostname, you can set the ``domain`` option to ``FALSE``. This forces
``Zend\Validator\EmailAddress`` not to validate the hostname part of the email address.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\EmailAddress();
   $validator->setOptions(array('domain' => FALSE));

.. _zend.validator.email_address.hostnametype:

Validating different types of hostnames
---------------------------------------

The hostname part of an email address is validated against :ref:`Zend\\Validator\\Hostname
<zend.validator.hostname>`. By default only DNS hostnames of the form ``domain.com`` are accepted, though if
you wish you can accept IP addresses and Local hostnames too.

To do this you need to instantiate ``Zend\Validator\EmailAddress`` passing a parameter to indicate the type of
hostnames you want to accept. More details are included in ``Zend\Validator\Hostname``, though an example of how to
accept both DNS and Local hostnames appears below:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\EmailAddress(
                       Zend\Validator\Hostname::ALLOW_DNS |
                       Zend\Validator\Hostname::ALLOW_LOCAL);
   if ($validator->isValid($email)) {
       // email appears to be valid
   } else {
       // email is invalid; print the reasons
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

.. _zend.validator.email_address.checkacceptance:

Checking if the hostname actually accepts email
-----------------------------------------------

Just because an email address is in the correct format, it doesn't necessarily mean that email address actually
exists. To help solve this problem, you can use MX validation to check whether an MX (email) entry exists in the
DNS record for the email's hostname. This tells you that the hostname accepts email, but doesn't tell you the exact
email address itself is valid.

MX checking is not enabled by default. To enable MX checking you can pass a second parameter to the
``Zend\Validator\EmailAddress`` constructor.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\EmailAddress(
       array(
           'allow' => Zend\Validator\Hostname::ALLOW_DNS,
           'useMxCheck'    => true
       )
   );

.. note::

   **MX Check under Windows**

   Within Windows environments MX checking is only available when *PHP* 5.3 or above is used. Below *PHP* 5.3 MX
   checking will not be used even if it's activated within the options.

Alternatively you can either pass ``TRUE`` or ``FALSE`` to ``setValidateMx()`` to enable or disable MX validation.

By enabling this setting network functions will be used to check for the presence of an MX record on the hostname
of the email address you wish to validate. Please be aware this will likely slow your script down.

Sometimes validation for MX records returns ``FALSE``, even if emails are accepted. The reason behind this
behaviour is, that servers can accept emails even if they do not provide a MX record. In this case they can provide
A, A6 or ``AAAA`` records. To allow ``Zend\Validator\EmailAddress`` to check also for these other records, you need
to set deep MX validation. This can be done at initiation by setting the ``deep`` option or by using
``setOptions()``.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\EmailAddress(
       array(
           'allow' => Zend\Validator\Hostname::ALLOW_DNS,
           'useMxCheck'    => true,
           'useDeepMxCheck'  => true
       )
   );

Sometimes it can be useful to get the server's MX information which have been used to do further processing. Simply
use ``getMXRecord()`` after validation. This method returns the received MX record including weight and sorted by
it.

.. warning::

   **Performance warning**

   You should be aware that enabling MX check will slow down you script because of the used network functions.
   Enabling deep check will slow down your script even more as it searches the given server for 3 additional types.

.. note::

   **Disallowed IP addresses**

   You should note that MX validation is only accepted for external servers. When deep MX validation is enabled,
   then local IP addresses like ``192.168.*`` or ``169.254.*`` are not accepted.

.. _zend.validator.email_address.validatoridn:

Validating International Domains Names
--------------------------------------

``Zend\Validator\EmailAddress`` will also match international characters that exist in some domains. This is known
as International Domain Name (IDN) support. This is enabled by default, though you can disable this by changing the
setting via the internal ``Zend\Validator\Hostname`` object that exists within ``Zend\Validator\EmailAddress``.

.. code-block:: php
   :linenos:

   $validator->getHostnameValidator()->setValidateIdn(false);

More information on the usage of ``setValidateIdn()`` appears in the ``Zend\Validator\Hostname`` documentation.

Please note IDNs are only validated if you allow DNS hostnames to be validated.

.. _zend.validator.email_address.validatortld:

Validating Top Level Domains
----------------------------

By default a hostname will be checked against a list of known TLDs. This is enabled by default, though you can
disable this by changing the setting via the internal ``Zend\Validator\Hostname`` object that exists within
``Zend\Validator\EmailAddress``.

.. code-block:: php
   :linenos:

   $validator->getHostnameValidator()->setValidateTld(false);

More information on the usage of ``setValidateTld()`` appears in the ``Zend\Validator\Hostname`` documentation.

Please note TLDs are only validated if you allow DNS hostnames to be validated.

.. _zend.validator.email_address.setmessage:

Setting messages
----------------

``Zend\Validator\EmailAddress`` makes also use of ``Zend\Validator\Hostname`` to check the hostname part of a given
email address. As with Zend Framework 1.10 you can simply set messages for ``Zend\Validator\Hostname`` from within
``Zend\Validator\EmailAddress``.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\EmailAddress();
   $validator->setMessages(
       array(
           Zend\Validator\Hostname::UNKNOWN_TLD => 'I don\'t know the TLD you gave'
       )
   );

Before Zend Framework 1.10 you had to attach the messages to your own ``Zend\Validator\Hostname``, and then set
this validator within ``Zend\Validator\EmailAddress`` to get your own messages returned.


