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

1. EVENT_RENDERER: Render the view, with the help of renderers.
2. EVENT_RENDERER_POST: Triggers after the view is rendered.
3. EVENT_RESPONSE: Populate the response from the view.

Those events are extensively describe in the following sections.


ViewEvent::RENDERER
-------------------

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

For PhpStrategy
"""""""""""""""""""""""

This listener are added when the strategy used for rendering is ``PhpStrategy``:

1. ``Zend\View\Strategy\PhpStrategy`` / priority : 1 / method called: ``selectRenderer`` => return a ``PhpRenderer``

For JsonStrategy
"""""""""""""""""""""""

This listener are added when the strategy used for rendering is ``JsonStrategy``:

1. ``Zend\View\Strategy\JsonStrategy`` / priority : 1 / method called: ``selectRenderer`` => return a ``JsonRenderer``

For FeedStrategy
"""""""""""""""""""""""

This listener are added when the strategy used for rendering is ``FeedStrategy``:

1. ``Zend\View\Strategy\FeedStrategy`` / priority : 1 / method called: ``selectRenderer`` => return a ``FeedRenderer``


Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

* ``Zend\View\View`` / in method: ``render`` => it has a short circuit callback that stops propagation once one result return an instance of a Renderer.


ViewEvent::RENDERER_POST
------------------------

Listeners
^^^^^^^^^

There are currently no built-in listeners for this event.


Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

* ``Zend\View\View`` / in method: ``render`` => this event is triggered after ViewEvent::RENDERER and before ViewEvent::RENDERER_POST



ViewEvent::RESPONSE
-------------------

Listeners
^^^^^^^^^

The following classes are listening to this event (they are sorted from higher priority to lower priority):

For PhpStrategy
"""""""""""""""""""""""

This listener are added when the strategy used for rendering is ``PhpStrategy``:

1. ``Zend\View\Strategy\PhpStrategy`` / priority : 1 / method called: ``injectResponse`` => populate the ``Response`` object from the view.

For JsonStrategy
"""""""""""""""""""""""

This listener are added when the strategy used for rendering is ``JsonStrategy``:

1. ``Zend\View\Strategy\JsonStrategy`` / priority : 1 / method called: ``injectResponse`` => populate the ``Response`` object from the view.

For FeedStrategy
"""""""""""""""""""""""

This listener are added when the strategy used for rendering is ``FeedStrategy``:

1. ``Zend\View\Strategy\FeedStrategy`` / priority : 1 / method called: ``injectResponse`` => populate the ``Response`` object from the view.


Triggerers
^^^^^^^^^^

This event is triggered by the following classes:

* ``Zend\View\View`` / in method: ``render`` => this event is triggered after ViewEvent::RENDERER and ViewEvent::RENDERER_POST