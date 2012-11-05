.. _zendmarkup.renderers:

ZendMarkup Renderers
=====================

``ZendMarkup`` is currently shipped with one renderer, the *HTML* renderer.

.. _zendmarkup.renderers.add:

Adding your own markups
-----------------------

By adding your own markups, you can add your own functionality to the ``ZendMarkup`` renderers. With the markup
structure, you can add about any functionality you want. From simple markups, to complicated markup structures. A
simple example for a 'foo' markup:

.. code-block:: php
   :linenos:

   // Creates instance of Zend\Markup\Renderer\Html,
   // with Zend\Markup\Parser\BbCode as its parser
   $bbcode = Zend\Markup\Markup::factory('Bbcode');

   // this will create a simple 'foo' markup
   // The first parameter defines the markup's name.
   // The second parameter takes an integer that defines the markups type.
   // The third parameter is an array that defines other things about a
   // markup, like the markup's group, and (in this case) a start and end markup.
   $bbcode->addMarkup(
       'foo',
       Zend\Markup\Renderer\RendererAbstract::TYPE_REPLACE,
       array(
           'start' => '-bar-',
           'end'   => '-baz-',
           'group' => 'inline'
       )
   );

   // now, this will output: 'my -bar-markup-baz-'
   echo $bbcode->render('my [foo]markup[/foo]');

Please note that creating your own markups only makes sense when your parser also supports it with a markup
structure. Currently, only BBCode supports this. Textile doesn't have support for custom markups.

Some renderers (like the *HTML* renderer) also have support for a 'markup' parameter. This replaces the 'start' and
'end' parameters, and it renders the markups including some default attributes and the closing markup.

.. _zendmarkup.renderers.add.callback:

Add a callback markup
^^^^^^^^^^^^^^^^^^^^^

By adding a callback markup, you can do a lot more then just a simple replace of the markups. For instance, you can
change the contents, use the parameters to influence the output etc.

A callback is a class that implements the ``Zend\Markup\Renderer\TokenInterface`` interface. An example of a
callback class:

.. code-block:: php
   :linenos:

   class My_Markup_Renderer_Html_Upper
       implements Zend\Markup\Renderer\TokenConverterInterface
   {

       public function convert(Zend\Markup\Token $token, $text)
       {
           return '!up!' . strtoupper($text) . '!up!';
       }

   }

Now you can add the 'upper' markup, with as callback, an instance of the ``My_Markup_Renderer_Html_Upper`` class. A
simple example:

.. code-block:: php
   :linenos:

   // Creates instance of Zend\Markup\Renderer\Html,
   // with Zend\Markup\Parser\BbCode as its parser
   $bbcode = Zend\Markup\Markup::factory('Bbcode');

   // this will create a simple 'foo' markup
   // The first parameter defines the markup's name.
   // The second parameter takes an integer that defines the markups type.
   // The third parameter is an array that defines other things about a
   // markup, like the markup's group, and (in this case) a start and end markup.
   $bbcode->addMarkup(
       'upper',
       Zend\Markup\Renderer\RendererAbstract::TYPE_CALLBACK,
       array(
           'callback' => new My_Markup_Renderer_Html_Upper(),
           'group'    => 'inline'
       )
   );

   // now, this will output: 'my !up!MARKUP!up!'
   echo $bbcode->render('my [upper]markup[/upper]');

.. _zendmarkup.renderers.list:

List of markups
---------------

.. _zendmarkup.renderers.list.markups:

.. table:: List of markups

   +--------------------------------------------------------+---------------------------------------------------------+
   |Sample input (bbcode)                                   |Sample output                                            |
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


