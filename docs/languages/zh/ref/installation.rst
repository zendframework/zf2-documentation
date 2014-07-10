.. _introduction.installation:

************
Installation
************

.. See the :ref:`requirements appendix <requirements>` for a detailed list of requirements for Zend Framework.

- **New to Zend Framework?** 
  `Download the latest stable release.`_ Available in ``.zip`` and ``.tar.gz`` formats.

- **Brave, cutting edge?**
  Download `Zend Framework's Git repository`_ using a `Git`_ client. Zend Framework is open source software, 
  and the Git repository used for its development is publicly available on `GitHub`_. Consider using Git to get 
  Zend Framework if you want to contribute back to the framework, or need to upgrade your framework version more 
  often than releases occur.

Once you have a copy of Zend Framework available, your application needs to be able to access the framework classes 
found in the library folder. There are `several ways to achieve this`_.

Failing to find a Zend Framework 2 installation, the following error occurs::

 Fatal error: Uncaught exception 'RuntimeException' with message
 'Unable to load ZF2. Run `php composer.phar install` or define 
 a ZF2_PATH environment variable.'

To fix that, you can add the Zend Framework's library path to the *PHP* `include_path`_.
Also, you should set an environment path named 'ZF2_PATH' in httpd.conf (or equivalent).
i.e.  ``SetEnv ZF2_PATH /var/ZF2`` running Linux.

`Rob Allen`_ has kindly provided the community with an introductory tutorial, `Getting Started with Zend Framework 2`_. 
Other Zend Framework community members are actively working on `expanding the tutorial`_.



.. _`Download the latest stable release.`: http://packages.zendframework.com/
.. _`Git`: http://git-scm.com/
.. _`GitHub`: http://github.com/
.. _`Zend Framework's Git repository`: https://github.com/zendframework/zf2
.. _`several ways to achieve this`: http://www.php.net/manual/en/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/en/ini.core.php#ini.include-path
.. _`Rob Allen`: http://akrabat.com/about
.. _`Getting Started with Zend Framework 2`: http://zf2.readthedocs.org/en/latest/user-guide/overview.html
.. _`expanding the tutorial`: http://zend-framework-community.634137.n4.nabble.com/zf2-tutorial-td4656144.html
