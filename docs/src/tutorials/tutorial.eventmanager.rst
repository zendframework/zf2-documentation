.. _tutorials.eventmanager.rst:

Using the EventManager
======================

This tutorial explores the various features of ``Zend\EventManager``.

.. _terminology:

Terminology
-----------

* An **Event** is a named action.
* A **Listener** is any PHP callback that reacts to an *event*.
* An **EventManager** *aggregates* listeners for one or more named events, and
  *triggers* events.

Typically, an *event* will be modeled as an object, containing metadata
surrounding when and how it was triggered, including the event name, what object
triggered the event (the "target"), and what parameters were provided. Events
are *named*, which allows a single *listener* to branch logic based on the
event.

.. _getting-started:

Getting started
---------------

The minimal things necessary to start using events are:

* An ``EventManager`` instance
* One or more listeners on one or more events
* A call to ``trigger()`` an event

The simplest example looks something like this:

.. code-block:: php
    :linenos:

    use Zend\EventManager\EventManager;

    $events = new EventManager();
    $events->attach('do', function ($e) {
        $event = $e->getName();
        $params = $e->getParams();
        printf(
            'Handled event "%s", with parameters %s',
            $event,
            json_encode($params)
        );
    });

    $params = array('foo' => 'bar', 'baz' => 'bat');
    $events->trigger('do', null, $params);

The above will result in the following::

    Handled event "do", with parameters {"foo":"bar","baz":"bat"}

.. note::

    Throughout this tutorial, we use closures as listeners. However, any valid
    PHP callback can be attached as a listeners: PHP function names, static
    class methods, object instance methods, functors, or closures. We use
    closures within this post simply for illustration and simplicity.

If you were paying attention to the example, you will have noted the ``null``
argument. Why is it there?

Typically, you will compose an ``EventManager`` within a class, to allow
triggering actions within methods. The middle argument to ``trigger()`` is the
"target", and in the case described, would be the current object instance. This
gives event listeners access to the calling object, which can often be useful.

.. code-block:: php
    :linenos:

    use Zend\EventManager\EventManager;
    use Zend\EventManager\EventManagerAwareInterface;
    use Zend\EventManager\EventManagerInterface;

    class Example implements EventManagerAwareInterface
    {
        protected $events;
        
        public function setEventManager(EventManagerInterface $events)
        {
            $events->setIdentifiers(array(
                __CLASS__,
                get_class($this)
            ));
            $this->events = $events;
        }
        
        public function getEventManager()
        {
            if (!$this->events) {
                $this->setEventManager(new EventManager());
            }
            return $this->events;
        }
        
        public function do($foo, $baz)
        {
            $params = compact('foo', 'baz');
            $this->getEventManager()->trigger(__FUNCTION__, $this, $params);
        }

    }

    $example = new Example();

    $example->getEventManager()->attach('do', function($e) {
        $event  = $e->getName();
        $target = get_class($e->getTarget()); // "Example"
        $params = $e->getParams();
        printf(
            'Handled event "%s" on target "%s", with parameters %s',
            $event,
            $target,
            json_encode($params)
        );
    });

    $example->do('bar', 'bat');

The above is basically the same as the first example. The main difference is
that we're now using that middle argument in order to pass the target, the
instance of ``Example``, on to the listeners. Our listener is now retrieving
that (``$e->getTarget()``), and doing something with it.

If you're reading this critically, you should have a new question: What is the
call to ``setIdentifiers()`` for?

.. _shared-managers:

Shared managers
---------------

One aspect that the ``EventManager`` implementation provides is an ability to
compose a ``SharedEventManagerInterface`` implementation. 

``Zend\EventManager\SharedEventManagerInterface`` describes an object that
aggregates listeners for events attached to objects with specific *identifiers*.
It does not trigger events itself. Instead, an ``EventManager`` instance that
composes a ``SharedEventManager`` will query the ``SharedEventManager`` for
listeners on identifiers it's interested in, and trigger those listeners as
well.

How does this work, exactly?

Consider the following:

.. code-block:: php
    :linenos:

    use Zend\EventManager\SharedEventManager;

    $sharedEvents = new SharedEventManager();
    $sharedEvents->attach('Example', 'do', function ($e) {
        $event  = $e->getName();
        $target = get_class($e->getTarget()); // "Example"
        $params = $e->getParams();
        printf(
            'Handled event "%s" on target "%s", with parameters %s',
            $event,
            $target,
            json_encode($params)
        );
    });

