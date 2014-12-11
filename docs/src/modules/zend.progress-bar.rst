Progress Bars
=============

.. _zend.progress-bar.introduction:

Introduction
------------

``Zend\ProgressBar`` is a component to create and update progress bars in different environments. It consists of a
single backend, which outputs the progress through one of the multiple adapters. On every update, it takes an
absolute value and optionally a status message, and then calls the adapter with some precalculated values like
percentage and estimated time left.

.. _zend.progress-bar.basic:

Basic Usage
-----------

``Zend\ProgressBar`` is quite easy in its usage. You simply create a new instance of ``Zend\Progressbar``, defining
a min- and a max-value, and choose an adapter to output the data. If you want to process a file, you would do
something like:

.. code-block:: php
   :linenos:

   $progressBar = new Zend\ProgressBar\ProgressBar($adapter, 0, $fileSize);

   while (!feof($fp)) {
       // Do something

       $progressBar->update($currentByteCount);
   }

   $progressBar->finish();

In the first step, an instance of ``Zend\ProgressBar`` is created, with a specific adapter, a min-value of 0 and a
max-value of the total filesize. Then a file is processed and in every loop the progressbar is updated with the
current byte count. At the end of the loop, the progressbar status is set to finished.

You can also call the ``update()`` method of ``Zend\ProgressBar`` without arguments, which just recalculates ETA
and notifies the adapter. This is useful when there is no data update but you want the progressbar to be updated.

.. _zend.progress-bar.persistent:

Persistent Progress
-------------------

If you want the progressbar to be persistent over multiple requests, you can give the name of a session namespace
as fourth argument to the constructor. In that case, the progressbar will not notify the adapter within the
constructor, but only when you call ``update()`` or ``finish()``. Also the current value, the status text and the
start time for ETA calculation will be fetched in the next request run again.

.. _zend.progress-bar.adapters:

Standard Adapters
-----------------

``Zend\ProgressBar`` comes with the following three adapters:



   - :ref:`Zend\\Progressbar\\Adapter\\Console <zend.progress-bar.adapter.console>`

   - :ref:`Zend\\Progressbar\\Adapter\\JsPush <zend.progress-bar.adapter.js-push>`

   - :ref:`Zend\\ProgressBar\\Adapter\\JsPull <zend.progress-bar.adapter.js-pull>`



.. include:: zend.progress-bar.adapter.console.rst
.. include:: zend.progress-bar.adapter.js-push.rst
.. include:: zend.progress-bar.adapter.js-pull.rst

