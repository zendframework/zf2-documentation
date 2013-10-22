.. _user-guide.skeleton-application:

Getting started: A skeleton application
=======================================

In order to build our application, we will start with the
`ZendSkeletonApplication <https://github.com/zendframework/ZendSkeletonApplication>`_ 
available on `github <https://github.com/>`_. We will be using Composer (http://getcomposer.org)
to create a new project from scratch with Zend Framework:

.. code-block:: bash
   :linenos:

    curl -s https://getcomposer.org/installer | php --
    php composer.phar create-project --repository-url="https://packages.zendframework.com" -s dev zendframework/skeleton-application zf2-tutorial
    cd zf2-tutorial
    php composer.phar update

.. note::

    Another way to install the ZendSkeletonApplication is to use github.  Go to 
    https://github.com/zendframework/ZendSkeletonApplication and click the “Zip”
    button. This will download a file with a name like
    ``ZendSkeletonApplication-master.zip`` or
    similar. 

    Unzip this file into the directory where you keep all your vhosts and rename the
    resultant directory to ``zf2-tutorial``. 

    ZendSkeletonApplication is set up to use Composer (http://getcomposer.org) to
    resolve its dependencies. In this case, the dependency is Zend Framework 2
    itself.

    To install Zend Framework 2 into our application we simply type:

    .. code-block:: bash
       :linenos:

        php composer.phar self-update
        php composer.phar install
        php composer.phar update

    from the ``zf2-tutorial`` folder. This takes a while. You should see an output like:

    .. code-block:: bash
       :linenos:

        Installing dependencies from lock file
        - Installing zendframework/zendframework (dev-master)
          Cloning 18c8e223f070deb07c17543ed938b54542aa0ed8

        Generating autoload files

.. note::

    If you see this message: 

    .. code-block:: bash
       :linenos:

        [RuntimeException]      
          The process timed out. 

    then your connection was too slow to download the entire package in time, and composer
    timed out. To avoid this, instead of running:

    .. code-block:: bash
       :linenos:

        php composer.phar install
        php composer.phar update

    run instead:

    .. code-block:: bash
       :linenos:

        COMPOSER_PROCESS_TIMEOUT=5000 php composer.phar install
        COMPOSER_PROCESS_TIMEOUT=5000 php composer.phar update

We can now move on to the virtual host.

Using the Apache Web Server
---------------------------

You now need to create an Apache virtual host for the application and edit your
hosts file so that http://zf2-tutorial.localhost will serve ``index.php`` from the
``zf2-tutorial/public`` directory.

Setting up the virtual host is usually done within ``httpd.conf`` or
``extra/httpd-vhosts.conf``.  If you are using ``httpd-vhosts.conf``, ensure
that this file is included by your main ``httpd.conf`` file.  Some Linux distributions 
(ex: Ubuntu) package Apache so that configuration files are stored in ``/etc/apache2`` 
and create one file per virtual host inside folder ``/etc/apache2/sites-enabled``.  In 
this case, you would place the virtual host block below into the file 
``/etc/apache2/sites-enabled/zf2-tutorial``.

Ensure that ``NameVirtualHost`` is defined and set to “\*:80” or similar, and then
define a virtual host along these lines:

.. code-block:: apache
   :linenos:

    <VirtualHost *:80>
        ServerName zf2-tutorial.localhost
        DocumentRoot /path/to/zf2-tutorial/public
        SetEnv APPLICATION_ENV "development"
        <Directory /path/to/zf2-tutorial/public>
            DirectoryIndex index.php
            AllowOverride All
            Order allow,deny
            Allow from all
        </Directory>
    </VirtualHost>

Make sure that you update your ``/etc/hosts`` or
``c:\windows\system32\drivers\etc\hosts`` file so that ``zf2-tutorial.localhost``
is mapped to ``127.0.0.1``. The website can then be accessed using
http://zf2-tutorial.localhost.  

.. code-block:: txt
   :linenos:

    127.0.0.1               zf2-tutorial.localhost localhost

Restart your web server.
If you’ve done it right, you should see something like this:

.. image:: ../images/user-guide.skeleton-application.hello-world.png
    :width: 940 px

To test that your ``.htaccess`` file is working, navigate to
http://zf2-tutorial.localhost/1234 and you should see this:

.. image:: ../images/user-guide.skeleton-application.404.png
    :width: 940 px

If you see a standard Apache 404 error, then you need to fix ``.htaccess`` usage
before continuing.  If you're are using IIS with the URL Rewrite Module, import the following:

.. code-block:: apache
   :linenos:

    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^.*$ index.php [NC,L]

You now have a working skeleton application and we can start adding the specifics
for our application.

Error reporting
---------------

Optionally, you can use the ``APPLICATION_ENV`` setting in your virtualhost to
let PHP output all its errors to the browser. This can be useful when during
development of your application.

Edit ``index.php`` from the ``zf2-tutorial/public/`` directory and change it to
the following:

.. code-block:: php
   :linenos:

    <?php

    /**
     * Display all errors when APPLICATION_ENV is development.
     */
    if ($_SERVER['APPLICATION_ENV'] == 'development') {
        error_reporting(E_ALL);
        ini_set("display_errors", 1);
    }
    
    /**
     * This makes our life easier when dealing with paths. Everything is relative
     * to the application root now.
     */
    chdir(dirname(__DIR__));
    
    // Setup autoloading
    require 'init_autoloader.php';
    
    // Run the application!
    Zend\Mvc\Application::init(require 'config/application.config.php')->run();
