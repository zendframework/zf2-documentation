Introducing Zend\\Db\\Sql and Zend\\Stdlib\\Hydrator
====================================================

In the last chapter we have introduced the mapping layer and created the ``PostMapperInterface``. Now it is time to
create an implementation of this interface so that we can make use of our ``PostService`` again. As an introductionary
example we will be using the ``Zend\Db\Sql`` classes. So let's jump right into it.


Preparing the Database
======================

Before we can start using a database we should prepare one. In this example we'll be using a MySQL-Database called
``blog`` which is accessible on the ``localhost``. The database will have one table called ``posts`` with three columns
``id``, ``title`` and ``text`` with the ``id`` being the primary key. For demo purpose, please use this database-dump.

.. code-block:: sql
   :linenos:

    CREATE TABLE posts (
      id int(11) NOT NULL auto_increment,
      title varchar(100) NOT NULL,
      text TEXT NOT NULL,
      PRIMARY KEY (id)
    );

    INSERT INTO posts (title, text)
      VALUES  ('Blog #1',  'Welcome to my first blog post');
    INSERT INTO posts (title, text)
      VALUES  ('Blog #2',  'Welcome to my second blog post');
    INSERT INTO posts (title, text)
      VALUES  ('Blog #3',  'Welcome to my third blog post');
    INSERT INTO posts (title, text)
      VALUES  ('Blog #4',  'Welcome to my fourth blog post');
    INSERT INTO posts (title, text)
      VALUES  ('Blog #5',  'Welcome to my fifth blog post');


Quick Facts Zend\\Db\\Sql
=========================

To create queries against a database using ``Zend\Db\Sql`` you need to have a database connection available. This
connection is served through any class implementing the ``Zend\Db\Adapter\AdapterInterface``. The most handy way to
create such a class is through the use of the ``Zend\Db\Adapter\AdapterServiceFactory`` which listens to the config-key
``db``. Let's start by creating the required configuration entries and modify your ``module.config.php`` adding a new
top-level key called ``db``:

.. code-block:: php
   :linenos:
   :emphasize-lines: 4-12

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array(
        'db' => array(
            'driver'         => 'Pdo',
            'username'       => 'SECRET_USERNAME',  //edit this
            'password'       => 'SECRET_PASSWORD',  //edit this
            'dsn'            => 'mysql:dbname=blog;host=localhost',
            'driver_options' => array(
                \PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES \'UTF8\''
            )
        ),
        'service_manager' => array( /** ServiceManager Config */ ),
        'view_manager'    => array( /** ViewManager Config */ ),
        'controllers'     => array( /** ControllerManager Config */ ),
        'router'          => array( /** Router Config */ )
    );

As you can see we've added the ``db``-key and inside we create the parameters required to create a driver instance.

.. note::

    One important thing to note is that in general you **do not** want to have your credentials inside the normal
    configuration file but rather in a local configuration file like ``/config/autoload/db.local.php``, that will
    **not** be pushed to servers using zend-skeletons ``.gitignore`` file. Keep this in mind when you share your codes!

    Taking this example you would have this file:

    .. code-block:: php
        :linenos:

        <?php
        // Filename: /config/autoload/db.local.php
        return array(
                'db' => array(
                    'driver'         => 'Pdo',
                    'username'       => 'SECRET_USERNAME',  //edit this
                    'password'       => 'SECRET_PASSWORD',  //edit this
                    'dsn'            => 'mysql:dbname=blog;host=localhost',
                    'driver_options' => array(
                        \PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES \'UTF8\''
                )
            ),
        );

The next thing we need to do is by making use of the ``AdapterServiceFactory``. This is a ``ServiceManager`` entry that
will look like the following:


.. code-block:: php
   :linenos:
   :emphasize-lines: 16

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array(
        'db' => array(
            'driver'         => 'Pdo',
            'username'       => 'SECRET_USERNAME',  //edit this
            'password'       => 'SECRET_PASSWORD',  //edit this
            'dsn'            => 'mysql:dbname=blog;host=localhost',
            'driver_options' => array(
                \PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES \'UTF8\''
            )
        ),
        'service_manager' => array(
            'factories' => array(
                'Blog\Service\PostServiceInterface' => 'Blog\Service\Factory\PostServiceFactory',
                'Zend\Db\Adapter\Adapter'           => 'Zend\Db\Adapter\AdapterServiceFactory'
            )
        ),
        'view_manager'    => array( /** ViewManager Config */ ),
        'controllers'     => array( /** ControllerManager Config */ ),
        'router'          => array( /** Router Config */ )
    );

