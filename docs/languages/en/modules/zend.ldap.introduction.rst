.. _zend.ldap.introduction:

Introduction to Zend\\Ldap
==========================

``Zend\Ldap\Ldap`` is a class for performing *LDAP* operations including but not limited to binding, searching and
modifying entries in an *LDAP* directory.

.. _zend.ldap.introduction.theory-of-operations:

Theory of operation
-------------------

This component currently consists of the main ``Zend\Ldap\Ldap`` class, that conceptually represents a binding to a
single *LDAP* server and allows for executing operations against a *LDAP* server such as OpenLDAP or
ActiveDirectory (AD) servers. The parameters for binding may be provided explicitly or in the form of an options
array. ``Zend\Ldap\Node`` provides an object-oriented interface for single *LDAP* nodes and can be used to form a
basis for an active-record-like interface for a *LDAP*-based domain model.

The component provides several helper classes to perform operations on *LDAP* entries (``Zend\Ldap\Attribute``)
such as setting and retrieving attributes (date values, passwords, boolean values, ...), to create and modify
*LDAP* filter strings (``Zend\Ldap\Filter``) and to manipulate *LDAP* distinguished names (DN) (``Zend\Ldap\Dn``).

Additionally the component abstracts *LDAP* schema browsing for OpenLDAP and ActiveDirectory servers
``Zend\Ldap\Node\Schema`` and server information retrieval for OpenLDAP-, ActiveDirectory- and Novell eDirectory
servers (``Zend\Ldap\Node\RootDse``).

Using the ``Zend\Ldap\Ldap`` class depends on the type of *LDAP* server and is best summarized with some simple
examples.

If you are using OpenLDAP, a simple example looks like the following (note that the **bindRequiresDn** option is
important if you are **not** using AD):

.. code-block:: php
   :linenos:

   $options = array(
       'host'              => 's0.foo.net',
       'username'          => 'CN=user1,DC=foo,DC=net',
       'password'          => 'pass1',
       'bindRequiresDn'    => true,
       'accountDomainName' => 'foo.net',
       'baseDn'            => 'OU=Sales,DC=foo,DC=net',
   );
   $ldap = new Zend\Ldap\Ldap($options);
   $acctname = $ldap->getCanonicalAccountName('abaker',
                                              Zend\Ldap\Ldap::ACCTNAME_FORM_DN);
   echo "$acctname\n";

If you are using Microsoft AD a simple example is:

.. code-block:: php
   :linenos:

   $options = array(
       'host'                   => 'dc1.w.net',
       'useStartTls'            => true,
       'username'               => 'user1@w.net',
       'password'               => 'pass1',
       'accountDomainName'      => 'w.net',
       'accountDomainNameShort' => 'W',
       'baseDn'                 => 'CN=Users,DC=w,DC=net',
   );
   $ldap = new Zend\Ldap\Ldap($options);
   $acctname = $ldap->getCanonicalAccountName('bcarter',
                                              Zend\Ldap\Ldap::ACCTNAME_FORM_DN);
   echo "$acctname\n";

Note that we use the ``getCanonicalAccountName()`` method to retrieve the account DN here only because that is what
exercises the most of what little code is currently present in this class.

.. _zend.ldap.introduction.theory-of-operations.automatic-username-canonicalization:

Automatic Username Canonicalization When Binding
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If ``bind()`` is called with a non-DN username but **bindRequiresDN** is ``TRUE`` and no username in DN form was
supplied as an option, the bind will fail. However, if a username in DN form is supplied in the options array,
``Zend\Ldap\Ldap`` will first bind with that username, retrieve the account DN for the username supplied to
``bind()`` and then re-bind with that DN.

This behavior is critical to :ref:`Zend\\Authentication\\Adapter\\Ldap <zend.authentication.adapter.ldap>`, which
passes the username supplied by the user directly to ``bind()``.

The following example illustrates how the non-DN username '**abaker**' can be used with ``bind()``:

.. code-block:: php
   :linenos:

   $options = array(
           'host'              => 's0.foo.net',
           'username'          => 'CN=user1,DC=foo,DC=net',
           'password'          => 'pass1',
           'bindRequiresDn'    => true,
           'accountDomainName' => 'foo.net',
           'baseDn'            => 'OU=Sales,DC=foo,DC=net',
   );
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind('abaker', 'moonbike55');
   $acctname = $ldap->getCanonicalAccountName('abaker',
                                              Zend\Ldap\Ldap::ACCTNAME_FORM_DN);
   echo "$acctname\n";

The ``bind()`` call in this example sees that the username '**abaker**' is not in DN form, finds **bindRequiresDn**
is ``TRUE``, uses '``CN=user1,DC=foo,DC=net``' and '**pass1**' to bind, retrieves the DN for '**abaker**', unbinds
and then rebinds with the newly discovered '``CN=Alice Baker,OU=Sales,DC=foo,DC=net``'.

.. _zend.ldap.introduction.theory-of-operations.account-name-canonicalization:

Account Name Canonicalization
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The **accountDomainName** and **accountDomainNameShort** options are used for two purposes: (1) they facilitate
multi-domain authentication and failover capability, and (2) they are also used to canonicalize usernames.
Specifically, names are canonicalized to the form specified by the **accountCanonicalForm** option. This option may
one of the following values:

