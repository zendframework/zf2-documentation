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
    return array(
        // ...

        'navigation' => array(
            'default' => array(
                array(
                    'label' => 'Home',
                    'route' => 'home',
                ),
                array(
                    'label' => 'Page #1',
                    'route' => 'page-1',
                    'pages' => array(
                        array(
                            'label' => 'Child #1',
                            'route' => 'page-1-child',
                        ),
                    ),
                ),
                array(
                    'label' => 'Page #2',
                    'route' => 'page-2',
                ),
            ),
        ),
        'service_manager' => array(
            'factories' => array(
                'navigation' => 'Zend\Navigation\Service\DefaultNavigationFactory',
            ),
        ),
        // ...
    );

.. code-block:: html
   :linenos:

    <!-- in your layout -->
    <!-- ... -->

    <body>
        <?php echo $this->navigation('navigation')->menu(); ?>
    </body>
    <!-- ... -->

Navigation Abstract Service Factory
-----------------------------------
If you want to use more than one navigation you can register the abstract factory
``\Zend\Navigation\Service\NavigationAbstractServiceFactory`` in the :ref:`service manager <zend.service-manager.quick-start>`.

Once, the service factory is registered, you can create as many navigation as you wish and this factory creates
the navigation container automatically. This factory can also be used for ``default``.

.. code-block:: php
   :linenos:

        <?php
        // your configuration file, e.g. config/autoload/global.php
        return array(
            // ...

            'navigation' => array(
                'special' => array(
                    array(
                        'label' => 'Special',
                        'route' => 'special',
                    ),
                    array(
                        'label' => 'Special Page #1',
                        'route' => 'page-1',
                        'pages' => array(
                            array(
                                'label' => 'Special Child #1',
                                'route' => 'page-1-child',
                            ),
                        ),
                    ),
                    array(
                        'label' => 'Special Page #2',
                        'route' => 'page-2',
                    ),
                ),
            ),
            'service_manager' => array(
                'abstract_factories' => array(
                    'Zend\Navigation\Service\NavigationAbstractServiceFactory'
                ),
            ),
            // ...
        );

There is one important point if you use the ``NavigationAbstractServiceFactory``. The name of the service in your
view must start with ``Zend\Navigation\`` followed by the name of the configuration key.

.. code-block:: html
   :linenos:

        <!-- in your layout -->
        <!-- ... -->

        <body>
            <?php echo $this->navigation('Zend\Navigation\Special')->menu(); ?>
        </body>
        <!-- ... -->
