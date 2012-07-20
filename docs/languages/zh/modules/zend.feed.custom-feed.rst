.. _zend.feed.custom-feed:

自定义Feed和条目类
=========================

最后，如果你想提供一个你自己的格式或者想更自动化的定义一个命名空间那么你可以扩展继承
*Zend_Feed*\ 类。

下面是一个用自定义Atom条目类处理 *myns:*\
命名空间的例子。注意构造函数中已经为你调用了 *registerNamespace()*\
，所以最终用户就可以完全不必当心命名空间了。

.. _zend.feed.custom-feed.example.extending:

.. rubric:: 用自定义的命名空间继承Atom条目类

.. code-block::
   :linenos:
   <?php
   /**
    * 自定义的条目类自动地识别feed URI(可选)
    * 并能自动添加额外的命名空间
    */
   class MyEntry extends Zend_Feed_Entry_Atom
   {

       public function __construct($uri = 'http://www.example.com/myfeed/',
                                   $xml = null)
       {
           parent::__construct($uri, $xml);

           Zend_Feed::registerNamespace('myns', 'http://www.example.com/myns/1.0');
       }

       public function __get($var)
       {
           switch ($var) {
               case 'myUpdated':
                   // Translate myUpdated to myns:updated.
                   return parent::__get('myns:updated');

               default:
                   return parent::__get($var);
               }
       }

       public function __set($var, $value)
       {
           switch ($var) {
               case 'myUpdated':
                   // Translate myUpdated to myns:updated.
                   parent::__set('myns:updated', $value);
                   break;

               default:
                   parent::__set($var, $value);
           }
       }

       public function __call($var, $unused)
       {
           switch ($var) {
               case 'myUpdated':
                   // Translate myUpdated to myns:updated.
                   return parent::__call('myns:updated', $unused);

               default:
                   return parent::__call($var, $unused);
           }
       }
   }

接下来你就可以直接实例化和设置 *myUpdated*\ 属性来使用这个类：

.. code-block::
   :linenos:
   <?php
   $entry = new MyEntry();
   $entry->myUpdated = '2005-04-19T15:30';

   // method-style call is handled by __call function
   $entry->myUpdated();
   // property-style call is handled by __get function
   $entry->myUpdated;


