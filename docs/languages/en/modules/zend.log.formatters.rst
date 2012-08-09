.. _zend.log.formatters:

Formatters
==========

A Formatter is an object that is responsible for taking an ``event`` array describing a log event and outputting a
string with a formatted log line.

Some Writers are not line-oriented and cannot use a Formatter. An example is the Database Writer, which inserts the
event items directly into database columns. For Writers that cannot support a Formatter, an exception is thrown if
you attempt to set a Formatter.

.. _zend.log.formatters.simple:

Simple Formatting
-----------------

``Zend\Log\Formatter\Simple`` is the default formatter. It is configured automatically when you specify no
formatter. The default configuration is equivalent to the following:

.. code-block:: php
   :linenos:

   $format = '%timestamp% %priorityName% (%priority%): %message%' . PHP_EOL;
   $formatter = new Zend\Log\Formatter\Simple($format);

A formatter is set on an individual Writer object using the Writer's ``setFormatter()`` method:

.. code-block:: php
   :linenos:

   $writer = new Zend\Log\Writer\Stream('php://output');
   $formatter = new Zend\Log\Formatter\Simple('hello %message%' . PHP_EOL);
   $writer->setFormatter($formatter);

   $logger = new Zend\Log\Logger();
   $logger->addWriter($writer);

   $logger->info('there');

   // outputs "hello there"

The constructor of ``Zend\Log\Formatter\Simple`` accepts a single parameter: the format string. This string
contains keys surrounded by percent signs (e.g. ``%message%``). The format string may contain any key from the
event data array. You can retrieve the default keys by using the DEFAULT_FORMAT constant from
``Zend\Log\Formatter\Simple``.

.. _zend.log.formatters.xml:

Formatting to XML
-----------------

``Zend\Log\Formatter\Xml`` formats log data into *XML* strings. By default, it automatically logs all items in the
event data array:

.. code-block:: php
   :linenos:

   $writer = new Zend\Log\Writer\Stream('php://output');
   $formatter = new Zend\Log\Formatter\Xml();
   $writer->setFormatter($formatter);

   $logger = new Zend\Log\Logger();
   $logger->addWriter($writer);

   $logger->info('informational message');

The code above outputs the following *XML* (space added for clarity):

.. code-block:: xml
   :linenos:

   <logEntry>
     <timestamp>2007-04-06T07:24:37-07:00</timestamp>
     <message>informational message</message>
     <priority>6</priority>
     <priorityName>INFO</priorityName>
   </logEntry>

It's possible to customize the root element as well as specify a mapping of *XML* elements to the items in the
event data array. The constructor of ``Zend\Log\Formatter\Xml`` accepts a string with the name of the root element
as the first parameter and an associative array with the element mapping as the second parameter:

.. code-block:: php
   :linenos:

   $writer = new Zend\Log\Writer\Stream('php://output');
   $formatter = new Zend\Log\Formatter\Xml('log',
                                           array('msg' => 'message',
                                                 'level' => 'priorityName')
                                          );
   $writer->setFormatter($formatter);

   $logger = new Zend\Log\Logger();
   $logger->addWriter($writer);

   $logger->info('informational message');

The code above changes the root element from its default of ``logEntry`` to ``log``. It also maps the element
``msg`` to the event data item ``message``. This results in the following output:

.. code-block:: xml
   :linenos:

   <log>
     <msg>informational message</msg>
     <level>INFO</level>
   </log>

.. _zend.log.formatters.firebug:

Formatting to FirePhp
---------------------

``Zend\Log\Formatter\FirePhp`` formats log data for the `Firebug`_ extension for Firefox.


.. _`Firebug`: http://getfirebug.com/
