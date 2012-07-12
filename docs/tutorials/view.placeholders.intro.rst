
Introduction
============

In :ref:`the previous chapter <learning.layout>` , we looked at primarily the Two Step View pattern, which allows you to embed individual application views within a sitewide layout. At the end of that chapter, however, we discussed some limitations:

These questions are addressed in the `Composite View`_ design pattern. One approach to that pattern is to provide "hints" or content to the sitewide layout. In Zend Framework, this is achieved through specialized view helpers called "placeholders." Placeholders allow you to aggregate content, and then render that aggregate content elsewhere.


.. _`Composite View`: http://java.sun.com/blueprints/corej2eepatterns/Patterns/CompositeView.html
