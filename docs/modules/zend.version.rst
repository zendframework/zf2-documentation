
Getting the Zend Framework Version
==================================

``Zend_Version`` provides a class constant ``Zend_Version::VERSION`` that contains a string identifying the version number of your Zend Framework installation. ``Zend_Version::VERSION`` might contain "1.7.4", for example.

The static method ``Zend_Version::compareVersion($version)`` is based on the *PHP* function `version_compare()`_ . This method returns -1 if the specified version is older than the installed Zend Framework version, 0 if they are the same and +1 if the specified version is newer than the version of the Zend Framework installation.

The static method ``Zend_Version::getLatest()`` provides the version number of the last stable release available for download on the site `Zend Framework`_ .


.. _`version_compare()`: http://php.net/version_compare
.. _`Zend Framework`: http://framework.zend.com/download/latest
