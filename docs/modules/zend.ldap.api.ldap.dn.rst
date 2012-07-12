
Zend\\Ldap\\Dn
==============

``Zend\Ldap\Dn`` provides an object-oriented interface to manipulating *LDAP* distinguished names (DN). The parameter ``$caseFold`` that is used in several methods determines the way DN attributes are handled regarding their case. Allowed values for this parameter are:

The default case-folding is ``Zend\Ldap\Dn::ATTR_CASEFOLD_NONE`` and can be set with ``Zend\Ldap\Dn::setDefaultCaseFold()`` . Each instance of ``Zend\Ldap\Dn`` can have its own case-folding-setting. If the ``$caseFold`` parameter is omitted in method-calls it defaults to the instance's case-folding setting.

The class implementsArrayAccessto allow indexer-access to the different parts of the DN. TheArrayAccess-methods proxy to ``Zend\Ldap\Dn::get($offset, 1, null)`` foroffsetGet(integer $offset), to ``Zend\Ldap\Dn::set($offset, $value)`` for ``offsetSet()`` and to ``Zend\Ldap\Dn::remove($offset, 1)`` for ``offsetUnset()`` . ``offsetExists()`` simply checks if the index is within the bounds.


