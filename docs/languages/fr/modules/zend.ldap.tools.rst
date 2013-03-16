.. EN-Revision: none
.. _zend.ldap.tools:

Outils
======

.. _zend.ldap.tools.dn:

Création et modification de chaînes DN
--------------------------------------



.. _zend.ldap.tools.filter:

Utilisation de l'API des filtres pour créer des filtres de recherche
--------------------------------------------------------------------

.. rubric:: Création de filtres LDAP simples

.. code-block:: php
   :linenos:

   $f1  = Zend\Ldap\Filter::equals('name', 'value');         // (name=value)
   $f2  = Zend\Ldap\Filter::begins('name', 'value');         // (name=value*)
   $f3  = Zend\Ldap\Filter::ends('name', 'value');           // (name=*value)
   $f4  = Zend\Ldap\Filter::contains('name', 'value');       // (name=*value*)
   $f5  = Zend\Ldap\Filter::greater('name', 'value');        // (name>value)
   $f6  = Zend\Ldap\Filter::greaterOrEqual('name', 'value'); // (name>=value)
   $f7  = Zend\Ldap\Filter::less('name', 'value');           // (name<value)
   $f8  = Zend\Ldap\Filter::lessOrEqual('name', 'value');    // (name<=value)
   $f9  = Zend\Ldap\Filter::approx('name', 'value');         // (name~=value)
   $f10 = Zend\Ldap\Filter::any('name');                     // (name=*)

.. rubric:: Création de filtres LDAP plus complexes

.. code-block:: php
   :linenos:

   $f1 = Zend\Ldap\Filter::ends('name', 'value')->negate(); // (!(name=*value))

   $f2 = Zend\Ldap\Filter::equals('name', 'value');
   $f3 = Zend\Ldap\Filter::begins('name', 'value');
   $f4 = Zend\Ldap\Filter::ends('name', 'value');

   // (&(name=value)(name=value*)(name=*value))
   $f5 = Zend\Ldap\Filter::andFilter($f2, $f3, $f4);

   // (|(name=value)(name=value*)(name=*value))
   $f6 = Zend\Ldap\Filter::orFilter($f2, $f3, $f4);

.. _zend.ldap.tools.attribute:

Modifier les entrées LDAP en utilisant l'API Attribute
------------------------------------------------------




