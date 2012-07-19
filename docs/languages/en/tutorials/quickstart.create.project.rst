.. _learning.quickstart.create-project:

Create Your Project
===================

In order to create your project, you must first download and extract Zend Framework.

.. _learning.quickstart.create-project.install-zf:

Install Zend Framework
----------------------

The easiest way to get Zend Framework along with a complete *PHP* stack is by installing `Zend Server`_. Zend
Server has native installers for Mac OSX, Windows, Fedora Core, and Ubuntu, as well as a universal installation
package compatible with most Linux distributions.

After you have installed Zend Server, the Framework files may be found under
``/usr/local/zend/share/ZendFramework`` on Mac OSX and Linux, and ``C:\Program
Files\Zend\ZendServer\share\ZendFramework`` on Windows. The ``include_path`` will already be configured to include
Zend Framework.

Alternately, you can `Download the latest version of Zend Framework`_ and extract the contents; make a note of
where you have done so.

Optionally, you can add the path to the ``library/`` subdirectory of the archive to your ``php.ini``'s
``include_path`` setting.

That's it! Zend Framework is now installed and ready to use.

.. _learning.quickstart.create-project.create-project:

Create Your Project
-------------------

.. note:: zf Command Line Tool

   In your Zend Framework installation is a ``bin/`` subdirectory, containing the scripts ``zf.sh`` and ``zf.bat``
   for Unix-based and Windows-based users, respectively. Make a note of the absolute path to this script.

   Wherever you see references to the command ``zf``, please substitute the absolute path to the script. On
   Unix-like systems, you may want to use your shell's alias functionality: ``alias
   zf.sh=path/to/ZendFramework/bin/zf.sh``.

   If you have problems setting up the ``zf`` command-line tool, please refer to :ref:`the manual
   <zend.tool.framework.clitool>`.

Open a terminal (in Windows, ``Start -> Run``, and then use ``cmd``). Navigate to a directory where you would like
to start a project. Then, use the path to the appropriate script, and execute one of the following:

.. code-block:: console
   :linenos:

   % zf create project quickstart

Running this command will create your basic site structure, including your initial controllers and views. The tree
looks like the following:

.. code-block:: text
   :linenos:

   quickstart
   |-- application
   |   |-- Bootstrap.php
   |   |-- configs
   |   |   `-- application.ini
   |   |-- controllers
   |   |   |-- ErrorController.php
   |   |   `-- IndexController.php
   |   |-- models
   |   `-- views
   |       |-- helpers
   |       `-- scripts
   |           |-- error
   |           |   `-- error.phtml
   |           `-- index
   |               `-- index.phtml
   |-- library
   |-- public
   |   |-- .htaccess
   |   `-- index.php
   `-- tests
       |-- application
       |   `-- bootstrap.php
       |-- library
       |   `-- bootstrap.php
       `-- phpunit.xml

At this point, if you haven't added Zend Framework to your ``include_path``, we recommend either copying or
symlinking it into your ``library/`` directory. In either case, you'll want to either recursively copy or symlink
the ``library/Zend/`` directory of your Zend Framework installation into the ``library/`` directory of your
project. On unix-like systems, that would look like one of the following:

.. code-block:: console
   :linenos:

   # Symlink:
   % cd library; ln -s path/to/ZendFramework/library/Zend .

   # Copy:
   % cd library; cp -r path/to/ZendFramework/library/Zend .

On Windows systems, it may be easiest to do this from the Explorer.

Now that the project is created, the main artifacts to begin understanding are the bootstrap, configuration, action
controllers, and views.

.. _learning.quickstart.create-project.bootstrap:

The Bootstrap
-------------

Your ``Bootstrap`` class defines what resources and components to initialize. By default, Zend Framework's
:ref:`Front Controller <zend.controller.front>` is initialized, and it uses the ``application/controllers/`` as the
default directory in which to look for action controllers (more on that later). The class looks like the following:

.. code-block:: php
   :linenos:

   // application/Bootstrap.php

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
   }

As you can see, not much is necessary to begin with.

.. _learning.quickstart.create-project.configuration:

Configuration
-------------

