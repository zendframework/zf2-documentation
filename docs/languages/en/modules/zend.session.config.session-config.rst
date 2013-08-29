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

