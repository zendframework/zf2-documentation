.. _zend.tag.introduction:

Introduction
============

``Zend_Tag`` is a component suite which provides a facility to work with taggable Items. As its base, it provides
two classes to work with Tags, ``Zend_Tag_Item`` and ``Zend_Tag_ItemList``. Additionally, it comes with the
interface ``Zend_Tag_Taggable``, which allows you to use any of your models as a taggable item in conjunction with
``Zend_Tag``.

``Zend_Tag_Item`` is a basic taggable item implementation which comes with the essential functionality required to
work with the ``Zend_Tag`` suite. A taggable item always consists of a title and a relative weight (e.g. number of
occurrences). It also stores parameters which are used by the different sub-components of ``Zend_Tag``.

To group multiple items together, ``Zend_Tag_ItemList`` exists as an array iterator and provides additional
functionality to calculate absolute weight values based on the given relative weights of each item in it.

.. _zend.tag.example.using:

.. rubric:: Using Zend_Tag

This example illustrates how to create a list of tags and spread absolute weight values on them.

.. code-block:: php
   :linenos:

   // Create the item list
   $list = new Zend_Tag_ItemList();

   // Assign tags to it
   $list[] = new Zend_Tag_Item(array('title' => 'Code', 'weight' => 50));
   $list[] = new Zend_Tag_Item(array('title' => 'Zend Framework', 'weight' => 1));
   $list[] = new Zend_Tag_Item(array('title' => 'PHP', 'weight' => 5));

   // Spread absolute values on the items
   $list->spreadWeightValues(array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));

   // Output the items with their absolute values
   foreach ($list as $item) {
       printf("%s: %d\n", $item->getTitle(), $item->getParam('weightValue'));
   }

This will output the three items Code, Zend Framework and *PHP* with the absolute values 10, 1 and 2.


