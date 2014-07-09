.. _project-structure:

*****************************************************************
Recommended Project Structure for Zend Framework MVC Applications
*****************************************************************

.. _project-structure.overview:

Overview
--------

Many developers seek guidance on the best project structure for a Zend Framework project in a relatively flexible
environment. A "flexible" environment is one in which the developer can manipulate their file systems and web
server configurations as needed to achieve the most ideal project structure to run and secure their application.
The default project structure will assume that the developer has such flexibility at their disposal.

The following directory structure is designed to be maximally extensible for complex projects, while providing a
simple subset of folder and files for project with simpler requirements. This structure also works without
alteration for both modular and non-modular Zend Framework applications. The ``.htaccess`` files require *URL*
rewrite functionality in the web server as described in the :ref:`Rewrite Configuration Guide
<project-structure.rewrite>`, also included in this appendix.

It is not the intention that this project structure will support all possible Zend Framework project requirements.
The default project profile used by ``Zend_Tool`` reflect this project structure, but applications with
requirements not supported by this structure should use a custom project profile.

.. _project-structure.project:

Recommended Project Directory Structure
---------------------------------------

.. code-block:: text
   :linenos:

   <project name>/
       application/
           configs/
               application.ini
           controllers/
               helpers/
           forms/
           layouts/
               filters/
               helpers/
               scripts/
           models/
           modules/
           services/
           views/
               filters/
               helpers/
               scripts/
           Bootstrap.php
       data/
           cache/
           indexes/
           locales/
           logs/
           sessions/
           uploads/
       docs/
       library/
       public/
           css/
           images/
           js/
           .htaccess
           index.php
       scripts/
           jobs/
           build/
       temp/
       tests/

The following describes the use cases for each directory as listed.