This looks almost identical to the previous example; the key difference is that
there is an additional argument at the *start* of the list, ``'Example'``. This
code is basically saying, "Listen to the 'do' event of the 'Example' target,
and, when notified, execute this callback."

This is where the ``setIdentifiers()`` argument of ``EventManager`` comes into
play.  The method allows passing a string, or an array of strings, defining the
name or names of the context or targets the given instance will be interested
in. If an array is given, then any listener on any of the targets given will be
notified.

So, getting back to our example, let's assume that the above shared listener is
registered, and also that the ``Example`` class is defined as above. We can then
execute the following:

.. code-block:: php
    :linenos:

    $example = new Example();
    $example->getEventManager()->setSharedManager($sharedEvents);
    $example->do('bar', 'bat');

and expect the following to be ``echo``'d::

    Handled event "do" on target "Example", with parameters {"foo":"bar","baz":"bat"}

Now, let's say we extended ``Example`` as follows:

.. code-block:: php
    :linenos:

    class SubExample extends Example
    {
    }

One interesting aspect of our ``setEventManager()`` method is that we defined it
to listen both on ``__CLASS__`` and ``get_class($this)``. This means that
calling ``do()`` on our ``SubExample`` class would also trigger the shared
listener! It also means that, if desired, we could attach to specifically
``SubExample``, and listeners attached to only the ``Example`` target would not
be triggered.

Finally, the names used as contexts or targets need not be class names; they can
be some name that only has meaning in your application if desired. As an
example, you could have a set of classes that respond to "log" or "cache" -- and
listeners on these would be notified by any of them.

.. note::

    We recommend using class names, interface names, and/or abstract class names
    for identifiers. This makes determining what events are available easier, as
    well as finding which listeners might be attaching to those events.
    Interfaces make a particularly good use case, as they allow attaching to a
    group of related classes a single operation.

At any point, if you do not want to notify shared listeners, pass a ``null``
value to ``setSharedManager()``:

.. code-block:: php

    $events->setSharedManager(null);

and they will be ignored. If at any point, you want to enable them again, pass
the ``SharedEventManager`` instance:

.. code-block:: php

    $events->setSharedManager($sharedEvents);

Wildcards
=========

So far, with both a normal ``EventManager`` instance and with the
``SharedEventManager`` instance, we've seen the usage of singular strings
representing the event and target names to which we want to attach. What if you
want to attach a listener to multiple events or targets?

The answer is to supply an array of events or targets, or a wildcard, ``*``.

Consider the following examples:

.. code-block:: php
    :linenos:

    // Multiple named events:
    $events->attach(
        array('foo', 'bar', 'baz'), // events
        $listener
    );

    // All events via wildcard:
    $events->attach(
        '*', // all events
        $listener
    );

    // Multiple named targets:
    $sharedEvents->attach(
        array('Foo', 'Bar', 'Baz'), // targets
        'doSomething', // named event
        $listener
    );

    // All targets via wildcard
    $sharedEvents->attach(
        '*', // all targets
        'doSomething', // named event
        $listener
    );

    // Mix and match: multiple named events on multiple named targets:
    $sharedEvents->attach(
        array('Foo', 'Bar', 'Baz'), // targets
        array('foo', 'bar', 'baz'), // events
        $listener
    );

    // Mix and match: all events on multiple named targets:
    $sharedEvents->attach(
        array('Foo', 'Bar', 'Baz'), // targets
        '*', // events
        $listener
    );

    // Mix and match: multiple named events on all targets:
    $sharedEvents->attach(
        '*', // targets
        array('foo', 'bar', 'baz'), // events
        $listener
    );

    // Mix and match: all events on all targets:
    $sharedEvents->attach(
        '*', // targets
        '*', // events
        $listener
    );

The ability to specify multiple targets and/or events when attaching can slim
down your code immensely.

Listener aggregates
===================

Another approach to listening to multiple events is via a concept of listener
aggregates, represented by ``Zend\EventManager\ListenerAggregateInterface``.
Via this approach, a single class can listen to multiple events, attaching
one or more instance methods as listeners. 

This interface defines two methods, ``attach(EventManagerInterface $events)``
and ``detach(EventManagerInterface $events)``.  Basically, you pass an
``EventManager`` instance to one and/or the other, and then it's up to the
implementing class to determine what to do.

