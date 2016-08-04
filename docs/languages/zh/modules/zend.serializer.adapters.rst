.. _zend.serializer.adapters:

Zend\\Serializer\\Adapter
=========================

``Zend\Serializer`` adapters create a bridge for different methods of
serializing with very little effort.

Every adapter has different pros and cons. In some cases, not every PHP_
datatype (e.g., objects) can be converted to a string representation. In most
such cases, the type will be converted to a similar type that is serializable.

As an example, PHP_ objects will often be cast to arrays. If this fails, a
``Zend\Serializer\Exception\ExceptionInterface`` will be thrown.

.. _zend.serializer.adapter.phpserialize:

The PhpSerialize Adapter
------------------------

The ``Zend\Serializer\Adapter\PhpSerialize`` adapter uses the built-in
``un/serialize`` PHP_ functions, and is a good default adapter choice.

There are no configurable options for this adapter.

.. _zend.serializer.adapter.igbinary:

The IgBinary Adapter
--------------------

`Igbinary`_ is Open Source Software released by Sulake Dynamoid Oy and since
2011-03-14 moved to PECL_ maintained by Pierre Joye. It's a drop-in replacement
for the standard PHP_ serializer. Instead of time and space consuming textual
representation, igbinary stores PHP_ data structures in a compact binary form.
Savings are significant when using memcached or similar memory based storages
for serialized data.

You need the igbinary PHP_ extension installed on your system in order to use
this adapter.

There are no configurable options for this adapter.

.. _zend.serializer.adapter.wddx:

The Wddx Adapter
----------------

`WDDX`_ (Web Distributed Data eXchange) is a programming-language-, platform-,
and transport-neutral data interchange mechanism for passing data between
different environments and different computers.

The adapter simply uses the `wddx_*()`_ PHP_ functions. Please read the PHP_
manual to determine how you may enable them in your PHP_ installation.

Additionally, the `SimpleXML`_ PHP_ extension is used to check if a returned
``NULL`` value from ``wddx_unserialize()`` is based on a serialized ``NULL``
or on invalid data.

Available options include:

.. _zend.serializer.adapter.wddx.table.options:

.. table:: Zend\Serializer\Adapter\Wddx Options

   +-------+-----------+-------------+------------------------------------------------------+
   |Option |Data Type  |Default Value|Description                                           |
   +=======+===========+=============+======================================================+
   |comment|``string`` |             |An optional comment that appears in the packet header.|
   +-------+-----------+-------------+------------------------------------------------------+

.. _zend.serializer.adapter.json:

The Json Adapter
----------------

The JSON_ adapter provides a bridge to the ``Zend\Json`` component. Please read
the :ref:`Zend\Json documentation <zend.json.introduction>` for further information.

Available options include:

.. _zend.serializer.adapter.json.table.options:

.. table:: Zend\Serializer\Adapter\Json Options

   +------------------------+---------------------------+-------------------------------+
   |Option                  |Data Type                  |Default Value                  |
   +========================+===========================+===============================+
   |cycle_check             |``boolean``                |``false``                      |
   +------------------------+---------------------------+-------------------------------+
   |object_decode_type      |``Zend\Json\Json::TYPE_*`` |``Zend\Json\Json::TYPE_ARRAY`` |
   +------------------------+---------------------------+-------------------------------+
   |enable_json_expr_finder |``boolean``                |``false``                      |
   +------------------------+---------------------------+-------------------------------+

.. _zend.serializer.adapter.pythonpickle:

The PythonPickle Adapter
------------------------

This adapter converts PHP_ types to a `Python Pickle`_ string representation.
With it, you can read the serialized data with Python and read Pickled data of
Python with PHP_.

Available options include:

.. _zend.serializer.adapter.pythonpickle.table.options:

.. table:: Zend\Serializer\Adapter\PythonPickle Options

   +--------+----------------------+--------------+---------------------------------------------+
   |Option  |Data Type             |Default Value |Description                                  |
   +========+======================+==============+=============================================+
   |protocol|``integer`` (0|1|2|3) |0             |The Pickle protocol version used on serialize|
   +--------+----------------------+--------------+---------------------------------------------+

