.. _zend.ldap.node:

Objektorientierter Zugriff auf den LDAP Baum durch Verwendung von Zend_Ldap_Node
================================================================================

.. _zend.ldap.node.basic:

Grundsätzliche CRUD Operationen
-------------------------------

.. _zend.ldap.node.basic.retrieve:

Daten von LDAP holen
^^^^^^^^^^^^^^^^^^^^

.. _zend.ldap.node.basic.retrieve.dn:

Einen Node durch seinen DN erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.basic.retrieve.search:

Den Subbaum eines Nodes durchsuchen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.basic.add:

Einen neuen Node in LDAP hinzufügen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.basic.delete:

Einen Node von LDAP löschen
^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.basic.update:

Einen Node in LDAP aktualisieren
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.extended:

Erweiterte Operationen
----------------------

.. _zend.ldap.node.extended.copy-and-move:

Nodes in LDAP kopieren und verschieben
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.traversal:

Baum Durchlaufen
----------------

.. rubric:: Einen LDAP Baum rekursiv durchlaufen

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend_Ldap($options);
   $ldap->bind();
   $ri = new RecursiveIteratorIterator($ldap->getBaseNode(),
                                       RecursiveIteratorIterator::SELF_FIRST);
   foreach ($ri as $rdn => $n) {
       var_dump($n);
   }


