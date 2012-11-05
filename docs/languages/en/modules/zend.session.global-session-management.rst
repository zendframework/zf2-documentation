.. _zend.session.global_session_management:

Global Session Management
=========================

The default behavior of sessions can be modified using the static methods of ``Zend\Session``. All management and
manipulation of global session management occurs using ``Zend\Session``, including configuration of the `usual
options provided by ext/session`_, using ``Zend\Session\Session::setOptions()``. For example, failure to insure the use of
a safe *save_path* or a unique cookie name by ext/session using ``Zend\Session\Session::setOptions()`` may result in
security issues.

.. _zend.session.global_session_management.configuration_options:

Configuration Options
---------------------

When the first session namespace is requested, ``Zend\Session`` will automatically start the *PHP* session, unless
already started with :ref:`Zend\Session\Session::start() <zend.session.advanced_usage.starting_a_session>`. The underlying
*PHP* session will use defaults from ``Zend\Session``, unless modified first by ``Zend\Session\Session::setOptions()``.

To set a session configuration option, include the basename (the part of the name after "*session.*") as a key of
an array passed to ``Zend\Session\Session::setOptions()``. The corresponding value in the array is used to set the session
option value. If no options are set by the developer, ``Zend\Session`` will utilize recommended default options
first, then the default php.ini settings. Community feedback about best practices for these options should be sent
to `fw-auth@lists.zend.com`_.

.. _zend.session.global_session_management.setoptions.example:

.. rubric:: Using Zend\Config to Configure Zend\Session

To configure this component using :ref:`Zend\Config\Ini <zend.config.adapters.ini>`, first add the configuration
options to the *INI* file:

.. code-block:: ini
   :linenos:

   ; Accept defaults for production
   [production]
   ; bug_compat_42
   ; bug_compat_warn
   ; cache_expire
   ; cache_limiter
   ; cookie_domain
   ; cookie_lifetime
   ; cookie_path
   ; cookie_secure
   ; entropy_file
   ; entropy_length
   ; gc_divisor
   ; gc_maxlifetime
   ; gc_probability
   ; hash_bits_per_character
   ; hash_function
   ; name should be unique for each PHP application sharing the same
   ; domain name
   name = UNIQUE_NAME
   ; referer_check
   ; save_handler
   ; save_path
   ; serialize_handler
   ; use_cookies
   ; use_only_cookies
   ; use_trans_sid

   ; remember_me_seconds = <integer seconds>
   ; strict = on|off

   ; Development inherits configuration from production, but overrides
   ; several values
   [development : production]
   ; Don't forget to create this directory and make it rwx (readable and
   ; modifiable) by PHP.
   save_path = /home/myaccount/zend_sessions/myapp
   use_only_cookies = on
   ; When persisting session id cookies, request a TTL of 10 days
   remember_me_seconds = 864000

Next, load the configuration file and pass its array representation to ``Zend\Session\Session::setOptions()``:

.. code-block:: php
   :linenos:

   $config = new Zend\Config\Ini('myapp.ini', 'development');

   Zend\Session\Session::setOptions($config->toArray());

