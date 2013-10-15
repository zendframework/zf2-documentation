.. _zend.session.config.standard-config:

Standard Config
---------------

``Zend\Session\Config\StandardConfig`` provides you a basic interface for implementing sessions when *not* leveraging
ext/session.  This is utilized more for specialized cases such as when you might have session management done by another
system.

Basic Configuration Options
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.session.config.standard-config.options:

The following configuration options are defined by ``Zend\Session\Config\StandardConfig``.

+------------------------+------------+-------------------------------------------------------------------------------------------+
|Option                  |Data Type   |Description                                                                                |
+========================+============+===========================================================================================+
|cache_expire            |``integer`` |Specifies time-to-live for cached session pages in minutes.                                |
+------------------------+------------+-------------------------------------------------------------------------------------------+
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
|hash_bits_per_character |``integer`` |Defines how many bits are stored in each character when converting the binary hash data.   |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|name                    |``string``  |Specifies the name of the session which is used as cookie name.                            |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|remember_me_seconds     |``integer`` |Specifies how long to remember the session before clearing data.                           |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|save_path               |``string``  |Defines the argument which is passed to the save handler.                                  |
+------------------------+------------+-------------------------------------------------------------------------------------------+
|use_cookies             |``boolean`` |Specifies whether the module will use cookies to store the session id.                     |
+------------------------+------------+-------------------------------------------------------------------------------------------+

Basic Usage
^^^^^^^^^^^

A basic example is one like the following:

.. code-block:: php
   :linenos:

   use Zend\Session\Config\StandardConfig;
   use Zend\Session\SessionManager;

   $config = new StandardConfig();
   $config->setOptions(array(
       'remember_me_seconds' => 1800,
       'name'                => 'zf2',
   ));
   $manager = new SessionManager($config);

