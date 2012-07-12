
Custom Feed and Entry Classes
=============================

Finally, you can extend the ``Zend_Feed`` classes if you'd like to provide your own format or niceties like automatic handling of elements that should go into a custom namespace.

Here is an example of a custom Atom entry class that handles its ownmyns:namespace entries. Note that it also makes the ``registerNamespace()`` call for you, so the end user doesn't need to worry about namespaces at all.


