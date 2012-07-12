
Modifying Feed and Entry structures
===================================

``Zend_Feed`` 's natural syntax extends to constructing and modifying feeds and entries as well as reading them. You can easily turn your new or modified objects back into well-formed *XML* for saving to a file or sending to a server.

If you want to use a namespace other than ``atom:`` , ``rss:`` , or ``osrss:`` in your entry, you need to register the namespace with ``Zend_Feed`` using ``Zend_Feed::registerNamespace()`` . When you are modifying an existing element, it will always maintain its original namespace. When adding a new element, it will go into the default namespace if you do not explicitly specify another namespace.


