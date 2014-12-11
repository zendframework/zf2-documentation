.. _learning.autoloading.intro:

Introduction
============

Autoloading is a mechanism that eliminates the need to manually require dependencies within your *PHP* code. Per
`the PHP autoload manual`_, once an autoloader has been defined, it "is automatically called in case you are trying
to use a class or an interface which hasn't been defined yet."

Using autoloading, you do not need to worry about **where** a class exists in your project. With well-defined
autoloaders, you do not need to worry about where a class file is relative to the current class file; you simply
use the class, and the autoloader will perform the file lookup.

Additionally, autoloading, because it defers loading to the last possible moment and ensures that a match only has
to occur once, can be a huge performance boost -- particularly if you take the time to strip out ``require_once()``
calls before you move to deployment.

Zend Framework encourages the use of autoloading, and provides several tools to provide autoloading of both library
code as well as application code. This tutorial covers these tools, as well as how to use them effectively.



.. _`the PHP autoload manual`: http://php.net/autoload
