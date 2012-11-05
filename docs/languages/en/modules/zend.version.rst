.. _zend.version.reading:

Getting the Zend Framework Version
==================================

``Zend\Version`` provides a class constant ``Zend\Version\Version::VERSION`` that contains a string identifying the version
number of your Zend Framework installation. ``Zend\Version\Version::VERSION`` might contain "1.7.4", for example.

The static method ``Zend\Version\Version::compareVersion($version)`` is based on the *PHP* function `version_compare()`_.
This method returns -1 if the specified version is older than the installed Zend Framework version, 0 if they are
the same and +1 if the specified version is newer than the version of the Zend Framework installation.

.. _zend.version.reading.example:

.. rubric:: Example of the compareVersion() Method

.. code-block:: php
   :linenos:

   // returns -1, 0 or 1
   $cmp = Zend\Version\Version::compareVersion('2.0.0');

The static method ``Zend\Version\Version::getLatest()`` provides the version number of the last stable release available
for download on the site `Zend Framework`_.

.. _zend.version.latest.example:

.. rubric:: Example of the getLatest() Method

.. code-block:: php
   :linenos:

   // returns 1.11.0 (or a later version)
   echo Zend\Version\Version::getLatest();



.. _`version_compare()`: http://php.net/version_compare
.. _`Zend Framework`: http://framework.zend.com/download/latest
