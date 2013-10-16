.. _zend.progress-bar.adapter.js-push:

JsPush Adapter
^^^^^^^^^^^^^^

``Zend\ProgressBar\Adapter\JsPush`` is an adapter which let's you update a progressbar in a browser via Javascript
Push. This means that no second connection is required to gather the status about a running process, but that the
process itself sends its status directly to the browser.

You can set the adapter options either via the *set** methods or give an array or a ``Zend\Config\Config`` instance with
options as first parameter to the constructor. The available options are:

- *updateMethodName*: The JavaScript method which should be called on every update. Default value is
  ``Zend\ProgressBar\Update``.

- *finishMethodName*: The JavaScript method which should be called after finish status was set. Default value is
  ``NULL``, which means nothing is done.

The usage of this adapter is quite simple. First you create a progressbar in your browser, either with JavaScript
or previously created with plain *HTML*. Then you define the update method and optionally the finish method in
JavaScript, both taking a json object as single argument. Then you call a webpage with the long-running process in
a hidden *iframe* or *object* tag. While the process is running, the adapter will call the update method on every
update with a json object, containing the following parameters:

- *current*: The current absolute value

- *max*: The max absolute value

- *percent*: The calculated percentage

- *timeTaken*: The time how long the process ran yet

- *timeRemaining*: The expected time for the process to finish

- *text*: The optional status message, if given

.. _zend.progress-bar.adapter.js-push.example:

.. rubric:: Basic example for the client-side stuff

This example illustrates a basic setup of *HTML*, *CSS* and JavaScript for the JsPush adapter

.. code-block:: html
   :linenos:

   <div id="zend-progressbar-container">
       <div id="zend-progressbar-done"></div>
   </div>

   <iframe src="long-running-process.php" id="long-running-process"></iframe>

.. code-block:: css
   :linenos:

   #long-running-process {
       position: absolute;
       left: -100px;
       top: -100px;

       width: 1px;
       height: 1px;
   }

   #zend-progressbar-container {
       width: 100px;
       height: 30px;

       border: 1px solid #000000;
       background-color: #ffffff;
   }

   #zend-progressbar-done {
       width: 0;
       height: 30px;

       background-color: #000000;
   }

.. code-block:: javascript
   :linenos:

   function Zend\ProgressBar\Update(data)
   {
       document.getElementById('zend-progressbar-done').style.width =
            data.percent + '%';
   }

This will create a simple container with a black border and a block which indicates the current process. You should
not hide the *iframe* or *object* by *display: none;*, as some browsers like Safari 2 will not load the actual
content then.

Instead of creating your custom progressbar, you may want to use one of the available JavaScript libraries like
Dojo, jQuery etc. For example, there are:

- Dojo: http://dojotoolkit.org/reference-guide/dijit/ProgressBar.html

- jQuery: http://t.wits.sg/2008/06/20/jquery-progress-bar-11/

- MooTools: http://davidwalsh.name/dw-content/progress-bar.php

- Prototype: http://livepipe.net/control/progressbar

.. note::

   **Interval of updates**

   You should take care of not sending too many updates, as every update has a min-size of 1kb. This is a
   requirement for the Safari browser to actually render and execute the function call. Internet Explorer has a
   similar limitation of 256 bytes.



