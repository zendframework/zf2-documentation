
.. _zend.serializer.adapter:

Zend_Serializer_Adapter
=======================

``Zend_Serializer`` adapters create a bridge for different methods of serializing with very little effort.

Every adapter has different pros and cons. In some cases, not every *PHP* datatype (e.g., objects) can be converted to a string representation. In most such cases, the type will be converted to a similar type that is serializable -- as an example, *PHP* objects will often be cast to arrays. If this fails, a ``Zend_Serializer_Exception`` will be thrown.

Below is a list of available adapters.


.. _zend.serializer.adapter.phpserialize:

Zend_Serializer_Adapter_PhpSerialize
------------------------------------

This adapter uses the built-in ``un/serialize`` *PHP* functions, and is a good default adapter choice.

There are no configurable options for this adapter.


.. _zend.serializer.adapter.igbinary:

Zend_Serializer_Adapter_IgBinary
--------------------------------

`Igbinary`_ is Open Source Software released by Sulake Dynamoid Oy. It's a drop-in replacement for the standard *PHP* serializer. Instead of time and space consuming textual representation, igbinary stores *PHP* data structures in a compact binary form. Savings are significant when using memcached or similar memory based storages for serialized data.

You need the igbinary *PHP* extension installed on your system in order to use this adapter.

There adapter takes no configuration options.


.. _zend.serializer.adapter.wddx:

Zend_Serializer_Adapter_Wddx
----------------------------

`WDDX`_ (Web Distributed Data eXchange) is a programming-language-, platform-, and transport-neutral data interchange mechanism for passing data between different environments and different computers.

The adapter simply uses the `wddx_*()`_ *PHP* functions. Please read the *PHP* manual to determine how you may enable them in your *PHP* installation.

Additionally, the `SimpleXML`_ *PHP* extension is used to check if a returned ``NULL`` value from ``wddx_unserialize()`` is based on a serialized ``NULL`` or on invalid data.

Available options include:


.. _zend.serializer.adapter.wddx.table.options:

.. table:: Zend_Serializer_Adapter_Wddx Options

   +-------+---------+-------------+------------------------------------------------------+
   |Option |Data Type|Default Value|Description                                           |
   +=======+=========+=============+======================================================+
   |comment|string   |             |An optional comment that appears in the packet header.|
   +-------+---------+-------------+------------------------------------------------------+



.. _zend.serializer.adapter.json:

Zend_Serializer_Adapter_Json
----------------------------

The *JSON* adapter provides a bridge to the ``Zend_Json`` component and/or ext/json. Please read the :ref:`Zend_Json documentation <zend.json.introduction>` for further information.

Available options include:


.. _zend.serializer.adapter.json.table.options:

.. table:: Zend_Serializer_Adapter_Json Options

   +--------------------+-----------------+---------------------+----------------+
   |Option              |Data Type        |Default Value        |Description     |
   +====================+=================+=====================+================+
   |cycleCheck          |boolean          |false                |See this section|
   +--------------------+-----------------+---------------------+----------------+
   |objectDecodeType    |Zend_Json::TYPE_*|Zend_Json::TYPE_ARRAY|See this section|
   +--------------------+-----------------+---------------------+----------------+
   |enableJsonExprFinder|boolean          |false                |See this section|
   +--------------------+-----------------+---------------------+----------------+



.. _zend.serializer.adapter.amf03:

Zend_Serializer_Adapter_Amf 0 and 3
-----------------------------------

The *AMF* adapters, ``Zend_Serializer_Adapter_Amf0`` and ``Zend_Serializer_Adapter_Amf3``, provide a bridge to the serializer of the ``Zend_Amf`` component. Please read the :ref:`Zend_Amf documentation <zend.amf.introduction>` for further information.

There are no options for these adapters.


.. _zend.serializer.adapter.pythonpickle:

Zend_Serializer_Adapter_PythonPickle
------------------------------------