Note the new Service that we called ``Zend\Db\Adapter\Adapter``. Calling this Service will now always give back a
running instance of the ``Zend\Db\Adapter\AdapterInterface`` depending on what driver we assign.

With the adapter in place we're now able to run queries against the database. The construction of queries is best done
through the "QueryBuilder" features of ``Zend\Db\Sql`` which are ``Zend\Db\Sql\Sql`` for select queries,
``Zend\Db\Sql\Insert`` for insert queries, ``Zend\Db\Sql\Update`` for update queries and ``Zend\Db\Sql\Delete`` for
delete queries. The basic workflow of these components is:

1. Build a query using ``Sql``, ``Insert``, ``Update`` or ``Delete``
2. Create an Sql-Statement from the ``Sql`` object
3. Execute the query
4. Do something with the result

Knowing this we can now write the implementation for the ``PostMapperInterface``.


Writing the mapper implementation
=================================

Our mapper implementation will reside inside the same namespace as its interface. Go ahead and create a class called
``ZendDbSqlMapper`` and implement the ``PostMapperInterface``.

.. code-block:: php
   :linenos:
   :emphasize-lines:

    <?php
    // Filename: /module/Blog/src/Blog/Mapper/ZendDbSqlMapper.php
    namespace Blog\Mapper;

    use Blog\Model\PostInterface;

    class ZendDbSqlMapper implements PostMapperInterface
    {
        /**
         * @param int|string $id
         *
         * @return PostInterface
         * @throws \InvalidArgumentException
         */
        public function find($id)
        {
        }

        /**
         * @return array|PostInterface[]
         */
        public function findAll()
        {
        }
    }

Now recall what we have learned earlier. For ``Zend\Db\Sql`` to function we will need a working implementation of the
``AdapterInterface``. This is a requirement and therefore will be injected using constructor-injection. Create a
``__construct()`` function that accepts an ``AdapterInterface`` as parameter and store it within the class.

.. code-block:: php
   :linenos:
   :emphasize-lines: 6, 8, 13, 18-21

    <?php
    // Filename: /module/Blog/src/Blog/Mapper/ZendDbSqlMapper.php
    namespace Blog\Mapper;

    use Blog\Model\PostInterface;
    use Zend\Db\Adapter\AdapterInterface;

    class ZendDbSqlMapper implements PostMapperInterface
    {
        /**
         * @var \Zend\Db\Adapter\AdapterInterface
         */
        protected $dbAdapter;

        /**
         * @param AdapterInterface  $dbAdapter
         */
        public function __construct(AdapterInterface $dbAdapter)
        {
            $this->dbAdapter = $dbAdapter;
        }

        /**
         * @param int|string $id
         *
         * @return PostInterface
         * @throws \InvalidArgumentException
         */
        public function find($id)
        {
        }

        /**
         * @return array|PostInterface[]
         */
        public function findAll()
        {
        }
    }

As you know from previous chapters, whenever we have a required parameter we need to write a factory for the class. Go
ahead and create a factory for our mapper implementation.

.. code-block:: php
   :linenos:
   :emphasize-lines:

    <?php
    // Filename: /module/Blog/src/Blog/Factory/ZendDbSqlMapperFactory.php
    namespace Blog\Factory;

    use Blog\Mapper\ZendDbSqlMapper;
    use Zend\ServiceManager\FactoryInterface;
    use Zend\ServiceManager\ServiceLocatorInterface;

    class ZendDbSqlMapperFactory implements FactoryInterface
    {
        /**
         * Create service
         *
         * @param ServiceLocatorInterface $serviceLocator
         *
         * @return mixed
         */
        public function createService(ServiceLocatorInterface $serviceLocator)
        {
            return new ZendDbSqlMapper(
                $serviceLocator->get('Zend\Db\Adapter\Adapter')
            );
        }
    }

We're now able to register our mapper implementation as a service. If you recall from the previous chapter, or if you
were to look at the current error message, you'll note that we call the Service ``Blog\Mapper\PostMapperInterface`` to
get a mapper implementation. Modify the configuration so that this key will call the newly called factory class.

