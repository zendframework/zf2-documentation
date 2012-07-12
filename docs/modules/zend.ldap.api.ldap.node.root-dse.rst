
Zend\\Ldap\\Node\\RootDse
=========================

The following methods are available on all vendor-specific subclasses.

``Zend\Ldap\Node\RootDse`` includes the magic property accessors ``__get()`` and ``__isset()`` to access the attributes by their name. They proxy to ``Zend\Ldap\Node\RootDse::getAttribute()`` and ``Zend\Ldap\Node\RootDse::existsAttribute()`` respectively. ``__set()`` and ``__unset()`` are also implemented but they throw aBadMethodCallExceptionas modifications are not allowed on RootDSE nodes. Furthermore the class implementsArrayAccessfor array-style-access to the attributes. ``offsetSet()`` and ``offsetUnset()`` also throw aBadMethodCallExceptiondue ro obvious reasons.

.. _zend.ldap.api.reference.zend-ldap-node-rootdse.openldap:

OpenLDAP
--------

Additionally the common methods above apply to instances of ``Zend\Ldap\Node\RootDse\OpenLdap`` .

.. note::
    ****

    Refer to `LDAP Operational Attributes and Objects`_ for information on the attributes of OpenLDAP RootDSE.

.. _zend.ldap.api.reference.zend-ldap-node-rootdse.openldap.table:


Zend\\Ldap\\Node\\RootDse\\OpenLdap API
---------------------------------------
+---------------------------------------------+-----------------------------------------------------------------------------+
|Method                                       |Description                                                                  |
+=============================================+=============================================================================+
|integer getServerType()                      |Gets the server type. Returns Zend\\Ldap\\Node\\RootDse::SERVER_TYPE_OPENLDAP|
+---------------------------------------------+-----------------------------------------------------------------------------+
|string|null getConfigContext()               |Gets the configContext.                                                      |
+---------------------------------------------+-----------------------------------------------------------------------------+
|string|null getMonitorContext()              |Gets the monitorContext.                                                     |
+---------------------------------------------+-----------------------------------------------------------------------------+
|boolean supportsControl(string|array $oids)  |Determines if the control is supported.                                      |
+---------------------------------------------+-----------------------------------------------------------------------------+
|boolean supportsExtension(string|array $oids)|Determines if the extension is supported.                                    |
+---------------------------------------------+-----------------------------------------------------------------------------+
|boolean supportsFeature(string|array $oids)  |Determines if the feature is supported.                                      |
+---------------------------------------------+-----------------------------------------------------------------------------+


.. _zend.ldap.api.reference.zend-ldap-node-rootdse.activedirectory:

ActiveDirectory
---------------

Additionally the common methods above apply to instances of ``Zend\Ldap\Node\RootDse\ActiveDirectory`` .

.. note::
    ****

    Refer to `RootDSE`_ for information on the attributes of Microsoft ActiveDirectory RootDSE.

.. _zend.ldap.api.reference.zend-ldap-node-rootdse.activedirectory.table:


Zend\\Ldap\\Node\\RootDse\\ActiveDirectory API
----------------------------------------------
+----------------------------------------------+------------------------------------------------------------------------------------+
|Method                                        |Description                                                                         |
+==============================================+====================================================================================+
|integer getServerType()                       |Gets the server type. Returns Zend\\Ldap\\Node\\RootDse::SERVER_TYPE_ACTIVEDIRECTORY|
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getConfigurationNamingContext()   |Gets the configurationNamingContext.                                                |
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getCurrentTime()                  |Gets the currentTime.                                                               |
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getDefaultNamingContext()         |Gets the defaultNamingContext.                                                      |
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getDnsHostName()                  |Gets the dnsHostName.                                                               |
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getDomainControllerFunctionality()|Gets the domainControllerFunctionality.                                             |
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getDomainFunctionality()          |Gets the domainFunctionality.                                                       |
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getDsServiceName()                |Gets the dsServiceName.                                                             |
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getForestFunctionality()          |Gets the forestFunctionality.                                                       |
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getHighestCommittedUSN()          |Gets the highestCommittedUSN.                                                       |
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getIsGlobalCatalogReady()         |Gets the isGlobalCatalogReady.                                                      |
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getIsSynchronized()               |Gets the isSynchronized.                                                            |
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getLdapServiceName()              |Gets the ldapServiceName.                                                           |
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getRootDomainNamingContext()      |Gets the rootDomainNamingContext.                                                   |
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getSchemaNamingContext()          |Gets the schemaNamingContext.                                                       |
+----------------------------------------------+------------------------------------------------------------------------------------+
|string|null getServerName()                   |Gets the serverName.                                                                |
+----------------------------------------------+------------------------------------------------------------------------------------+
|boolean supportsCapability(string|array $oids)|Determines if the capability is supported.                                          |
+----------------------------------------------+------------------------------------------------------------------------------------+
|boolean supportsControl(string|array $oids)   |Determines if the control is supported.                                             |
+----------------------------------------------+------------------------------------------------------------------------------------+
|boolean supportsPolicy(string|array $policies)|Determines if the version is supported.                                             |
+----------------------------------------------+------------------------------------------------------------------------------------+


