.. _zend.view.view-event:

The ViewEvent
=============

The view layer of Zend Framework 2 incorporates and utilizes a custom ``Zend\EventManager\Event`` implementation -
``Zend\View\ViewEvent``. This event is created during ``Zend\View\View::getEvent()`` and is passed directly to all
the events that method triggers.

The ``ViewEvent`` adds accessors and mutators for the following:

- ``Model`` object, typically representing the layout view model.
- ``Renderer`` object.
- ``Request`` object.
- ``Response`` object.
- ``Result`` object.

The methods it defines are:

- ``setModel(Model $model)``

- ``getModel()``

- ``setRequest($request)``

- ``getRequest()``

- ``setResponse($response)``

- ``getResponse()``

- ``setRenderer($renderer)``

- ``getRenderer()``

- ``setResult($result)``

- ``getResult()``


Order of events
---------------

The following events are triggered, in the following order:

.. table:: ``ViewEvent`` Events

   +------------------+-----------------------------------+---------------------------------------------+
   |Name              |Constant                           |Description                                  |
   +==================+===================================+=============================================+
   |``renderer``      |``ViewEvent::EVENT_RENDERER``      |Render the view, with the help of renderers. |
   +------------------+-----------------------------------+---------------------------------------------+
   |``renderer.post`` |``ViewEvent::EVENT_RENDERER_POST`` |Triggers after the view is rendered.         |
   +------------------+-----------------------------------+---------------------------------------------+
   |``response``      |``ViewEvent::EVENT_RESPONSE``      |Populate the response from the view.         |
   +------------------+-----------------------------------+---------------------------------------------+


Those events are extensively describe in the following sections.

.. _zend.view.view-event.renderer:

ViewEvent::EVENT_RENDERER
-------------------------

.. _zend.view.view-event.renderer.listeners:

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

For PhpStrategy
"""""""""""""""

This listener is added when the strategy used for rendering is ``PhpStrategy``:

.. table:: ``ViewEvent::EVENT_RENDERER`` Listeners for ``PhpStrategy``

   +-----------------------------------+---------+-------------------+-------------------------+
   |Class                              |Priority |Method Called      |Description              |
   +===================================+=========+===================+=========================+
   |``Zend\View\Strategy\PhpStrategy`` |1        |``selectRenderer`` |Return a ``PhpRenderer`` |
   +-----------------------------------+---------+-------------------+-------------------------+

For JsonStrategy
""""""""""""""""

This listener is added when the strategy used for rendering is ``JsonStrategy``:

.. table:: ``ViewEvent::EVENT_RENDERER`` Listeners for ``JsonStrategy``

   +------------------------------------+---------+-------------------+--------------------------+
   |Class                               |Priority |Method Called      |Description               |
   +====================================+=========+===================+==========================+
   |``Zend\View\Strategy\JsonStrategy`` |1        |``selectRenderer`` |Return a ``JsonRenderer`` |
   +------------------------------------+---------+-------------------+--------------------------+

For FeedStrategy
""""""""""""""""

This listener is added when the strategy used for rendering is ``FeedStrategy``:

.. table:: ``ViewEvent::EVENT_RENDERER`` Listeners for ``FeedStrategy``

   +------------------------------------+---------+-------------------+--------------------------+
   |Class                               |Priority |Method Called      |Description               |
   +====================================+=========+===================+==========================+
   |``Zend\View\Strategy\FeedStrategy`` |1        |``selectRenderer`` |Return a ``FeedRenderer`` |
   +------------------------------------+---------+-------------------+--------------------------+


Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

.. table:: ``ViewEvent::EVENT_RENDERER`` Triggerers

   +-------------------+--------------------+------------------------------------------------------------+
   |Class              |In Method           |Description                                                 |
   +===================+====================+============================================================+
   |``Zend\View\View`` |``render``          |It has a short circuit callback that stops propagation once |
   |                   |                    |one result return an instance of a Renderer.                |
   +-------------------+--------------------+------------------------------------------------------------+


.. _zend.view.view-event.renderer.post:

ViewEvent::EVENT_RENDERER_POST
------------------------------

.. _zend.view.view-event.renderer-post.listeners:

Listeners
^^^^^^^^^

There are currently no built-in listeners for this event.


Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

.. table:: ``ViewEvent::EVENT_RENDERER_POST`` Triggerers

   +-------------------+--------------------+------------------------------------------------------------+
   |Class              |In Method           |Description                                                 |
   +===================+====================+============================================================+
   |``Zend\View\View`` |``render``          |This event is triggered after ``ViewEvent::EVENT_RENDERER`` |
   |                   |                    |and before ``ViewEvent::EVENT_RESPONSE``.                   |
   +-------------------+--------------------+------------------------------------------------------------+


.. _zend.view.view-event.response:

ViewEvent::EVENT_RESPONSE
-------------------------

.. _zend.view.view-event.response.listeners:

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

For PhpStrategy
"""""""""""""""

This listener is added when the strategy used for rendering is ``PhpStrategy``:

.. table:: ``ViewEvent::EVENT_RESPONSE`` Listeners for ``PhpStrategy``

   +-----------------------------------+---------+-------------------+------------------------------------------------+
   |Class                              |Priority |Method Called      |Description                                     |
   +===================================+=========+===================+================================================+
   |``Zend\View\Strategy\PhpStrategy`` |1        |``injectResponse`` |Populate the ``Response`` object from the view. |
   +-----------------------------------+---------+-------------------+------------------------------------------------+

For JsonStrategy
""""""""""""""""

This listener is added when the strategy used for rendering is ``JsonStrategy``:

.. table:: ``ViewEvent::EVENT_RESPONSE`` Listeners for ``JsonStrategy``

   +------------------------------------+---------+-------------------+------------------------------------------------+
   |Class                               |Priority |Method Called      |Description                                     |
   +====================================+=========+===================+================================================+
   |``Zend\View\Strategy\JsonStrategy`` |1        |``injectResponse`` |Populate the ``Response`` object from the view. |
   +------------------------------------+---------+-------------------+------------------------------------------------+

For FeedStrategy
""""""""""""""""

This listener is added when the strategy used for rendering is ``FeedStrategy``:

.. table:: ``ViewEvent::EVENT_RESPONSE`` Listeners for ``FeedStrategy``

   +------------------------------------+---------+-------------------+------------------------------------------------+
   |Class                               |Priority |Method Called      |Description                                     |
   +====================================+=========+===================+================================================+
   |``Zend\View\Strategy\FeedStrategy`` |1        |``injectResponse`` |Populate the ``Response`` object from the view. |
   +------------------------------------+---------+-------------------+------------------------------------------------+


Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

.. table:: ``ViewEvent::EVENT_RESPONSE`` Triggerers

   +-------------------+--------------------+------------------------------------------------------------+
   |Class              |In Method           |Description                                                 |
   +===================+====================+============================================================+
   |``Zend\View\View`` |``render``          |This event is triggered after ``ViewEvent::EVENT_RENDERER`` |
   |                   |                    |and  ``ViewEvent::EVENT_RENDERER_POST``.                    |
   +-------------------+--------------------+------------------------------------------------------------+
