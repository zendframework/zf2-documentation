.. _zend.event-manager.event-manager:

The EventManager
================

.. _zend.event-manager.event-manager.intro:

Overview
--------

The ``EventManager`` is a component designed for the following use cases:

- Implementing simple subject/observer patterns.

- Implementing Aspect-Oriented designs.

- Implementing event-driven architectures.

The basic architecture allows you to attach and detach listeners to named events, both on a per-instance basis as
well as via shared collections; trigger events; and interrupt execution of listeners.

.. _zend.event-manager.event-manager.quick-start:

Quick Start
-----------

Typically, you will compose an ``EventManager`` instance in a class.

.. code-block:: php
   :linenos:

   use Zend\EventManager\EventManagerInterface;
   use Zend\EventManager\EventManager;
   use Zend\EventManager\EventManagerAwareInterface;

   class Foo implements EventManagerAwareInterface
   {
       protected $events;

       public function setEventManager(EventManagerInterface $events)
       {
           $events->setIdentifiers(array(
               __CLASS__,
               get_called_class(),
           ));
           $this->events = $events;
           return $this;
       }

       public function getEventManager()
       {
           if (null === $this->events) {
               $this->setEventManager(new EventManager());
           }
           return $this->events;
       }
   }

The above allows users to access the ``EventManager`` instance, or reset it with a new instance; if one does not
exist, it will be lazily instantiated on-demand.

The instance property `events` is a convention within Zend Framework 2 to refer to the EventManager instance.

An ``EventManager`` is really only interesting if it triggers some events. 

Basic triggering takes three arguments:
- The event ``name``, which is usually the current function/method name; 
- The ``target``, which is usually the current object instance; 
- The ``arguments``, which are usually the arguments provided to the current function/method.

An optional fourth argument; a ``callback`` may also be supplied.

.. code-block:: php
   :linenos:

   class Foo
   {
       // ... assume events definition from above

       public function bar($baz, $bat = null)
       {
           $params = compact('baz', 'bat');
           $this->getEventManager()->trigger(__FUNCTION__, $this, $params);
       }
   }

In turn, triggering events is only interesting if something is listening for the event. 

Listeners attach to the ``EventManager``, specifying a named event and the callback to notify. 
The callback receives an ``Event`` object, which has accessors for retrieving the event name, target, and parameters. 
Let's add a listener, and trigger the event.

.. code-block:: php
   :linenos:

   use Zend\Log\Factory as LogFactory;

   $log = LogFactory($someConfig);
   $foo = new Foo();
   $foo->getEventManager()->attach('bar', function ($e) use ($log) {
       $event  = $e->getName();
       $target = get_class($e->getTarget());
       $params = json_encode($e->getParams());

       $log->info(sprintf(
           '%s called on %s, using params %s',
           $event,
           $target,
           $params
       ));
   });

   // Results in log message:
   $foo->bar('baz', 'bat');
   // reading: bar called on Foo, using params {"baz" : "baz", "bat" : "bat"}"

Note that the second argument to ``attach()`` is any valid callback; an anonymous function is shown in the example
in order to keep the example self-contained.

However, you could also utilize a valid function name, a functor, a string referencing
a static method, or an array callback with a named static method or instance method.
Again, any PHP callback is valid.

Sometimes you may want to specify listeners without yet having an object instance of the class composing an
``EventManager``. 
Zend Framework enables this through the concept of a ``SharedEventManager``.

Simply put, you can inject individual ``EventManager`` instances with a well-known ``SharedEventManager``, and the
``EventManager`` instance will query it for additional listeners. 

Listeners attach to a ``SharedEventManager`` in roughly the same way they do to normal
event managers; the call to ``attach`` is identical to the ``EventManager``, but
expects an additional parameter at the beginning: a named instance.

Remember the example of composing an ``EventManager``, how we passed it ``__CLASS__``?
That value, or any strings you provide in an array to the
constructor, may be used to identify an instance when using a ``SharedEventManager``.

