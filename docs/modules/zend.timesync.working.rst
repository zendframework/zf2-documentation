.. _zend.timesync.working:

Working with Zend_TimeSync
==========================

``Zend\TimeSync\TimeSync`` can return the actual time from any given **NTP** or **SNTP** time server. It can automatically handle multiple servers and provides a simple interface.

.. note::

   All examples in this chapter use a public, generic time server: **0.europe.pool.ntp.org**. You should use a public, generic time server which is close to your application server. See `http://www.pool.ntp.org`_ for information.

.. _zend.timesync.working.generic:

Generic Time Server Request
---------------------------

Requesting the time from a time server is simple. First, you provide the time server from which you want to request the time.

.. code-block:: php
   :linenos:

   $server = new Zend\TimeSync\TimeSync('0.pool.ntp.org');

   print $server->getDate()->format(DateTime::ISO8601);

So what is happening in the background of ``Zend\TimeSync\TimeSync``? First the syntax of the time server is checked. In our example, '**0.pool.ntp.org**' is checked and recognised as a possible address for a time server. Then when calling ``getDate()`` the actual set time server is requested and it will return its own time. ``Zend\TimeSync\TimeSync`` then calculates the difference to the actual time of the server running the script and returns a ``DateTime`` object with the correct time.

For details about ``DateTime`` and its methods see the `DateTimedocumentation`_.

.. _zend.timesync.working.multiple:

Multiple Time Servers
---------------------

Not all time servers are always available to return their time. Servers may be unavailable during maintenance, for example. When the time cannot be requested from the time server, you will get an exception.

``Zend\TimeSync\TimeSync`` is a simple solution that can handle multiple time servers and supports an automatic fallback mechanism. There are two supported ways; you can either specify an array of time servers when creating the instance, or you can add additional time servers to the instance using the ``addServer()`` method.

.. code-block:: php
   :linenos:

   $server = new Zend\TimeSync\TimeSync(array('0.pool.ntp.org',
                                              '1.pool.ntp.org',
                                              '2.pool.ntp.org'));
   $server->addServer('3.pool.ntp.org');

   print $server->getDate()->format(DateTime::ISO8601);

There is no limit to the number of time servers you can add. When a time server can not be reached, ``Zend\TimeSync\TimeSync`` will fallback and try to connect to the next time server.

When you supply more than one time server- which is considered a best practice for ``Zend\TimeSync\TimeSync``- you should name each server. You can name your servers with array keys, with the second parameter at instantiation, or with the second parameter when adding another time server.

.. code-block:: php
   :linenos:

   $server = new Zend\TimeSync\TimeSync(array('generic'  => '0.pool.ntp.org',
                                              'fallback' => '1.pool.ntp.org',
                                              'reserve'  => '2.pool.ntp.org'));
   $server->addServer('3.pool.ntp.org', 'additional');

   print $server->getDate()->format(DateTime::ISO8601);

Naming the time servers allows you to request a specific time server as we will see later in this chapter.

.. _zend.timesync.working.protocol:

Protocols of Time Servers
-------------------------

There are different types of time servers. Most public time servers use the **NTP** protocol. But there are other time synchronization protocols available.

You set the proper protocol in the address of the time server. There are two protocols which are supported by ``Zend\TimeSync\TimeSync``: **NTP** and **SNTP**. The default protocol is **NTP**. If you are using **NTP**, you can omit the protocol in the address as demonstrated in the previous examples.

.. code-block:: php
   :linenos:

   $server = new Zend\TimeSync\TimeSync(array('generic'  => 'ntp://0.pool.ntp.org',
                                              'fallback' => 'ntp://1.pool.ntp.org',
                                              'reserve'  => 'ntp://2.pool.ntp.org'));
   $server->addServer('sntp://internal.myserver.com', 'additional');

   print $server->getDate()->format(DateTime::ISO8601);

``Zend\TimeSync\TimeSync`` can handle mixed time servers. So you are not restricted to only one protocol; you can add any server independently from its protocol.

.. _zend.timesync.working.ports:

Using Ports for Time Servers
----------------------------

As with every protocol within the world wide web, the **NTP** and **SNTP** protocols use standard ports. NTP uses port **123** and SNTP uses port **37**.

