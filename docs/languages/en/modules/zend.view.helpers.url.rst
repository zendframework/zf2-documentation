.. _zend.view.helpers.initial.url:

View Helper - URL
=================

.. _zend.view.helpers.initial.url.basicusage:

Basic Usage
-----------

``url($name, $urlParams, $routeOptions, $reuseMatchedParams)``: Creates a *URL* string based on a named route.
``$urlParams`` should be an associative array of key/value pairs used by the particular route.

.. code-block:: php
   :linenos:

   // In a configuration array (e.g. returned by some module's module.config.php)
   'router' => array(
       'routes' => array(
           'auth' => array(
               'type'    => 'segment',
               'options' => array(
                   'route'       => '/auth[/:action][/:id]',
                   'constraints' => array(
                       'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                   ),
                   'defaults' => array(
                       'controller' => 'auth',
                       'action'     => 'index',
                   ),
               )
           )
       )
   ),

   // In a view script:
   <a href="<?php echo $this->url('auth', array('action' => 'logout', 'id' => 100)); ?>">Logout</a>

Output:

.. code-block:: html
   :linenos:

   <a href="/auth/logout/100">Logout</a>
