.. _user-guide.overview:

Getting Started with Zend Framework 2
=====================================

This tutorial is intended to give an introduction to using Zend Framework 2 by
creating a simple database driven application using the Model-View-Controller
paradigm. By the end you will have a working ZF2 application and you can then
poke around the code to find out more about how it all works and fits together.

.. _user-guide.overview.assumptions:

Some assumptions
----------------

This tutorial assumes that you are running at least PHP 5.4.0 with the Apache web server
and MySQL, accessible via the PDO extension. Your Apache installation must have
the mod_rewrite extension installed and configured.

You must also ensure that Apache is configured to support ``.htaccess`` files. This is
usually done by changing the setting:

.. code-block:: apache
   :linenos:

    AllowOverride None

to

.. code-block:: apache
   :linenos:

    AllowOverride FileInfo

in your ``httpd.conf`` file. Check with your distribution’s documentation for
exact details. You will not be able to navigate to any page other than the home
page in this tutorial if you have not configured mod_rewrite and .htaccess usage
correctly.

.. note::

   Alternatively, if you are using PHP 5.4+ you may use the built-in web server instead of Apache for development.

The tutorial application
------------------------

The application that we are going to build is a simple inventory system to
display which albums we own. The main page will list our collection and allow us
to add, edit and delete CDs. We are going to need four pages in our website:

+----------------+------------------------------------------------------------+
| Page           | Description                                                |
+================+============================================================+
| List of albums | This will display the list of albums and provide links to  |
|                | edit and delete them. Also, a link to enable adding new    |
|                | albums will be provided.                                   |
+----------------+------------------------------------------------------------+
| Add new album  | This page will provide a form for adding a new album.      |
+----------------+------------------------------------------------------------+
| Edit album     | This page will provide a form for editing an album.        |
+----------------+------------------------------------------------------------+
| Delete album   | This page will confirm that we want to delete an album and |
|                | then delete it.                                            |
+----------------+------------------------------------------------------------+

We will also need to store our data into a database. We will only need one table
with these fields in it:

+------------+--------------+-------+-----------------------------+
| Field name | Type         | Null? | Notes                       |
+============+==============+=======+=============================+
| id         | integer      | No    | Primary key, auto-increment |
+------------+--------------+-------+-----------------------------+
| artist     | varchar(100) | No    |                             |
+------------+--------------+-------+-----------------------------+
| title      | varchar(100) | No    |                             |
+------------+--------------+-------+-----------------------------+