As an example, assuming we have a ``SharedEventManager`` instance that we know has been
injected in our ``EventManager`` instances (for instance, via dependency injection),
we could change the above example to attach via the shared collection:

.. code-block:: php
   :linenos:

   use Zend\Log\Factory as LogFactory;

   // Assume $events is a Zend\EventManager\SharedEventManager instance

   $log = LogFactory($someConfig);
   $events->attach('Foo', 'bar', function ($e) use ($log) {
       $event  = $e->getName();
       $target = get_class($e->getTarget());
       $params = json_encode($e->getParams());

       $log->info(sprintf(
           '%s called on %s, using params %s',
           $event,
           $target,
           $params
       ));
   });

   // Later, instantiate Foo:
   $foo = new Foo();
   $foo->getEventManager()->setSharedManager($events);

   // And we can still trigger the above event:
   $foo->bar('baz', 'bat');
   // results in log message:
   // bar called on Foo, using params {"baz" : "baz", "bat" : "bat"}"

.. note::

   **StaticEventManager**

   As of 2.0.0beta3, you can use the ``StaticEventManager`` singleton as a ``SharedEventCollection``. As such, you
   do not need to worry about where and how to get access to the ``SharedEventCollection``; it's globally available
   by simply calling *StaticEventManager::getInstance()*.

   Be aware, however, that its usage is deprecated within the framework, and starting with 2.0.0beta4, you will
   instead configure a ``SharedEventManager`` instance that will be injected by the framework into individual
   ``EventManager`` instances.

The ``EventManager`` also provides the ability to detach listeners, short-circuit execution of an event either from
within a listener or by testing return values of listeners, test and loop through the results returned by
listeners, prioritize listeners, and more. Many of these features are detailed in the examples.

.. _zend.event-manager.event-manager.quick-start.wildcard:

Wildcard Listeners
^^^^^^^^^^^^^^^^^^

Sometimes you'll want to attach the same listener to many events or to all events of a given instance -- or
potentially, with a shared event collection, many contexts, and many events. The ``EventManager`` component allows
for this.

.. _zend.event-manager.event-manager.quick-start.wildcard.many:

.. rubric:: Attaching to many events at once

.. code-block:: php
   :linenos:

   $events = new EventManager();
   $events->attach(array('these', 'are', 'event', 'names'), $callback);

Note that if you specify a priority, that priority will be used for all events specified.

.. _zend.event-manager.event-manager.quick-start.wildcard.wildcard:

.. rubric:: Attaching using the wildcard

.. code-block:: php
   :linenos:

   $events = new EventManager();
   $events->attach('*', $callback);

Note that if you specify a priority, that priority will be used for this listener for any event triggered.

What the above specifies is that **any** event triggered will result in notification of this particular listener.

.. _zend.event-manager.event-manager.quick-start.wildcard.shared-many:

.. rubric:: Attaching to many events at once via a SharedEventManager

.. code-block:: php
   :linenos:

   $events = new SharedEventManager();
   // Attach to many events on the context "foo"
   $events->attach('foo', array('these', 'are', 'event', 'names'), $callback);

   // Attach to many events on the contexts "foo" and "bar"
   $events->attach(array('foo', 'bar'), array('these', 'are', 'event', 'names'), $callback);

Note that if you specify a priority, that priority will be used for all events specified.

.. _zend.event-manager.event-manager.quick-start.wildcard.shared-wildcard:

.. rubric:: Attaching using the wildcard via a SharedEventManager

.. code-block:: php
   :linenos:

   $events = new SharedEventManager();
   // Attach to all events on the context "foo"
   $events->attach('foo', '*', $callback);

   // Attach to all events on the contexts "foo" and "bar"
   $events->attach(array('foo', 'bar'), '*', $callback);

Note that if you specify a priority, that priority will be used for all events specified.

The above is specifying that for the contexts "foo" and "bar", the specified listener should be notified for any
event they trigger.

.. _zend.event-manager.event-manager.options:

Configuration Options
---------------------

.. rubric:: EventManager Options

