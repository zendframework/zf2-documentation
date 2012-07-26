.. _introduction.installation:

************
Installation
************

See the :ref:`requirements appendix <requirements>` for a detailed list of requirements for Zend Framework.

Installing Zend Framework is extremely simple. Once you have downloaded and extracted the framework, you should add
the ``/library`` folder in the distribution to the beginning of your include path. You may also want to move the
library folder to another – possibly shared – location on your file system.

- `Download the latest stable release.`_ This version, available in both ``.zip`` and ``.tar.gz`` formats, is a
  good choice for those who are new to Zend Framework.

- `Download the latest nightly snapshot.`_ For those who would brave the cutting edge, the nightly snapshots
  represent the latest progress of Zend Framework development. Snapshots are bundled with documentation either in
  English only or in all available languages. If you anticipate working with the latest Zend Framework
  developments, consider using a Subversion (*SVN*) client.

- Using a `Git`_ client. Zend Framework is open source software, and the Git repository used
  for its development is publicly available on GitHub. Consider using Git to get Zend Framework if you already use
  Git for your application development, want to contribute back to the framework, or need to upgrade your framework
  version more often than releases occur.

  The *URL* for Zend Framework's *Git* repository is:
  `https://github.com/zendframework/zf2`_

Once you have a copy of Zend Framework available, your application needs to be able to access the framework
classes. Though there are `several ways to achieve this`_, your *PHP* `include_path`_ needs to contain the path to
Zend Framework's library.

Zend provides a `QuickStart`_ to get you up and running as quickly as possible. This is an excellent way to begin
learning about the framework with an emphasis on real world examples that you can build upon.

Since Zend Framework components are loosely coupled, you may use a somewhat unique combination of them in your own
applications. The following chapters provide a comprehensive reference to Zend Framework on a
component-by-component basis.



.. _`Download the latest stable release.`: http://framework.zend.com/download/latest
.. _`Download the latest nightly snapshot.`: http://framework.zend.com/download/snapshot
.. _`Git`: http://git-scm.com/
.. _`https://github.com/zendframework/zf2`: https://github.com/zendframework/zf2
.. _`several ways to achieve this`: http://www.php.net/manual/en/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/en/ini.core.php#ini.include-path
.. _`QuickStart`: http://framework.zend.com/docs/quickstart