.. code-block:: php
   :linenos:
   :emphasize-lines: 7

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array(
        'db'              => array( /** Db Config */ ),
        'service_manager' => array(
            'factories' => array(
                'Blog\Mapper\PostMapperInterface'   => 'Blog\Factory\ZendDbSqlMapperFactory',
                'Blog\Service\PostServiceInterface' => 'Blog\Service\Factory\PostServiceFactory',
                'Zend\Db\Adapter\Adapter'           => 'Zend\Db\Adapter\AdapterServiceFactory'
            )
        ),
        'view_manager'    => array( /** ViewManager Config */ ),
        'controllers'     => array( /** ControllerManager Config */ ),
        'router'          => array( /** Router Config */ )
    );

With the adapter in place you're now able to refresh the blog index at ``localhost:8080/blog`` and you'll notice that
the ``ServiceNotFoundException`` is gone and we get the following PHP Warning:

.. code-block:: text
   :linenos:

    Warning: Invalid argument supplied for foreach() in /module/Blog/view/blog/list/index.phtml on line 13
    ID	Text	Title

This is due to the fact that our mapper doesn't return anything yet. Let's modify the ``findAll()`` function to return
all blogs from the database table.

.. code-block:: php
   :linenos:
   :emphasize-lines: 37-43

    <?php
    // Filename: /module/Blog/src/Blog/Mapper/ZendDbSqlMapper.php
    namespace Blog\Mapper;

    use Zend\Db\Adapter\AdapterInterface;

    class ZendDbSqlMapper implements PostMapperInterface
    {
        /**
         * @var \Zend\Db\Adapter\AdapterInterface
         */
        protected $dbAdapter;

        /**
         * @param AdapterInterface  $dbAdapter
         */
        public function __construct(AdapterInterface $dbAdapter)
        {
            $this->dbAdapter = $dbAdapter;
        }

        /**
         * @param int|string $id
         *
         * @return \Blog\Entity\PostInterface
         * @throws \InvalidArgumentException
         */
        public function find($id)
        {
        }

        /**
         * @return array|\Blog\Entity\PostInterface[]
         */
        public function findAll()
        {
            $sql    = new Sql($this->dbAdapter);
            $select = $sql->select('posts');

            $stmt   = $sql->prepareStatementForSqlObject($select);
            $result = $stmt->execute();

            return $result;
        }
    }

The above code should look fairly straight forward to you. Sadly, though, a refresh of the application reveals another
error message.

.. code-block:: text
   :lineos:

    Fatal error: Call to a member function getId() on a non-object in /module/Blog/view/blog/list/index.phtml on line 15

Let's not return the ``$result`` variable for now and do a dump of it to see what we get here. Change the ``findAll()``
function and do a data dumping of the ``$result`` variable:

.. code-block:: php
   :linenos:
   :emphasize-lines: 45

    <?php
    // Filename: /module/Blog/src/Blog/Mapper/ZendDbSqlMapper.php
    namespace Blog\Mapper;

    use Blog\Model\PostInterface;
    use Zend\Db\Adapter\AdapterInterface;
    use Zend\Db\Sql\Sql;

    class ZendDbSqlMapper implements PostMapperInterface
    {
        /**
         * @var \Zend\Db\Adapter\AdapterInterface
         */
        protected $dbAdapter;

        /**
         * @param AdapterInterface  $dbAdapter
         */
        public function __construct(AdapterInterface $dbAdapter)
        {
            $this->dbAdapter = $dbAdapter;
        }

        /**
         * @param int|string $id
         *
         * @return PostInterface
         * @throws \InvalidArgumentException
         */
        public function find($id)
        {
        }

        /**
         * @return array|PostInterface[]
         */
        public function findAll()
        {
            $sql    = new Sql($this->dbAdapter);
            $select = $sql->select('posts');

            $stmt   = $sql->prepareStatementForSqlObject($select);
            $result = $stmt->execute();

            \Zend\Debug\Debug::dump($result);die();
        }
    }

Refreshing the application you should now see the following output:

.. code-block:: text
   :linenos:

    object(Zend\Db\Adapter\Driver\Pdo\Result)#303 (8) {
      ["statementMode":protected] => string(7) "forward"
      ["resource":protected] => object(PDOStatement)#296 (1) {
        ["queryString"] => string(29) "SELECT `posts`.* FROM `posts`"
      }
      ["options":protected] => NULL
      ["currentComplete":protected] => bool(false)
      ["currentData":protected] => NULL
      ["position":protected] => int(-1)
      ["generatedValue":protected] => string(1) "0"
      ["rowCount":protected] => NULL
    }

