.. _zend.feed.custom-feed:

独自のフィードクラスおよびエントリクラス
====================

独自のフォーマットを提供したい、
あるいは要素が自動的に所定の名前空間に配置されるなどの素敵な機能を追加したい、
といった場合は ``Zend_Feed`` クラスを拡張して対応します。

以下に Atom エントリクラスを拡張する例を示します。
このクラスでは、独自の名前空間 **myns:** を使用しています。 また、
``registerNamespace()`` がコールされていることに注意しましょう。
このクラスの使用者は、名前空間について心配する必要がなくなります。

.. _zend.feed.custom-feed.example.extending:

.. rubric:: 独自の名前空間を使用しての Atom エントリクラスの拡張

.. code-block:: php
   :linenos:

   /**
    * この独自エントリクラスは、自動的にフィード URI を識別 (オプション) して
    * 名前空間を追加します
    */
   class MyEntry extends Zend_Feed_Entry_Atom
   {

       public function __construct($uri = 'http://www.example.com/myfeed/',
                                   $xml = null)
       {
           parent::__construct($uri, $xml);

           Zend_Feed::registerNamespace('myns',
                                        'http://www.example.com/myns/1.0');
       }

       public function __get($var)
       {
           switch ($var) {
               case 'myUpdated':
                   // myUpdated を myns:updated に変換します
                   return parent::__get('myns:updated');

               default:
                   return parent::__get($var);
               }
       }

       public function __set($var, $value)
       {
           switch ($var) {
               case 'myUpdated':
                   // myUpdated を myns:updated に変換します
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
                   // myUpdated を myns:updated に変換します
                   return parent::__call('myns:updated', $unused);

               default:
                   return parent::__call($var, $unused);
           }
       }
   }

そしてこのクラスを使用すると、インスタンスを作成したらすぐに ``myUpdated``
プロパティを設定できます。

.. code-block:: php
   :linenos:

   $entry = new MyEntry();
   $entry->myUpdated = '2005-04-19T15:30';

   // メソッド型のコールは __call 関数が処理します
   $entry->myUpdated();
   // プロパティ型のコールは __get 関数が処理します
   $entry->myUpdated;


