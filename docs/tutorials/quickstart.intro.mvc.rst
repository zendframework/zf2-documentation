.. _learning.quickstart.intro:

Zend Framework & MVC Introduction
=================================

.. _learning.quickstart.intro.zf:

Zend Framework
--------------

Zend Framework is an open source, object oriented web application framework for *PHP* 5. Zend Framework is often called a 'component library', because it has many loosely coupled components that you can use more or less independently. But Zend Framework also provides an advanced Model-View-Controller (*MVC*) implementation that can be used to establish a basic structure for your Zend Framework applications. A full list of Zend Framework components along with short descriptions may be found in the `components overview`_. This QuickStart will introduce you to some of Zend Framework's most commonly used components, including ``Zend_Controller``, ``Zend_Layout``, ``Zend_Config``, ``Zend_Db``, ``Zend_Db_Table``, ``Zend_Registry``, along with a few view helpers.

Using these components, we will build a simple database-driven guest book application within minutes. The complete source code for this application is available in the following archives:

- `zip`_

- `tar.gz`_

.. _learning.quickstart.intro.mvc:

Model-View-Controller
---------------------

So what exactly is this *MVC* pattern everyone keeps talking about, and why should you care? *MVC* is much more than just a three-letter acronym (*TLA*) that you can whip out anytime you want to sound smart; it has become something of a standard in the design of modern web applications. And for good reason. Most web application code falls under one of the following three categories: presentation, business logic, and data access. The *MVC* pattern models this separation of concerns well. The end result is that your presentation code can be consolidated in one part of your application with your business logic in another and your data access code in yet another. Many developers have found this well-defined separation indispensable for keeping their code organized, especially when more than one developer is working on the same application.

.. note::

   **More Information**

   Let's break down the pattern and take a look at the individual pieces:

   .. image:: ../images/learning.quickstart.intro.mvc.png
      :width: 321
      :align: center

   - **Model**- This is the part of your application that defines its basic functionality behind a set of abstractions. Data access routines and some business logic can be defined in the model.

   - **View**- Views define exactly what is presented to the user. Usually controllers pass data to each view to render in some format. Views will often collect data from the user, as well. This is where you're likely to find *HTML* markup in your *MVC* applications.

   - **Controller**- Controllers bind the whole pattern together. They manipulate models, decide which view to display based on the user's request and other factors, pass along the data that each view will need, or hand off control to another controller entirely. Most *MVC* experts recommend `keeping controllers as skinny as possible`_.

   Of course there is `more to be said`_ about this critical pattern, but this should give you enough background to understand the guestbook application we'll be building.



.. _`components overview`: http://framework.zend.com/about/components
.. _`zip`: http://framework.zend.com/demos/ZendFrameworkQuickstart.zip
.. _`tar.gz`: http://framework.zend.com/demos/ZendFrameworkQuickstart.tar.gz
.. _`keeping controllers as skinny as possible`: http://weblog.jamisbuck.org/2006/10/18/skinny-controller-fat-model
.. _`more to be said`: http://ootips.org/mvc-pattern.html