**identifier**
   A string or array of strings to which the given ``EventManager`` instance can answer when accessed via a
   ``SharedEventManager``.

**event_class**
   The name of an alternate ``Event`` class to use for representing events passed to listeners.

**shared_collections**
   An instance of a ``SharedEventCollection`` instance to use when triggering events.

.. _zend.event-manager.event-manager.methods:

Available Methods
-----------------

.. _zend.event-manager.event-manager.methods.constructor:

**__construct**
   ``__construct(null|string|int|array|Traversable $identifiers)``

   Constructs a new ``EventManager`` instance, using the given identifiers, if provided, for purposes of use
   with a ``SharedEventManager`` instance.

.. _zend.event-manager.event-manager.methods.set-event-class:

**setEventClass**
   ``setEventClass(string $class)``

   Provide the name of an alternate ``Event`` class to use when creating events to pass to triggered listeners.

.. _zend.event-manager.event-manager.methods.set-shared-manager:

**setSharedManager**
  ``setSharedManager(SharedEventManagerInterface $sharedEventManager)``

  Accepts an instance of ``SharedEventManagerInterface`` and sets the sharedManager property.

.. _zend.event-manager.event-manager.methods.unset-shared-manager:

**unsetSharedManager**
  ``unsetSharedManager()``

  Removes the SharedEventManager currently attached to the EventManager instance.

.. _zend.event-manager.event-manager.methods.get-shared-manager:

**getSharedManager**
  ``getSharedManager()``

  Returns the static SharedEventManager is one has been assigned or will return false.

.. _zend.event-manager.event-manager.methods.get-identifiers:

**getIdentifiers**
  ``getIdentifiers()``

  Returns the ``identifiers`` that have been set for this EventManager instance

.. _zend.event-manager.event-manager.methods.set-identifiers:

**setIdentifiers**
  ``setIdentifiers(string|int|array|Traversable $identifiers)``

  Sets the identifiers for this EventManager instance. This method will clear any
  existing ``identifiers`` that have been previously added to the instance.

.. _zend.event-manager.event-manager.methods.add-identifiers:

**addIdentifiers**
  ``addIdentifiers(string|int|array|Traversable $identifiers)``

  Add ``identifiers`` to the EventManager instance. This method will merge the ``identifiers`` with
  any that have previously been added to the instance.

.. _zend.event-manager.event-manager.methods.trigger:

**trigger**
   ``trigger(string $event, mixed $target = null, mixed $argv, callback $callback = null)``

   Triggers all listeners to a named event. The recommendation is to use the current function/method name for
   ``$event``, appending it with values such as ".pre", ".post", etc. as needed. ``$target`` should be the current
   object instance, or the name of the function if not triggering within an object. ``$argv`` should typically be
   an associative array or ``ArrayAccess`` instance; we recommend using the parameters passed to the
   function/method (``compact()`` is often useful here). This method can also take a callback and behave in the
   same way as ``triggerUntil()``.

   The method returns an instance of ``ResponseCollection``, which may be used to introspect return values of the
   various listeners, test for short-circuiting, and more.

.. _zend.event-manager.event-manager.methods.trigger-until:

**triggerUntil**
   ``triggerUntil(string $event, mixed $target, mixed $argv = null, callback $callback = null)``

   Triggers all listeners to a named event, just like :ref:`trigger()
   <zend.event-manager.event-manager.methods.trigger>`, with the addition that it passes the return value from each
   listener to ``$callback``; if ``$callback`` returns a boolean ``true`` value, execution of the listeners is
   interrupted. You can test for this using *$result->stopped()*.

.. _zend.event-manager.event-manager.methods.attach:

**attach**
   ``attach(string $event, callback $callback, int $priority)``

   Attaches ``$callback`` to the ``EventManager`` instance, listening for the event ``$event``. If a ``$priority``
   is provided, the listener will be inserted into the internal listener stack using that priority; higher values
   execute earliest. (Default priority is "1", and negative priorities are allowed.)

   The method returns an instance of ``Zend\Stdlib\CallbackHandler``; this value can later be passed to
   ``detach()`` if desired.

