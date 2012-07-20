.. _zend.ldap.usage:

Scénarios d'utilisation
=======================

.. _zend.ldap.usage.authentication:

Scénarios d'authentification
----------------------------

.. _zend.ldap.usage.authentication.openldap:

OpenLDAP
^^^^^^^^



.. _zend.ldap.usage.authentication.activedirectory:

ActiveDirectory
^^^^^^^^^^^^^^^



.. _zend.ldap.usage.basic:

Opérations CRUD basiques
------------------------

.. _zend.ldap.usage.basic.retrieve:

Récupérer des données depuis LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.ldap.usage.basic.retrieve.dn:

.. rubric:: Récupérer une entrée grâce à son DN

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $hm = $ldap->getEntry('cn=Hugo Müller,ou=People,dc=my,dc=local');
   /*
   $hm est un tableau à la structure suivante:
   array(
       'dn'          => 'cn=Hugo Müller,ou=People,dc=my,dc=local',
       'cn'          => array('Hugo Müller'),
       'sn'          => array('Müller'),
       'objectclass' => array('inetOrgPerson', 'top'),
       ...
   )
   */

.. _zend.ldap.usage.basic.retrieve.exists:

.. rubric:: Vérifier l'existence d'un DN donné

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $isThere = $ldap->exists('cn=Hugo Müller,ou=People,dc=my,dc=local');

.. _zend.ldap.usage.basic.retrieve.counting-children:

.. rubric:: Compter les enfants d'un DN donné

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $childrenCount = $ldap->countChildren(
                               'cn=Hugo Müller,ou=People,dc=my,dc=local');

.. _zend.ldap.usage.basic.retrieve.search:

.. rubric:: Chercher dans l'arbre LDAP

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $result = $ldap->search('(objectclass=*)',
                           'ou=People,dc=my,dc=local',
                           Zend_Ldap_Ext::SEARCH_SCOPE_ONE);
   foreach ($result as $item) {
       echo $item["dn"] . ': ' . $item['cn'][0] . PHP_EOL;
   }

.. _zend.ldap.usage.basic.add:

Ajouter des données à LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Ajouter une nouvelle entrée à LDAP

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $entry = array();
   Zend_Ldap_Attribute::setAttribute($entry, 'cn', 'Hans Meier');
   Zend_Ldap_Attribute::setAttribute($entry, 'sn', 'Meier');
   Zend_Ldap_Attribute::setAttribute($entry, 'objectClass', 'inetOrgPerson');
   $ldap->add('cn=Hans Meier,ou=People,dc=my,dc=local', $entry);

.. _zend.ldap.usage.basic.delete:

Supprimer de LDAP
^^^^^^^^^^^^^^^^^

.. rubric:: Supprimer une entrée existante de LDAP

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $ldap->delete('cn=Hans Meier,ou=People,dc=my,dc=local');

.. _zend.ldap.usage.basic.update:

Mettre à jour LDAP
^^^^^^^^^^^^^^^^^^

.. rubric:: Mettre à jour une entrée existante dans LDAP

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $hm = $ldap->getEntry('cn=Hugo Müller,ou=People,dc=my,dc=local');
   Zend_Ldap_Attribute::setAttribute($hm, 'mail', 'mueller@my.local');
   Zend_Ldap_Attribute::setPassword($hm,
                                    'newPa$$w0rd',
                                    Zend_Ldap_Attribute::PASSWORD_HASH_SHA1);
   $ldap->update('cn=Hugo Müller,ou=People,dc=my,dc=local', $hm);

.. _zend.ldap.usage.extended:

Opérations avancées
-------------------

.. _zend.ldap.usage.extended.copy-and-move:

Copier et déplacer des entrées LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.ldap.usage.extended.copy-and-move.copy:

.. rubric:: Copier une entrée LDAP récursivement avec tous ses descendants

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $ldap->copy('cn=Hugo Müller,ou=People,dc=my,dc=local',
               'cn=Hans Meier,ou=People,dc=my,dc=local',
               true);

.. _zend.ldap.usage.extended.copy-and-move.move-to-subtree:

.. rubric:: Déplacer une entrée LDAP récursivement vers un sous-arbre différent

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $ldap->moveToSubtree('cn=Hugo Müller,ou=People,dc=my,dc=local',
                        'ou=Dismissed,dc=my,dc=local',
                        true);


