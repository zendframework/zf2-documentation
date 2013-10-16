.. _zend.filter.file.rename-upload:

RenameUpload
------------

``Zend\Filter\File\RenameUpload`` can be used to rename or move an uploaded file
to a new path.

.. _zend.filter.file.rename-upload.options:

.. rubric:: Supported Options

The following set of options are supported:

- **target** ``(string) default: "*"``
   Target directory or full filename path.
- **overwrite** ``(boolean) default: false``
   Shall existing files be overwritten?

   If the file is unable to be moved into the target path, a
   ``Zend\Filter\Exception\RuntimeException`` will be thrown.
- **randomize** ``(boolean) default: false``
   Shall target files have a random postfix attached? The random postfix will be
   a ``uniqid('_')`` after the file name and before the extension.

   For example, ``"file.txt"`` will be randomized to ``"file_4b3403665fea6.txt"``
- **use_upload_name** ``(boolean) default: false``
   When true, this filter will use the $_FILES['name'] as the target filename.
   Otherwise, the default ``target`` rules and the ``$_FILES['tmp_name']`` will be used.

- **use_upload_extension** ``(boolean) default: false``
    When true, the uploaded file will maintains its original extension if not
    specified.

    For example, if the uploaded file is ``"file.txt"`` and the target is something
    like ``"mynewfile"``, the upload will be renamed to ``"mynewfile.txt"``.

.. warning::

   Be **very** careful when using the ``use_upload_name`` option. For instance,
   extremely bad things could happen if you were to allow uploaded ``.php`` files
   (or other CGI files) to be moved into the ``DocumentRoot``.

   It is generally a better idea to supply an internal filename to avoid security risks.

``RenameUpload`` does not support an array of options like the``Rename`` filter.
When filtering HTML5 file uploads with the ``multiple`` attribute set, all files will
be filtered with the same option settings.

.. _zend.filter.file.rename-upload.usage:

.. rubric:: Usage Examples

Move all filtered files to a different directory:

.. code-block:: php
   :linenos:

   use Zend\Http\PhpEnvironment\Request;

   $request = new Request();
   $files   = $request->getFiles();
   // i.e. $files['my-upload']['tmp_name'] === '/tmp/php5Wx0aJ'
   // i.e. $files['my-upload']['name'] === 'myfile.txt'

   // 'target' option is assumed if param is a string
   $filter = \Zend\Filter\File\RenameUpload("./data/uploads/");
   echo $filter->filter($files['my-upload']);
   // File has been moved to "./data/uploads/php5Wx0aJ"

   // ... or retain the uploaded file name
   $filter->setUseUploadName(true);
   echo $filter->filter($files['my-upload']);
   // File has been moved to "./data/uploads/myfile.txt"


Rename all filtered files to a new name:

.. code-block:: php
   :linenos:

   use Zend\Http\PhpEnvironment\Request;

   $request = new Request();
   $files   = $request->getFiles();
   // i.e. $files['my-upload']['tmp_name'] === '/tmp/php5Wx0aJ'

   $filter = \Zend\Filter\File\Rename("./data/uploads/newfile.txt");
   echo $filter->filter($files['my-upload']);
   // File has been renamed to "./data/uploads/newfile.txt"

Move to a new path and randomize file names:

.. code-block:: php
   :linenos:

   use Zend\Http\PhpEnvironment\Request;

   $request = new Request();
   $files   = $request->getFiles();
   // i.e. $files['my-upload']['tmp_name'] === '/tmp/php5Wx0aJ'

   $filter = \Zend\Filter\File\Rename(array(
       "target"    => "./data/uploads/newfile.txt",
       "randomize" => true,
   ));
   echo $filter->filter($files['my-upload']);
   // File has been renamed to "./data/uploads/newfile_4b3403665fea6.txt"

