.. _zend.tag.cloud:

Creating tag clouds with Zend\\Tag\\Cloud
=========================================

``Zend\Tag\Cloud`` is the rendering part of ``Zend\Tag``. By default it comes with a set of *HTML* decorators,
which allow you to create tag clouds for a website, but also supplies you with two abstract classes to create your
own decorators, to create tag clouds in *PDF* documents for example.

You can instantiate and configure ``Zend\Tag\Cloud`` either programmatically or completely via an array or an
instance of ``Traversable``. The available options are:

.. _zend.tag.cloud.options.table:

.. table:: ``Zend\Tag\Cloud`` Options

   +--------------------------+------------------------------------------------------------------------------------------------+
   |Option                    |Description                                                                                     |
   +==========================+================================================================================================+
   |``cloudDecorator``        |Defines the decorator for the cloud. Can either be the name of the class which should be loaded |
   |                          |by the plugin manager, an instance of ``Zend\Tag\Cloud\Decorator\AbstractCloud`` or an array    |
   |                          |containing the decorator under the key ``decorator`` and optionally an array under the key      |
   |                          |``options``, which will be passed to the decorator's constructor.                               |
   +--------------------------+------------------------------------------------------------------------------------------------+
   |``tagDecorator``          |Defines the decorator for individual tags. This can either be the name of the class which       |
   |                          |should be loaded by the plugin manager, an instance of ``Zend\Tag\Cloud\Decorator\AbstractTag`` |
   |                          |or an array containing the decorator under the key ``decorator`` and optionally an array under  |
   |                          |the key ``options``, which will be passed to the decorator's constructor.                       |
   +--------------------------+------------------------------------------------------------------------------------------------+
   |``decoratorPluginManager``|A different plugin manager to use.                                                              |
   |                          |Must be an instance of ``Zend\ServiceManager\AbstractPluginManager``.                           |
   +--------------------------+------------------------------------------------------------------------------------------------+
   |``itemList``              |A different item list to use. Must be an instance of ``Zend\Tag\ItemList``.                     |
   +--------------------------+------------------------------------------------------------------------------------------------+
   |``tags``                  |A array of tags to assign to the cloud. Each tag must either implement                          |
   |                          |``Zend\Tag\TaggableInterface`` or be an array which can be used to instantiate                  |
   |                          |``Zend\Tag\Item``.                                                                              |
   +--------------------------+------------------------------------------------------------------------------------------------+


.. _zend.tag.cloud.example.using:

.. rubric:: Using Zend\\Tag\\Cloud

This example illustrates a basic example of how to create a tag cloud, add multiple tags to it and finally render
it.

.. code-block:: php
   :linenos:

   // Create the cloud and assign static tags to it
   $cloud = new Zend\Tag\Cloud(array(
       'tags' => array(
           array(
               'title'  => 'Code',
               'weight' => 50,
               'params' => array('url' => '/tag/code'),
           ),
           array(
               'title'  => 'Zend Framework',
               'weight' => 1,
               'params' => array('url' => '/tag/zend-framework'),
           ),
           array(
               'title' => 'PHP',
               'weight' => 5,
               'params' => array('url' => '/tag/php'),
           ),
       ),
   ));

   // Render the cloud
   echo $cloud;

This will output the tag cloud with the three tags, spread with the default
font-sizes:

.. code-block:: html
   :linenos:

   <ul class="zend-tag-cloud">
       <li>
           <a href="/tag/code" style="font-size: 20px;">
               Code
           </a>
       </li>
       <li>
           <a href="/tag/zend-framework" style="font-size: 10px;">
               Zend Framework
           </a>
       </li>
       <li>
           <a href="/tag/php" style="font-size: 11px;">
               PHP
           </a>
       </li>
   </ul>

.. note::

   The HTML code examples are preformatted for a better visualization in the
   documentation.

   You can define a output separator for the
   :ref:`HTML Cloud decorator<zend.tag.cloud.decorators.htmlcloud>`.

The following example shows how create the **same** tag cloud from a
``Zend\Config\Config`` object.

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
which renders the single tags as well as a decorator which renders the surrounding cloud. ``Zend\Tag\Cloud`` ships
a default decorator set for formatting a tag cloud in *HTML*. This set will, by default, create a tag cloud as
ul/li -list, spread with different font-sizes according to the weight values of the tags assigned to them.

.. _zend.tag.cloud.decorators.htmltag:

HTML Tag decorator
^^^^^^^^^^^^^^^^^^

The *HTML* tag decorator will by default render every tag in an anchor element, surrounded by a ``<li>`` element.
The anchor itself is fixed and cannot be changed, but the surrounding element(s) can.

.. note::

   **URL parameter**

   As the *HTML* tag decorator always surounds the tag title with an anchor, you should define a *URL* parameter
   for every tag used in it.

The tag decorator can either spread different font-sizes over the anchors or a defined list of classnames. When
setting options for one of those possibilities, the corresponding one will automatically be enabled. The following
configuration options are available:

.. _zend.tag.cloud.decorators.htmltag.options.table:

