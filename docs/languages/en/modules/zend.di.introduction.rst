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
