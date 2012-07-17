
.. _zend.json.advanced:

Advanced Usage of Zend_Json
===========================


.. _zend.json.advanced.objects1:

JSON Objects
------------

When encoding *PHP* objects as *JSON*, all public properties of that object will be encoded in a *JSON* object.

*JSON* does not allow object references, so care should be taken not to encode objects with recursive references. If you have issues with recursion, ``Zend_Json::encode()`` and ``Zend_Json_Encoder::encode()`` allow an optional second parameter to check for recursion; if an object is serialized twice, an exception will be thrown.

Decoding *JSON* objects poses an additional difficulty, however, since Javascript objects correspond most closely to *PHP*'s associative array. Some suggest that a class identifier should be passed, and an object instance of that class should be created and populated with the key/value pairs of the *JSON* object; others feel this could pose a substantial security risk.

By default, ``Zend_Json`` will decode *JSON* objects as associative arrays. However, if you desire an object returned, you can specify this:

.. code-block:: php
   :linenos:

   // Decode JSON objects as PHP objects
   $phpNative = Zend_Json::decode($encodedValue, Zend_Json::TYPE_OBJECT);

Any objects thus decoded are returned as ``StdClass`` objects with properties corresponding to the key/value pairs in the *JSON* notation.

The recommendation of Zend Framework is that the individual developer should decide how to decode *JSON* objects. If an object of a specified type should be created, it can be created in the developer code and populated with the values decoded using ``Zend_Json``.


.. _zend.json.advanced.objects2:

Encoding PHP objects
--------------------

If you are encoding *PHP* objects by default the encoding mechanism can only access public properties of these objects. When a method ``toJson()`` is implemented on an object to encode, ``Zend_Json`` calls this method and expects the object to return a *JSON* representation of its internal state.


.. _zend.json.advanced.internal:

Internal Encoder/Decoder
------------------------

``Zend_Json`` has two different modes depending if ext/json is enabled in your *PHP* installation or not. If ext/json is installed by default ``json_encode()`` and ``json_decode()`` functions are used for encoding and decoding *JSON*. If ext/json is not installed a Zend Framework implementation in *PHP* code is used for en-/decoding. This is considerably slower than using the *PHP* extension, but behaves exactly the same.

Still sometimes you might want to use the internal encoder/decoder even if you have ext/json installed. You can achieve this by calling:

.. code-block:: php
   :linenos:

   Zend_Json::$useBuiltinEncoderDecoder = true:


.. _zend.json.advanced.expr:

JSON Expressions
----------------

Javascript makes heavy use of anonymnous function callbacks, which can be saved within *JSON* object variables. Still they only work if not returned inside double qoutes, which ``Zend_Json`` naturally does. With the Expression support for ``Zend_Json`` support you can encode *JSON* objects with valid javascript callbacks. This works for both ``json_encode()`` or the internal encoder.

A javascript callback is represented using the ``Zend_Json_Expr`` object. It implements the value object pattern and is immutable. You can set the javascript expression as the first constructor argument. By default ``Zend_Json::encode`` does not encode javascript callbacks, you have to pass the option ``enableJsonExprFinder`` and set it to ``TRUE`` into the ``encode`` function. If enabled the expression support works for all nested expressions in large object structures. A usage example would look like:

.. code-block:: php
   :linenos:

   $data = array(
       'onClick' => new Zend_Json_Expr('function() {'
                 . 'alert("I am a valid javascript callback '
                 . 'created by Zend_Json"); }'),
       'other' => 'no expression',
   );
   $jsonObjectWithExpression = Zend_Json::encode(
       $data,
       false,
       array('enableJsonExprFinder' => true)
   );