.. table:: HTML Tag decorator Options

   +----------------+---------------+----------------------------------------------------------------------+
   |Option          |Default        |Description                                                           |
   +================+===============+======================================================================+
   |``fontSizeUnit``|``px``         |Defines the font-size unit used for all font-sizes. The possible      |
   |                |               |values are: em, ex, px, in, cm, mm, pt, pc and %.                     |
   +----------------+---------------+----------------------------------------------------------------------+
   |``minFontSize`` |``10``         |The minimum font-size distributed through the tags (must be numeric). |
   +----------------+---------------+----------------------------------------------------------------------+
   |``maxFontSize`` |``20``         |The maximum font-size distributed through the tags (must be numeric). |
   +----------------+---------------+----------------------------------------------------------------------+
   |``classList``   |``null``       |An array of classes distributed through the tags.                     |
   +----------------+---------------+----------------------------------------------------------------------+
   |``htmlTags``    |``array('li')``|An array of *HTML* tags surrounding the anchor. Each element can      |
   |                |               |either be a string, which is used as element type, or an array        |
   |                |               |containing an attribute list for the element, defined as key/value    |
   |                |               |pair. In this case, the array key is used as element type.            |
   +----------------+---------------+----------------------------------------------------------------------+


The following example shows how to create a tag cloud with a customized *HTML* tag decorator.

.. code-block:: php
   :linenos:

    $cloud = new Zend\Tag\Cloud(array(
        'tagDecorator' => array(
            'decorator' => 'htmltag',
            'options'   => array(
                'minFontSize' => '20',
                'maxFontSize' => '50',
                'htmlTags'    => array(
                    'li' => array('class' => 'my_custom_class'),
                ),
            ),
        ),
        'tags' => array(
           array(
               'title'  => 'Code',
               'weight' => 50,
               'params' => array('url' => '/tag/code'),
           ),
           array(
               'title'  => 'Zend Framework',
               'weight' => 1,
               'params' => array('url' => '/tag/zend-framework'),
           ),
           array(
               'title'  => 'PHP',
               'weight' => 5,
               'params' => array('url' => '/tag/php')
           ),
       ),
    ));

    // Render the cloud
    echo $cloud;

The output:

.. code-block:: html
   :linenos:

   <ul class="zend-tag-cloud">
       <li class="my_custom_class">
           <a href="/tag/code" style="font-size: 50px;">Code</a>
       </li>
       <li class="my_custom_class">
           <a href="/tag/zend-framework" style="font-size: 20px;">Zend Framework</a>
       </li>
       <li class="my_custom_class">
           <a href="/tag/php" style="font-size: 23px;">PHP</a>
       </li>
   </ul>

.. _zend.tag.cloud.decorators.htmlcloud:

HTML Cloud decorator
^^^^^^^^^^^^^^^^^^^^

By default the *HTML* cloud decorator will surround the *HTML* tags with a ``<ul>`` element and add no separation.
Like in the tag decorator, you can define multiple surrounding *HTML* tags and additionally define a separator.
The available options are:

.. _zend.tag.cloud.decorators.htmlcloud.options.table:

.. table:: HTML Cloud decorator Options

   +--------------+-----------------------------------------------------+---------------------------------------------------------------------+
   |Option        |Default                                              |Description                                                          |
   +==============+=====================================================+=====================================================================+
   |``separator`` |``' '`` *(a whitespace)*                             |Defines the separator which is placed between all tags.              |
   +--------------+-----------------------------------------------------+---------------------------------------------------------------------+
   |``htmlTags``  |``array('ul' => array('class' => 'zend-tag-cloud'))``|An array of *HTML* tags surrounding all tags. Each element can either|
   |              |                                                     |be a string, which is used as element type, or an array containing an|
   |              |                                                     |attribute list for the element, defined as key/value pair. In this   |
   |              |                                                     |case, the array key is used as element type.                         |
   +--------------+-----------------------------------------------------+---------------------------------------------------------------------+

.. code-block:: php
   :linenos:

   // Create the cloud and assign static tags to it
   $cloud = new Zend\Tag\Cloud(array(
       'cloudDecorator' => array(
           'decorator' => 'htmlcloud',
           'options'   => array(
               'separator' => "\n\n",
               'htmlTags'  => array(
                   'ul' => array(
                       'class' => 'my_custom_class',
                       'id'    => 'tag-cloud',
                   ),
               ),
           ),
       ),
       'tags' => array(
           array(
               'title'  => 'Code',
               'weight' => 50,
               'params' => array('url' => '/tag/code'),
           ),
           array(
               'title'  => 'Zend Framework',
               'weight' => 1,
               'params' => array('url' => '/tag/zend-framework'),
           ),
           array(
               'title' => 'PHP',
               'weight' => 5,
               'params' => array('url' => '/tag/php'),
           ),
       ),
   ));

   // Render the cloud
   echo $cloud;

The ouput:

.. code-block:: html
   :linenos:

   <ul class="my_custom_class" id="tag-cloud"><li><a href="/tag/code" style="font-size: 20px;">Code</a></li>

   <li><a href="/tag/zend-framework" style="font-size: 10px;">Zend Framework</a></li>

   <li><a href="/tag/php" style="font-size: 11px;">PHP</a></li></ul>