
Zend_Wildfire
=============

``Zend_Wildfire`` is a component that facilitates communication between *PHP* code and `Wildfire`_ client components.

The purpose of the Wildfire Project is to develop standardized communication channels between a large variety of components and a dynamic and scriptable plugin architecture. At this time, the primary focus is to provide a system that allows server-side *PHP* code to inject logging messages into the `Firebug Console`_ .

The :ref:`Zend_Log_Writer_Firebug <zend.log.writers.firebug>` component is provided for the purpose of logging to Firebug, and a communication protocol has been developed that uses *HTTP* request and response headers to send data between the server and client components. It is great for logging intelligence data to the browser that is generated during script execution, without interfering with the page content. With this approach, it is possible to debug *AJAX* requests that require clean *JSON* and *XML* responses.

There is also a :ref:`Zend_Db_Profiler_Firebug <zend.db.profiler.profilers.firebug>` component to log database profiling information to Firebug.


.. _`Wildfire`: http://www.wildfirehq.org/
.. _`Firebug Console`: http://www.getfirebug.com/
