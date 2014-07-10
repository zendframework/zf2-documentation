.. _zend.ldap.node:

Object-oriented access to the LDAP tree using Zend\\Ldap\\Node
==============================================================

.. _zend.ldap.node.basic:

Basic CRUD operations
---------------------

.. _zend.ldap.node.basic.retrieve:

Retrieving data from the LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.ldap.node.basic.retrieve.dn:

Getting a node by its DN
^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.basic.retrieve.search:

Searching a node's subtree
^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.basic.add:

Adding a new node to the LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.basic.delete:

Deleting a node from the LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.basic.update:

Updating a node on the LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.extended:

Extended operations
-------------------

.. _zend.ldap.node.extended.copy-and-move:

Copy and move nodes in the LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.traversal:

Tree traversal
--------------

.. rubric:: Traverse LDAP tree recursively

.. code-block:: php
   :linenos:

   $options = array(/* ... */);
   $ldap = new Zend\Ldap\Ldap($options);
   $ldap->bind();
   $ri = new RecursiveIteratorIterator($ldap->getBaseNode(),
                                       RecursiveIteratorIterator::SELF_FIRST);
   foreach ($ri as $rdn => $n) {
       var_dump($n);
   }


