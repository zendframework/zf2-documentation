.. _zend.filter.set.compress:

Compress and Decompress
-----------------------

These two filters are capable of compressing and decompressing strings, files, and directories.

.. _zend.filter.set.compress.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\Compress`` and ``Zend\Filter\Decompress``:

- **adapter**: The compression adapter which should be used. It defaults to ``Gz``.

- **options**: Additional options which are given to the adapter at initiation. Each adapter supports it's own
  options.

.. _zend.filter.set.compress.basic:

.. rubric:: Supported Compression Adapters

The following compression formats are supported by their own adapter:

- **Bz2**

- **Gz**

- **Lzf**

- **Rar**

- **Tar**

- **Zip**

Each compression format has different capabilities as described below. All compression filters may be used in
approximately the same ways, and differ primarily in the options available and the type of compression they offer
(both algorithmically as well as string vs. file vs. directory)

.. _zend.filter.set.compress.generic:

.. rubric:: Generic Handling

To create a compression filter you need to select the compression format you want to use. The following description
takes the **Bz2** adapter. Details for all other adapters are described after this section.

The two filters are basically identical, in that they utilize the same backends. ``Zend\Filter\Compress`` should be
used when you wish to compress items, and ``Zend\Filter\Decompress`` should be used when you wish to decompress
items.

For instance, if we want to compress a string, we have to initiate ``Zend\Filter\Compress`` and indicate the
desired adapter.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Compress('Bz2');

To use a different adapter, you simply specify it to the constructor.

You may also provide an array of options or a Traversable object. If you do, provide minimally the key "adapter",
and then either the key "options" or "adapterOptions" (which should be an array of options to provide to the
adapter on instantiation).

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Compress(array(
       'adapter' => 'Bz2',
       'options' => array(
           'blocksize' => 8,
       ),
   ));

.. note::

   **Default compression Adapter**

   When no compression adapter is given, then the **Gz** adapter will be used.

Almost the same usage is we want to decompress a string. We just have to use the decompression filter in this case.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Decompress('Bz2');

To get the compressed string, we have to give the original string. The filtered value is the compressed version of
the original string.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Compress('Bz2');
   $compressed = $filter->filter('Uncompressed string');
   // Returns the compressed string

Decompression works the same way.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Decompress('Bz2');
   $compressed = $filter->filter('Compressed string');
   // Returns the uncompressed string

.. note::

   **Note on string compression**

   Not all adapters support string compression. Compression formats like **Rar** can only handle files and
   directories. For details, consult the section for the adapter you wish to use.

.. _zend.filter.set.compress.archive:

.. rubric:: Creating an Archive

Creating an archive file works almost the same as compressing a string. However, in this case we need an additional
parameter which holds the name of the archive we want to create.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Compress(array(
       'adapter' => 'Bz2',
       'options' => array(
           'archive' => 'filename.bz2',
       ),
   ));
   $compressed = $filter->filter('Uncompressed string');
   // Returns true on success and creates the archive file

In the above example the uncompressed string is compressed, and is then written into the given archive file.

.. note::

   **Existing archives will be overwritten**

   The content of any existing file will be overwritten when the given filename of the archive already exists.

When you want to compress a file, then you must give the name of the file with its path.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Compress(array(
       'adapter' => 'Bz2',
       'options' => array(
           'archive' => 'filename.bz2'
       ),
   ));
   $compressed = $filter->filter('C:\temp\compressme.txt');
   // Returns true on success and creates the archive file

You may also specify a directory instead of a filename. In this case the whole directory with all its files and
subdirectories will be compressed into the archive.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Compress(array(
       'adapter' => 'Bz2',
       'options' => array(
           'archive' => 'filename.bz2'
       ),
   ));
   $compressed = $filter->filter('C:\temp\somedir');
   // Returns true on success and creates the archive file

.. note::

   **Do not compress large or base directories**

   You should never compress large or base directories like a complete partition. Compressing a complete partition
   is a very time consuming task which can lead to massive problems on your server when there is not enough space
   or your script takes too much time.

.. _zend.filter.set.compress.decompress:

.. rubric:: Decompressing an Archive

Decompressing an archive file works almost like compressing it. You must specify either the ``archive`` parameter,
or give the filename of the archive when you decompress the file.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Decompress('Bz2');
   $decompressed = $filter->filter('filename.bz2');
   // Returns true on success and decompresses the archive file

Some adapters support decompressing the archive into another subdirectory. In this case you can set the ``target``
parameter.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Decompress(array(
       'adapter' => 'Zip',
       'options' => array(
           'target' => 'C:\temp',
       )
   ));
   $decompressed = $filter->filter('filename.zip');
   // Returns true on success and decompresses the archive file
   // into the given target directory