.. _zend.ldap.using.theory-of-operation.account-name-canonicalization.table:

.. table:: Options for accountCanonicalForm

   +-----------------------+-----+-----------------------------------------+
   |Name                   |Value|Example                                  |
   +=======================+=====+=========================================+
   |ACCTNAME_FORM_DN       |1    |CN=Alice Baker,CN=Users,DC=example,DC=com|
   +-----------------------+-----+-----------------------------------------+
   |ACCTNAME_FORM_USERNAME |2    |abaker                                   |
   +-----------------------+-----+-----------------------------------------+
   |ACCTNAME_FORM_BACKSLASH|3    |EXAMPLE\\abaker                          |
   +-----------------------+-----+-----------------------------------------+
   |ACCTNAME_FORM_PRINCIPAL|4    |abaker@example.com                       |
   +-----------------------+-----+-----------------------------------------+

The default canonicalization depends on what account domain name options were supplied. If
**accountDomainNameShort** was supplied, the default **accountCanonicalForm** value is ``ACCTNAME_FORM_BACKSLASH``.
Otherwise, if **accountDomainName** was supplied, the default is ``ACCTNAME_FORM_PRINCIPAL``.

Account name canonicalization ensures that the string used to identify an account is consistent regardless of what
was supplied to ``bind()``. For example, if the user supplies an account name of ``abaker@example.com`` or just
**abaker** and the **accountCanonicalForm** is set to 3, the resulting canonicalized name would be
**EXAMPLE\\abaker**.

.. _zend.ldap.introduction.theory-of-operations.multi-domain-failover:

Multi-domain Authentication and Failover
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``Zend\Ldap\Ldap`` component by itself makes no attempt to authenticate with multiple servers. However,
``Zend\Ldap\Ldap`` is specifically designed to handle this scenario gracefully. The required technique is to simply
iterate over an array of arrays of serve options and attempt to bind with each server. As described above
``bind()`` will automatically canonicalize each name, so it does not matter if the user passes ``abaker@foo.net``
or **W\bcarter** or **cdavis**- the ``bind()`` method will only succeed if the credentials were successfully used
in the bind.

Consider the following example that illustrates the technique required to implement multi-domain authentication and
failover:

.. code-block:: php
   :linenos:

   $acctname = 'W\\user2';
   $password = 'pass2';

   $multiOptions = array(
       'server1' => array(
           'host'                   => 's0.foo.net',
           'username'               => 'CN=user1,DC=foo,DC=net',
           'password'               => 'pass1',
           'bindRequiresDn'         => true,
           'accountDomainName'      => 'foo.net',
           'accountDomainNameShort' => 'FOO',
           'accountCanonicalForm'   => 4, // ACCT_FORM_PRINCIPAL
           'baseDn'                 => 'OU=Sales,DC=foo,DC=net',
       ),
       'server2' => array(
           'host'                   => 'dc1.w.net',
           'useSsl'                 => true,
           'username'               => 'user1@w.net',
           'password'               => 'pass1',
           'accountDomainName'      => 'w.net',
           'accountDomainNameShort' => 'W',
           'accountCanonicalForm'   => 4, // ACCT_FORM_PRINCIPAL
           'baseDn'                 => 'CN=Users,DC=w,DC=net',
       ),
   );

   $ldap = new Zend\Ldap\Ldap();

   foreach ($multiOptions as $name => $options) {

       echo "Trying to bind using server options for '$name'\n";

       $ldap->setOptions($options);
       try {
           $ldap->bind($acctname, $password);
           $acctname = $ldap->getCanonicalAccountName($acctname);
           echo "SUCCESS: authenticated $acctname\n";
           return;
       } catch (Zend\Ldap\Exception\LdapException $zle) {
           echo '  ' . $zle->getMessage() . "\n";
           if ($zle->getCode() === Zend\Ldap\Exception\LdapException::LDAP_X_DOMAIN_MISMATCH) {
               continue;
           }
       }
   }

If the bind fails for any reason, the next set of server options is tried.

The ``getCanonicalAccountName()`` call gets the canonical account name that the application would presumably use to
associate data with such as preferences. The **accountCanonicalForm = 4** in all server options ensures that the
canonical form is consistent regardless of which server was ultimately used.

The special ``LDAP_X_DOMAIN_MISMATCH`` exception occurs when an account name with a domain component was supplied
(e.g., ``abaker@foo.net`` or **FOO\\abaker** and not just **abaker**) but the domain component did not match either
domain in the currently selected server options. This exception indicates that the server is not an authority for
the account. In this case, the bind will not be performed, thereby eliminating unnecessary communication with the
server. Note that the **continue** instruction has no effect in this example, but in practice for error handling
and debugging purposes, you will probably want to check for ``LDAP_X_DOMAIN_MISMATCH`` as well as
``LDAP_NO_SUCH_OBJECT`` and ``LDAP_INVALID_CREDENTIALS``.

The above code is very similar to code used within :ref:`Zend\\Authentication\\Adapter\\Ldap
<zend.authentication.adapter.ldap>`. In fact, we recommend that you simply use that authentication adapter for
multi-domain + failover *LDAP* based authentication (or copy the code).