As you can see we do not get any data returned. Instead we are presented with a dump of some ``Result`` object that
appears to have no data in it whatsoever. But this is a faulty assumption. This ``Result`` object only has information
available for you when you actually try to access it. To make use of the data within the ``Result`` object the best
approach would be to pass the ``Result`` object over into a ``ResultSet`` object, as long as the query was successful.

.. code-block:: php
   :linenos:
   :emphasize-lines: 7, 47-53

    <?php
    // Filename: /module/Blog/src/Blog/Mapper/ZendDbSqlMapper.php
    namespace Blog\Mapper;

    use Blog\Model\PostInterface;
    use Zend\Db\Adapter\AdapterInterface;
    use Zend\Db\Adapter\Driver\ResultInterface;
    use Zend\Db\ResultSet\ResultSet;
    use Zend\Db\Sql\Sql;

    class ZendDbSqlMapper implements PostMapperInterface
    {
        /**
         * @var \Zend\Db\Adapter\AdapterInterface
         */
        protected $dbAdapter;

        /**
         * @param AdapterInterface  $dbAdapter
         */
        public function __construct(AdapterInterface $dbAdapter)
        {
            $this->dbAdapter = $dbAdapter;
        }

        /**
         * @param int|string $id
         *
         * @return PostInterface
         * @throws \InvalidArgumentException
         */
        public function find($id)
        {
        }

        /**
         * @return array|PostInterface[]
         */
        public function findAll()
        {
            $sql    = new Sql($this->dbAdapter);
            $select = $sql->select('posts');

            $stmt   = $sql->prepareStatementForSqlObject($select);
            $result = $stmt->execute();

            if ($result instanceof ResultInterface && $result->isQueryResult()) {
                $resultSet = new ResultSet();

                \Zend\Debug\Debug::dump($resultSet->initialize($result));die();
            }

            die("no data");
        }
    }

Refreshing the page you should now see the dump of a ``ResultSet`` object that has a property
``["count":protected] => int(5)``. Meaning we have five rows inside our database.

.. code-block:: text
   :linenos:
   :emphasize-lines: 12

    object(Zend\Db\ResultSet\ResultSet)#304 (8) {
      ["allowedReturnTypes":protected] => array(2) {
        [0] => string(11) "arrayobject"
        [1] => string(5) "array"
      }
      ["arrayObjectPrototype":protected] => object(ArrayObject)#305 (1) {
        ["storage":"ArrayObject":private] => array(0) {
        }
      }
      ["returnType":protected] => string(11) "arrayobject"
      ["buffer":protected] => NULL
      ["count":protected] => int(2)
      ["dataSource":protected] => object(Zend\Db\Adapter\Driver\Pdo\Result)#303 (8) {
        ["statementMode":protected] => string(7) "forward"
        ["resource":protected] => object(PDOStatement)#296 (1) {
          ["queryString"] => string(29) "SELECT `posts`.* FROM `posts`"
        }
        ["options":protected] => NULL
        ["currentComplete":protected] => bool(false)
        ["currentData":protected] => NULL
        ["position":protected] => int(-1)
        ["generatedValue":protected] => string(1) "0"
        ["rowCount":protected] => int(2)
      }
      ["fieldCount":protected] => int(3)
      ["position":protected] => int(0)
    }

Another very interesting property is ``["returnType":protected] => string(11) "arrayobject"``. This tells us that all
database entries will be returned as an ``ArrayObject``. And this is a little problem as the ``PostMapperInterface``
requires us to return an array of ``PostInterface`` objects. Luckily there is a very simple option for us available to
make this happen. In the examples above we have used the default ``ResultSet`` object. There is also a
``HydratingResultSet`` which will hydrate the given data into a provided object.

This means: if we tell the ``HydratingResultSet`` to use the database data to create ``Post`` objects for us, then it
will do exactly this. Let's modify our code:

