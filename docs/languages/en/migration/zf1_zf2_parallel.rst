.. _migration.zf1_zf2_parallel:

Running Zend Framework 2 and Zend Framework 1 in parallel
=========================================================

From a technical point of view it is absolutely possible to run ZF2 in parallel
with ZF1 because there is no conflict between the classnames due to the fact
that ZF2 uses namespaces and ZF1 does not.  Running ZF1 and ZF2 in parallel can
be used as a migration strategy in projects where it is not possible, or not
convenient, to migrate an entire application from ZF1 to ZF2. For instance, you
could implement any new features of the application using ZF2, while maintaining
original ZF1 features.

Let's examine some scenarios on how to execute ZF1 and ZF2 together.

.. _zf2-in-zf1:

Use ZF2 in a ZF1 project
------------------------

Suppose we have an existing ZF1 application and we want to start using ZF2; how
could we do that?

Because ZF2 uses namespaced classes, you can run it in parallel with ZF1 without
naming conflicts. In order to do this, you will need to add some code to
autoload ZF2 from within your ZF1 project.  Add these lines of code in your
``public/index.php``, before the instantiation of ``$application``:

.. code-block:: php
   :linenos:

   define('ZF2_PATH', '/path/to/zf2/library');
   require_once ZF2_PATH . '/Zend/Loader/StandardAutoloader.php';
   $loader = new Zend\Loader\StandardAutoloader(array(
       'autoregister_zf' => true,
   ));
   $loader->register();

We used the ``StandardAutoloader`` class from ZF2. Using this autoloader,
classes with the initial namespace ``Zend`` will be loaded using the
``ZF2_PATH``, and any ZF1 classes will continue to be loaded via the mechanisms
present in ZF1.

Of course, this is not a real integration of ZF2 inside ZF1; it only provides
the ability to consume ZF2 classes within your ZF1 application.  For instance,
you cannot use the MVC architecture of ZF2 because you are using the MVC of ZF1.

Evan Coury, a member of the ZF community review team, has produced a nice module
for ZF1 (`zf-2-for-1`_) that allows you to use ZF2 features inside an existing
ZF1 application. This module offers some basic integrations like the usage of
ZF2 view helpers in the ZF1 view layer (i.e. ``$this->zf2->get('formRow')``).


.. _zf1-in-zf2:

Use ZF1 in a ZF2 project
------------------------

You can add ZF1 to your ZF2 application via Composer by adding the
"zendframework/zendframework1" package as a requirement.

For instance, if you have a ZF2 application and you want to install ZF 1.12, you
need to add the following line in the require section of your ``composer.json``
file:

.. code-block:: json
   :linenos:

   "require": {
        "php": ">=5.3.3",
        "zendframework/zendframework1": "1.12",
        ...
    }
    
After executing ``composer.phar update``, you can start to use ZF1 classes in your ZF2
project. Since all ZF1 classes exist in the global namespace, you will need to
refer to them by their full name; as examples, ``Zend_Date``,
``Zend_Feed_Reader``, etc.

For other strategies on how to use ZF1 in a ZF2 project, you can check out this
blog post by Abdul Malik Ikhsan, `Zend Framework 2 : Using Zend Framework 1
libraries`_.


.. _zf1-and-zf2-together:

Run ZF1 and ZF2 together
------------------------

As we mentioned early, one way to migrate a ZF1 application to ZF2 can be to
execute in parallel the different versions of the framework, using ZF2 for the
new features, and migrating the ZF1 code step by step.  In order to execute in
parallel, we need to map different URLs to the different front controllers for
ZF1 and ZF2. This goal can be accomplished using the rewriting rules of your web
server. From a performance point of view, this is the best solution because it
does not involve pre-processing overhead.  For each URL we can define a
different version of the framework to be used.

For instance, imagine we have a ZF1 application and we want to use ZF2 only for
URLs starting with ``/album``. We can use the following ``.htaccess`` file (this
information is related to `apache`_; if you are using another web server, read
the instructions in the note below):

.. code-block:: apacheconf
   :linenos:
   
   SetEnv APPLICATION_ENV development
   RewriteEngine On
   RewriteCond %{REQUEST_FILENAME} -s [OR]
   RewriteCond %{REQUEST_FILENAME} -l [OR]
   RewriteCond %{REQUEST_FILENAME} -d
   RewriteRule ^ - [NC,L]
   RewriteRule ^album(/.*)?$ index_zf2.php [NC,L]
   RewriteRule ^ index.php [NC,L]

``index_zf2.php`` is a PHP script that includes as the typical
``public/index.php`` file of ZF2.  Here is the source code for
``index_zf2.php``:

.. code-block:: php
   :linenos:

   require_once '../path-to-ZF2-app/public/index.php';

We suggest putting the ZF2 application in a separate folder under the same root
directory of the ZF1 application. In this way you can continue to maintain the
existing ZF1 code and use ZF2 only for the new features.  Moreover, if you want
to migrate the old code you can do that by URL and switch to the new ZF2 code
only when you are ready. This approach can be useful to provide migration
guideline without losing development time in a full stack migration.

.. note::

   All web servers support a rewriting mechanism. For instance, if you are using
   `Microsoft IIS 7`_, you can check how to configure the rewriting rules from
   Rob Allen's post `Zend Framework URL Rewriting in IIS7`_; if you are using
   `nginx`_, you can check out this StackOverflow question: `Zend Framework on
   nginx`_.


.. _`zf-2-for-1`: https://github.com/EvanDotPro/zf-2-for-1
.. _`Zend Framework 2 : Using Zend Framework 1 libraries`: http://samsonasik.wordpress.com/2012/12/04/zend-framework-2-using-zend-framework-1-libraries-in-zend-framework-2/
.. _`apache`: http://httpd.apache.org/
.. _`Microsoft IIS 7`: http://www.iis.net/
.. _`Zend Framework URL Rewriting in IIS7`: http://akrabat.com/winphp-challenge/zend-framework-url-rewriting-in-iis7/
.. _`nginx`: http://nginx.org/
.. _`Zend Framework on nginx`: http://stackoverflow.com/questions/376732/zend-framework-on-nginx
