.. _zendtool.introduction:

Zend Framework Tool (ZFTool)
============================

`ZFTool`_ is a utility module for maintaining modular Zend Framework 2 applications.
It runs from the command line and can be installed as ZF2 module or as PHAR (see below).
This tool gives you the ability to:

   - create a ZF2 project, installing a skeleton application;

   - create a new module inside an existing ZF2 application;

   - get the list of all the modules installed inside an application;

   - get the configuration file of a ZF2 application;

   - install the ZF2 library choosing a specific version.

To install the ZFTool you can use one of the following methods or you can just download
the PHAR package and use it.

Installation using `Composer`_
------------------------------

    1. Open console (command prompt)
    2. Go to your application's directory
    3. Run `php composer.phar require zendframework/zftool:dev-master`
    
`zf.php` (Zend Tool) will be installed in the `vendor/bin` folder.
You may run it with `php vendor/bin/zf.php`.

Manual installation
-------------------

    1. Clone using `git` or `download zipball`_
    2. Extract to `vendor/ZFTool` in your ZF2 application
    3. Enter the `vendor/ZFTool` folder and execute `zf.php` as reported below.

Without installation, using the PHAR file
-----------------------------------------

    1. You don't need to install ZFTool if you want just use it as a shell command.
       You can `download zftool.phar`_ and use it.

Usage
-----

From Composer or Manual install:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The `zf.php` should be installed into the `vendor/ZFTool` directory (relative to
your project root) - however, the command needs to be run from your project root
in order for it to work correctly. You can symlink `vendor/ZFTool/zf.php` to
your project root, or alternatively substitute `zf.php` for
`vendor/ZFTool/zf.php` in the examples below.

Using the PHAR:
^^^^^^^^^^^^^^^

Simply substitute `zftool.phar` for `zf.php` in the below examples.


Basic information
^^^^^^^^^^^^^^^^^

.. code-block:: bash

    > zf.php modules [list]           show loaded modules

The *modules* option gives you the list of all the modules installed in a ZF2 application.

.. code-block:: bash

    > zf.php version | --version      display current Zend Framework version

The *version* option gives you the version number of ZFTool and, if executed from the root
folder of a ZF2 application, the version number of the Zend Framework library used by the application.

Project creation
^^^^^^^^^^^^^^^^

.. code-block:: bash

    > zf.php create project <path>

    <path>              The path of the project to be created

This command installs the `ZendSkeletonApplication`_ in the specified path.

Module creation
^^^^^^^^^^^^^^^

.. code-block:: bash

    > zf.php create module <name> [<path>]

    <name>              The name of the module to be created
    <path>              The path to the root folder of the ZF2 application (optional)

This command can be used to create a new module inside an existing ZF2 application.
If the path is not provided the ZFTool try to create a new module in the local directory
(only if the local folder contains a ZF2 application).

Classmap generator
^^^^^^^^^^^^^^^^^^

.. code-block:: bash

    > zf.php classmap generate <directory> <classmap file> [--append|-a] [--overwrite|-w]

    <directory>         The directory to scan for PHP classes (use "." to use current directory)
    <classmap file>     File name for generated class map file  or - for standard output. If not supplied, defaults to
                        autoload_classmap.php inside <directory>.
    --append | -a       Append to classmap file if it exists
    --overwrite | -w    Whether or not to overwrite existing classmap file

ZF library installation
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

    > zf.php install zf <path> [<version>]

    <path>              The directory where to install the ZF2 library
    <version>           The version to install, if not specified uses the last available

This command install the specified version of the ZF2 library in a path. If the version is omitted it
will be used the last stable available. Using this command you can install all the tag version specified
in the `ZF2 github`_ repository (the name used for the version is obtained removing the *'release-'* string
from the tag name; for instance, the tag *'release-2.0.0'* is equivalent to the version number *2.0.0*).

Compile the PHAR file
^^^^^^^^^^^^^^^^^^^^^

You can create a .phar file containing the ZFTool project. In order to compile ZFTool in a .phar file you need
to execute the following command:

.. code-block:: bash

    > bin/create-phar

This command will create a *zftool.phar* file in the bin folder.
You can use and ship only this file to execute all the ZFTool functionalities.
After the *zftool.phar* creation, we suggest to add the folder bin of ZFTool in your PATH environment. In this
way you can execute the *zftool.phar* script wherever you are.

.. _`ZFTool`: https://github.com/zendframework/ZFTool
.. _`Composer`: http://getcomposer.org
.. _`download zipball`: https://github.com/zendframework/ZFTool/zipball/master
.. _`download zftool.phar`: https://packages.zendframework.com/zftool.phar
.. _`ZendSkeletonApplication`: https://github.com/zendframework/ZendSkeletonApplication
.. _`ZF2 github`: https://github.com/zendframework/zf2
