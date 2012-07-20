.. _zend.markup.renderers:

Zend_Markup レンダラー
=================

``Zend_Markup`` には現在ひとつのレンダラー、 *HTML* レンダラーが同梱されています。

.. _zend.markup.renderers.add:

自作のタグの追加
--------

自作のタグを追加することによって、 ``Zend_Markup`` レンダラーに
自作の機能の追加できます。 タグ構造とともに、
あなたが望むいかなる機能も追加ができます。 簡潔なタグから複雑なタグ構造まで。
'foo' タグでの単純な例:

.. code-block:: php
   :linenos:

   // Zend_Markup_Parser_BbCode をパーサーとして、
   // Zend_Markup_Renderer_Html のインスタンスを生成します。
   $bbcode = Zend_Markup::factory('Bbcode');

   // これは単純な 'foo' タグが作成されるでしょう
   // 第一引数は自身のタグ名を定義します。
   // 第二引数はタグの定数で定義された整数を引数に取ります。
   // 第三引数は、タグについて、タググループと(この例では)開始ならびに終了タグのように
   // 他のことを配列にて定義します。
   $bbcode->addTag(
       'foo',
       Zend_Markup_Renderer_RendererAbstract::TYPE_REPLACE,
       array(
           'start' => '-bar-',
           'end'   => '-baz-',
           'group' => 'inline'
       )
   );

   // これは 'my -bar-tag-baz-' と出力されるでしょう。
   echo $bbcode->render('my [foo]tag[/foo]');

あなたの作成したタグは、あなたのパーサーがタグ構造もサポートするときに
機能することに注意してください。現在、 BBCode はこれをサポートします。 Textile
はカスタムタグをサポートしません。

Some renderers (like the HTML renderer) also have support for a 'tag' parameter. This replaces the 'start' and
'end' parameters, and it renders the tags including some default attributes and the closing tag.

.. _zend.markup.renderers.add.callback:

Add a callback tag
^^^^^^^^^^^^^^^^^^

By adding a callback tag, you can do a lot more then just a simple replace of the tags. For instance, you can
change the contents, use the parameters to influence the output etc.

A callback is a class that implements the ``Zend_Markup_Renderer_TokenInterface`` interface. An example of a
callback class:

.. code-block:: php
   :linenos:

   class My_Markup_Renderer_Html_Upper extends Zend_Markup_Renderer_TokenConverterInterface
   {

       public function convert(Zend_Markup_Token $token, $text)
       {
           return '!up!' . strtoupper($text) . '!up!';
       }

   }

Now you can add the 'upper' tag, with as callback, an instance of the ``My_Markup_Renderer_Html_Upper`` class. A
simple example:

.. code-block:: php
   :linenos:

   // Creates instance of Zend_Markup_Renderer_Html,
   // with Zend_Markup_Parser_BbCode as its parser
   $bbcode = Zend_Markup::factory('Bbcode');

   // this will create a simple 'foo' tag
   // The first parameter defines the tag's name.
   // The second parameter takes an integer that defines the tags type.
   // The third parameter is an array that defines other things about a
   // tag, like the tag's group, and (in this case) a start and end tag.
   $bbcode->addTag(
       'upper',
       Zend_Markup_Renderer_RendererAbstract::TYPE_CALLBACK,
       array(
           'callback' => new My_Markup_Renderer_Html_Upper(),
           'group'    => 'inline'
       )
   );

   // now, this will output: 'my !up!TAG!up!'
   echo $bbcode->render('my [upper]tag[/upper]');

.. _zend.markup.renderers.list:

タグ一覧
----

.. _zend.markup.renderers.list.tags:

.. table:: タグ一覧

   +--------------------------------------------------------+---------------------------------------------------------+
   |入力例 (bbcode)                                            |出力例                                                      |
   +========================================================+=========================================================+
   |[b]foo[/b]                                              |<strong>foo</strong>                                     |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[i]foo[/i]                                              |<em>foo</em>                                             |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[cite]foo[/cite]                                        |<cite>foo</cite>                                         |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[del]foo[/del]                                          |<del>foo</del>                                           |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[ins]foo[/ins]                                          |<ins>foo</ins>                                           |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[sup]foo[/sup]                                          |<sup>foo</sup>                                           |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[sub]foo[/sub]                                          |<sub>foo</sub>                                           |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[span]foo[/span]                                        |<span>foo</span>                                         |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[acronym title="PHP Hypertext Preprocessor]PHP[/acronym]|<acronym title="PHP Hypertext Preprocessor">PHP</acronym>|
   +--------------------------------------------------------+---------------------------------------------------------+
   |[url=http://framework.zend.com/]Zend Framework[/url]    |<a href="http://framework.zend.com/">Zend Framework</a>  |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[h1]foobar[/h1]                                         |<h1>foobar</h1>                                          |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[img]http://framework.zend.com/images/logo.gif[/img]    |<img src="http://framework.zend.com/images/logo.gif" />  |
   +--------------------------------------------------------+---------------------------------------------------------+


