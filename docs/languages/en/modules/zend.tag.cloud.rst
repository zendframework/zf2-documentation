.. _zend.tag.cloud:

Creating tag clouds with Zend\\Tag\\Cloud
==============

``Zend\Tag\Cloud`` is the rendering part of ``Zend\Tag``. By default it comes with a set of *HTML* decorators,
which allow you to create tag clouds for a website, but also supplies you with two abstract classes to create your
own decorators, to create tag clouds in *PDF* documents for example.

You can instantiate and configure ``Zend\Tag\Cloud`` either programatically or completely via an array or an
instance of ``Zend\Config\Config``. The available options are:

- ``cloudDecorator``: defines the decorator for the cloud. Can either be the name of the class which should be
  loaded by the pluginloader, an instance of ``Zend\Tag\Cloud\Decorator\Cloud`` or an array containing the string
  'decorator' and optionally an array 'options', which will be passed to the decorators constructor.

- ``tagDecorator``: defines the decorator for individual tags. This can either be the name of the class which
  should be loaded by the pluginloader, an instance of ``Zend\Tag\Cloud\Decorator\Tag`` or an array containing the
  string 'decorator' and optionally an array 'options', which will be passed to the decorators constructor.

- ``pluginDecoratorManager``: a different plugin manager to use. Must be an instance of
  ``Zend\ServiceManager\AbstractPluginManager``.

- ``itemList``: a different item list to use. Must be an instance of ``Zend\Tag\ItemList``.

- ``tags``: a list of tags to assign to the cloud. Each tag must either implement ``Zend\Tag\TaggableInterface`` or be an
  array which can be used to instantiate ``Zend\Tag\Item``.

.. _zend.tag.cloud.example.using:

.. rubric:: Using Zend\\Tag\\Cloud

This example illustrates a basic example of how to create a tag cloud, add multiple tags to it and finally render
it.

.. code-block:: php
   :linenos:

   // Create the cloud and assign static tags to it
   $cloud = new Zend\Tag\Cloud(array(
       'tags' => array(
           array('title' => 'Code', 'weight' => 50,
                 'params' => array('url' => '/tag/code')),
           array('title' => 'Zend Framework', 'weight' => 1,
                 'params' => array('url' => '/tag/zend-framework')),
           array('title' => 'PHP', 'weight' => 5,
                 'params' => array('url' => '/tag/php')),
       )
   ));

   // Render the cloud
   echo $cloud;

This will output the tag cloud with the three tags, spread with the default font-sizes.

The following example shows how create a tag cloud from a ``Zend\Config\Config`` object.

.. code-block:: ini
    :linenos:

    # An example tags.ini file
    tags.1.title = "Code"
    tags.1.weight = 50
    tags.1.params.url = "/tag/code"
    tags.2.title = "Zend Framework"
    tags.2.weight = 1
    tags.2.params.url = "/tag/zend-framework"
    tags.3.title = "PHP"
    tags.3.weight = 2
    tags.3.params.url = "/tag/php"

.. code-block:: php
    :linenos:

    // Create the cloud from a Zend\Config\Config object
    $config = Zend\Config\Factory::fromFile('tags.ini');
    $cloud = new Zend\Tag\Cloud($config);

    // Render the cloud
    echo $cloud;

.. _zend.tag.cloud.decorators:

Decorators
----------

``Zend\Tag\Cloud`` requires two types of decorators to be able to render a tag cloud. This includes a decorator
which renders the single tags as well as a decorator which renders the surounding cloud. ``Zend\Tag\Cloud`` ships a
default decorator set for formatting a tag cloud in *HTML*. This set will by default create a tag cloud as
ul/li-list, spread with different font-sizes according to the weight values of the tags assigned to them.

.. _zend.tag.cloud.decorators.htmltag:

HTML Tag decorator
^^^^^^^^^^^^^^^^^^

The *HTML* tag decorator will by default render every tag in an anchor element, surounded by a li element. The
anchor itself is fixed and cannot be changed, but the surounding element(s) can.

.. note::

   **URL parameter**

   As the *HTML* tag decorator always surounds the tag title with an anchor, you should define an *URL* parameter
   for every tag used in it.

The tag decorator can either spread different font-sizes over the anchors or a defined list of classnames. When
setting options for one of those possibilities, the corespondening one will automatically be enabled. The following
configuration options are available:

- ``fontSizeUnit``: defines the font-size unit used for all font-sizes. The possible values are: em, ex, px, in,
  cm, mm, pt, pc and %. Default value is px.

- ``minFontSize``: the minimum font-size distributed through the tags (must be an integer). Default value is 10.

- ``maxFontSize``: the maximum font-size distributed through the tags (must be an integer). Default value is 20.

- ``classList``: an arry of classes distributed through the tags.

- ``htmlTags``: an array of *HTML* tags surounding the anchor. Each element can either be a string, which is used
  as element type then, or an array containing an attribute list for the element, defined as key/value pair. In
  this case, the array key is used as element type.

The following example shows how to create a tag cloud with a customized *HTML* tag decorator.

.. code-block:: php
    :linenos:

    $cloud = new Zend\Tag\Cloud(array(
        'tagDecorator' => array(
            'decorator' => 'htmltag',
            'options' => array(
                'minFontSize' => '20',
                'maxFontSize' => '50',
                'htmlTags' => array(
                    'li' => array('class' => 'my_custom_class')
                )
            )
        ),
        'tags' => array(
           array('title' => 'Code', 'weight' => 50,
                 'params' => array('url' => '/tag/code')),
           array('title' => 'Zend Framework', 'weight' => 1,
                 'params' => array('url' => '/tag/zend-framework')),
           array('title' => 'PHP', 'weight' => 5,
                 'params' => array('url' => '/tag/php')),
       )
    ));

    // Render the cloud
    echo $cloud;

.. _zend.tag.cloud.decorators.htmlcloud:

HTML Cloud decorator
^^^^^^^^^^^^^^^^^^^^

The *HTML* cloud decorator will suround the *HTML* tags with an ul-element by default and add no separation. Like
in the tag decorator, you can define multiple surounding *HTML* tags and additionally define a separator. The
available options are:

- ``separator``: defines the separator which is placed between all tags.

- ``htmlTags``: an array of *HTML* tags surounding all tags. Each element can either be a string, which is used as
  element type then, or an array containing an attribute list for the element, defined as key/value pair. In this
  case, the array key is used as element type.


