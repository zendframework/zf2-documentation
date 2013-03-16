.. _user-guide.conclusion:

Conclusion
==========

This concludes our brief look at building a simple, but fully functional, MVC
application using Zend Framework 2. 

In this tutorial we but briefly touched quite a number of different parts of
the framework.

The most important part of applications built with Zend Framework 2 are the
:ref:`modules <zend.module-manager.intro>`, the building blocks of any 
:ref:`MVC ZF2 application <zend.mvc.intro>`.

To ease the work with dependencies inside our applications, we use the
:ref:`service manager <zend.service-manager.intro>`.

To be able to map a request to controllers and their actions, we use
:ref:`routes <zend.mvc.routing>`.

Data persistence, in most cases, includes using :ref:`Zend\\Db <zend.db.adapter>`
to communicate with one of the databases. Input data is filtered and validated
with :ref:`input filters <zend.input-filter.intro>` and together with 
:ref:`Zend\\Form <zend.form.intro>` they provide a strong bridge between
the domain model and the view layer.

:ref:`Zend\\View <zend.view.quick-start>` is responsible for the View in the MVC
stack, together with a vast amount of :ref:`view helpers <zend.view.helpers>`.
