.. _zend.navigation.quick-start:

Quick Start
===========

The fastest way to get up and running with ``Zend\Navigation`` is by the **navigation** key in your service manager
configuration and the navigation factory will handle the rest for you. After setting up the configuration simply use
the key name with the ``Zend\Navigation`` view helper to output the container.

.. code-block:: php
   :linenos:

    <?php
    // your configuration file, e.g. config/autoload/global.php
    return [
        // ...

        'navigation' => [
            'default' => [
                [
                    'label' => 'Home',
                    'route' => 'home',
                ],
                [
                    'label' => 'Page #1',
                    'route' => 'page-1',
                    'pages' => [
                        [
                            'label' => 'Child #1',
                            'route' => 'page-1-child',
                        ],
                    ],
                ],
                [
                    'label' => 'Page #2',
                    'route' => 'page-2',
                ],
            ],
        ],
        'service_manager' => [
            'factories' => [
                'navigation' => 'Zend\Navigation\Service\DefaultNavigationFactory',
            ],
        ],
        // ...
    ];

.. code-block:: html+php
   :linenos:

    <!-- in your layout -->
    <!-- ... -->

    <body>
        <?php echo $this->navigation('navigation')->menu(); ?>
    </body>
    <!-- ... -->

Using multiple navigations
--------------------------

If you want to use more than one navigation, you can register the abstract factory
``\Zend\Navigation\Service\NavigationAbstractServiceFactory`` in the :ref:`service manager <zend.service-manager.quick-start>`.

Once the service factory is registered, you can create as many navigation definitions as you wish,
and the factory will create navigation containers automatically. This factory can also be used for
the ``default`` container.

.. code-block:: php
   :linenos:

   <?php
   // your configuration file, e.g. config/autoload/global.php
   return [
       // ...

       'navigation' => [

           // navigation with name default
           'default' => [
               [
                   'label' => 'Home',
                   'route' => 'home',
               ],
               [
                   'label' => 'Page #1',
                   'route' => 'page-1',
                   'pages' => [
                       [
                           'label' => 'Child #1',
                           'route' => 'page-1-child',
                       ],
                   ],
               ],
               [
                   'label' => 'Page #2',
                   'route' => 'page-2',
               ],
           ],

           // navigation with name special
           'special' => [
               [
                   'label' => 'Special',
                   'route' => 'special',
               ],
               [
                   'label' => 'Special Page #2',
                   'route' => 'special-2',
               ],
           ],

           // navigation with name sitemap
           'sitemap' => [
               [
                   'label' => 'Sitemap',
                   'route' => 'sitemap',
               ],
               [
                   'label' => 'Sitemap Page #2',
                   'route' => 'sitemap-2',
               ],
           ],
       ],
       'service_manager' => [
           'abstract_factories' => [
               'Zend\Navigation\Service\NavigationAbstractServiceFactory'
           ],
       ],
       // ...
   ];


.. note::

    There is one important point if you use the ``NavigationAbstractServiceFactory``: The name of
    the service in your view must start with ``Zend\Navigation\`` followed by the name of the
    configuration key. This helps ensure that no naming collisions occur with other services.

The following example demonstrates rendering the navigation menus for the named ``default``,
``special`` and ``sitemap`` containers.

.. code-block:: html+php
   :linenos:

   <!-- in your layout -->
   <!-- ... -->

   <body>
       <?php echo $this->navigation('Zend\Navigation\Default')->menu(); ?>

       <?php echo $this->navigation('Zend\Navigation\Special')->menu(); ?>

       <?php echo $this->navigation('Zend\Navigation\Sitemap')->menu(); ?>
   </body>
   <!-- ... -->
