.. _zend.ldap.usage:

Usage Scenarios
===============

.. _zend.ldap.usage.authentication:

Authentication scenarios
------------------------

.. _zend.ldap.usage.authentication.openldap:

OpenLDAP
^^^^^^^^



.. _zend.ldap.usage.authentication.activedirectory:

ActiveDirectory
^^^^^^^^^^^^^^^



.. _zend.ldap.usage.basic:

Basic CRUD operations
---------------------

.. _zend.ldap.usage.basic.retrieve:

Retrieving data from the LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.ldap.usage.basic.retrieve.dn:

.. rubric:: Getting an entry by its DN

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $hm = $ldap->getEntry('cn=Hugo Müller,ou=People,dc=my,dc=local');
   /*
   $hm is an array of the following structure
   array(
       'dn'          => 'cn=Hugo Müller,ou=People,dc=my,dc=local',
       'cn'          => array('Hugo Müller'),
       'sn'          => array('Müller'),
       'objectclass' => array('inetOrgPerson', 'top'),
       ...
   )
   */

.. _zend.ldap.usage.basic.retrieve.exists:

.. rubric:: Check for the existence of a given DN

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $isThere = $ldap->exists('cn=Hugo Müller,ou=People,dc=my,dc=local');

.. _zend.ldap.usage.basic.retrieve.counting-children:

.. rubric:: Count children of a given DN

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $childrenCount = $ldap->countChildren(
                               'cn=Hugo Müller,ou=People,dc=my,dc=local');

.. _zend.ldap.usage.basic.retrieve.search:

.. rubric:: Searching the LDAP tree

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $result = $ldap->search('(objectclass=*)',
                           'ou=People,dc=my,dc=local',
                           Zend\Ldap\Ldap::SEARCH_SCOPE_ONE);
   foreach ($result as $item) {
       echo $item["dn"] . ': ' . $item['cn'][0] . PHP_EOL;
   }

.. _zend.ldap.usage.basic.add:

Adding data to the LDAP
^^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Add a new entry to the LDAP

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $entry = array();
   Zend\Ldap\Attribute::setAttribute($entry, 'cn', 'Hans Meier');
   Zend\Ldap\Attribute::setAttribute($entry, 'sn', 'Meier');
   Zend\Ldap\Attribute::setAttribute($entry, 'objectClass', 'inetOrgPerson');
   $ldap->add('cn=Hans Meier,ou=People,dc=my,dc=local', $entry);

.. _zend.ldap.usage.basic.delete:

Deleting from the LDAP
^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Delete an existing entry from the LDAP

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $ldap->delete('cn=Hans Meier,ou=People,dc=my,dc=local');

.. _zend.ldap.usage.basic.update:

Updating the LDAP
^^^^^^^^^^^^^^^^^

.. rubric:: Update an existing entry on the LDAP

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $hm = $ldap->getEntry('cn=Hugo Müller,ou=People,dc=my,dc=local');
   Zend\Ldap\Attribute::setAttribute($hm, 'mail', 'mueller@my.local');
   Zend\Ldap\Attribute::setPassword($hm,
                                    'newPa$$w0rd',
                                    Zend\Ldap\Attribute::PASSWORD_HASH_SHA1);
   $ldap->update('cn=Hugo Müller,ou=People,dc=my,dc=local', $hm);

.. _zend.ldap.usage.extended:

Extended operations
-------------------

.. _zend.ldap.usage.extended.copy-and-move:

Copy and move entries in the LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.ldap.usage.extended.copy-and-move.copy:

.. rubric:: Copy a LDAP entry recursively with all its descendants

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $ldap->copy('cn=Hugo Müller,ou=People,dc=my,dc=local',
               'cn=Hans Meier,ou=People,dc=my,dc=local',
               true);

.. _zend.ldap.usage.extended.copy-and-move.move-to-subtree:

.. rubric:: Move a LDAP entry recursively with all its descendants to a different subtree

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $ldap->moveToSubtree('cn=Hugo Müller,ou=People,dc=my,dc=local',
                        'ou=Dismissed,dc=my,dc=local',
                        true);


