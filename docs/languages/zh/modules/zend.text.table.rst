.. _zend.text.table:

Zend\\Text\\Table
=================

.. _zend.text.table.introduction:

Introduction
------------

``Zend\Text\Table`` is a component to create text based tables on the fly with different decorators. This can be
helpful, if you either want to send structured data in text emails, which are used to have mono-spaced fonts, or to
display table information in a CLI application. ``Zend\Text\Table`` supports multi-line columns, colspan and align
as well.

.. note::

   **Encoding**

   ``Zend\Text\Table`` expects your strings to be UTF-8 encoded by default. If this is not the case, you can either
   supply the character encoding as a parameter to the ``constructor()`` or the ``setContent()`` method of
   ``Zend\Text\Table\Column``. Alternatively if you have a different encoding in the entire process, you can define
   the standard input charset with ``Zend\Text\Table\Table::setInputCharset($charset)``. In case you need another 
   output charset for the table, you can set this with ``Zend\Text\Table\Table::setOutputCharset($charset)``.

A ``Zend\Text\Table\Table`` object consists of rows, which contain columns, represented by ``Zend\Text\Table\Row``
and ``Zend\Text\Table\Column``. When creating a table, you can supply an array with options for the table. Those are:

   - ``columnWidths`` (required): An array defining all columns width their widths in characters.

   - ``decorator``: The decorator to use for the table borders. The default is **unicode**, but you may also
     specify **ascii** or give an instance of a custom decorator object.

   - ``padding``: The left and right padding withing the columns in characters. The default padding is zero.

   - ``AutoSeparate``: The way how the rows are separated with horizontal lines. The default is a separation
     between all rows. This is defined as a bitmask containing one ore more of the following constants of
     ``Zend\Text\Table``:

        - ``Zend\Text\Table\Table::AUTO_SEPARATE_NONE``

        - ``Zend\Text\Table\Table::AUTO_SEPARATE_HEADER``

        - ``Zend\Text\Table\Table::AUTO_SEPARATE_FOOTER``

        - ``Zend\Text\Table\Table::AUTO_SEPARATE_ALL``

     Where header is always the first row, and the footer is always the last row.

Rows are simply added to the table by creating a new instance of ``Zend\Text\Table\Row``, and appending it to the
table via the ``appendRow()`` method. Rows themselves have no options. You can also give an array to directly to
the ``appendRow()`` method, which then will automatically converted to a row object, containing multiple column
objects.

The same way you can add columns to the rows. Create a new instance of ``Zend\Text\Table\Column`` and then either
set the column options in the constructor or later with the ``set*()`` methods. The first parameter is the content
of the column which may have multiple lines, which in the best case are separated by just the '\\n' character. The
second parameter defines the align, which is 'left' by default and can be one of the class constants of
``Zend\Text\Table\Column``:

   - ``ALIGN_LEFT``

   - ``ALIGN_CENTER``

   - ``ALIGN_RIGHT``

The third parameter is the colspan of the column. For example, when you choose "2" as colspan, the column will span
over two columns of the table. The last parameter defines the encoding of the content, which should be supplied, if
the content is neither ASCII nor UTF-8. To append the column to the row, you simply call ``appendColumn()`` in your
row object with the column object as parameter. Alternatively you can directly give a string to the
``appendColumn()`` method.

To finally render the table, you can either use the ``render()`` method of the table, or use the magic method
``__toString()`` by doing ``echo $table;`` or ``$tableString = (string) $table``.

.. _zend.text.table.basic-usage:

Basic Usage
-----------

This example illustrates the basic use of ``Zend\Text\Table`` to create a simple table:

.. code-block:: php
   :linenos:

   $table = new Zend\Text\Table\Table(array('columnWidths' => array(10, 20)));

   // Either simple
   $table->appendRow(array('Zend', 'Framework'));

   // Or verbose
   $row = new Zend\Text\Table\Row();

   $row->appendColumn(new Zend\Text\Table\Column('Zend'));
   $row->appendColumn(new Zend\Text\Table\Column('Framework'));

   $table->appendRow($row);

   echo $table;

This will result in the following output:

.. code-block:: text
   :linenos:

   ┌──────────┬────────────────────┐
   │Zend      │Framework           │
   |──────────|────────────────────|
   │Zend      │Framework           │
   └──────────┴────────────────────┘

