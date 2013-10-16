.. _zend.filter.set.realpath:

RealPath
--------

This filter will resolve given links and pathnames and returns canonicalized absolute pathnames.

.. _zend.filter.set.realpath.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\RealPath``:

- **exists**: This option defaults to ``TRUE`` which checks if the given path really exists.

.. _zend.filter.set.realpath.basic:

.. rubric:: Basic Usage

For any given link of pathname its absolute path will be returned. References to '``/./``', '``/../``' and extra
'``/``' characters in the input path will be stripped. The resulting path will not have any symbolic link,
'``/./``' or '``/../``' character.

``Zend\Filter\RealPath`` will return ``FALSE`` on failure, e.g. if the file does not exist. On *BSD* systems
``Zend\Filter\RealPath`` doesn't fail if only the last path component doesn't exist, while other systems will
return ``FALSE``.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\RealPath();
   $path   = '/www/var/path/../../mypath';
   $filtered = $filter->filter($path);

   // returns '/www/mypath'

.. _zend.filter.set.realpath.exists:

.. rubric:: Non-Existing Paths

Sometimes it is useful to get also paths when they don't exist, f.e. when you want to get the real path for a path
which you want to create. You can then either give a ``FALSE`` at initiation, or use ``setExists()`` to set it.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\RealPath(false);
   $path   = '/www/var/path/../../non/existing/path';
   $filtered = $filter->filter($path);

   // returns '/www/non/existing/path'
   // even when file_exists or realpath would return false