.. code-block:: php
   :linenos:
   :emphasize-lines: 47-53

    <?php
    // Filename: /module/Blog/src/Blog/Mapper/ZendDbSqlMapper.php
    namespace Blog\Mapper;

    use Blog\Model\PostInterface;
    use Zend\Db\Adapter\AdapterInterface;
    use Zend\Db\Adapter\Driver\ResultInterface;
    use Zend\Db\ResultSet\HydratingResultSet;
    use Zend\Db\Sql\Sql;

    class ZendDbSqlMapper implements PostMapperInterface
    {
        /**
         * @var \Zend\Db\Adapter\AdapterInterface
         */
        protected $dbAdapter;

        /**
         * @param AdapterInterface  $dbAdapter
         */
        public function __construct(AdapterInterface $dbAdapter)
        {
            $this->dbAdapter = $dbAdapter;
        }

        /**
         * @param int|string $id
         *
         * @return PostInterface
         * @throws \InvalidArgumentException
         */
        public function find($id)
        {
        }

        /**
         * @return array|PostInterface[]
         */
        public function findAll()
        {
            $sql    = new Sql($this->dbAdapter);
            $select = $sql->select('posts');

            $stmt   = $sql->prepareStatementForSqlObject($select);
            $result = $stmt->execute();

            if ($result instanceof ResultInterface && $result->isQueryResult()) {
                $resultSet = new HydratingResultSet(new \Zend\Stdlib\Hydrator\ClassMethods(), new \Blog\Model\Post());

                return $resultSet->initialize($result);
            }

            return array();
        }
    }

We have changed a couple of things here. Firstly instead of a normal ``ResultSet`` we are using the
``HydratingResultSet``. This Object requires two parameters, the second one being the object to hydrate into and the
first one being the ``hydrator`` that will be used. A ``hydrator``, in short, is an object that changes any sort of
data from one format to another. The InputFormat that we have is an ``ArrayObject`` but we want ``Post``-Models. The
``ClassMethods``-hydrator will take care of this using the setter- and getter functions of our ``Post``-model.

Instead of dumping the ``$result`` variable we now directly return the initialized ``HydratingResultSet`` so we'll be
able to access the data stored within. In case we get something else returned that is not an instance of a
``ResultInterface`` we return an empty array.

Refreshing the page you will now see all your blog posts listed on the page. Great!


Refactoring hidden dependencies
===============================

There's one little thing that we have done that's not a best-practice. We use both a Hydrator and an Object inside our


.. code-block:: php
   :linenos:
   :emphasize-lines: 10, 19, 21, 30, 31, 59-66

    <?php
    // Filename: /module/Blog/src/Blog/Mapper/ZendDbSqlMapper.php
    namespace Blog\Mapper;

    use Blog\Model\PostInterface;
    use Zend\Db\Adapter\AdapterInterface;
    use Zend\Db\Adapter\Driver\ResultInterface;
    use Zend\Db\ResultSet\HydratingResultSet;
    use Zend\Db\Sql\Sql;
    use Zend\Stdlib\Hydrator\HydratorInterface;

    class ZendDbSqlMapper implements PostMapperInterface
    {
        /**
         * @var \Zend\Db\Adapter\AdapterInterface
         */
        protected $dbAdapter;

        /**
         * @var \Zend\Stdlib\Hydrator\HydratorInterface
         */
        protected $hydrator;

        /**
         * @var \Blog\Model\PostInterface
         */
        protected $postPrototype;

        /**
         * @param AdapterInterface  $dbAdapter
         * @param HydratorInterface $hydrator
         * @param PostInterface    $postPrototype
         */
        public function __construct(
            AdapterInterface $dbAdapter,
            HydratorInterface $hydrator,
            PostInterface $postPrototype
        ) {
            $this->dbAdapter      = $dbAdapter;
            $this->hydrator       = $hydrator;
            $this->postPrototype  = $postPrototype;
        }

        /**
         * @param int|string $id
         *
         * @return PostInterface
         * @throws \InvalidArgumentException
         */
        public function find($id)
        {
        }

        /**
         * @return array|PostInterface[]
         */
        public function findAll()
        {
            $sql    = new Sql($this->dbAdapter);
            $select = $sql->select('posts');

            $stmt   = $sql->prepareStatementForSqlObject($select);
            $result = $stmt->execute();

            if ($result instanceof ResultInterface && $result->isQueryResult()) {
                $resultSet = new HydratingResultSet($this->hydrator, $this->postPrototype);

                return $resultSet->initialize($result);
            }

            return array();
        }
    }