.. _zend.ldap.api.reference.zend-ldap-node-rootdse.edirectory:

eDirectory
----------

Additionally the common methods above apply to instances ofZend\\Ldap\\Node\\RootDse\\eDirectory.

.. note::
    ****

    Refer to `Getting Information about the LDAP Server`_ for information on the attributes of Novell eDirectory RootDSE.

.. _zend.ldap.api.reference.zend-ldap-node-rootdse.edirectory.table:


Zend\\Ldap\\Node\\RootDse\\eDirectory API
-----------------------------------------
+------------------------------------------------+-------------------------------------------------------------------------------+
|Method                                          |Description                                                                    |
+================================================+===============================================================================+
|integer getServerType()                         |Gets the server type. Returns Zend\\Ldap\\Node\\RootDse::SERVER_TYPE_EDIRECTORY|
+------------------------------------------------+-------------------------------------------------------------------------------+
|boolean supportsExtension(string|array $oids)   |Determines if the extension is supported.                                      |
+------------------------------------------------+-------------------------------------------------------------------------------+
|string|null getVendorName()                     |Gets the vendorName.                                                           |
+------------------------------------------------+-------------------------------------------------------------------------------+
|string|null getVendorVersion()                  |Gets the vendorVersion.                                                        |
+------------------------------------------------+-------------------------------------------------------------------------------+
|string|null getDsaName()                        |Gets the dsaName.                                                              |
+------------------------------------------------+-------------------------------------------------------------------------------+
|string|null getStatisticsErrors()               |Gets the server statistics "errors".                                           |
+------------------------------------------------+-------------------------------------------------------------------------------+
|string|null getStatisticsSecurityErrors()       |Gets the server statistics "securityErrors".                                   |
+------------------------------------------------+-------------------------------------------------------------------------------+
|string|null getStatisticsChainings()            |Gets the server statistics "chainings".                                        |
+------------------------------------------------+-------------------------------------------------------------------------------+
|string|null getStatisticsReferralsReturned()    |Gets the server statistics "referralsReturned".                                |
+------------------------------------------------+-------------------------------------------------------------------------------+
|string|null getStatisticsExtendedOps()          |Gets the server statistics "extendedOps".                                      |
+------------------------------------------------+-------------------------------------------------------------------------------+
|string|null getStatisticsAbandonOps()           |Gets the server statistics "abandonOps".                                       |
+------------------------------------------------+-------------------------------------------------------------------------------+
|string|null getStatisticsWholeSubtreeSearchOps()|Gets the server statistics "wholeSubtreeSearchOps".                            |
+------------------------------------------------+-------------------------------------------------------------------------------+



.. _`LDAP Operational Attributes and Objects`: http://www.zytrax.com/books/ldap/ch3/#operational
.. _`RootDSE`: http://msdn.microsoft.com/en-us/library/ms684291(VS.85).aspx
.. _`Getting Information about the LDAP Server`: http://www.novell.com/documentation/edir88/edir88/index.html?page=/documentation/edir88/edir88/data/ah59jqq.html
