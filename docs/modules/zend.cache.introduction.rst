
Introduction
============

``Zend_Cache`` provides a generic way to cache any data.

Caching in Zend Framework is operated by frontends while cache records are stored through backend adapters (File,Sqlite,Memcache...) through a flexible system of IDs and tags. Using those, it is easy to delete specific types of records afterwards (for example: "delete all cache records marked with a given tag").

The core of the module ( ``Zend_Cache_Core`` ) is generic, flexible and configurable. Yet, for your specific needs there are cache frontends that extend ``Zend_Cache_Core`` for convenience:Output,File,FunctionandClass.

.. note::
    **Frontends and Backends Consisting of Multiple Words**

    Some frontends and backends are named using multiple words, such as 'ZendPlatform'. When specifying them to the factory, separate them using a word separator, such as a space (' '), hyphen ('-'), or period ('.').

.. note::
    ****

    When using ``Zend_Cache`` , pay attention to the important cache identifier (passed to ``save()`` and ``start()`` ). It must be unique for every resource you cache, otherwise unrelated cache records may wipe each other or, even worse, be displayed in place of the other.


