.. _migration.zf1_zf2_parallel:

Running Zend Framework 2 and Zend Framework 1 in parallel
=========================================================

From a technical point of view is absolutely possible to run ZF2 in parallel with ZF1 because
there is not conflict between the classnames. In fact, ZF2 uses the namespace and ZF1 doesn't.
The execution of ZF1 and ZF2 together can be an idea for some migration projects where is not possible,
or not convenient, to migrate an entire application from ZF1 to ZF2. For instance, you can imagine to 
implement the new features of the application using ZF2 and manage the old ones using ZF1.
This can be also a valid technique to schedule a process of migration from ZF1 to ZF2 without freeze
your developing time in a full stack migration.

Let see some scenarios on how to execute ZF1 and ZF2 together.

Use ZF2 in a ZF1 project
------------------------

Suppose we have an existing ZF1 application and we want to start to use ZF2, how we can do that?
Because ZF2 is based on namespace is very easy to run it in parallel with ZF1. 
The simplest way to execute ZF2 components inside a ZF1 project is to register the autoloading
system of ZF2 inside the ``public/index.php`` script of ZF1. You can just add these lines of code in your
``public/index.php``, before the instantiation of ``$application``:

.. code-block:: php
   :linenos:

   define('ZF2_PATH', '/path/to/zf2/library');
   require_once ZF2_PATH . '/Zend/Loader/StandardAutoloader.php';
   $loader = new Zend\Loader\StandardAutoloader(array(
       'autoregister_zf' => true,
       'fallback_autoloader' => true,
   ));
   $loader->register();

We used the Standard autoloader component of ZF2. Using this autoloader the classes with namespace
Zend will be loaded using the ZF2_PATH and the ZF1 classes will continue to be loaded with the
previous mechanism (the "fallback_autoloader" to true guarantee this).

With this change you can start using ZF2 classes in your ZF1 application. Of course, this is not a
real integration of ZF2 inside ZF1. In this way you can only execute ZF2 components inside a ZF1 project.
For instance, you cannot use the MVC architecture of ZF2 because you are using the MVC of ZF1.

Evan Coury, member of the ZF community team has produced a nice module for ZF1 (`zf-2-for-1`_) that allow to
use ZF2 features in an existing ZF1 application. This module offers some basic integrations like the usage
of the ZF2 view helpers in the ZF1 view layer (i.e. ``$this->zf2->get('formRow')``).

If you are interested in how to use ZF1 in a ZF2 application you can read the next section.

Use ZF1 in a ZF2 project
------------------------

The easy way to execute ZF1 classes in a ZF2 application is to use composer with the following require
key ``"zendframework/zendframework1"``.

For instance, if you have a ZF2 application and you want to install ZF 1.12 you need to add the following
line in the require section of your ``composer.json`` file:

.. code-block:: json
   :linenos:

   "require": {
        "php": ">=5.3.3",
        "zendframework/zendframework1": "1.12",
        ...
    }
    
After execute the composer.phar update command you can start to use the ZF1 classes in your ZF2
project. Remember to use the absolute namespace to refer to the ``Zend_*`` classes, for instance
``\Zend_Date`` instead of ``Zend_Date``.

For other strategies on how to use ZF1 in a ZF2 project you can check out this blog post of Abdul
Malik Ikhsan, `Zend Framework 2 : Using Zend Framework 1 libraries`_.


Run together ZF1 and ZF2
------------------------

As we mentioned early, one way to migrate a ZF1 application to ZF2 can be to execute in parallel the
different versions of the framework, using ZF2 for the new features and migrate the ZF1 code step by step.
In order to execute in parallel we need to map different URLs with the different front controllers of ZF1
and ZF2. This goal can be accomplished using the rewriting rules of a web server. From a performance point
of view this is the best solution because does not involve pre-processing overhead.
For each URL we can define a different version of the framework to be used.

For instance, imagine we have a ZF1 application and we want to use ZF2 only for the URL starting with
``/album``, we can use the following ``.htaccess`` file (this information are related to `apache`_, if you
are using another web server read the instruction reported in the Note):

.. code-block:: apacheconf
   :linenos:
   
   SetEnv APPLICATION_ENV development
   RewriteEngine On
   RewriteCond %{REQUEST_FILENAME} -s [OR]
   RewriteCond %{REQUEST_FILENAME} -l [OR]
   RewriteCond %{REQUEST_FILENAME} -d
   RewriteRule ^.*$ - [NC,L]
   RewriteRule ^album(/.*)?$ index_zf2.php [NC,L]
   RewriteRule ^.*$ index.php [NC,L]

The ``index_zf2.php`` is a simple PHP script that includes the usual ``index.php`` file of ZF2.
Here the source code of this ``index_zf2.php`` file:

.. code-block:: php
   :linenos:

   require_once '../path-to-ZF2-app/public/index.php';

We suggest to put the ZF2 application in a separate folder under the same root directory of the ZF1
application. In this way you can continue to maintain the existing ZF1 code and use ZF2 only for the
new features.
Moreover, if you want to migrate the old code you can do that by URL and switch to the new ZF2 code
only when you are ready. This approach can be useful to provide a migration guideline without loose
development time in a full stack migration.

.. note::

   All the web servers support a rewriting mechanism. For instance, if you are using `Microsoft IIS 7`_
   you can check how to configure the rewriting rules from the Akrabat's post
   `Zend Framework URL Rewriting in IIS7`_, if you are using `nginx`_ you can check out this stackoverflow
   question `Zend Framework on nginx`_.


.. _`zf-2-for-1`: https://github.com/EvanDotPro/zf-2-for-1
.. _`Zend Framework 2 : Using Zend Framework 1 libraries`: http://samsonasik.wordpress.com/2012/12/04/zend-framework-2-using-zend-framework-1-libraries-in-zend-framework-2/
.. _`apache`: http://httpd.apache.org/
.. _`Microsoft IIS`: http://www.iis.net/
.. _`Zend Framework URL Rewriting in IIS7`: http://akrabat.com/winphp-challenge/zend-framework-url-rewriting-in-iis7/
.. _`nginx`: http://nginx.org/
.. _`Zend Framework on nginx`: http://stackoverflow.com/questions/376732/zend-framework-on-nginx