As an example:

.. code-block:: php
    :linenos:

    use Zend\EventManager\EventInterface;
    use Zend\EventManager\EventManagerInterface;
    use Zend\EventManager\ListenerAggregateInterface;
    use Zend\Log\Logger;
    
    class LogEvents implements ListenerAggregateInterface
    {
        protected $listeners = array();
        protected $log;
    
        public function __construct(Logger $log)
        {
            $this->log = $log;
        }
    
        public function attach(EventManagerInterface $events)
        {
            $this->listeners[] = $events->attach('do', array($this, 'log'));
            $this->listeners[] = $events->attach('doSomethingElse', array($this, 'log'));
        }
        
        public function detach(EventCollection $events)
        {
            foreach ($this->listeners as $index => $listener) {
                if ($events->detach($listener)) {
                    unset($this->listeners[$index];
                }
            }
        }
    
        public function log(EventInterface $e)
        {
            $event  = $e->getName();
            $params = $e->getParams();
            $this->log->info(sprintf('%s: %s', $event, json_encode($params)));
        }
    }

You can attach this using either ``attach()`` or ``attachAggregate()``:

.. code-block:: php

    $logListener = new LogEvents($logger);

    $events->attachAggregate($logListener); // OR
    $events->attach($logListener);

Any events the aggregate attaches to will then be notified when triggered.

Why bother? For a couple of reasons:

* Aggregates allow you to have stateful listeners. The above example
  demonstrates this via the composition of the logger; another example would be
  tracking configuration options.
* Aggregates make detaching listeners easier. When you call ``attach()``
  normally, you receive a ``Zend\Stdlib\CallbackHandler`` instance; the only way
  to ``detach()`` a listener is to pass that instance back -- which means if you
  want to detach later, you need to keep that instance somewhere. Aggregates
  typically do this for you -- as you can see in the example above.

.. _introspecting-results:

Introspecting results
---------------------

Sometimes you'll want to know what your listeners returned. One thing to
remember is that you may have multiple listeners on the same event; the
interface for results must be consistent regardless of the number of listeners.

The ``EventManager`` implementation by default returns a
``Zend\EventManager\ResponseCollection`` instance. This class extends PHP's
``SplStack``, allowing you to loop through responses in reverse order (since the
last one executed is likely the one you're most interested in). It also
implements the following methods:

* ``first()`` will retrieve the first result received
* ``last()`` will retrieve the last result received
* ``contains($value)`` allows you to test all values to see if a given one was
  received, and returns simply a boolean ``true`` if found, and ``false`` if not.

Typically, you should not worry about the return values from events, as the
object triggering the event shouldn't really have much insight into what
listeners are attached. However, sometimes you may want to short-circuit
execution if interesting results are obtained.

.. _short-circuiting-listener-execution:

Short-circuiting listener execution
----------------------------------

You may want to short-ciruit execution if a particular result is obtained, or if
a listener determines that something is wrong, or that it can return something
quicker than the target.

As examples, one rationale for adding an ``EventManager`` is as a caching mechanism.
You can trigger one event early in the method, returning if a cache is found,
and trigger another event late in the method, seeding the cache.

The ``EventManager`` component offers two ways to handle this. The first is to
pass a callback as the last argument to ``trigger()``; if that callback returns
a boolean ``true``, execution is halted.

Here's an example:

.. code-block:: php
    :linenos:

    public function someExpensiveCall($criteria1, $criteria2)
    {
        $params  = compact('criteria1', 'criteria2');
        $results = $this->getEventManager()->trigger(
            __FUNCTION__, 
            $this, 
            $params, 
            function ($r) {
                return ($r instanceof SomeResultClass);
            }
        );
        if ($results->stopped()) {
            return $results->last();
        }
        
        // ... do some work ...
    }

With this paradigm, we know that the likely reason of execution halting is due
to the last result meeting the test callback criteria; as such, we simply return
that last result.

The other way to halt execution is within a listener, acting on the ``Event``
object it receives. In this case, the listener calls ``stopPropagation(true)``,
and the ``EventManager`` will then return without notifying any additional
listeners.

.. code-block:: php
    :linenos:

    $events->attach('do', function ($e) {
        $e->stopPropagation();
        return new SomeResultClass();
    });

This, of course, raises some ambiguity when using the trigger paradigm, as you
can no longer be certain that the last result meets the criteria it's searching
on. As such, we recommend that you standardize on one approach or the other.

.. _keeping-it-in-order:

Keeping it in order
-------------------

On occasion, you may be concerned about the order in which listeners execute. As
an example, you may want to do any logging early, to ensure that if
short-circuiting occurs, you've logged; or if implementing a cache, you may want
to return early if a cache hit is found, and execute late when saving to a
cache.

Each of ``EventManager::attach()`` and ``SharedEventManager::attach()`` accept
one additional argument, a *priority*. By default, if this is omitted, listeners
get a priority of 1, and are executed in the order in which they are attached.
However, if you provide a priority value, you can influence order of execution.

* Higher priority values execute *earlier*.
* Lower (negative) priority values execute *later*.

To borrow an example from earlier:

.. code-block:: php
    :linenos:

    $priority = 100;
    $events->attach('Example', 'do', function($e) {
        $event  = $e->getName();
        $target = get_class($e->getTarget()); // "Example"
        $params = $e->getParams();
        printf(
            'Handled event "%s" on target "%s", with parameters %s',
            $event,
            $target,
            json_encode($params)
        );
    }, $priority);

This would execute with high priority, meaning it would execute early. If we
changed ``$priority`` to ``-100``, it would execute with low priority, executing
late.

While you can't necessarily know all the listeners attached, chances are you can
make adequate guesses when necessary in order to set appropriate priority
values. We advise avoiding setting a priority value unless absolutely necessary.

.. _custom-event-objects:

Custom event objects
--------------------

Hopefully some of you have been wondering, "where and when is the Event object
created"? In all of the examples above, it's created based on the arguments
passed to ``trigger()`` -- the event name, target, and parameters. Sometimes,
however, you may want greater control over the object.

As an example, one thing that looks like a code smell is when you have code like
this:

.. code-block:: php
    :linenos:

    $routeMatch = $e->getParam('route-match', false);
    if (!$routeMatch) {
        // Oh noes! we cannot do our work! whatever shall we do?!?!?!
    }

The problems with this are several. First, relying on string keys is going to
very quickly run into problems -- typos when setting or retrieving the argument
can lead to hard to debug situations. Second, we now have a documentation issue;
how do we document expected arguments? how do we document what we're shoving
into the event? Third, as a side effect, we can't use IDE or editor hinting
support -- string keys give these tools nothing to work with.

Similarly, consider how you might represent a computational result of a method
when triggering an event. As an example:

.. code-block:: php
    :linenos:

    // in the method:
    $params['__RESULT'] = $computedResult;
    $events->trigger(__FUNCTION__ . '.post', $this, $params);

    // in the listener:
    $result = $e->getParam('__RESULT__');
    if (!$result) {
        // Oh noes! we cannot do our work! whatever shall we do?!?!?!
    }

Sure, that key may be unique, but it suffers from a lot of the same issues.

So, the solution is to create custom events. As an example, we have a custom
``MvcEvent`` in the ZF2 MVC layer. This event composes the application instance,
the router, the route match object, request and response objects, the view
model, and also a result. We end up with code like this in our listeners:

.. code-block:: php
    :linenos:

    $response = $e->getResponse();
    $result   = $e->getResult();
    if (is_string($result)) {
        $content = $view->render('layout.phtml', array('content' => $result));
        $response->setContent($content);
    }

But how do we use this custom event? Simple: ``trigger()`` can accept an event
object instead of any of the event name, target, or params arguments.

.. code-block:: php
    :linenos:

    $event = new CustomEvent();
    $event->setSomeKey($value);

    // Injected with event name and target:
    $events->trigger('foo', $this, $event);

    // Injected with event name:
    $event->setTarget($this);
    $events->trigger('foo', $event);

    // Fully encapsulates all necessary properties:
    $event->setName('foo');
    $event->setTarget($this);
    $events->trigger($event);

    // Passing a callback following the event object works for 
    // short-circuiting, too.
    $results = $events->trigger('foo', $this, $event, $callback);

This is a really powerful technique for domain-specific event systems, and
definitely worth experimenting with.

.. _putting-it-together:

Putting it together: Implementing a simple caching system
---------------------------------------------------------

In previous sections, I indicated that short-circuiting is a way to potentially
implement a caching solution. Let's create a full example.

First, let's define a method that could use caching. You'll note that in most of
the examples, I've used ``__FUNCTION__`` as the event name; this is a good practice,
as it makes it simple to create a macro for triggering events, as well as helps
to keep event names unique (as they're usually within the context of the
triggering class). However, in the case of a caching example, this would lead to
identical events being triggered. As such, I recommend postfixing the event name
with semantic names: "do.pre", "do.post", "do.error", etc. I'll use that
convention in this example.

Additionally, you'll notice that the ``$params`` I pass to the event is usually the
list of parameters passed to the method. This is because those are often not
stored in the object, and also to ensure the listeners have the exact same
context as the calling method. But it raises an interesting problem in this
example: what name do we give the result of the method? One standard that has
emerged is the use of ``__RESULT__``, as double-underscored variables are
typically reserved for the sytem.

Here's what the method will look like:

.. code-block:: php
    :linenos:

    public function someExpensiveCall($criteria1, $criteria2)
    {
        $params  = compact('criteria1', 'criteria2');
        $results = $this->getEventManager()->trigger(
            __FUNCTION__ . '.pre',
            $this,
            $params,
            function ($r) {
                return ($r instanceof SomeResultClass);
            }
        );
        if ($results->stopped()) {
            return $results->last();
        }
        
        // ... do some work ...
        
        $params['__RESULT__'] = $calculatedResult;
        $this->events()->trigger(__FUNCTION__ . '.post', $this, $params);
        return $calculatedResult;
    }

Now, to provide some caching listeners. We'll need to attach to each of the
"someExpensiveCall.pre" and "someExpensiveCall.post" methods. In the former
case, if a cache hit is detected, we return it, and move on. In the latter, we
store the value in the cache.

We'll assume ``$cache`` is defined, and follows the paradigms of ``Zend\Cache``. We'll
want to return early if a hit is detected, and execute late when saving a cache
(in case the result is modified by another listener). As such, we'll set the
"someExpensiveCall.pre" listener to execute with priority ``100``, and the
"someExpensiveCall.post" listener to execute with priority ``-100``.

.. code-block:: php
    :linenos:

    $events->attach('someExpensiveCall.pre', function($e) use ($cache) {
        $params = $e->getParams();
        $key    = md5(json_encode($params));
        $hit    = $cache->load($key);
        return $hit;
    }, 100);

    $events->attach('someExpensiveCall.post', function($e) use ($cache) {
        $params = $e->getParams();
        $result = $params['__RESULT__'];
        unset($params['__RESULT__']);
        $key    = md5(json_encode($params));
        $cache->save($result, $key);
    }, -100);

.. note::

    The above could have been done within a ``ListenerAggregate``, which would
    have allowed keeping the ``$cache`` instance as a stateful property, instead
    of importing it into closures.

Another approach would be to move the body of the method to a listener as well,
which would allow using the priority system in order to implement caching. That
would look like this:

.. code-block:: php
    :linenos:

    public function setEventManager(EventManagerInterface $events)
    {
        $this->events = $events;
        $events->setIdentifiers(array(__CLASS__, get_class($this)));
        $events->attach('someExpensiveCall', array($this, 'doSomeExpensiveCall'));
    }

    public function someExpensiveCall($criteria1, $criteria2)
    {
        $params  = compact('criteria1', 'criteria2');
        $results = $this->getEventManager()->trigger(
            __FUNCTION__,
            $this,
            $params,
            function ($r) {
                return ($r instanceof SomeResultClass);
            }
        );
        return $results->last();
    }

    public function doSomeExpensiveCall($e)
    {
        // ... do some work ...
        $e->setParam('__RESULT__', $calculatedResult);
        return $calculatedResult;
    }

The listeners would then attach to the "someExpensiveCall" event, with the cache
lookup listener listening at high priority, and the cache storage listener
listening at low (negative) priority.

Sure, we could probably simply add caching to the object itself - but this
approach allows the same handlers to be attached to multiple events, or to
attach multiple listeners to the same events (e.g. an argument validator, a
logger and a cache manager). The point is that if you design your object with
events in mind, you can easily make it more flexible and extensible, without
requiring developers to actually extend it -- they can simply attach listeners.

.. _conclusion:

Conclusion
----------

The ``EventManager`` is a powerful component. It drives the workflow of the MVC
layer, and is used in countless components to provide hook points for developers
to manipulate the workflow. It can be put to any number of uses inside your own
code, and is an important part of your Zend Framework toolbox.
