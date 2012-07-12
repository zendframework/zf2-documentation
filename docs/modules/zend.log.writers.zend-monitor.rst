
Writing to the Zend Server Monitor
==================================

``Zend\Log\Writer\ZendMonitor`` allows you to log events via Zend Server's Monitor *API* . This allows you to aggregate log messages for your entire application environment in a single location. Internally, it simply uses the ``monitor_custom_event()`` function from the Zend Monitor *API* .

One particularly useful feature of the Monitor *API* is that it allows you to specify arbitrary custom information alongside the log message. For instance, if you wish to log an exception, you can log not just the exception message, but pass the entire exception object to the function, and then inspect the object within the Zend Server event monitor.

.. note::
    **Zend Monitor must be installed and enabled**

    In order to use this log writer, Zend Monitor must be both installed and enabled. However, it is designed such that if Zend Monitor is not detected, it will simply act as a ``NULL`` logger.

Instantiating the ``Zend\Log\Writer\ZendMonitor`` log writer is trivial:

.. code-block:: php
    :linenos:
    
    $writer = new Zend\Log\Writer\ZendMonitor();
    $logger = new Zend\Log\Logger($writer);
    

Then, simply log messages as usual:

.. code-block:: php
    :linenos:
    
    $logger->info('This is a message');
    

If you want to specify additional information to log with the event, pass that information in a second parameter:

.. code-block:: php
    :linenos:
    
    $logger->info('Exception occurred', $e);
    

The second parameter may be a scalar, object, or array; if you need to pass multiple pieces of information, the best way to do so is to pass an associative array.

.. code-block:: php
    :linenos:
    
    $logger->info('Exception occurred', array(
        'request'   => $request,
        'exception' => $e,
    ));
    

Within Zend Server, your event is logged as a "custom event". From the "Monitor" tab, select the "Events" sub-item, and then filter on "Custom" to see custom events.



Events in Zend Server's Monitor dashboard

In this screenshot, the first two events listed are custom events logged via the ``Zend\Log\Writer\ZendMonitor`` log writer. You may then click on an event to view all information related to it.



Event detail in Zend Server's Monitor

Clicking on the "Custom" sub tab will detail any extra information you logged by passing the second argument to the logging method. This information will be logged as the ``info`` subkey; you can see that the request object was logged in this example.


