.. _zend.session.config.session-config:

Session Config
==============

``Zend\Session\Config\SessionConfig`` provides you a basic interface for implementing sessions when that leverage PHP's 
ext/session.  Most configuration options configure either the ``Zend\Session\Storage`` OR configure ext/session directly.

Basic Configuration Options
---------------------------

.. _zend.session.config.session-config.options:

The following configuration options are defined by ``Zend\Session\Config\SessionConfig``.

+------------------------+------------+-------------------------------------------------------------------------------------------+
|Option                  |Data Type   |Description                                                                                |
+========================+============+===========================================================================================+
|cookie_domain           |``string``  |Specifies the domain to set in the session cookie.                                         |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|cookie_httponly         |``boolean`` |Marks the cookie as accessible only through the HTTP protocol.                             |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|cookie_lifetime         |``integer`` |Specifies the lifetime of the cookie in seconds which is sent to the browser.              |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|cookie_path             |``string``  |Specifies path to set in the session cookie.                                               |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|cookie_secure           |``boolean`` |Specifies whether cookies should only be sent over secure connections.                     |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|name                    |``string``  |Specifies the name of the session which is used as cookie name.                            |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|remember_me_seconds     |``integer`` |Specifies how long to remember the session before clearing data.                           |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|save_path               |``string``  |Defines the argument which is passed to the save handler.                                  |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|use_cookies             |``boolean`` |Specifies whether the module will use cookies to store the session id.                     |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|hash_bits_per_character |``integer`` |Defines how many bits are stored in each character when converting the binary hash data.   |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|cache_expire            |``integer`` |Specifies time-to-live for cached session pages in minutes.                                |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|entropy_length          |``integer`` |Specifies the number of bytes which will be read from the file specified in entropy_file.  |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|entropy_file            |``string``  |Defines a path to an external resource (file) which will be used as an additional entropy. |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|gc_maxlifetime          |``integer`` |Specifies the number of seconds after which data will be seen as 'garbage'.                |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|gc_divisor              |``integer`` |Defines the probability that the gc process is started on every session initialization.    |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|gc_probability          |``integer`` |Defines the probability that the gc process is started on every session initialization.    |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|serialize_handler       |``string``  |Defines the name of the handler which is used to serialize/deserialize data.               |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|cache_limiter           |``string``  |Specifies the cache control method used for session pages.                                 |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|hash_function           |``string``  |Allows you to specify the hash algorithm used to generate the session IDs.                 |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|url_rewriter_tags       |``string``  |Specifies which HTML tags are rewritten to include session id if transparent sid enabled.  |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|use_trans_sid           |``boolean`` |Whether transparent sid support is enabled or not.                                         |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|php_save_handler        |``string``  |Defines the name of a PHP save_handler embedded into PHP.                                  |
+------------------------+------------+-------------------------------------------------------------------------------------------+



Basic Usage
===========

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