This adapter converts *PHP* types to a `Python Pickle`_ string representation. With it, you can read the serialized data with Python and read Pickled data of Python with *PHP*.

Available options include:


.. _zend.serializer.adapter.pythonpickle.table.options:

.. table:: Zend_Serializer_Adapter_PythonPickle Options

   +--------+-----------------------+-------------+---------------------------------------------+
   |Option  |Data Type              |Default Value|Description                                  |
   +========+=======================+=============+=============================================+
   |protocol|integer (0 | 1 | 2 | 3)|0            |The Pickle protocol version used on serialize|
   +--------+-----------------------+-------------+---------------------------------------------+


Datatype merging (PHP to Python) occurs as follows:


.. _zend.serializer.adapter.pythonpickle.table.php2python:

.. table:: Datatype merging (PHP to Python)

   +-----------------+-----------+
   |PHP Type         |Python Type|
   +=================+===========+
   |NULL             |None       |
   +-----------------+-----------+
   |boolean          |boolean    |
   +-----------------+-----------+
   |integer          |integer    |
   +-----------------+-----------+
   |float            |float      |
   +-----------------+-----------+
   |string           |string     |
   +-----------------+-----------+
   |array            |list       |
   +-----------------+-----------+
   |associative array|dictionary |
   +-----------------+-----------+
   |object           |dictionary |
   +-----------------+-----------+


Datatype merging (Python to *PHP*) occurs per the following:


.. _zend.serializer.adapter.pythonpickle.table.python2php:

.. table:: Datatype merging (Python to PHP)

   +---------------+----------------------------------------------------+
   |Python-Type    |PHP-Type                                            |
   +===============+====================================================+
   |None           |NULL                                                |
   +---------------+----------------------------------------------------+
   |boolean        |boolean                                             |
   +---------------+----------------------------------------------------+
   |integer        |integer                                             |
   +---------------+----------------------------------------------------+
   |long           |integer | float | string | Zend_Serializer_Exception|
   +---------------+----------------------------------------------------+
   |float          |float                                               |
   +---------------+----------------------------------------------------+
   |string         |string                                              |
   +---------------+----------------------------------------------------+
   |bytes          |string                                              |
   +---------------+----------------------------------------------------+
   |Unicode string |UTF-8 string                                        |
   +---------------+----------------------------------------------------+
   |list           |array                                               |
   +---------------+----------------------------------------------------+
   |tuple          |array                                               |
   +---------------+----------------------------------------------------+
   |dictionary     |associative array                                   |
   +---------------+----------------------------------------------------+
   |All other types|Zend_Serializer_Exception                           |
   +---------------+----------------------------------------------------+



.. _zend.serializer.adapter.phpcode:

Zend_Serializer_Adapter_PhpCode
-------------------------------

This adapter generates a parsable *PHP* code representation using `var_export()`_. On restoring, the data will be executed using `eval`_.

There are no configuration options for this adapter.

.. warning::
   **Unserializing objects**

   Objects will be serialized using the `\__set_state`_ magic method. If the class doesn't implement this method, a fatal error will occur during execution.


.. warning::
   **Uses eval()**

   The ``PhpCode`` adapter utilizes ``eval()`` to unserialize. This introduces both a performance and potential security issue as a new process will be executed. Typically, you should use the ``PhpSerialize`` adapter unless you require human-readability of the serialized data.




.. _`Igbinary`: http://opensource.dynamoid.com
.. _`WDDX`: http://wikipedia.org/wiki/WDDX
.. _`wddx_*()`: http://php.net/manual/book.wddx.php
.. _`SimpleXML`: http://php.net/manual/book.simplexml.php
.. _`Python Pickle`: http://docs.python.org/library/pickle.html
.. _`var_export()`: http://php.net/manual/function.var-export.php
.. _`eval`: http://php.net/manual/function.eval.php
.. _`\__set_state`: http://php.net/manual/language.oop5.magic.php#language.oop5.magic.set-state
