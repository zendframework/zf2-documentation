
Getting information from the LDAP server
========================================

.. _zend.ldap.server.rootdse:

RootDSE
-------

See the following documents for more information on the attributes contained within the RootDSE for a given *LDAP* server.

    - OpenLDAPMicrosoft
    - ActiveDirectoryNovell
    - eDirectory


.. _zend.ldap.server.rootdse.getting:

Getting hands on the RootDSE
----------------------------

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

Getting hands on the server schema
----------------------------------

.. code-block:: php
    :linenos:
    
    $options = array(/* ... */);
    $ldap = new Zend\Ldap\Ldap($options);
    $schema = $ldap->getSchema();
    $classes = $schema->getObjectClasses();
    

.. _zend.ldap.server.schema.openldap:

OpenLDAP
--------



.. _zend.ldap.server.schema.activedirectory:

ActiveDirectory
---------------

.. note::
    **Schema browsing on ActiveDirectory servers**

    Due to restrictions on Microsoft ActiveDirectory servers regarding the number of entries returned by generic search routines and due to the structure of the ActiveDirectory schema repository, schema browsing is currentlynotavailable for Microsoft ActiveDirectory servers.


