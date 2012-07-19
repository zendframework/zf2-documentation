.. _learning.form.decorators.intro:

Introduction
============

:ref:`Zend_Form <zend.form>` utilizes the **decorator** pattern in order to render elements and forms. Unlike the
classic `decorator pattern`_, in which you pass an object to a wrapping class, decorators in ``Zend_Form``
implement a `strategy pattern`_, and utilize the metadata contained in an element or form in order to create a
representation of it

Don't let the terminology scare you away, however; at heart, decorators in ``Zend_Form`` are not terribly
difficult, and the mini-tutorials that follow should help you along the way. They will guide you through the basics
of decoration, all the way to creating decorators for composite elements.



.. _`decorator pattern`: http://en.wikipedia.org/wiki/Decorator_pattern
.. _`strategy pattern`: http://en.wikipedia.org/wiki/Strategy_pattern
