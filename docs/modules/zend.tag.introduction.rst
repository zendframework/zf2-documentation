
Introduction
============

``Zend_Tag`` is a component suite which provides a facility to work with taggable Items. As its base, it provides two classes to work with Tags, ``Zend_Tag_Item`` and ``Zend_Tag_ItemList`` . Additionally, it comes with the interface ``Zend_Tag_Taggable`` , which allows you to use any of your models as a taggable item in conjunction with ``Zend_Tag`` .

``Zend_Tag_Item`` is a basic taggable item implementation which comes with the essential functionality required to work with the ``Zend_Tag`` suite. A taggable item always consists of a title and a relative weight (e.g. number of occurrences). It also stores parameters which are used by the different sub-components of ``Zend_Tag`` .

To group multiple items together, ``Zend_Tag_ItemList`` exists as an array iterator and provides additional functionality to calculate absolute weight values based on the given relative weights of each item in it.


