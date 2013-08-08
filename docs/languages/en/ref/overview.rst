.. _introduction.overview:

********
Overview
********

Zend Framework 2 is an open source framework for developing web applications and services using *PHP* 5.3+. Zend 
Framework 2 uses 100% `object-oriented`_ code and utilises most of the new features of PHP 5.3, namely 
`namespaces`_, `late static binding`_, `lambda functions and closures`_.

Zend Framework 2 evolved from Zend Framework 1, a successful PHP framework with over 15 million 
downloads. 

.. note::

    *ZF2* is not backward compatible with *ZF1*, because of the new features in PHP 5.3+ implemented by 
    the framework, and due to major rewrites of many components.

The component structure of Zend Framework 2 is unique; each component is designed with few
dependencies on other components. ZF2 follows the `SOLID`_ object-oriented design principle. This loosely coupled 
architecture allows developers to use whichever components they want. We call this a "use-at-will" design. 
We support `Pyrus`_ and `Composer`_ as installation  and dependency tracking mechanisms for the framework as a whole and 
for each component, further enhancing this design.

We use `PHPUnit`_ to test our code and `Travis CI`_ as a Continuous Integration service.

While they can be used separately, Zend Framework 2 components in the standard library form a powerful and extensible
web application framework when combined. Also, it offers a robust, high performance `MVC`_ implementation, a
database abstraction that is simple to use, and a forms component that implements `HTML5 form rendering`_,
validation, and filtering so that developers can consolidate all of these operations using one easy-to-use, object
oriented interface. Other components, such as :doc:`Zend\\Authentication <zend.authentication.intro>` and
:doc:`Zend\\Permissions\\Acl <zend.permissions.acl.intro>`, provide user authentication and authorization against 
all common credential stores. 

Still others, with the ``ZendService`` namespace, implement client libraries to simply access the most
popular web services available. Whatever your application needs are, you're likely to find a Zend Framework 2
component that can be used to dramatically reduce development time with a thoroughly tested foundation.
 
The principal sponsor of the project 'Zend Framework 2' is `Zend Technologies`_, but many companies have contributed 
components or significant features to the framework. Companies such as Google, Microsoft, and StrikeIron have 
partnered with Zend to provide interfaces to web services and other technologies they wish to make available 
to Zend Framework 2 developers.

Zend Framework 2 could not deliver and support all of these features without the help of the vibrant Zend Framework 2
community. Community members, including contributors, make themselves available on `mailing lists`_, 
`IRC channels`_ and other forums. Whatever question you have about Zend Framework 2, the community is always 
available to address it.

.. _`object-oriented`: http://en.wikipedia.org/wiki/Object-oriented_programming
.. _`namespaces`: http://php.net/manual/en/language.namespaces.php
.. _`late static binding`: http://php.net/lsb
.. _`lambda functions and closures`: http://php.net/manual/en/functions.anonymous.php
.. _`SOLID`: http://en.wikipedia.org/wiki/SOLID_%28object-oriented_design%29
.. _`Pyrus`: http://pear.php.net/manual/en/pyrus.php
.. _`Composer`: http://getcomposer.org/
.. _`PHPUnit`: http://www.phpunit.de
.. _`Travis CI`: http://travis-ci.org/
.. _`MVC`: http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller#PHP
.. _`HTML5 form rendering`: http://www.w3.org/TR/html5/forms.html#forms
.. _`Zend Technologies`: http://www.zend.com
.. _`mailing lists`: http://framework.zend.com/archives
.. _`IRC channels`: http://www.zftalk.com
