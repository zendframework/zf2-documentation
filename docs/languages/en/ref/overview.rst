.. _introduction.overview:

********
Overview
********

Zend Framework 2 is an open source framework for developing web applications and services with *PHP* 5.3+. Zend
Framework 2 is implemented using 100% object-oriented code and uses most of the new features of PHP 5.3 such as
`namespaces`_, `late static binding`_, `lambda functions and closures`_.

Zend Framework 2 is the evolution of Zend Framework 1 a successfully PHP framework with more than 15 million of
downloads. Because we used the new features of the PHP 5.3, *ZF2* is not backward compatible with *ZF1* that
requires PHP 5.2. We also tested *ZF2* on PHP 5.4 and it works fine but we decided to have PHP 5.3 as requirement.

The component structure of Zend Framework 2 is somewhat unique; each component is designed with few
dependencies on other components. During the implementation we followed the `SOLID`_ object oriented design
principle. This loosely coupled architecture allows developers to use components individually (we support `Pyrus`_
and `Composer`_). We often call this a "use-at-will" design.

While they can be used separately, Zend Framework components in the standard library form a powerful and extensible
web application framework when combined. Zend Framework offers a robust, high performance *MVC* implementation, a
database abstraction that is simple to use, and a forms component that implements *HTML* form rendering,
validation, and filtering so that developers can consolidate all of these operations using one easy-to-use, object
oriented interface. Other components, such as ``Zend\Authentication`` and ``Zend\Permissions\Acl``, provide user
authentication and authorization against all common credential stores. 

Still others, with the ``ZendService`` namespace, implement client libraries to simply access to the most
popular web services available. Whatever your application needs are, you're likely to find a Zend Framework
component that can be used to dramatically reduce development time with a thoroughly tested foundation.
We use `PHPUnit`_ to test our code and `Travis CI`_ as continuous integration service.
 
The principal sponsor of the project 'Zend Framework' is `Zend Technologies`_, but many companies have contributed
components or significant features to the framework. Companies such as Google, Microsoft, and StrikeIron have
partnered with Zend to provide interfaces to web services and other technologies that they wish to make available
to Zend Framework developers.

Zend Framework could not deliver and support all of these features without the help of the vibrant Zend Framework
community. Community members, including contributors, make themselves available on `mailing lists`_, `IRC
channels`_, and other forums. Whatever question you have about Zend Framework, the community is always available to
address it.

.. _`namespaces`: http://php.net/manual/en/language.namespaces.php
.. _`late static binding`: http://it.php.net/lsb
.. _`lambda functions and closures`: http://it2.php.net/manual/en/functions.anonymous.php
.. _`SOLID`: http://en.wikipedia.org/wiki/SOLID_%28object-oriented_design%29
.. _`Pyrus`: http://pear.php.net/manual/en/pyrus.php
.. _`Composer`: http://getcomposer.org/
.. _`PHPUnit`: http://www.phpunit.de
.. _`Travis CI`: http://travis-ci.org/
.. _`Zend Technologies`: http://www.zend.com
.. _`mailing lists`: http://framework.zend.com/archives
.. _`IRC channels`: http://www.zftalk.com