But sometimes the port that the protocols use differs from the standard one. You can define the port which has to be used for each server within the address. Just add the number of the port after the address. If no port is defined, then ``Zend\TimeSync\TimeSync`` will use the standard port.

.. code-block:: php
   :linenos:

   $server = new Zend\TimeSync\TimeSync(array('generic'  => 'ntp://0.pool.ntp.org:200',
                                              'fallback' => 'ntp://1.pool.ntp.org'));
   $server->addServer('sntp://internal.myserver.com:399', 'additional');

   print $server->getDate()->format(DateTime::ISO8601);

.. _zend.timesync.working.options:

Time Servers Options
--------------------

There is only one option within ``Zend\TimeSync\TimeSync`` which will be used internally: **timeout**. You can set any self-defined option you are in need of and request it, however.

The option **timeout** defines the number of seconds after which a connection is detected as broken when there was no response. The default value is **1**, which means that ``Zend\TimeSync\TimeSync`` will fallback to the next time server if the requested time server does not respond in one second.

With the ``setOptions()`` method, you can set any option. This function accepts an array where the key is the option to set and the value is the value of that option. Any previously set option will be overwritten by the new value. If you want to know which options are set, use the ``getOptions()`` method. It accepts either a key which returns the given option if specified, or, if no key is set, it will return all set options.

.. code-block:: php
   :linenos:

   Zend\TimeSync\TimeSync::setOptions(array('timeout' => 3, 'myoption' => 'timesync'));
   $server = new Zend\TimeSync\TimeSync(array('generic'  => 'ntp://0.pool.ntp.org',
                                              'fallback' => 'ntp://1.pool.ntp.org'));
   $server->addServer('sntp://internal.myserver.com', 'additional');

   print $server->getDate()->format(DateTime::ISO8601);
   print_r(Zend\TimeSync\TimeSync::getOptions();
   print "Timeout = " . Zend\TimeSync\TimeSync::getOptions('timeout');

As you can see, the options for ``Zend\TimeSync\TimeSync`` are static. Each instance of ``Zend\TimeSync\TimeSync`` will use the same options.

.. _zend.timesync.working.different:

Using Different Time Servers
----------------------------

``Zend\TimeSync\TimeSync``'s default behavior for requesting a time is to request it from the first given server. But sometimes it is useful to set a different time server from which to request the time. This can be done with the ``setServer()`` method. To define the used time server set the alias as a parameter within the method. To get the actual used time server call the ``getServer()`` method. It accepts an alias as a parameter which defines the time server to be returned. If no parameter is given, the current time server will be returned.

.. code-block:: php
   :linenos:

   $server = new Zend\TimeSync\TimeSync(array('generic'  => 'ntp://0.pool.ntp.org',
                                              'fallback' => 'ntp://1.pool.ntp.org'));
   $server->addServer('sntp://internal.myserver.com', 'additional');

   $actual = $server->getServer();
   $server = $server->setServer('additional');

.. _zend.timesync.working.informations:

Information from Time Servers
-----------------------------

Time servers not only offer the time itself, but also additional information. You can get this information with the ``getInfo()`` method.

.. code-block:: php
   :linenos:

   $server = new Zend\TimeSync\TimeSync(array('generic'  => 'ntp://0.pool.ntp.org',
                                              'fallback' => 'ntp://1.pool.ntp.org'));

   print_r ($server->getInfo());

The returned information differs with the protocol used and can also differ with the server used.

.. _zend.timesync.working.exceptions:

Handling Exceptions
-------------------

Exceptions are collected for all time servers and returned as an array. So you can iterate through all thrown exceptions as shown in the following example:

.. code-block:: php
   :linenos:

   $serverlist = array(
           // invalid servers
           'invalid_a'  => 'ntp://a.foo.bar.org',
           'invalid_b'  => 'sntp://b.foo.bar.org',
   );

   $server = new Zend\TimeSync\TimeSync($serverlist);

   try {
       $result = $server->getDate();
       echo $result->format(DateTime::ISO8601);
   } catch (Zend\TimeSync\Exception\RuntimeException $e) {
       while ($e = $e->getPrevious()) {
           echo $e->getMessage();
           echo '<br />';
       }
   }



.. _`http://www.pool.ntp.org`: http://www.pool.ntp.org
.. _`DateTimedocumentation`: http://php.net/class.datetime.php
