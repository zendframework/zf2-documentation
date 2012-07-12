
Zend\\Ldap\\Node\\Schema
========================

The following methods are available on all vendor-specific subclasses.

Zend\\Ldap\\Node\\Schemaincludes the magic property accessors__get()and__isset()to access the attributes by their name. They proxy toZend\\Ldap\\Node\\Schema::getAttribute()andZend\\Ldap\\Node\\Schema::existsAttribute()respectively.__set()and__unset()are also implemented, but they throw aBadMethodCallExceptionas modifications are not allowed on RootDSE nodes. Furthermore the class implementsArrayAccessfor array-style-access to the attributes.offsetSet()andoffsetUnset()also throw aBadMethodCallExceptiondue to obvious reasons.

Classes representing attribute types and object classes extendZend\\Ldap\\Node\\Schema\\AbstractItemwhich provides some core methods to access arbitrary attributes on the underlying *LDAP* node.Zend\\Ldap\\Node\\Schema\\AbstractItemincludes the magic property accessors__get()and__isset()to access the attributes by their name. Furthermore the class implementsArrayAccessfor array-style-access to the attributes.offsetSet()andoffsetUnset()throw aBadMethodCallExceptionas modifications are not allowed on schema information nodes.

.. _zend.ldap.api.reference.zend-ldap-node-schema.openldap:

OpenLDAP
--------

Additionally the common methods above apply to instances ofZend\\Ldap\\Node\\Schema\\OpenLDAP.

.. _zend.ldap.api.reference.zend-ldap-node-schema.openldap.table:


Zend\\Ldap\\Node\\Schema\\OpenLDAP API
--------------------------------------
+--------------------------+---------------------------+
|Method                    |Description                |
+==========================+===========================+
|array getLdapSyntaxes()   |Gets the LDAP syntaxes.    |
+--------------------------+---------------------------+
|array getMatchingRules()  |Gets the matching rules.   |
+--------------------------+---------------------------+
|array getMatchingRuleUse()|Gets the matching rule use.|
+--------------------------+---------------------------+


.. _zend.ldap.api.reference.zend-ldap-node-schema.openldap.attributetype-interface.table:


Zend\\Ldap\\Node\\Schema\\AttributeType\\OpenLDAP API
-----------------------------------------------------
+------------------------------------------------------------------+------------------------------------------------------------------------+
|Method                                                            |Description                                                             |
+==================================================================+========================================================================+
|Zend\\Ldap\\Node\\Schema\\AttributeType\\OpenLdap|null getParent()|Returns the parent attribute type in the inheritance tree if one exists.|
+------------------------------------------------------------------+------------------------------------------------------------------------+


.. _zend.ldap.api.reference.zend-ldap-node-schema.openldap.objectclass-interface.table:


Zend\\Ldap\\Node\\Schema\\ObjectClass\\OpenLDAP API
---------------------------------------------------
+------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
|Method            |Description                                                                                                                                                |
+==================+===========================================================================================================================================================+
|array getParents()|Returns the parent object classes in the inheritance tree if one exists. The returned array is an array of Zend\\Ldap\\Node\\Schema\\ObjectClass\\OpenLdap.|
+------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+


.. _zend.ldap.api.reference.zend-ldap-node-schema.activedirectory:

ActiveDirectory
---------------

.. note::
    **Schema browsing on ActiveDirectory servers**

    Due to restrictions on Microsoft ActiveDirectory servers regarding the number of entries returned by generic search routines and due to the structure of the ActiveDirectory schema repository, schema browsing is currentlynotavailable for Microsoft ActiveDirectory servers.

Zend\\Ldap\\Node\\Schema\\ActiveDirectorydoes not provide any additional methods.

.. _zend.ldap.api.reference.zend-ldap-node-schema.activedirectory.attributetype-interface.table:


Zend\\Ldap\\Node\\Schema\\AttributeType\\ActiveDirectory API
------------------------------------------------------------
+-------------------------------------------------------------------------------------------------+
|Zend\\Ldap\\Node\\Schema\\AttributeType\\ActiveDirectory does not provide any additional methods.|
+-------------------------------------------------------------------------------------------------+

.. _zend.ldap.api.reference.zend-ldap-node-schema.activedirectory.objectclass-interface.table:


Zend\\Ldap\\Node\\Schema\\ObjectClass\\ActiveDirectory API
----------------------------------------------------------
+-----------------------------------------------------------------------------------------------+
|Zend\\Ldap\\Node\\Schema\\ObjectClass\\ActiveDirectory does not provide any additional methods.|
+-----------------------------------------------------------------------------------------------+