.. _zend.event-manager.event-manager.methods.attach-aggregate:

**attachAggregate**
   ``attachAggregate(string|ListenerAggregate $aggregate)``

   If a string is passed for ``$aggregate``, instantiates that class. The ``$aggregate`` is then passed the
   ``EventManager`` instance to its ``attach()`` method so that it may register listeners.

   The ``ListenerAggregate`` instance is returned.

.. _zend.event-manager.event-manager.methods.detach:

**detach**
   ``detach(CallbackHandler|ListenerAggregateInterface $listener)``

   Scans all listeners, and detaches any that match ``$listener`` so that they will no longer be triggered.

   Returns a boolean ``true`` if any listeners have been identified and unsubscribed, and a boolean ``false``
   otherwise.

.. _zend.event-manager.event-manager.methods.detach-aggregate:

**detachAggregate**
   ``detachAggregate(ListenerAggregateInterface $aggregate)``

   Loops through all listeners of all events to identify listeners that are represented by the aggregate; for all
   matches, the listeners will be removed.

   Returns a boolean ``true`` if any listeners have been identified and unsubscribed, and a boolean ``false``
   otherwise.

.. _zend.event-manager.event-manager.methods.get-events:

**getEvents**
   ``getEvents()``

   Returns an array of all event names that have listeners attached.

.. _zend.event-manager.event-manager.methods.get-listeners:

**getListeners**
   ``getListeners(string $event)``

   Returns a ``Zend\Stdlib\PriorityQueue`` instance of all listeners attached to ``$event``.

.. _zend.event-manager.event-manager.methods.clear-listeners:

**clearListeners**
   ``clearListeners(string $event)``

   Removes all listeners attached to ``$event``.

.. _zend.event-manager.event-manager.methods.prepare-args:

**prepareArgs**
   ``prepareArgs(array $args)``

   Creates an ``ArrayObject`` from the provided ``$args``. This can be useful if you want yours listeners to be
   able to modify arguments such that later listeners or the triggering method can see the changes.

.. _zend.event-manager.event-manager.examples:

Examples
--------

.. _zend.event-manager.event-manager.examples.modifying-args:

.. rubric:: Modifying Arguments

Occasionally it can be useful to allow listeners to modify the arguments they receive so that later listeners or
the calling method will receive those changed values.

As an example, you might want to pre-filter a date that you know will arrive as a string and convert it to a
``DateTime`` argument.

To do this, you can pass your arguments to ``prepareArgs()``, and pass this new object when triggering an event.
You will then pull that value back into your method.

.. code-block:: php
   :linenos:

   class ValueObject
   {
       // assume a composed event manager

       function inject(array $values)
       {
           $argv = compact('values');
           $argv = $this->getEventManager()->prepareArgs($argv);
           $this->getEventManager()->trigger(__FUNCTION__, $this, $argv);
           $date = isset($argv['values']['date']) ? $argv['values']['date'] : new DateTime('now');

           // ...
       }
   }

   $v = new ValueObject();

   $v->getEventManager()->attach('inject', function($e) {
       $values = $e->getParam('values');
       if (!$values) {
           return;
       }

       if (!isset($values['date'])) {
           $values['date'] = new \DateTime('now');
       } else {
           $values['date'] = new \Datetime($values['date']);
       }
       
       $e->setParam('values', $values);
   });

   $v->inject(array(
       'date' => '2011-08-10 15:30:29',
   ));

.. _zend.event-manager.event-manager.examples.short-circuiting:

.. rubric:: Short Circuiting

One common use case for events is to trigger listeners until either one indicates no further processing should be
done, or until a return value meets specific criteria. As examples, if an event creates a Response object, it may
want execution to stop.

.. code-block:: php
   :linenos:

   $listener = function($e) {
       // do some work

       // Stop propagation and return a response
       $e->stopPropagation(true);
       return $response;
   };

Alternately, we could do the check from the method triggering the event.

