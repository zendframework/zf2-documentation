
Zend\\Ldap\\Ldap
================

``Zend\Ldap\Ldap`` is the base interface into a *LDAP* server. It provides connection and binding methods as well as methods to operate on the *LDAP* tree.

.. _zend.ldap.api.reference.zend-ldap.zend-ldap-collection:

Zend\\Ldap\\Collection
----------------------

``Zend\Ldap\Collection`` implementsIteratorto allow for item traversal using ``foreach()`` andCountableto be able to respond to ``count()`` . With its protected ``createEntry()`` method it provides a simple extension point for developers needing custom result objects.

.. _zend.ldap.api.reference.zend-ldap.zend-ldap-collection.table:


Zend\\Ldap\\Collection API
--------------------------
+------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Method                                                            |Description                                                                                                                                                                                                                                 |
+==================================================================+============================================================================================================================================================================================================================================+
|__construct(Zend\\Ldap\\Collection\\Iterator\\Interface $iterator)|Constructor. The constructor must be provided by a Zend\\Ldap\\Collection\\Iterator\\Interface which does the real result iteration. Zend\\Ldap\\Collection\\Iterator\\Default is the default implementation for iterating ext/ldap results.|
+------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|boolean close()                                                   |Closes the internal iterator. This is also called in the destructor.                                                                                                                                                                        |
+------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|array toArray()                                                   |Returns all entries as an array.                                                                                                                                                                                                            |
+------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|array getFirst()                                                  |Returns the first entry in the collection or NULL if the collection is empty.                                                                                                                                                               |
+------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



