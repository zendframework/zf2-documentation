
Zend_ProgressBar_Adapter_JsPush
===============================

``Zend_ProgressBar_Adapter_JsPush`` is an adapter which let's you update a progressbar in a browser via Javascript Push. This means that no second connection is required to gather the status about a running process, but that the process itself sends its status directly to the browser.

You can set the adapter options either via theset*methods or give an array or a ``Zend_Config`` instance with options as first parameter to the constructor. The available options are:

The usage of this adapter is quite simple. First you create a progressbar in your browser, either with JavaScript or previously created with plain *HTML* . Then you define the update method and optionally the finish method in JavaScript, both taking a json object as single argument. Then you call a webpage with the long-running process in a hiddeniframeorobjecttag. While the process is running, the adapter will call the update method on every update with a json object, containing the following parameters:

.. note::
    **Interval of updates**

    You should take care of not sending too many updates, as every update has a min-size of 1kb. This is a requirement for the Safari browser to actually render and execute the function call. Internet Explorer has a similar limitation of 256 bytes.


