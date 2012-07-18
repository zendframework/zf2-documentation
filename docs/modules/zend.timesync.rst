.. _zend.timesync.introduction:

Introduction
============

``Zend_TimeSync`` is able to receive internet or network time from a time server using the **NTP** or **SNTP**
protocol. With ``Zend_TimeSync``, Zend Framework is able to act independently from the time settings of the server
where it is running.

To be independent from the actual time of the server, ``Zend_TimeSync`` works with the difference of the real time
which is sent through NTP or SNTP and the internal server's time.

.. note::

   **Background**

   ``Zend_TimeSync`` is not able to change the server's time, but it will return a ``DateTime`` instance from which
   the difference from the server's time can be worked with.

.. _zend.timesync.introduction.why:

Why Zend_TimeSync ?
-------------------

So why would someone use ``Zend_TimeSync``?

Normally every server within a multi-server farm will have a service running which synchronizes its own time with a
time server. So within a standard environment it should not be necessary to use ``Zend_TimeSync``. But it can
become handy if there is no service available and if you don't have the right to install such a service.

Here are some example use cases, for which ``Zend_TimeSync`` is perfect suited:

- **Server without time service**

  If your application is running on a server and this server does not have any time service running, it may make
  sense to use ``Zend_TimeSync`` in your application.

- **Separate database server**

  If your database is running on a different server and this server is not connected with **NTP** or **SNTP** to
  the application server, you might have problems using storing and using time stamp data.

- **Multiple servers**

  If your application is running on more than one server and these servers' time bases are not synchronized, you
  can expect problems within your application when part of the application is coming from one server and another
  part from another server.

- **Batch processing**

  If you want to work with a time service within a batch file or within a command line application,
  ``Zend_TimeSync`` may be of use.

``Zend_TimeSync`` may provide a good solution in all of these cases and can be used if you are unable to run any
services on your server.

.. _zend.timesync.introduction.ntp:

What is NTP ?
-------------

The Network Time Protocol (**NTP**) is a protocol for synchronizing multiple systems' clocks over packet-switched,
variable-latency data networks. NTP uses UDP port 123 as its transport layer. See the `wikipedia article`_ for
details about this protocol.

.. _zend.timesync.introduction.sntp:

What is SNTP?
-------------

The Simple Network Time Protocol (**SNTP**) is a protocol synchronizing multiple systems' clocks over
packet-switched, variable-latency data networks. SNTP uses UDP port 37 as its transport layer. It is closely
related to the Network Time Protocol, but simpler.

.. _zend.timesync.introduction.problematic:

Problematic usage
-----------------

Be warned that when you are using ``Zend_TimeSync`` you will have to think about some details related to the
structure of time sync and the internet itself. Correct usage and best practices will be described here. Read
carefully before you begin using ``Zend_TimeSync``.

.. _zend.timesync.introduction.decision:

Decide which server to use
--------------------------

You should select the time server that you want to use very carefully according to the following criteria:

- Distance

  The distance from your application server to the time server. If your server is in Europe, it would make little
  sense to select a time server in Tahiti. Always select a server which is not far away. This reduces the request
  time and overall network load.

- Speed

  How long it takes to receive the request is also relevant. Try different servers to get the best result. If you
  are requesting a server which is never accessible, you will always have an unnecessary delay.

- Splitting

  Do not always use the same server. All time servers will lock out requests from servers that are flooding the
  server. If your application requires heavy use of time servers, you should consider one of the pools described
  later.

So where can you find a time server? Generally you can use any timeserver you can connect to. This can be a time
server within your LAN or any public time server you have access to. If you decide to use a public time server, you
should consider using a server pool. Server pools are public addresses from which you will get a random, pooled
time server by requesting the time. This way you will not have to split your requests. There are public server
pools available for many regions which you may use to avoid problems mentioned above.

See `pool.ntp.org`_ to find your nearest server pool. For example, if your server is located within Germany you can
connect to **0.europe.pool.ntp.org**.



.. _`wikipedia article`: http://en.wikipedia.org/wiki/Network_Time_Protocol
.. _`pool.ntp.org`: http://www.pool.ntp.org
