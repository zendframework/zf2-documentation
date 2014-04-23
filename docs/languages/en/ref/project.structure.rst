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

The project structure below is the one used by the Zend Framework skeleton application, and is designed to be
maximally extensible for complex projects, while providing a simple subset of folders and files for project with
simpler requirements.

.. _project-structure.project:

Recommended Project Directory Structure
---------------------------------------

.. code-block:: text
   :linenos:

   <project name>/
       config/
           autoload/
               global.php
               local.php
           application.config.php
       data/
           cache/
       module/
           Application/
       public/
           css/
           images/
           js/
           .htaccess
           index.php
       vendor/

The following describes the use cases for each directory as listed.

- **config/**: The application-wide configuration directory.

  - **autoload/**: Configuration files in this folder are automatically read and merged with the main
    configuration.

- **module/**: The application's modules, see the :ref:`Zend\\ModuleManager <zend.module-manager.intro>`
  documentation for details. Note that modules can also be loaded from other folders (such as ``vendor/``).

- **data/**: This directory provides a place to store application data that is volatile and possibly temporary. The
  disturbance of data in this directory might cause the application to fail. Also, the information in this
  directory may or may not be committed to source control.

  - **cache/**: For cache files when using the ``Zend\Cache`` Filesystem adapter.

- **public/**: This directory contains all public files for your application. ``index.php`` sets up and invokes
  ``Zend\Mvc\Application``. The web root of your web server would typically be set to this directory.

- **vendor/**: This directory is for libraries on which the application depends, including Zend Framework itself.
  Typically the contents of this directory are setup and managed by `Composer`_, but git submodules can be used
  instead.

.. _`Composer`: https://getcomposer.org/
