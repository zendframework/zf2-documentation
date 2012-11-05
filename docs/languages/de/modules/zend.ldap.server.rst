.. EN-Revision: none
.. _zend.ldap.server:

Informationen vom LDAP Server erhalten
======================================

.. _zend.ldap.server.rootdse:

RootDSE
-------

Siehe die folgenden Dokumente für weitere Informationen über die Attribute die im RootDSE für einen gegebenen
*LDAP* Server enthalten sind.

- `OpenLDAP`_

- `Microsoft ActiveDirectory`_

- `Novell eDirectory`_

.. _zend.ldap.server.rootdse.getting:

.. rubric:: Mit dem RootDSE arbeiten

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $rootdse = $ldap->getRootDse();
   $serverType = $rootdse->getServerType();

.. _zend.ldap.server.schema:

Schema Browsen
--------------

.. _zend.ldap.server.schema.getting:

.. rubric:: Mit dem Schema Server arbeiten

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

   **Browsen im Schema von ActiveDirectory Servern**

   Wegen der Restriktionen bei Microsoft ActiveDirectory Servern bei der Anzahl an Einträgen die von generischen
   Suchroutinen zurückgegeben werden und durch die Struktur des ActiveDirectory Schema Repositories, ist das
   Schema Browsen aktuell **nicht** für Microsoft ActiveDirectory Server möglich.



.. _`OpenLDAP`: http://www.zytrax.com/books/ldap/ch3/#operational
.. _`Microsoft ActiveDirectory`: http://msdn.microsoft.com/en-us/library/ms684291(VS.85).aspx
.. _`Novell eDirectory`: http://www.novell.com/documentation/edir88/edir88/index.html?page=/documentation/edir88/edir88/data/ah59jqq.html
