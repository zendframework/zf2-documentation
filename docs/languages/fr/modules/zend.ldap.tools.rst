.. _zend.ldap.tools:

Outils
======

.. _zend.ldap.tools.dn:

Création et modification de chaines DN
--------------------------------------



.. _zend.ldap.tools.filter:

Utilisation de l'API des filtres pour créer des filtres de recherche
--------------------------------------------------------------------

.. rubric:: Création de filtres LDAP simples

.. code-block:: php
   :linenos:

   $f1  = Zend_Ldap_Filter::equals('name', 'value');         // (name=value)
   $f2  = Zend_Ldap_Filter::begins('name', 'value');         // (name=value*)
   $f3  = Zend_Ldap_Filter::ends('name', 'value');           // (name=*value)
   $f4  = Zend_Ldap_Filter::contains('name', 'value');       // (name=*value*)
   $f5  = Zend_Ldap_Filter::greater('name', 'value');        // (name>value)
   $f6  = Zend_Ldap_Filter::greaterOrEqual('name', 'value'); // (name>=value)
   $f7  = Zend_Ldap_Filter::less('name', 'value');           // (name<value)
   $f8  = Zend_Ldap_Filter::lessOrEqual('name', 'value');    // (name<=value)
   $f9  = Zend_Ldap_Filter::approx('name', 'value');         // (name~=value)
   $f10 = Zend_Ldap_Filter::any('name');                     // (name=*)

.. rubric:: Création de filtres LDAP plus complexes

.. code-block:: php
   :linenos:

   $f1 = Zend_Ldap_Filter::ends('name', 'value')->negate(); // (!(name=*value))

   $f2 = Zend_Ldap_Filter::equals('name', 'value');
   $f3 = Zend_Ldap_Filter::begins('name', 'value');
   $f4 = Zend_Ldap_Filter::ends('name', 'value');

   // (&(name=value)(name=value*)(name=*value))
   $f5 = Zend_Ldap_Filter::andFilter($f2, $f3, $f4);

   // (|(name=value)(name=value*)(name=*value))
   $f6 = Zend_Ldap_Filter::orFilter($f2, $f3, $f4);

.. _zend.ldap.tools.attribute:

Modifier les entrées LDAP en utilisant l'API Attribute
------------------------------------------------------




