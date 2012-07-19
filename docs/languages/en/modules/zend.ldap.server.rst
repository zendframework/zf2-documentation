.. _zend.ldap.server:

Getting information from the LDAP server
========================================

.. _zend.ldap.server.rootdse:

RootDSE
-------

See the following documents for more information on the attributes contained within the RootDSE for a given *LDAP*
server.

- `OpenLDAP`_

- `Microsoft ActiveDirectory`_

- `Novell eDirectory`_

.. _zend.ldap.server.rootdse.getting:

.. rubric:: Getting hands on the RootDSE

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $rootdse = $ldap->getRootDse();
   $serverType = $rootdse->getServerType();

.. _zend.ldap.server.schema:

Schema Browsing
---------------

.. _zend.ldap.server.schema.getting:

.. rubric:: Getting hands on the server schema

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $schema = $ldap->getSchema();
   $classes = $schema->getObjectClasses();

.. _zend.ldap.server.schema.openldap:

OpenLDAP
^^^^^^^^



.. _zend.ldap.server.schema.activedirectory:

ActiveDirectory
^^^^^^^^^^^^^^^

.. note::

   **Schema browsing on ActiveDirectory servers**

   Due to restrictions on Microsoft ActiveDirectory servers regarding the number of entries returned by generic
   search routines and due to the structure of the ActiveDirectory schema repository, schema browsing is currently
   **not** available for Microsoft ActiveDirectory servers.



.. _`OpenLDAP`: http://www.zytrax.com/books/ldap/ch3/#operational
.. _`Microsoft ActiveDirectory`: http://msdn.microsoft.com/en-us/library/ms684291(VS.85).aspx
.. _`Novell eDirectory`: http://www.novell.com/documentation/edir88/edir88/index.html?page=/documentation/edir88/edir88/data/ah59jqq.html
