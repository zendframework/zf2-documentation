:orphan:

.. _zend.session.config.session-config:

Session Config
--------------

``Zend\Session\Config\SessionConfig`` provides you a basic interface for implementing sessions when that leverage PHP's 
ext/session.  Most configuration options configure either the ``Zend\Session\Storage`` OR configure ext/session directly.

Basic Configuration Options
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.session.config.session-config.options:

The following configuration options are defined by ``Zend\Session\Config\SessionConfig``, note that it inherits all
configuration from ``Zend\Session\Config\StandardConfig``.

+------------------------+------------+-------------------------------------------------------------------------------------------+
|Option                  |Data Type   |Description                                                                                |
+========================+============+===========================================================================================+
|cache_limiter           |``string``  |Specifies the cache control method used for session pages.                                 |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|hash_function           |``string``  |Allows you to specify the hash algorithm used to generate the session IDs.                 |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|php_save_handler        |``string``  |Defines the name of a PHP save_handler embedded into PHP.                                  |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|serialize_handler       |``string``  |Defines the name of the handler which is used to serialize/deserialize data.               |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|url_rewriter_tags       |``string``  |Specifies which HTML tags are rewritten to include session id if transparent sid enabled.  |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|use_trans_sid           |``boolean`` |Whether transparent sid support is enabled or not.                                         |
+------------------------+------------+-------------------------------------------------------------------------------------------+

Basic Usage
^^^^^^^^^^^

A basic example is one like the following:

.. code-block:: php
   :linenos:

   use Zend\Session\Config\SessionConfig;
   use Zend\Session\SessionManager;

   $config = new SessionConfig();
   $config->setOptions(array(
       'phpSaveHandler' => 'redis',
       'savePath' => 'tcp://127.0.0.1:6379?weight=1&timeout=1',
   ));
   $manager = new SessionManager($config);

Service Manager Factory 
^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.session.config.session-config.service-manager-factory:

``Zend\Session`` ships with a :doc:`Service Manager <zend.service-manager.intro>` factory which reads configuration data
from the application configuration and injects a corresponding instance of ``Zend\Session\Config\SessionConfig`` into
the session manager automatically.

To use this factory, you first need to register it with the Service Manager by adding the appropriate factory definition:

.. code-block:: php
   :linenos:

   'service_manager' => array(
       'factories' => array(
           'Zend\Session\Config\ConfigInterface' => 'Zend\Session\Service\SessionConfigFactory',
       ),
   ),

Then place your application's session configuration in the root-level configuration key ``session_config``:

.. code-block:: php
   :linenos:

   'session_config' => array(
       'phpSaveHandler' => 'redis',
       'savePath' => 'tcp://127.0.0.1:6379?weight=1&timeout=1',
   ),

Any of the configuration options defined in :ref:`zend.session.config.session-config.options` can be used there, as well as the following factory-specific
configuration options: 

+------------------------+------------+-------------------------------------------------------------------------------------------+
|Option                  |Data Type   |Description                                                                                |
+========================+============+===========================================================================================+
|config_class            |``string``  |Name of the class to use as the configuration container                                    |
|                        |            |(Defaults to ``Zend\Session\Config\SessionConfig``
+------------------------+------------+-------------------------------------------------------------------------------------------+