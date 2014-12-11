.. _zend.ldap.tools:

Tools
=====

.. _zend.ldap.tools.dn:

Creation and modification of DN strings
---------------------------------------



.. _zend.ldap.tools.filter:

Using the filter API to create search filters
---------------------------------------------

.. rubric:: Create simple LDAP filters

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

.. rubric:: Create more complex LDAP filters

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

Modify LDAP entries using the Attribute API
-------------------------------------------