.. code-block:: php
   :linenos:

   class Foo implements DispatchableInterface
   {
       // assume composed event manager

       public function dispatch(Request $request, Response $response = null)
       {
           $argv = compact('request', 'response');
           $results = $this->getEventManager()->triggerUntil(__FUNCTION__, $this, $argv, function($v) {
               return ($v instanceof Response);
           });
       }
   }

Typically, you may want to return a value that stopped execution, or use it some way. Both ``trigger()`` and
``triggerUntil()`` return a ``ResponseCollection`` instance; call its ``stopped()`` method to test if execution was
stopped, and ``last()`` method to retrieve the return value from the last executed listener:

.. code-block:: php
   :linenos:

   class Foo implements DispatchableInterface
   {
       // assume composed event manager

       public function dispatch(Request $request, Response $response = null)
       {
           $argv = compact('request', 'response');
           $results = $this->getEventManager()->triggerUntil(__FUNCTION__, $this, $argv, function($v) {
               return ($v instanceof Response);
           });

           // Test if execution was halted, and return last result:
           if ($results->stopped()) {
               return $results->last();
           }

           // continue...
       }
   }

.. _zend.event-manager.event-manager.examples.priority:

.. rubric:: Assigning Priority to Listeners

One use case for the ``EventManager`` is for implementing caching systems. As such, you often want to check the
cache early, and save to it late.

The third argument to ``attach()`` is a priority value. The higher this number, the earlier that listener will
execute; the lower it is, the later it executes. The value defaults to 1, and values will trigger in the order
registered within a given priority.

So, to implement a caching system, our method will need to trigger an event at method start as well as at method
end. At method start, we want an event that will trigger early; at method end, an event should trigger late.

Here is the class in which we want caching:

.. code-block:: php
   :linenos:

   class SomeValueObject
   {
       // assume it composes an event manager

       public function get($id)
       {
           $params = compact('id');
           $results = $this->getEventManager()->trigger('get.pre', $this, $params);

           // If an event stopped propagation, return the value
           if ($results->stopped()) {
               return $results->last();
           }

           // do some work...

           $params['__RESULT__'] = $someComputedContent;
           $this->getEventManager()->trigger('get.post', $this, $params);
       }
   }

Now, let's create a ``ListenerAggregateInterface`` that can handle caching for us:

.. code-block:: php
   :linenos:

   use Zend\Cache\Cache;
   use Zend\EventManager\EventManagerInterface;
   use Zend\EventManager\ListenerAggregateInterface;
   use Zend\EventManager\EventInterface;

   class CacheListener implements ListenerAggregateInterface
   {
       protected $cache;

       protected $listeners = array();

       public function __construct(Cache $cache)
       {
           $this->cache = $cache;
       }

       public function attach(EventManagerInterface $events)
       {
           $this->listeners[] = $events->attach('get.pre', array($this, 'load'), 100);
           $this->listeners[] = $events->attach('get.post', array($this, 'save'), -100);
       }

       public function detach(EventManagerInterface $events)
       {
           foreach ($this->listeners as $index => $listener) {
               if ($events->detach($listener)) {
                   unset($this->listeners[$index]);
               }
           }
       }

       public function load(EventInterface $e)
       {
           $id = get_class($e->getTarget()) . '-' . json_encode($e->getParams());
           if (false !== ($content = $this->cache->load($id))) {
               $e->stopPropagation(true);
               return $content;
           }
       }

       public function save(EventInterface $e)
       {
           $params  = $e->getParams();
           $content = $params['__RESULT__'];
           unset($params['__RESULT__']);

           $id = get_class($e->getTarget()) . '-' . json_encode($params);
           $this->cache->save($content, $id);
       }
   }

We can then attach the aggregate to an instance.

.. code-block:: php
   :linenos:

   $value         = new SomeValueObject();
   $cacheListener = new CacheListener($cache);
   $value->getEventManager()->attachAggregate($cacheListener);

Now, as we call ``get()``, if we have a cached entry, it will be returned immediately; if not, a computed entry
will be cached when we complete the method.


