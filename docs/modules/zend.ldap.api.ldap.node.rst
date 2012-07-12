
Zend\\Ldap\\Node
================

``Zend\Ldap\Node`` includes the magic property accessors ``__set()`` , ``__get()`` , ``__unset()`` and ``__isset()`` to access the attributes by their name. They proxy to ``Zend\Ldap\Node::setAttribute()`` , ``Zend\Ldap\Node::getAttribute()`` , ``Zend\Ldap\Node::deleteAttribute()`` and ``Zend\Ldap\Node::existsAttribute()`` respectively. Furthermore the class implementsArrayAccessfor array-style-access to the attributes. ``Zend\Ldap\Node`` also implementsIteratorandRecursiveIteratorto allow for recursive tree-traversal.


