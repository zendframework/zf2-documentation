.. _zend.json.objects:

JSON 对象
===========

当编码PHP对象为JSON时, 它的所有的公有属性将被编码为JSON格式（到JSON对象中）.

JSON 不允许 object references，所以注意不要带递归 references 解码对象（ objects）。
如果递归有问题， *Zend_Json::encode()* 和 *Zend_Json_Encoder::encode()*
允许一个可选的第二个参数来检查递归；如果对象被系列化两次就抛出异常。

解码JSON对象貌似有一点轻微的难度， 因为Javascript对象与PHP的联合数组的结构更相近。
尽管如此，
一些人建议应该传入一个类的定义，然后类的实例应该由JSON的key/value对来被建造和组装；
另外有人这样做会引发一些安全问题。

默认情况下， *Zend_Json*
将解码JSON对象作为关联数组。但是如果你希望它返回一个对象， 以可以这样来指定：

.. code-block::
   :linenos:

   // 解码 JSON 对象作为 PHP 对象
   $phpNative = Zend_Json::decode($encodedValue, Zend_Json::TYPE_OBJECT);


这样任何解码后的对象将被作为一个 *StdClass*\
的对象来返回，对象带有根据JSON对象的key/value对生成的一系列属性。

Zend Framework推荐每个开发者应该决定怎样来解码JSON对象。
如果一个特定类型的对象需要被构建，它可以由开发者的代码创建，然后用 *Zend_Json*
解码后的值来组装。


