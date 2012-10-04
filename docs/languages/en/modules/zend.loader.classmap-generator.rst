.. _zend.loader.classmap-generator:

The Class Map Generator utility: bin/classmap_generator.php
===========================================================

.. _zend.loader.classmap-generator.intro:

Overview
--------

The script ``bin/classmap_generator.php`` can be used to generate class map files for use with :ref:`the
ClassMapAutoloader <zend.loader.class-map-autoloader>`.

Internally, it consumes both :ref:`Zend\\Console\\Getopt <zend.console.getopt>` (for parsing command-line options)
and :ref:`Zend\\File\\ClassFileLocator <zend.file.class-file-locator>` for recursively finding all PHP class files
in a given tree.

.. _zend.loader.classmap-generator.quick-start:

Quick Start
-----------

You may run the script over any directory containing source code. By default, it will look in the current
directory, and will write the script to ``autoloader_classmap.php`` in the directory you specify.

.. code-block:: sh
   :linenos:

   php classmap_generator.php Some/Directory/

.. _zend.loader.classmap-generator.options:

Configuration Options
---------------------

.. rubric:: Class Map Generator Options

**--help or -h**
   Returns the usage message. If any other options are provided, they will be ignored.

**--library or -l**
   Expects a single argument, a string specifying the library directory to parse. If this option is not specified,
   it will assume the current working directory.

**--output or -o**
   Where to write the autoload class map file. If not provided, assumes "autoload_classmap.php" in the library directory.

**--append or -a**
   Append to autoload file if it exists.

**--overwrite or -w**
   If an autoload class map file already exists with the name as specified via the ``--output`` option, you can
   overwrite it by specifying this flag. Otherwise, the script will not write the class map and return a warning.