.. _zend.serializer.adapter.pythonpickle.table.php2python:

.. table:: Datatype merging (PHP_ to `Python Pickle`_)

   +---------------+----------------------+
   |PHP_ Type      |`Python Pickle`_ Type |
   +===============+======================+
   |``NULL``       |``None``              |
   +---------------+----------------------+
   |``boolean``    |``boolean``           |
   +---------------+----------------------+
   |``integer``    |``integer``           |
   +---------------+----------------------+
   |``float``      |``float``             |
   +---------------+----------------------+
   |``string``     |``string``            |
   +---------------+----------------------+
   |``array`` list |``list``              |
   +---------------+----------------------+
   |``array`` map  |``dictionary``        |
   +---------------+----------------------+
   |``object``     |``dictionary``        |
   +---------------+----------------------+

.. _zend.serializer.adapter.pythonpickle.table.python2php:

.. table:: Datatype merging (`Python Pickle`_ to PHP_)

   +----------------------+-------------------------------------------------------------------------------------------+
   |`Python Pickle`_ Type |PHP_ Type                                                                                  |
   +======================+===========================================================================================+
   |``None``              |``NULL``                                                                                   |
   +----------------------+-------------------------------------------------------------------------------------------+
   |``boolean             |``boolean``                                                                                |
   +----------------------+-------------------------------------------------------------------------------------------+
   |``integer             |``integer``                                                                                |
   +----------------------+-------------------------------------------------------------------------------------------+
   |``long                |``integer`` or ``float`` or ``string`` or ``Zend\Serializer\Exception\ExceptionInterface`` |
   +----------------------+-------------------------------------------------------------------------------------------+
   |``float               |``float``                                                                                  |
   +----------------------+-------------------------------------------------------------------------------------------+
   |``string              |``string``                                                                                 |
   +----------------------+-------------------------------------------------------------------------------------------+
   |``bytes               |``string``                                                                                 |
   +----------------------+-------------------------------------------------------------------------------------------+
   |``unicode string``    |``string`` UTF-8                                                                           |
   +----------------------+-------------------------------------------------------------------------------------------+
   |``list``              |``array`` list                                                                             |
   +----------------------+-------------------------------------------------------------------------------------------+
   |``tuple``             |``array`` list                                                                             |
   +----------------------+-------------------------------------------------------------------------------------------+
   |``dictionary``        |``array`` map                                                                              |
   +----------------------+-------------------------------------------------------------------------------------------+
   |All other types       |``Zend\Serializer\Exception\ExceptionInterface``                                           |
   +----------------------+-------------------------------------------------------------------------------------------+

.. _zend.serializer.adapter.phpcode:

The PhpCode Adapter
-------------------

The ``Zend\Serializer\Adapter\PhpCode`` adapter generates a parsable PHP_ code
representation using `var_export()`_. On restoring, the data will be executed using
`eval`_.

There are no configuration options for this adapter.

.. warning::

   **Unserializing objects**

   Objects will be serialized using the `\__set_state`_ magic method. If the
   class doesn't implement this method, a fatal error will occur during
   execution.

.. warning::

   **Uses eval()**

   The ``PhpCode`` adapter utilizes ``eval()`` to unserialize. This introduces
   both a performance and potential security issue as a new process will be
   executed. Typically, you should use the ``PhpSerialize`` adapter unless you
   require human-readability of the serialized data.

.. _`PHP`: http://php.net
.. _`PECL`: http://pecl.php.net
.. _`JSON`: http://wikipedia.org/wiki/JavaScript_Object_Notation
.. _`Igbinary`: http://pecl.php.net/package/igbinary
.. _`WDDX`: http://wikipedia.org/wiki/WDDX
.. _`wddx_*()`: http://php.net/manual/book.wddx.php
.. _`SimpleXML`: http://php.net/manual/book.simplexml.php
.. _`Python Pickle`: http://docs.python.org/library/pickle.html
.. _`var_export()`: http://php.net/manual/function.var-export.php
.. _`eval`: http://php.net/manual/function.eval.php
.. _`\__set_state`: http://php.net/manual/language.oop5.magic.php#language.oop5.magic.set-state
