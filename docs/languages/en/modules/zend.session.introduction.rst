.. _zend.session.introduction:

Introduction
============

The Zend Framework Auth team greatly appreciates your feedback and contributions on our email list:
`fw-auth@lists.zend.com`_

With web applications written using *PHP*, a **session** represents a logical, one-to-one connection between
server-side, persistent state data and a particular user agent client (e.g., web browser). ``Zend\Session`` helps
manage and preserve session data, a logical complement of cookie data, across multiple page requests by the same
client. Unlike cookie data, session data are not stored on the client side and are only shared with the client when
server-side source code voluntarily makes the data available in response to a client request. For the purposes of
this component and documentation, the term "session data" refers to the server-side data stored in `$_SESSION`_,
managed by ``Zend\Session``, and individually manipulated by ``Zend\Session\Namespace`` accessor objects. **Session
namespaces** provide access to session data using classic `namespaces`_ implemented logically as named groups of
associative arrays, keyed by strings (similar to normal *PHP* arrays).

``Zend\Session\Namespace`` instances are accessor objects for namespaced slices of ``$_SESSION``. The
``Zend\Session`` component wraps the existing *PHP* ext/session with an administration and management interface, as
well as providing an *API* for ``Zend\Session\Namespace`` to persist session namespaces. ``Zend\Session\Namespace``
provides a standardized, object-oriented interface for working with namespaces persisted inside *PHP*'s standard
session mechanism. Support exists for both anonymous and authenticated (e.g., "login") session namespaces.
``Zend\Auth``, the authentication component of Zend Framework, uses ``Zend\Session\Namespace`` to store some
information associated with authenticated users. Since ``Zend\Session`` uses the normal *PHP* ext/session functions
internally, all the familiar configuration options and settings apply (see `http://www.php.net/session`_), with
such bonuses as the convenience of an object-oriented interface and default behavior that provides both best
practices and smooth integration with Zend Framework. Thus, a standard *PHP* session identifier, whether conveyed
by cookie or within *URL*\ s, maintains the association between a client and session state data.

The default `ext/session save handler`_ does not maintain this association for server clusters under certain
conditions because session data are stored to the filesystem of the server that responded to the request. If a
request may be processed by a different server than the one where the session data are located, then the responding
server has no access to the session data (if they are not available from a networked filesystem). A list of
additional, appropriate save handlers will be provided, when available. Community members are encouraged to suggest
and submit save handlers to the `fw-auth@lists.zend.com`_ list. A ``Zend\Db`` compatible save handler has been
posted to the list.



.. _`fw-auth@lists.zend.com`: mailto:fw-auth@lists.zend.com
.. _`$_SESSION`: http://www.php.net/manual/en/reserved.variables.php#reserved.variables.session
.. _`namespaces`: http://en.wikipedia.org/wiki/Namespace_%28computer_science%29
.. _`http://www.php.net/session`: http://www.php.net/session
.. _`ext/session save handler`: http://www.php.net/manual/en/function.session-set-save-handler.php