- **application/**: This directory contains your application. It will house the *MVC* system, as well as
  configurations, services used, and your bootstrap file.

  - **configs/**: The application-wide configuration directory.

  - **controllers/**, **models/**, and **views/**: These directories serve as the default controller, model or view
    directories. Having these three directories inside the application directory provides the best layout for
    starting a simple project as well as starting a modular project that has global ``controllers/models/views``.

  - **controllers/helpers/**: These directories will contain action helpers. Action helpers will be namespaced
    either as "``Controller_Helper_``" for the default module or "<Module>_Controller_Helper" in other modules.

  - **layouts/**: This layout directory is for *MVC*-based layouts. Since ``Zend_Layout`` is capable of *MVC*- and
    non-*MVC*-based layouts, the location of this directory reflects that layouts are not on a 1-to-1 relationship
    with controllers and are independent of templates within ``views/``.

  - **modules/**: Modules allow a developer to group a set of related controllers into a logically organized group.
    The structure under the modules directory would resemble the structure under the application directory.

  - **services/**: This directory is for your application specific web-service files that are provided by your
    application, or for implementing a `Service Layer`_ for your models.

  - **Bootstrap.php**: This file is the entry point for your application, and should implement
    ``Zend\Application\Bootstrap\Bootstrapper``. The purpose for this file is to bootstrap the application and make
    components available to the application by initializing them.

- **data/**: This directory provides a place to store application data that is volatile and possibly temporary. The
  disturbance of data in this directory might cause the application to fail. Also, the information in this
  directory may or may not be committed to a subversion repository. Examples of things in this directory are
  session files, cache files, sqlite databases, logs and indexes.

- **docs/**: This directory contains documentation, either generated or directly authored.

- **library/**: This directory is for common libraries on which the application depends, and should be on the *PHP*
  ``include_path``. Developers should place their application's library code under this directory in a unique
  namespace, following the guidelines established in the *PHP* manual's `Userland Naming Guide`_, as well as those
  established by Zend itself. This directory may also include Zend Framework itself; if so, you would house it in
  ``library/Zend/``.

- **public/**: This directory contains all public files for your application. ``index.php`` sets up and invokes
  ``Zend_Application``, which in turn invokes the ``application/Bootstrap.php`` file, resulting in dispatching the
  front controller. The web root of your web server would typically be set to this directory.

- **scripts/**: This directory contains maintenance and/or build scripts. Such scripts might include command line,
  cron, or phing build scripts that are not executed at runtime but are part of the correct functioning of the
  application.

- **temp/**: The ``temp/`` folder is set aside for transient application data. This information would not typically
  be committed to the applications svn repository. If data under the ``temp/`` directory were deleted, the
  application should be able to continue running with a possible decrease in performance until data is once again
  restored or recached.

- **tests/**: This directory contains application tests. These could be hand-written, PHPUnit tests, Selenium-RC
  based tests or based on some other testing framework. By default, library code can be tested by mimicking the
  directory structure of your ``library/`` directory. Additionally, functional tests for your application could be
  written mimicing the ``application/`` directory structure (including the application subdirectory).

.. _project-structure.filesystem:

Module Structure
----------------

The directory structure for modules should mimic that of the ``application/`` directory in the recommended project
structure:

.. code-block:: text
   :linenos:

   <modulename>
       configs/
           application.ini
       controllers/
           helpers/
       forms/
       layouts/
           filters/
           helpers/
           scripts/
       models/
       services/
       views/
           filters/
           helpers/
           scripts/
       Bootstrap.php

The purpose of these directories remains exactly the same as for the recommended project directory structure.

.. _project-structure.rewrite:

Rewrite Configuration Guide
---------------------------

*URL* rewriting is a common function of *HTTP* servers. However, the rules and configuration differ widely between
them. Below are some common approaches across a variety of popular web servers available at the time of writing.

.. _project-structure.rewrite.apache:

Apache HTTP Server
^^^^^^^^^^^^^^^^^^

All examples that follow use ``mod_rewrite``, an official module that comes bundled with Apache. To use it,
``mod_rewrite`` must either be included at compile time or enabled as a Dynamic Shared Object (*DSO*). Please
consult the `Apache documentation`_ for your version for more information.

.. _project-structure.rewrite.apache.vhost:

Rewriting inside a VirtualHost
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Here is a very basic virtual host definition. These rules direct all requests to ``index.php``, except when a
matching file is found under the ``document_root``.

.. code-block:: text
   :linenos:

   <VirtualHost my.domain.com:80>
       ServerName   my.domain.com
       DocumentRoot /path/to/server/root/my.domain.com/public

       RewriteEngine off

       <Location />
           RewriteEngine On
           RewriteCond %{REQUEST_FILENAME} -s [OR]
           RewriteCond %{REQUEST_FILENAME} -l [OR]
           RewriteCond %{REQUEST_FILENAME} -d
           RewriteRule ^ - [NC,L]
           RewriteRule ^ /index.php [NC,L]
       </Location>
   </VirtualHost>

Note the slash ("/") prefixing ``index.php``; the rules for ``.htaccess`` differ in this regard.

.. _project-structure.rewrite.apache.htaccess:

Rewriting within a .htaccess file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Below is a sample ``.htaccess`` file that utilizes ``mod_rewrite``. It is similar to the virtual host
configuration, except that it specifies only the rewrite rules, and the leading slash is omitted from
``index.php``.

.. code-block:: text
   :linenos:

   RewriteEngine On
   RewriteCond %{REQUEST_FILENAME} -s [OR]
   RewriteCond %{REQUEST_FILENAME} -l [OR]
   RewriteCond %{REQUEST_FILENAME} -d
   RewriteRule ^ - [NC,L]
   RewriteRule ^ index.php [NC,L]

There are many ways to configure ``mod_rewrite``; if you would like more information, see Jayson Minard's
`Blueprint for PHP Applications: Bootstrapping`_.

.. _project-structure.rewrite.iis:

Microsoft Internet Information Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As of version 7.0, *IIS* now ships with a standard rewrite engine. You may use the following configuration to
create the appropriate rewrite rules.

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <configuration>
       <system.webServer>
           <rewrite>
               <rules>
                   <rule name="Imported Rule 1" stopProcessing="true">
                       <match url="^.*$" />
                       <conditions logicalGrouping="MatchAny">
                           <add input="{REQUEST_FILENAME}"
                                matchType="IsFile" pattern=""
                                ignoreCase="false" />
                           <add input="{REQUEST_FILENAME}"
                                matchType="IsDirectory"
                                pattern=""
                                ignoreCase="false" />
                       </conditions>
                       <action type="None" />
                   </rule>
                   <rule name="Imported Rule 2" stopProcessing="true">
                       <match url="^.*$" />
                       <action type="Rewrite" url="index.php" />
                   </rule>
               </rules>
           </rewrite>
       </system.webServer>
   </configuration>



.. _`Service Layer`: http://www.martinfowler.com/eaaCatalog/serviceLayer.html
.. _`Userland Naming Guide`: http://www.php.net/manual/en/userlandnaming.php
.. _`Apache documentation`: http://httpd.apache.org/docs/
.. _`Blueprint for PHP Applications: Bootstrapping`: http://devzone.zend.com/400/blueprint-for-php-applications_bootstrapping-part-1/
