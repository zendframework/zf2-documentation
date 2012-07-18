.. _learning.view.placeholders.intro:

Introduction
============

In :ref:`the previous chapter <learning.layout>`, we looked at primarily the Two Step View pattern, which allows
you to embed individual application views within a sitewide layout. At the end of that chapter, however, we
discussed some limitations:

- How do you alter the page title?

- How would you inject conditional scripts or stylesheets into the sitewide layout?

- How would you create and render an optional sidebar? What if there was some content that was unconditional, and
  other content that was conditional for the sidebar?

These questions are addressed in the `Composite View`_ design pattern. One approach to that pattern is to provide
"hints" or content to the sitewide layout. In Zend Framework, this is achieved through specialized view helpers
called "placeholders." Placeholders allow you to aggregate content, and then render that aggregate content
elsewhere.



.. _`Composite View`: http://java.sun.com/blueprints/corej2eepatterns/Patterns/CompositeView.html
