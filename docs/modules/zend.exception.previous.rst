
Previous Exceptions
===================

Since Zend Framework 1.10, ``Zend_Exception`` implements the *PHP* 5.3 support for previous exceptions. Simply put, when in a ``catch()`` block, you can throw a new exception that references the original exception, which helps provide additional context when debugging. By providing this support in Zend Framework, your code may now be forwards compatible with *PHP* 5.3.

Previous exceptions are indicated as the third argument to an exception constructor.


