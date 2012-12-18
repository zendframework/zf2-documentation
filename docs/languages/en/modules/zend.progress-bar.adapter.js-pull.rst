.. _zend.progress-bar.adapter.js-pull:

JsPull Adapter
^^^^^^^^^^^^^^

``Zend\ProgressBar\Adapter\JsPull`` is the opposite of jsPush, as it requires to pull for new updates, instead of
pushing updates out to the browsers. Generally you should use the adapter with the persistence option of the
``Zend\ProgressBar``. On notify, the adapter sends a *JSON* string to the browser, which looks exactly like the
*JSON* string which is send by the jsPush adapter. The only difference is, that it contains an additional
parameter, ``finished``, which is either ``FALSE`` when ``update()`` is called or ``TRUE``, when ``finish()`` is
called.

You can set the adapter options either via the ``set*()`` methods or give an array or a ``Zend\Config\Config`` instance
with options as first parameter to the constructor. The available options are:

- ``exitAfterSend``: Exits the current request after the data were send to the browser. Default is ``TRUE``.


