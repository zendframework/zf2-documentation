.. _zend.navigation.quick-start:

Quick Start
===========

The fastest way to get up and running with ``Zend\Navigation`` is by the **navigation** key in your service manager
configuration and the navigation factory will handle the rest for you. After setting up the configuration simply use
the key name with the ``Zend\Navigation`` view helper to output the container.

.. code-block:: php
   :linenos:

    <?php
    // your configuration file, e.g., config/autoload/global.php
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
