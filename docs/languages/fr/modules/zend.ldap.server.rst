.. EN-Revision: none
.. _zend.ldap.server:

Récupérer des informations depuis un serveur LDAP
=================================================

.. _zend.ldap.server.rootdse:

RootDSE
-------

Voyez les documents qui suivent pour plus d'informations sur les attributs contenus dans le RootDSE pour un serveur
*LDAP* donné.

- `OpenLDAP`_

- `Microsoft ActiveDirectory`_

- `Novell eDirectory`_

.. _zend.ldap.server.rootdse.getting:

.. rubric:: Prendre la main sur le RootDSE

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $rootdse = $ldap->getRootDse();
   $serverType = $rootdse->getServerType();

.. _zend.ldap.server.schema:

Parcours de Schema
------------------

.. _zend.ldap.server.schema.getting:

.. rubric:: Prendre la main sur le schema du serveur

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $schema = $ldap->getSchema();
   $classes = $schema->getObjectClasses();

.. _zend.ldap.server.schema.openldap:

OpenLDAP
^^^^^^^^



.. _zend.ldap.server.schema.activedirectory:

ActiveDirectory
^^^^^^^^^^^^^^^

.. note::

   **Parcours du Schema pour les serveurs ActiveDirectory**

   A cause de restrictions concernant le nombre d'entrées retournées par une recherche générique et la
   structure du schema de ActiveDirectory, le parcours de schema n'est **pas** disponible actuellement pour les
   serveurs Microsoft ActiveDirectory.



.. _`OpenLDAP`: http://www.zytrax.com/books/ldap/ch3/#operational
.. _`Microsoft ActiveDirectory`: http://msdn.microsoft.com/en-us/library/ms684291(VS.85).aspx
.. _`Novell eDirectory`: http://www.novell.com/documentation/edir88/edir88/index.html?page=/documentation/edir88/edir88/data/ah59jqq.html
