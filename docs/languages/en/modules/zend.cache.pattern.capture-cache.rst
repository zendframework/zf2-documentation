.. _zend.cache.pattern.capture-cache:

Zend\\Cache\\Pattern\\CaptureCache
=================================

.. _zend.cache.pattern.capture-cache.overview:

Overview
--------

The ``CaptureCache`` pattern is useful to auto-generate static resources in base of a HTTP request.
The Webserver needs to be configured to run a PHP script generating the requested resource so further
requests for the same resource can be shipped without calling PHP again.

It comes with basic logic to manage generated resources.

.. _zend.cache.pattern.capture-cache.quick-start:

Quick Start
-----------

Simplest usage as Apache-404 handler

.. code-block:: apacheconf
   :linenos:

   # .htdocs
   ErrorDocument 404 /index.php

.. code-block:: php
   :linenos:

   // index.php
   use Zend\Cache\PatternFactory;   $capture = Zend\Cache\PatternFactory::factory('capture', array(
       'public_dir' => __DIR__,
   ));

   // Start capturing all output excl. headers and write to public directory
   $capture->start();

   // Don't forget to change HTTP response code
   header('Status: 200', true, 200);
   
   // do stuff to dynamically generate output

.. _zend.cache.pattern.capture-cache.options:

Configuration options
---------------------

+------------------+------------------------+------------------------+-----------------------------------------------------------------+
|Option            |Data Type               |Default Value           |Description                                                      |
+==================+========================+========================+=================================================================+
|public_dir        |``string``              |<none>                  |Location of public directory to write output to                  |
+------------------+------------------------+------------------------+-----------------------------------------------------------------+
|index_filename    |``string``              |"index.html"            |The name of the first file if only a directory was requested     |
+------------------+------------------------+------------------------+-----------------------------------------------------------------+
|file_locking      |``boolean``             |``true``                |Locking output files on writing                                  |
+------------------+------------------------+------------------------+-----------------------------------------------------------------+
|file_permission   |``integer`` ``boolean`` |0600 (``false`` on win) |Set permissions of generated output files                        |
+------------------+------------------------+------------------------+-----------------------------------------------------------------+
|dir_permission    |``integer`` ``boolean`` |0700 (``false`` on win) |Set permissions of generated output directories                  |
+------------------+------------------------+------------------------+-----------------------------------------------------------------+
|umask             |``integer`` ``boolean`` |``false``               |Using umask on generationg output files / directories            |
+------------------+------------------------+------------------------+-----------------------------------------------------------------+

.. _zend.cache.pattern.capture-cache.methods:

Available Methods
-----------------

.. _zend.cache.pattern.capture-cache.methods.start:

**start**
   ``start(string|null $pageId = null)``

   Start capturing output

   Returns void

.. _zend.cache.pattern.capture-cache.methods.set:

**set**
   ``set(string $content, string|null $pageId = null)``

   Write content to page identity

   Returns void

**get**
   ``get(string|null $pageId = null)``

   Get content of an already cached page

   Returns string|false

**has**
   ``has(string|null $pageId = null)``

   Check if a page has been created

   Returns boolean

**remove**
   ``remove(string|null $pageId = null)``

   Remove a page

   Returns boolean

**clearByGlob**
   ``clearByGlob(string $pattern = '**')``

   Clear pages matching glob pattern

   Returns void

.. _zend.cache.pattern.capture-cache.methods.set-options:

**setOptions**
   ``setOptions(Zend\Cache\Pattern\PatternOptions $options)``

   Set pattern options

   Returns Zend\\Cache\\Pattern\\OutputCache

.. _zend.cache.pattern.capture-cache.methods.get-options:

**getOptions**
   ``getOptions()``

   Get all pattern options

   Returns ``PatternOptions`` instance.

.. _zend.cache.pattern.pattern-factory.examples:

Examples
--------

.. _zend.cache.pattern.capture-cache.examples.scaling-images:

.. rubric:: Scaling images in base of request

.. code-block:: apacheconf
   :linenos:

   # .htdocs
   ErrorDocument 404 /index.php

.. code-block:: php
   :linenos:

   // index.php
   $captureCache = Zend\Cache\PatternFactory::factory('capture', array(
       'public_dir' => __DIR__,
   ));
   
   // TODO