Most options shown above need no explanation beyond that found in the standard *PHP* documentation, but those of
particular interest are noted below.



   - boolean *strict*- disables automatic starting of ``Zend\Session`` when using *new Zend\Session\Namespace()*.

   - integer *remember_me_seconds*- how long should session id cookie persist, after user agent has ended (e.g.,
     browser application terminated).

   - string *save_path*- The correct value is system dependent, and should be provided by the developer using an
     **absolute path** to a directory readable and writable by the *PHP* process. If a writable path is not
     supplied, then ``Zend\Session`` will throw an exception when started (i.e., when ``start()`` is called).

     .. note::

        **Security Risk**

        If the path is readable by other applications, then session hijacking might be possible. if the path is
        writable by other applications, then `session poisoning`_ might be possible. If this path is shared with
        other users or other *PHP* applications, various security issues might occur, including theft of session
        content, hijacking of sessions, and collision of garbage collection (e.g., another user's application might
        cause *PHP* to delete your application's session files).

        For example, an attacker can visit the victim's website to obtain a session cookie. Then, he edits the
        cookie path to his own domain on the same server, before visiting his own website to execute
        ``var_dump($_SESSION)``. Armed with detailed knowledge of the victim's use of data in their sessions, the
        attacker can then modify the session state (poisoning the session), alter the cookie path back to the
        victim's website, and then make requests from the victim's website using the poisoned session. Even if two
        applications on the same server do not have read/write access to the other application's *save_path*, if
        the *save_path* is guessable, and the attacker has control over one of these two websites, the attacker
        could alter their website's *save_path* to use the other's save_path, and thus accomplish session
        poisoning, under some common configurations of *PHP*. Thus, the value for *save_path* should not be made
        public knowledge and should be altered to a secure location unique to each application.

   - string *name*- The correct value is system dependent and should be provided by the developer using a value
     **unique** to the application.

     .. note::

        **Security Risk**

        If the *php.ini* setting for *session.name* is the same (e.g., the default "PHPSESSID"), and there are two
        or more *PHP* applications accessible through the same domain name then they will share the same session
        data for visitors to both websites. Additionally, possible corruption of session data may result.

   - boolean *use_only_cookies*- In order to avoid introducing additional security risks, do not alter the default
     value of this option.

        .. note::

           **Security Risk**

           If this setting is not enabled, an attacker can easily fix victim's session ids, using links on the
           attacker's website, such as *http://www.example.com/index.php?PHPSESSID=fixed_session_id*. The fixation
           works, if the victim does not already have a session id cookie for example.com. Once a victim is using a
           known session id, the attacker can then attempt to hijack the session by pretending to be the victim,
           and emulating the victim's user agent.





.. _zend.session.global_session_management.headers_sent:

Error: Headers Already Sent
---------------------------

If you see the error message, "Cannot modify header information - headers already sent", or, "You must call ...
before any output has been sent to the browser; output started in ...", then carefully examine the immediate cause
(function or method) associated with the message. Any actions that require sending *HTTP* headers, such as sending
a cookie, must be done before sending normal output (unbuffered output), except when using *PHP*'s output
buffering.

- Using `output buffering`_ often is sufficient to prevent this issue, and may help improve performance. For
  example, in *php.ini*, "*output_buffering = 65535*" enables output buffering with a 64K buffer. Even though
  output buffering might be a good tactic on production servers to increase performance, relying only on buffering
  to resolve the "headers already sent" problem is not sufficient. The application must not exceed the buffer size,
  or the problem will occur whenever the output sent (prior to the *HTTP* headers) exceeds the buffer size.

- If a ``Zend\Session`` method is involved in causing the error message, examine the method carefully, and make
  sure its use really is needed in the application. For example, the default usage of ``destroy()`` also sends an
  *HTTP* header to expire the client-side session cookie. If this is not needed, then use ``destroy(false)``, since
  the instructions to set cookies are sent with *HTTP* headers.

- Alternatively, try rearranging the application logic so that all actions manipulating headers are performed prior
  to sending any output whatsoever.

- Remove any closing "*?>*" tags, if they occur at the end of a *PHP* source file. They are not needed, and
  newlines and other nearly invisible whitespace following the closing tag can trigger output to the client.

.. _zend.session.global_session_management.session_identifiers:

Session Identifiers
-------------------

Introduction: Best practice in relation to using sessions with Zend Framework calls for using a browser cookie
(i.e. a normal cookie stored in your web browser), instead of embedding a unique session identifier in *URL*\ s as
a means to track individual users. By default this component uses only cookies to maintain session identifiers. The
cookie's value is the unique identifier of your browser's session. *PHP*'s ext/session uses this identifier to
maintain a unique one-to-one relationship between website visitors, and persistent session data storage unique to
each visitor. ``Zend\Session``\ * wraps this storage mechanism (``$_SESSION``) with an object-oriented interface.
Unfortunately, if an attacker gains access to the value of the cookie (the session id), an attacker might be able
to hijack a visitor's session. This problem is not unique to *PHP*, or Zend Framework. The ``regenerateId()``
method allows an application to change the session id (stored in the visitor's cookie) to a new, random,
unpredictable value. Note: Although not the same, to make this section easier to read, we use the terms "user
agent" and "web browser" interchangeably.

Why?: If an attacker obtains a valid session identifier, an attacker might be able to impersonate a valid user (the
victim), and then obtain access to confidential information or otherwise manipulate the victim's data managed by
your application. Changing session ids helps protect against session hijacking. If the session id is changed, and
an attacker does not know the new value, the attacker can not use the new session id in their attempts to hijack
the visitor's session. Even if an attacker gains access to an old session id, ``regenerateId()`` also moves the
session data from the old session id "handle" to the new one, so no data remains accessible via the old session id.

When to use regenerateId(): Adding ``Zend\Session\Session::regenerateId()`` to your Zend Framework bootstrap yields one of
the safest and most secure ways to regenerate session id's in user agent cookies. If there is no conditional logic
to determine when to regenerate the session id, then there are no flaws in that logic. Although regenerating on
every request prevents several possible avenues of attack, not everyone wants the associated small performance and
bandwidth cost. Thus, applications commonly try to dynamically determine situations of greater risk, and only
regenerate the session ids in those situations. Whenever a website visitor's session's privileges are "escalated"
(e.g. a visitor re-authenticates their identity before editing their personal "profile"), or whenever a security
"sensitive" session parameter change occurs, consider using ``regenerateId()`` to create a new session id. If you
call the ``rememberMe()`` function, then don't use ``regenerateId()``, since the former calls the latter. If a user
has successfully logged into your website, use ``rememberMe()`` instead of ``regenerateId()``.

.. _zend.session.global_session_management.session_identifiers.hijacking_and_fixation:

Session Hijacking and Fixation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Avoiding `cross-site script (XSS) vulnerabilities`_ helps preventing session hijacking. According to `Secunia's`_
statistics XSS problems occur frequently, regardless of the languages used to create web applications. Rather than
expecting to never have a XSS problem with an application, plan for it by following best practices to help minimize
damage, if it occurs. With XSS, an attacker does not need direct access to a victim's network traffic. If the
victim already has a session cookie, Javascript XSS might allow an attacker to read the cookie and steal the
session. for victims with no session cookies, using XSS to inject Javascript, an attacker could create a session id
cookie on the victim's browser with a known value, then set an identical cookie on the attacker's system, in order
to hijack the victim's session. If the victim visited an attacker's website, then the attacker can also emulate
most other identifiable characteristics of the victim's user agent. If your website has an XSS vulnerability, the
attacker might be able to insert an *AJAX* Javascript that secretly "visits" the attacker's website, so that the
attacker knows the victim's browser characteristics and becomes aware of a compromised session at the victim
website. However, the attacker can not arbitrarily alter the server-side state of *PHP* sessions, provided the
developer has correctly set the value for the *save_path* option.

By itself, calling ``Zend\Session\Session::regenerateId()`` when the user's session is first used, does not prevent session
fixation attacks, unless you can distinguish between a session originated by an attacker emulating the victim. At
first, this might sound contradictory to the previous statement above, until we consider an attacker who first
initiates a real session on your website. The session is "first used" by the attacker, who then knows the result of
the initialization (``regenerateId()``). The attacker then uses the new session id in combination with an XSS
vulnerability, or injects the session id via a link on the attacker's website (works if *use_only_cookies = off*).

If you can distinguish between an attacker and victim using the same session id, then session hijacking can be
dealt with directly. However, such distinctions usually involve some form of usability tradeoffs, because the
methods of distinction are often imprecise. For example, if a request is received from an IP in a different country
than the IP of the request when the session was created, then the new request probably belongs to an attacker.
Under the following conditions, there might not be any way for a website application to distinguish between a
victim and an attacker:



   - attacker first initiates a session on your website to obtain a valid session id

   - attacker uses XSS vulnerability on your website to create a cookie on the victim's browser with the same,
     valid session id (i.e. session fixation)

   - both the victim and attacker originate from the same proxy farm (e.g. both are behind the same firewall at a
     large company, like AOL)

The sample code below makes it much harder for an attacker to know the current victim's session id, unless the
attacker has already performed the first two steps above.

.. _zend.session.global_session_management.session_identifiers.hijacking_and_fixation.example:

.. rubric:: Session Fixation

.. code-block:: php
   :linenos:

   $defaultNamespace = new Zend\Session\Namespace();

   if (!isset($defaultNamespace->initialized)) {
       Zend\Session\Session::regenerateId();
       $defaultNamespace->initialized = true;
   }

.. _zend.session.global_session_management.rememberme:

rememberMe(integer $seconds)
----------------------------

Ordinarily, sessions end when the user agent terminates, such as when an end user exits a web browser program.
However, your application may provide the ability to extend user sessions beyond the lifetime of the client program
through the use of persistent cookies. Use ``Zend\Session\Session::rememberMe()`` before a session is started to control
the length of time before a persisted session cookie expires. If you do not specify a number of seconds, then the
session cookie lifetime defaults to *remember_me_seconds*, which may be set using ``Zend\Session\Session::setOptions()``.
To help thwart session fixation/hijacking, use this function when a user successfully authenticates with your
application (e.g., from a "login" form).

.. _zend.session.global_session_management.forgetme:

forgetMe()
----------

This function complements ``rememberMe()`` by writing a session cookie that has a lifetime ending when the user
agent terminates.

.. _zend.session.global_session_management.sessionexists:

sessionExists()
---------------

Use this method to determine if a session already exists for the current user agent/request. It may be used before
starting a session, and independently of all other ``Zend\Session`` and ``Zend\Session\Namespace`` methods.

.. _zend.session.global_session_management.destroy:

destroy(bool $remove_cookie = true, bool $readonly = true)
----------------------------------------------------------

``Zend\Session\Session::destroy()`` destroys all of the persistent data associated with the current session. However, no
variables in *PHP* are affected, so your namespaced sessions (instances of ``Zend\Session\Namespace``) remain
readable. To complete a "logout", set the optional parameter to ``TRUE`` (the default) to also delete the user
agent's session id cookie. The optional ``$readonly`` parameter removes the ability to create new
``Zend\Session\Namespace`` instances and for ``Zend\Session`` methods to write to the session data store.

If you see the error message, "Cannot modify header information - headers already sent", then either avoid using
``TRUE`` as the value for the first argument (requesting removal of the session cookie), or see :ref:`this section
<zend.session.global_session_management.headers_sent>`. Thus, ``Zend\Session\Session::destroy(true)`` must either be called
before *PHP* has sent *HTTP* headers, or output buffering must be enabled. Also, the total output sent must not
exceed the set buffer size, in order to prevent triggering sending the output before the call to ``destroy()``.

.. note::

   **Throws**

   By default, ``$readonly`` is enabled and further actions involving writing to the session data store will throw
   an exception.

.. _zend.session.global_session_management.stop:

stop()
------

This method does absolutely nothing more than toggle a flag in ``Zend\Session`` to prevent further writing to the
session data store. We are specifically requesting feedback on this feature. Potential uses/abuses might include
temporarily disabling the use of ``Zend\Session\Namespace`` instances or ``Zend\Session`` methods to write to the
session data store, while execution is transferred to view- related code. Attempts to perform actions involving
writes via these instances or methods will throw an exception.

.. _zend.session.global_session_management.writeclose:

writeClose($readonly = true)
----------------------------

Shutdown the session, close writing and detach ``$_SESSION`` from the back-end storage mechanism. This will
complete the internal data transformation on this request. The optional ``$readonly`` boolean parameter can remove
write access by throwing an exception upon any attempt to write to the session via ``Zend\Session`` or
``Zend\Session\Namespace``.

.. note::

   **Throws**

   By default, ``$readonly`` is enabled and further actions involving writing to the session data store will throw
   an exception. However, some legacy application might expect ``$_SESSION`` to remain writable after ending the
   session via ``session_write_close()``. Although not considered "best practice", the ``$readonly`` option is
   available for those who need it.

.. _zend.session.global_session_management.expiresessioncookie:

expireSessionCookie()
---------------------

This method sends an expired session id cookie, causing the client to delete the session cookie. Sometimes this
technique is used to perform a client-side logout.

.. _zend.session.global_session_management.savehandler:

setSaveHandler(Zend\Session\SaveHandler\Interface $interface)
-------------------------------------------------------------

Most developers will find the default save handler sufficient. This method provides an object-oriented wrapper for
`session_set_save_handler()`_.

.. _zend.session.global_session_management.namespaceisset:

namespaceIsset($namespace)
--------------------------

Use this method to determine if a session namespace exists, or if a particular index exists in a particular
namespace.

.. note::

   **Throws**

   An exception will be thrown if ``Zend\Session`` is not marked as readable (e.g., before ``Zend\Session`` has
   been started).

.. _zend.session.global_session_management.namespaceunset:

namespaceUnset($namespace)
--------------------------

Use ``Zend\Session\Session::namespaceUnset($namespace)`` to efficiently remove an entire namespace and its contents. As
with all arrays in *PHP*, if a variable containing an array is unset, and the array contains other objects, those
objects will remain available, if they were also stored by reference in other array/objects that remain accessible
via other variables. So ``namespaceUnset()`` does not perform a "deep" unsetting/deleting of the contents of the
entries in the namespace. For a more detailed explanation, please see `References Explained`_ in the *PHP* manual.

.. note::

   **Throws**

   An exception will be thrown if the namespace is not writable (e.g., after ``destroy()``).

.. _zend.session.global_session_management.namespaceget:

namespaceGet($namespace)
------------------------

DEPRECATED: Use ``getIterator()`` in ``Zend\Session\Namespace``. This method returns an array of the contents of
``$namespace``. If you have logical reasons to keep this method publicly accessible, please provide feedback to the
`fw-auth@lists.zend.com`_ mail list. Actually, all participation on any relevant topic is welcome :)

.. note::

   **Throws**

   An exception will be thrown if ``Zend\Session`` is not marked as readable (e.g., before ``Zend\Session`` has
   been started).

.. _zend.session.global_session_management.getiterator:

getIterator()
-------------

Use ``getIterator()`` to obtain an array containing the names of all namespaces.

.. note::

   **Throws**

   An exception will be thrown if ``Zend\Session`` is not marked as readable (e.g., before ``Zend\Session`` has
   been started).



.. _`usual options provided by ext/session`: http://www.php.net/session#session.configuration
.. _`fw-auth@lists.zend.com`: mailto:fw-auth@lists.zend.com
.. _`session poisoning`: http://en.wikipedia.org/wiki/Session_poisoning
.. _`output buffering`: http://php.net/outcontrol
.. _`cross-site script (XSS) vulnerabilities`: http://en.wikipedia.org/wiki/Cross_site_scripting
.. _`Secunia's`: http://secunia.com/
.. _`session_set_save_handler()`: http://php.net/session_set_save_handler
.. _`References Explained`: http://php.net/references
