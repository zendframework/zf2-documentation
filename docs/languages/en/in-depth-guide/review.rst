Reviewing the Blog-application
===============================

Throughout the past seven chapters we have created a fully functional CRUD-Application using music-blogs as an example.
While doing so we've made use of several different design-patterns and best-practices. Now it's time to reiterate and
take a look at some of the code-samples we've written. This is going to be done in a Q&A fashion.

- `Do we always need all the layers and interfaces?`_
- `Having many objects, won't there be many code-duplication?`_
- `Why are there so many controllers?`_


Do we always need all the layers and interfaces?
------------------------------------------------

Short answer: no.

Long answer: The importance of interfaces goes up the bigger your application becomes. If you can foresee that
your application will be used by other people or is supposed to be extendable, then you should strongly consider to
always code against interfaces. This is a very common best-practice that is not tied to ZF2 specifically but rather
aimed at strict OOP programming.

The main role of the multiple layers that we have introduced ( **Controller** -> **Service** -> **Mapper** ->
**Backend** ) are to get a strict separation of concerns for all of our objects. There are many resources who can
explain in detail the big advantages of each layer so please go ahead and read up on them.

For a very simple application, though, you're most likely to strip away the **Mapper**-layer. In practice all the code
from the mapper layer often resides inside the services directly. And this works for most of the applications but as
soon as you plan to support multiple backends (i.e. open source software) or you want to be prepared for changing
backends, you should always consider including this layer.


Having many objects, won't there be much code-duplication?
----------------------------------------------------------

Short answer: yes.

Long answer: there doesn't need to be. Most code-duplication would come from the mapper-layer, too. If you take a
closer look at the class you'll notice that there's just two things that are tied to a specific object. First, it is
the name of the database-table. Second, it is the object-prototype that's passed into the mapper.

The prototype is already passed into the class from the ``__construct()`` function so that's already interchangeable.
If you want to make the table-name interchangeable, too, all you need to do is to provide the table-name from the
constructor, too, and you have a fully versatile db-mapper-implementation that can be used for pretty much every
object of your application.

You could then write a factory class that could look like this:

.. code-block:: php
   :linenos:

    <?php

    class NewsMapperFactory implements FactoryInterface
    {
        public function createService(ServiceLocatorInterface $serviceLocator)
        {
            return new ZendDbSqlMapper(
                $serviceLocator->get('Zend\Db\Adapter\Adapter'), // DB-Adapter
                'news',                                          // Table-Name
                new ClassMethods(false),                         // Object-Hydrator
                new News()                                       // Object-Prototype
            );
        }
    }


Why are there so many controllers?
----------------------------------

Looking back at code-examples from a couple of years back you'll notice that there was a lot of code inside each
controller. This has become a bad-practice that's known as Fat Controllers or Bloated Controllers.

The major difference about each controller we have created is that there are different dependencies. For example, the
``WriteController`` required the ``PostForm`` as well as the ``PostService`` while the ``DeleteController`` only required the
``PostService``. In this example it wouldn't make sense to write the ``deleteAction()`` into the ``WriteController`` because
we then would needlessly create an instance of the ``PostForm`` which is not required. In large scale applications this
would create a huge bottleneck that would slow down the application.

Looking at the ``DeleteController`` as well as the ``ListController`` you'll notice that both controllers have the same
dependency. Both require only the ``PostService`` so why not merge them into one controller? The reason here is for
semantical reasons. Would you look for a ``deleteAction()`` in a ``ListController``? Most of us wouldn't and therefore we
have created a new class for that.

In applications where the ``InsertForm`` differs from the ``UpdateForm`` you'd always want to have two different controllers
for each of them instead of one united ``WriteController`` like we have in our example. These things heavily differ from
application to application but the general intent always is: **keep your controllers slim / lightweight**!


Do you have more questions? PR them!
------------------------------------

If there's anything you feel that's missing in this FAQ, please PR your question and we will give you the answer that
you need!
