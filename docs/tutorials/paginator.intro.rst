
.. _learning.paginator.intro:

Introduction
============

Let's say you're creating a blogging application that will be home to your vast collection of blog posts. There is a good chance that you do not want all of your blog posts to appear on one single page when someone visits your blog. An obvious solution would be to only display a small number of blog posts on the screen at a time, and allow the user to browse through the different pages, much like your favorite search engine shows you the result of your search query. ``Zend_Paginator`` is designed to help you achieve the goal of dividing collections of data in smaller, more manageable sets more easily, with more consistency, and with less duplicate code.

``Zend_Paginator`` uses Adapters to support various data sources and ScrollingStyles to support various methods of showing the user which pages are available. In later sections of this text we will have a closer look at what these things are and how they can help you to make the most out of ``Zend_Paginator``.

Before going in-depth, we will have a look at some simple examples first. After these simple examples, we will see how ``Zend_Paginator`` supports the most common use-case; paginating database results.

This introduction has given you a quick overview of ``Zend_Paginator``. To get started and to have a look at some code snippets, let's have a look at some simple examples.


