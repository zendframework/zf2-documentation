.. _zend.ldap.node:

Accès à l'arbre LDAP de manière orientée objet avec Zend_Ldap_Node
==================================================================

.. _zend.ldap.node.basic:

Opérations CRUD basiques
------------------------

.. _zend.ldap.node.basic.retrieve:

Récupérer des données depuis LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.ldap.node.basic.retrieve.dn:

Récupérer un noeud par son DN
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.basic.retrieve.search:

Chercher les sous-arbres d'un noeud
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.basic.add:

Ajouter un nouveau noeud à LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.basic.delete:

Supprimer un noeud de LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.basic.update:

Mettre à jour un noeud de LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.extended:

Opérations avancées
-------------------

.. _zend.ldap.node.extended.copy-and-move:

Copier et déplacer des noeuds dans LDAP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



.. _zend.ldap.node.traversal:

Parcours d'un arbre
-------------------

.. rubric:: Parcours récursif d'un arbre LDAP

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