Now that our mapper requires more parameters we need to update the ``ZendDbSqlMapperFactory`` and inject those
parameters.

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Blog/src/Blog/Factory/ZendDbSqlMapperFactory.php
    namespace Blog\Factory;

    use Blog\Mapper\ZendDbSqlMapper;
    use Blog\Model\Post;
    use Zend\ServiceManager\FactoryInterface;
    use Zend\ServiceManager\ServiceLocatorInterface;
    use Zend\Stdlib\Hydrator\ClassMethods;

    class ZendDbSqlMapperFactory implements FactoryInterface
    {
        /**
         * Create service
         *
         * @param ServiceLocatorInterface $serviceLocator
         *
         * @return mixed
         */
        public function createService(ServiceLocatorInterface $serviceLocator)
        {
            return new ZendDbSqlMapper(
                $serviceLocator->get('Zend\Db\Adapter\Adapter'),
                new ClassMethods(false),
                new Post()
            );
        }
    }

With this in place you can refresh the application again and you'll see your blog posts listed once again. Our Mapper
has now a really good architecture and no more hidden dependencies.


Finishing the mapper
====================

Before we jump into the next chapter let's quickly finish the mapper by writing an implementation for the ``find()``
method.

.. code-block:: php
   :linenos:
   :emphasize-lines: 46-57

    <?php
    // Filename: /module/Blog/src/Blog/Mapper/ZendDbSqlMapper.php
    namespace Blog\Mapper;

    use Blog\Model\PostInterface;
    use Zend\Db\Adapter\AdapterInterface;
    use Zend\Db\Adapter\Driver\ResultInterface;
    use Zend\Db\ResultSet\HydratingResultSet;
    use Zend\Db\Sql\Sql;
    use Zend\Stdlib\Hydrator\HydratorInterface;

    class ZendDbSqlMapper implements PostMapperInterface
    {
        /**
         * @var \Zend\Db\Adapter\AdapterInterface
         */
        protected $dbAdapter;

        /**
         * @var \Zend\Stdlib\Hydrator\HydratorInterface
         */
        protected $hydrator;

        /**
         * @var \Blog\Model\PostInterface
         */
        protected $postPrototype;

        /**
         * @param AdapterInterface  $dbAdapter
         * @param HydratorInterface $hydrator
         * @param PostInterface    $postPrototype
         */
        public function __construct(
            AdapterInterface $dbAdapter,
            HydratorInterface $hydrator,
            PostInterface $postPrototype
        ) {
            $this->dbAdapter      = $dbAdapter;
            $this->hydrator       = $hydrator;
            $this->postPrototype  = $postPrototype;
        }

        /**
         * @param int|string $id
         *
         * @return PostInterface
         * @throws \InvalidArgumentException
         */
        public function find($id)
        {
            $sql    = new Sql($this->dbAdapter);
            $select = $sql->select('posts');
            $select->where(array('id = ?' => $id));

            $stmt   = $sql->prepareStatementForSqlObject($select);
            $result = $stmt->execute();

            if ($result instanceof ResultInterface && $result->isQueryResult() && $result->getAffectedRows()) {
                return $this->hydrator->hydrate($result->current(), $this->postPrototype);
            }

            throw new \InvalidArgumentException("Blog with given ID:{$id} not found.");
        }

        /**
         * @return array|PostInterface[]
         */
        public function findAll()
        {
            $sql    = new Sql($this->dbAdapter);
            $select = $sql->select('posts');

            $stmt   = $sql->prepareStatementForSqlObject($select);
            $result = $stmt->execute();

            if ($result instanceof ResultInterface && $result->isQueryResult()) {
                $resultSet = new HydratingResultSet($this->hydrator, $this->postPrototype);

                return $resultSet->initialize($result);
            }

            return array();
        }
    }

The ``find()`` function looks really similar to the ``findAll()`` function. There's just three simple differences.
Firstly we need to add a condition to the query to only select one row. This is done using the ``where()`` function of
the ``Sql`` object. Then we also check if the ``$result`` has a row in it through ``getAffectedRows()``. The return
statement then will be hydrated using the injected hydrator into the prototype that has also been injected.

This time, when we do not find a row we will throw an ``\InvalidArgumentException`` so that the application will easily
be able to handle the scenario.


Conclusion
==========

Finishing this chapter you now know how to query for data using the ``Zend\Db\Sql`` classes. You have also learned about
the ``Zend\Stdlib\Hydrator``-Component which is one of the new key components of ZF2. Furthermore you have once again
proven that you are able to manage proper dependency injection.

In the next chapter we'll take a closer look at the router so we'll be able to do some more action within our Module.
