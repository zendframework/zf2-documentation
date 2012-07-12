
Installation
============

See the :ref:`requirements appendix <requirements>` for a detailed list of requirements for Zend Framework.

Installing Zend Framework is extremely simple. Once you have downloaded and extracted the framework, you should add the ``/library`` folder in the distribution to the beginning of your include path. You may also want to move the library folder to another – possibly shared – location on your file system.

Once you have a copy of Zend Framework available, your application needs to be able to access the framework classes. Though there are `several ways to achieve this`_ , your *PHP*  `include_path`_ needs to contain the path to Zend Framework's library.

Zend provides a `QuickStart`_ to get you up and running as quickly as possible. This is an excellent way to begin learning about the framework with an emphasis on real world examples that you can build upon.

Since Zend Framework components are loosely coupled, you may use a somewhat unique combination of them in your own applications. The following chapters provide a comprehensive reference to Zend Framework on a component-by-component basis.


.. _`several ways to achieve this`: http://www.php.net/manual/en/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/en/ini.core.php#ini.include-path
.. _`QuickStart`: http://framework.zend.com/docs/quickstart
