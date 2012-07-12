
Introduction
============

``Zend\Config`` is designed to simplify the access to, and the use of, configuration data within applications. It provides a nested object property based user interface for accessing this configuration data within application code. The configuration data may come from a variety of media supporting hierarchical data storage. Currently ``Zend\Config`` provides adapters for read and write configuration data that are stored in Ini or XML files.

As illustrated in the example above, ``Zend\Config\Config`` provides nested object property syntax to access configuration data passed to its constructor.

Along with the object oriented access to the data values, ``Zend\Config\Config`` also has ``get()`` which will return the supplied default value if the data element doesn't exist. For example:

.. code-block:: php
    :linenos:
    
    $host = $config->database->get('host', 'localhost');
    


