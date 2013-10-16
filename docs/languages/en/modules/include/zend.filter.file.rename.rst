.. _zend.filter.file.rename:

Rename
------

``Zend\Filter\File\Rename`` can be used to rename a file and/or move a
file to a new path.

.. _zend.filter.file.rename.options:

.. rubric:: Supported Options

The following set of options are supported:

- **target** ``(string) default: "*"``
   Target filename or directory, the new name of the source file.
- **source** ``(string) default: "*"``
   Source filename or directory which will be renamed.

   Used to match the filtered file with an options set.
- **overwrite** ``(boolean) default: false``
   Shall existing files be overwritten?

   If the file is unable to be moved into the target path, a
   ``Zend\Filter\Exception\RuntimeException`` will be thrown.
- **randomize** ``(boolean) default: false``
   Shall target files have a random postfix attached? The random postfix will be
   a ``uniqid('_')`` after the file name and before the extension.

   For example, ``"file.txt"`` will be randomized to ``"file_4b3403665fea6.txt"``

An array of option sets is also supported, where a single ``Rename`` filter
instance can filter several files using different options. The options used
for the filtered file will be matched from the ``source`` option in the
options set.

.. _zend.filter.file.rename.usage:

.. rubric:: Usage Examples

Move all filtered files to a different directory:

.. code-block:: php
   :linenos:

   // 'target' option is assumed if param is a string
   $filter = \Zend\Filter\File\Rename("/tmp/");
   echo $filter->filter("./myfile.txt");
   // File has been moved to "/tmp/myfile.txt"

Rename all filtered files to a new name:

.. code-block:: php
   :linenos:

   $filter = \Zend\Filter\File\Rename("/tmp/newfile.txt");
   echo $filter->filter("./myfile.txt");
   // File has been renamed to "/tmp/newfile.txt"

Move to a new path and randomize file names:

.. code-block:: php
   :linenos:

   $filter = \Zend\Filter\File\Rename(array(
       "target"    => "/tmp/newfile.txt",
       "randomize" => true,
   ));
   echo $filter->filter("./myfile.txt");
   // File has been renamed to "/tmp/newfile_4b3403665fea6.txt"

Configure different options for several possible source files:

.. code-block:: php
   :linenos:

   $filter = \Zend\Filter\File\Rename(array(
       array(
           "source"    => "fileA.txt"
           "target"    => "/dest1/newfileA.txt",
           "overwrite" => true,
       ),
       array(
           "source"    => "fileB.txt"
           "target"    => "/dest2/newfileB.txt",
           "randomize" => true,
       ),
   ));
   echo $filter->filter("fileA.txt");
   // File has been renamed to "/dest1/newfileA.txt"
   echo $filter->filter("fileB.txt");
   // File has been renamed to "/dest2/newfileB_4b3403665fea6.txt"


.. _zend.filter.file.rename.methods:

.. rubric:: Public Methods

The specific public methods for the ``Rename`` filter, besides the common ``filter()`` method, are as follows:

.. function:: getFile()
   :noindex:

   Returns the files to rename and their new name and location

   :rtype: ``array``

.. function:: setFile(string|array $options)
   :noindex:

   Sets the file options for renaming. Removes any previously set file options.

   :param $options: See :ref:`Supported Options <zend.filter.file.rename.options>` section for more information.

.. function:: addFile(string|array $options)
   :noindex:

   Adds file options for renaming to the current list of file options.

   :param $options: See :ref:`Supported Options <zend.filter.file.rename.options>` section for more information.