.. note::

   **Directories to extract to must exist**

   When you want to decompress an archive into a directory, then that directory must exist.

.. _zend.filter.set.compress.bz2:

.. rubric:: Bz2 Adapter

The Bz2 Adapter can compress and decompress:

- Strings

- Files

- Directories

This adapter makes use of *PHP*'s Bz2 extension.

To customize compression, this adapter supports the following options:

- **Archive**: This parameter sets the archive file which should be used or created.

- **Blocksize**: This parameter sets the blocksize to use. It can be from '0' to '9'. The default value is '4'.

All options can be set at instantiation or by using a related method. For example, the related methods for
'Blocksize' are ``getBlocksize()`` and ``setBlocksize()``. You can also use the ``setOptions()`` method which
accepts all options as array.

.. _zend.filter.set.compress.gz:

.. rubric:: Gz Adapter

The Gz Adapter can compress and decompress:

- Strings

- Files

- Directories

This adapter makes use of *PHP*'s Zlib extension.

To customize the compression this adapter supports the following options:

- **Archive**: This parameter sets the archive file which should be used or created.

- **Level**: This compression level to use. It can be from '0' to '9'. The default value is '9'.

- **Mode**: There are two supported modes. 'compress' and 'deflate'. The default value is 'compress'.

All options can be set at initiation or by using a related method. For example, the related methods for 'Level' are
``getLevel()`` and ``setLevel()``. You can also use the ``setOptions()`` method which accepts all options as array.

.. _zend.filter.set.compress.lzf:

.. rubric:: Lzf Adapter

The Lzf Adapter can compress and decompress:

- Strings

.. note::

   **Lzf supports only strings**

   The Lzf adapter can not handle files and directories.

This adapter makes use of *PHP*'s Lzf extension.

There are no options available to customize this adapter.

.. _zend.filter.set.compress.rar:

.. rubric:: Rar Adapter

The Rar Adapter can compress and decompress:

- Files

- Directories

.. note::

   **Rar does not support strings**

   The Rar Adapter can not handle strings.

This adapter makes use of *PHP*'s Rar extension.

.. note::

   **Rar compression not supported**

   Due to restrictions with the Rar compression format, there is no compression available for free. When you want
   to compress files into a new Rar archive, you must provide a callback to the adapter that can invoke a Rar
   compression program.

To customize the compression this adapter supports the following options:

- **Archive**: This parameter sets the archive file which should be used or created.

- **Callback**: A callback which provides compression support to this adapter.

- **Password**: The password which has to be used for decompression.

- **Target**: The target where the decompressed files will be written to.

All options can be set at instantiation or by using a related method. For example, the related methods for 'Target'
are ``getTarget()`` and ``setTarget()``. You can also use the ``setOptions()`` method which accepts all options as
array.

.. _zend.filter.set.compress.tar:

.. rubric:: Tar Adapter

The Tar Adapter can compress and decompress:

- Files

- Directories

.. note::

   **Tar does not support strings**

   The Tar Adapter can not handle strings.

This adapter makes use of *PEAR*'s ``Archive_Tar`` component.

To customize the compression this adapter supports the following options:

- **Archive**: This parameter sets the archive file which should be used or created.

- **Mode**: A mode to use for compression. Supported are either '``NULL``' which means no compression at all, 'Gz'
  which makes use of *PHP*'s Zlib extension and 'Bz2' which makes use of *PHP*'s Bz2 extension. The default value
  is '``NULL``'.

- **Target**: The target where the decompressed files will be written to.

All options can be set at instantiation or by using a related method. For example, the related methods for 'Target'
are ``getTarget()`` and ``setTarget()``. You can also use the ``setOptions()`` method which accepts all options as
array.

.. note::

   **Directory usage**

   When compressing directories with Tar then the complete file path is used. This means that created Tar files
   will not only have the subdirectory but the complete path for the compressed file.

.. _zend.filter.set.compress.zip:

.. rubric:: Zip Adapter

The Zip Adapter can compress and decompress:

- Strings

- Files

- Directories

.. note::

   **Zip does not support string decompression**

   The Zip Adapter can not handle decompression to a string; decompression will always be written to a file.

This adapter makes use of *PHP*'s ``Zip`` extension.

To customize the compression this adapter supports the following options:

- **Archive**: This parameter sets the archive file which should be used or created.

- **Target**: The target where the decompressed files will be written to.

All options can be set at instantiation or by using a related method. For example, the related methods for 'Target'
are ``getTarget()`` and ``setTarget()``. You can also use the ``setOptions()`` method which accepts all options as
array.


