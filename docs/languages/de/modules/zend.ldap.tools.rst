.. EN-Revision: none
.. _zend.ldap.tools:

Tools
=====

.. _zend.ldap.tools.dn:

Erstellung und Modifizierung von DN Strings
-------------------------------------------



.. _zend.ldap.tools.filter:

Verwendung der Filter API um Suchfilter zu erstellen
----------------------------------------------------

.. rubric:: Einfache LDAP Filter erstellen

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

.. rubric:: Komplexere LDAP Filter erstellen

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

LDAP Einträge modifizieren und die Attribut API verwenden
---------------------------------------------------------




