.. EN-Revision: none
.. _zend.ldap.usage:

Szenarien der Verwendung
========================

.. _zend.ldap.usage.authentication:

Szenarien der Authentifizierung
-------------------------------

.. _zend.ldap.usage.authentication.openldap:

OpenLDAP
^^^^^^^^



.. _zend.ldap.usage.authentication.activedirectory:

ActiveDirectory
^^^^^^^^^^^^^^^



.. _zend.ldap.usage.basic:

Grundsätzliche CRUD Operationen
-------------------------------

.. _zend.ldap.usage.basic.retrieve:

Daten von LDAP empfangen
^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.ldap.usage.basic.retrieve.dn:

.. rubric:: Einen Eintrag durch seinen DN erhalten

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

.. rubric:: Die Existenz eines angegebenen DN prüfen

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $isThere = $ldap->exists('cn=Hugo Müller,ou=People,dc=my,dc=local');

.. _zend.ldap.usage.basic.retrieve.counting-children:

.. rubric:: Kinder eines angegebenen DN zählen

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $childrenCount = $ldap->countChildren(
                               'cn=Hugo Müller,ou=People,dc=my,dc=local');

.. _zend.ldap.usage.basic.retrieve.search:

.. rubric:: Im LDAP Baum suchen

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $result = $ldap->search('(objectclass=*)',
                           'ou=People,dc=my,dc=local',
                           Zend\Ldap\Ext::SEARCH_SCOPE_ONE);
   foreach ($result as $item) {
       echo $item["dn"] . ': ' . $item['cn'][0] . PHP_EOL;
   }

.. _zend.ldap.usage.basic.add:

Daten zu LDAP hinzufügen
^^^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Einen neuen Eintrag zu LDAP hinzufügen

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

In LDAP löschen
^^^^^^^^^^^^^^^

.. rubric:: Einen existierenden Eintrag von LDAP löschen

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $ldap->delete('cn=Hans Meier,ou=People,dc=my,dc=local');

.. _zend.ldap.usage.basic.update:

LDAP aktualisieren
^^^^^^^^^^^^^^^^^^

.. rubric:: Einen existierenden Eintrag in LDAP aktualisieren

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

Erweiterte Operationen
----------------------

.. _zend.ldap.usage.extended.copy-and-move:

Kopieren und Verschieben von Einträgen in LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.ldap.usage.extended.copy-and-move.copy:

.. rubric:: Einen LDAP Eintrag mit allen seinen Abhängigkeiten rekursiv kopieren

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $ldap->copy('cn=Hugo Müller,ou=People,dc=my,dc=local',
               'cn=Hans Meier,ou=People,dc=my,dc=local',
               true);

.. _zend.ldap.usage.extended.copy-and-move.move-to-subtree:

.. rubric:: Einen LDAP Eintrag rekursiv in einen anderen Unterbaum verschieben mit allen seinen Abhängigkeiten

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $ldap->moveToSubtree('cn=Hugo Müller,ou=People,dc=my,dc=local',
                        'ou=Dismissed,dc=my,dc=local',
                        true);