While Zend Framework is itself configurationless, you often need to configure your application. The default
configuration is placed in ``application/configs/application.ini``, and contains some basic directives for setting
your *PHP* environment (for instance, turning error reporting on and off), indicating the path to your bootstrap
class (as well as its class name), and the path to your action controllers. It looks as follows:

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   [production]
   phpSettings.display_startup_errors = 0
   phpSettings.display_errors = 0
   includePaths.library = APPLICATION_PATH "/../library"
   bootstrap.path = APPLICATION_PATH "/Bootstrap.php"
   bootstrap.class = "Bootstrap"
   appnamespace = "Application"
   resources.frontController.controllerDirectory = APPLICATION_PATH "/controllers"
   resources.frontController.params.displayExceptions = 0

   [staging : production]

   [testing : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

   [development : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

Several things about this file should be noted. First, when using *INI*-style configuration, you can reference
constants directly and expand them; ``APPLICATION_PATH`` is actually a constant. Additionally note that there are
several sections defined: production, staging, testing, and development. The latter three inherit settings from the
"production" environment. This is a useful way to organize configuration to ensure that appropriate settings are
available in each stage of application development.

.. _learning.quickstart.create-project.action-controllers:

Action Controllers
------------------

Your application's **action controllers** contain your application workflow, and do the work of mapping your
requests to the appropriate models and views.

An action controller should have one or more methods ending in "Action"; these methods may then be requested via
the web. By default, Zend Framework URLs follow the schema ``/controller/action``, where "controller" maps to the
action controller name (minus the "Controller" suffix) and "action" maps to an action method (minus the "Action"
suffix).

Typically, you always need an ``IndexController``, which is a fallback controller and which also serves the home
page of the site, and an ``ErrorController``, which is used to indicate things such as *HTTP* 404 errors
(controller or action not found) and *HTTP* 500 errors (application errors).

The default ``IndexController`` is as follows:

.. code-block:: php
   :linenos:

   // application/controllers/IndexController.php

   class IndexController extends Zend_Controller_Action
   {

       public function init()
       {
           /* Initialize action controller here */
       }

       public function indexAction()
       {
           // action body
       }
   }

And the default ``ErrorController`` is as follows:

.. code-block:: php
   :linenos:

   // application/controllers/ErrorController.php

   class ErrorController extends Zend_Controller_Action
   {

       public function errorAction()
       {
           $errors = $this->_getParam('error_handler');

           switch ($errors->type) {
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ROUTE:
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER:
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION:

                   // 404 error -- controller or action not found
                   $this->getResponse()->setHttpResponseCode(404);
                   $this->view->message = 'Page not found';
                   break;
               default:
                   // application error
                   $this->getResponse()->setHttpResponseCode(500);
                   $this->view->message = 'Application error';
                   break;
           }

           $this->view->exception = $errors->exception;
           $this->view->request   = $errors->request;
       }
   }

You'll note that (1) the ``IndexController`` contains no real code, and (2) the ``ErrorController`` makes reference
to a "view" property. That leads nicely into our next subject.

.. _learning.quickstart.create-project.views:

Views
-----

Views in Zend Framework are written in plain old *PHP*. View scripts are placed in ``application/views/scripts/``,
where they are further categorized using the controller names. In our case, we have an ``IndexController`` and an
``ErrorController``, and thus we have corresponding ``index/`` and ``error/`` subdirectories within our view
scripts directory. Within these subdirectories, you will then find and create view scripts that correspond to each
controller action exposed; in the default case, we thus have the view scripts ``index/index.phtml`` and
``error/error.phtml``.

View scripts may contain any markup you want, and use the **<?php** opening tag and **?>** closing tag to insert
*PHP* directives.

The following is what we install by default for the ``index/index.phtml`` view script:

.. code-block:: php
   :linenos:

   <!-- application/views/scripts/index/index.phtml -->
   <style>

       a:link,
       a:visited
       {
           color: #0398CA;
       }

       span#zf-name
       {
           color: #91BE3F;
       }

       div#welcome
       {
           color: #FFFFFF;
           background-image: url(http://framework.zend.com/images/bkg_header.jpg);
           width:  600px;
           height: 400px;
           border: 2px solid #444444;
           overflow: hidden;
           text-align: center;
       }

       div#more-information
       {
           background-image: url(http://framework.zend.com/images/bkg_body-bottom.gif);
           height: 100%;
       }

   </style>
   <div id="welcome">
       <h1>Welcome to the <span id="zf-name">Zend Framework!</span><h1 />
       <h3>This is your project's main page<h3 />
       <div id="more-information">
           <p>
               <img src="http://framework.zend.com/images/PoweredBy_ZF_4LightBG.png" />
           </p>

           <p>
               Helpful Links: <br />
               <a href="http://framework.zend.com/">Zend Framework Website</a> |
               <a href="http://framework.zend.com/manual/en/">Zend Framework
                   Manual</a>
           </p>
       </div>
   </div>

The ``error/error.phtml`` view script is slightly more interesting as it uses some *PHP* conditionals:

.. code-block:: php
   :linenos:

   <!-- application/views/scripts/error/error.phtml -->
   <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN";
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd>
   <html xmlns="http://www.w3.org/1999/xhtml">
   <head>
     <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
     <title>Zend Framework Default Application</title>
   </head>
   <body>
     <h1>An error occurred</h1>
     <h2><?php echo $this->message ?></h2>

     <?php if ('development' == $this->env): ?>

     <h3>Exception information:</h3>
     <p>
         <b>Message:</b> <?php echo $this->exception->getMessage() ?>
     </p>

     <h3>Stack trace:</h3>
     <pre><?php echo $this->exception->getTraceAsString() ?>
     </pre>

     <h3>Request Parameters:</h3>
     <pre><?php echo var_export($this->request->getParams(), 1) ?>
     </pre>
     <?php endif ?>

   </body>
   </html>

.. _learning.quickstart.create-project.vhost:

Create a virtual host
---------------------

For purposes of this quick start, we will assume you are using the `Apache web server`_. Zend Framework works
perfectly well with other web servers -- including Microsoft Internet Information Server, lighttpd, nginx, and more
-- but most developers should be famililar with Apache at the minimum, and it provides an easy introduction to Zend
Framework's directory structure and rewrite capabilities.

To create your vhost, you need to know the location of your ``httpd.conf`` file, and potentially where other
configuration files are located. Some common locations:

- ``/etc/httpd/httpd.conf`` (Fedora, RHEL, and others)

- ``/etc/apache2/httpd.conf`` (Debian, Ubuntu, and others)

- ``/usr/local/zend/etc/httpd.conf`` (Zend Server on \*nix machines)

- ``C:\Program Files\Zend\Apache2\conf`` (Zend Server on Windows machines)

Within your ``httpd.conf`` (or ``httpd-vhosts.conf`` on some systems), you will need to do two things. First,
ensure that the ``NameVirtualHost`` is defined; typically, you will set it to a value of "\*:80". Second, define a
virtual host:

.. code-block:: apache
   :linenos:

   <VirtualHost *:80>
       ServerName quickstart.local
       DocumentRoot /path/to/quickstart/public

       SetEnv APPLICATION_ENV "development"

       <Directory /path/to/quickstart/public>
           DirectoryIndex index.php
           AllowOverride All
           Order allow,deny
           Allow from all
       </Directory>
   </VirtualHost>

There are several things to note. First, note that the ``DocumentRoot`` setting specifies the ``public``
subdirectory of our project; this means that only files under that directory can ever be served directly by the
server. Second, note the ``AllowOverride``, ``Order``, and ``Allow`` directives; these are to allow us to use
``htacess`` files within our project. During development, this is a good practice, as it prevents the need to
constantly restart the web server as you make changes to your site directives; however, in production, you should
likely push the content of your ``htaccess`` file into your server configuration and disable this. Third, note the
``SetEnv`` directive. What we are doing here is setting an environment variable for your virtual host; this
variable will be picked up in the ``index.php`` and used to set the ``APPLICATION_ENV`` constant for our Zend
Framework application. In production, you can omit this directive (in which case it will default to the value
"production") or set it explicitly to "production".

Finally, you will need to add an entry in your ``hosts`` file corresponding to the value you place in your
``ServerName`` directive. On \*nix-like systems, this is usually ``/etc/hosts``; on Windows, you'll typically find
it in ``C:\WINDOWS\system32\drivers\etc``. Regardless of the system, the entry will look like the following:

.. code-block:: text
   :linenos:

   127.0.0.1 quickstart.local

Start your webserver (or restart it), and you should be ready to go.

.. _learning.quickstart.create-project.checkpoint:

Checkpoint
----------

At this point, you should be able to fire up your initial Zend Framework application. Point your browser to the
server name you configured in the previous section; you should be able to see a welcome page at this point.



.. _`Zend Server`: http://www.zend.com/en/products/server-ce/downloads
.. _`Download the latest version of Zend Framework`: http://framework.zend.com/download/latest
.. _`Apache web server`: http://httpd.apache.org/
