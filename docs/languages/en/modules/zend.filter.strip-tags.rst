.. _zend.filter.set.striptags:

StripTags
=========

This filter can strip XML and HTML tags from given content.

.. warning::

   Zend\\Filter\\StripTags is potentially unsecure
   ===============================================

   Be warned that Zend\Filter\StripTags should only be used to strip all available tags.

   Using Zend\Filter\StripTags to make your site secure by stripping some unwanted tags will lead 
   to unsecure and dangerous code.

   Zend\Filter\StripTags must not be used to prevent XSS attacks. This filter is no replacement for 
   using Tidy or HtmlPurifier. 

.. _zend.filter.set.striptags.options:

Supported options for Zend\\Filter\\StripTags
-------------------------------------------------

The following options are supported for ``Zend\Filter\StripTags``:

- **allowAttribs**: This option sets the attributes which are accepted. All other attributes are 
stripped from the given content.
 
- **allowTags**: This option sets the tags which are accepted. All other tags will be stripped 
from the given content.

.. _zend.filter.set.striptags.basic:

Basic usage
-----------

See the following example for the default behaviour of this filter: 

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\StripTags();

   print $filter->filter('<B>My content</B>');

As result you will get the stripped content 'My content'.

When the content contains broken or partitial tags then the complete following content will be erased.
See the following example: 

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\StripTags();

   print $filter->filter('This contains <a href="http://example.com">no ending tag');

The above will return 'This contains' with the rest being stripped.

.. _zend.filter.set.striptags.allowtags:

Allowing defined tags
---------------------

``Zend\Filter\StripTags`` allows stripping of all but defined tags. This can be used for example to
strip all tags but links from a text.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\StripTags(array('allowTags' => 'a'));
 
   $input  = "A text with <br/> a <a href='link.com'>link</a>";
   print $filter->filter($input);

The above will return 'A text with a <a href='link.com'>link</a>' as result. It strips all tags but
the link. By providing an array you can set multiple tags at once.

.. warning::

   Do not use this feature to get a probably secure content. This component does not replace the use
   of a proper configured html filter.  

.. _zend.filter.set.striptags.allowattributes:

Allowing defined attributes
---------------------------

It is also possible to strip all but allowed attributes from a tag. 

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\StripTags(array('allowAttribs' => 'src'));
 
   $input  = "A text with <br/> a <img src='picture.com' width='100'>picture</img>";
   print $filter->filter($input);

The above will return 'A text with a <img src='picture.com'>picture</img>' as result. It strips all
tags but img. Additionally from the img tag all attributes but src will be stripped. By providing an
array you can set multiple attributes at once. 
