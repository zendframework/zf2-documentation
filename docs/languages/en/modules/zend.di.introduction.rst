.. _zend.di.intro:

Introduction to Zend\\Di
========================

.. _zend.di.intro.di:

Dependency Injection
--------------------

Dependency Injection (here-in called DI) is a concept that has been talked about in numerous places over the web.
Simply put, we'll explain the act of injecting dependencies simply with this below code:

.. code-block:: php
   :linenos:

   $b = new MovieLister(new MovieFinder());

Above, MovieFinder is a dependency of MovieLister, and MovieFinder was injected into MovieLister. If you are not
familiar with the concept of DI, here are a couple of great reads: `Matthew Weier O'Phinney's Analogy`_, `Ralph
Schindler's Learning DI`_, or `Fabien Potencier's Series`_ on DI.

.. note::

   ``Zend\Di`` is an example of an Inversion of Control (IoC) container. IoC containers are widely
   used to create object instances that have all dependencies resolved and injected. Dependency
   Injection containers are one form of IoC -- but not the only form.

   Zend Framework 2 ships with another form of IoC as well, :ref:`Zend\ServiceManager <zend.service-manager.intro>`.
   Unlike ``Zend\Di``, The ServiceManager is code-driven, meaning that you typically tell it what
   class to instantiate, or provide a factory for the given class. This approach offers several
   benefits:

   - Easier to debug (error stacks take you into your factories, not the dependency injection
     container).
   - Easier to setup (write code to instantiate objects, instead of configuration).
   - Faster (``Zend\Di`` has known performance issues due to the approaches used).

   Unless you have specific needs for a dependency injection container versus more general Inversion
   of Control, we recommend using ``Zend\ServiceManager`` for the above reasons.

.. _zend.di.intro.dic:

Dependency Injection Containers
-------------------------------

When your code is written in such a way that all your dependencies are injected into consuming objects, you might
find that the simple act of wiring an object has gotten more complex. When this becomes the case, and you find that
this wiring is creating more boilerplate code, this makes for an excellent opportunity to utilize a Dependency
Injection Container.

In it's simplest form, a Dependency Injection Container (here-in called a DiC for brevity), is an object that is
capable of creating objects on request and managing the "wiring", or the injection of required dependencies, for
those requested objects. Since the patterns that developers employ in writing DI capable code vary, DiC's are
generally either in the form of smallish objects that suit a very specific pattern, or larger DiC frameworks.

Zend\\Di is a DiC framework. While for the simplest code there is no configuration needed, and the use cases are
quite simple; for more complex code, Zend\\Di is capable of being configured to wire these complex use cases



.. _`Matthew Weier O'Phinney's Analogy`: http://weierophinney.net/matthew/archives/260-Dependency-Injection-An-analogy.html
.. _`Ralph Schindler's Learning DI`: http://ralphschindler.com/2011/05/18/learning-about-dependency-injection-and-php
.. _`Fabien Potencier's Series`: http://fabien.potencier.org/article/11/what-is-dependency-injection
