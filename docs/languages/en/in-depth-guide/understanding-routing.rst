Understanding the Router
========================

Right now we have a pretty solid set up for our module. However we're not really doing all too much yet, to be
precise, all we do is display all ``Album`` entries on one page. In this chapter you will learn everything you need
to know about the ``Router`` to create other routes to be able to display only a single album, to add new albums
to your application and to edit and delete existing albums.


Different route types
=====================

Before we go into details on our application, let's take a look at the most important route types that Zend
Framework offers.

Zend\\Mvc\\Router\\Http\\Literal
--------------------------------

The first common route type is the ``Literal``-Route. As mentioned in a previous chapter a literal route is one that
matches a specific string. Examples for URLs that are usually literal routes are:

- http://domain.com/album
- http://domain.com/album/add
- http://domain.com/about-me
- http://domain.com/my/very/deep/page
- http://domain.com/my/very/deep/page

Configuration for a literal route requires you to set up the route that should be matched and needs you to define
some defaults to be used, for example which controller and which action to call. A simple configuration for a
literal route looks like this:

.. code-block:: php
   :linenos:
   :emphasize-lines: 3, 4, 6, 8, 9

    'router' => array(
        'routes' => array(
            'about' => array(
                'type' => 'literal',
                'options' => array(
                    'route'    => '/about-me',
                    'defaults' => array(
                        'controller' => 'AboutMeController',
                        'action'     => 'aboutme',
                    ),
                ),
            )
        )
    )

Zend\\Mvc\\Router\\Http\\Segment
--------------------------------

The second most commonly used route type is the ``Segment``-Route. A segmented route is used for whenever your url
is supposed to contain variable parameters. Pretty often those parameters are used to identify certain objects
within your application. Some examples for URLs that contain parameters and are usually segment routes are:

.. code-block:: text
   :lineos:

    http://domain.com/album/1                     // parameter "1"
    http://domain.com/album/details/1             // parameter "1"
    http://domain.com/album/edit/1                // parameter "1"
    http://domain.com/album/1/edit                // parameter "1"
    http://domain.com/news/archive/2014           // parameter "2014"
    http://domain.com/news/archive/2014/january   // parameter "2014" and "january"

Configuring a ``Segment``-Route takes a little more effort but isn't difficult to understand. The tasks you have to
do are similar at first, you have to define the route-type, just be sure to make it ``Segment``. Then you have to
define the route and add parameters to it. Then as usual you define the defaults to be used, the only thing that
differs in this part is that you can assign defaults for your parameters, too. The new part that is used on routes
of the ``Segment`` type is to define so called ``constraints``. They are used to tell the ``Router`` what "rules" are
given for parameters. For example, an ``id``-parameter is only allowed to be of type ``integer``, the ``year``-parameter
is only allowed to be of type ``integer`` and may only contain exactly ``four digits``. A sample configuration can
look like this:

.. code-block:: php
   :linenos:
   :emphasize-lines: 4, 6, 11-13

    'router' => array(
        'routes' => array(
            'archives' => array(
                'type' => 'segment',
                'options' => array(
                    'route'    => '/news/archive/:year',
                    'defaults' => array(
                        'controller' => 'ArchiveController',
                        'action'     => 'byYear',
                    ),
                    'constraints' => array(
                        'year' => '\d{4}'
                    )
                ),
            )
        )
    )

This configuration defines a route for an URL like ``domain.com/news/archive/2014``. As you can see we our route now
contains the part ``:year``. This is called a route-parameter. Route parameters for ``Segment``-Routes are defined by a
in front of a string. The string then is the ``name`` of the parameter.

Under ``constraints`` you see that we have another array. This array contains regular expression rules for each
parameter of your route. In our example case the regex uses two parts, the first one being ``\d`` which means "a
digit", so any number from 0-9. The second part is ``{4}`` which means that the part before this has to match exactly
four times. So in easy words we say "four digits".

If now you call the URL ``domain.com/news/archive/123``, the router will not match the URL because we only support
years with four digits.

You may notice that we did not define any ``defaults`` for the parameter ``year``. This is because the parameter is
currently set up as a ``required`` parameter. If a parameter is supposed to be ``optional`` we need to define this
inside the route definition. This is done by adding square brackets around the parameter. Let's modify the above
example route to have the ``year`` parameter optional and use the current year as default:

.. code-block:: php
   :linenos:
   :emphasize-lines: 10

    'router' => array(
        'routes' => array(
            'archives' => array(
                'type' => 'segment',
                'options' => array(
                    'route'    => '/news/archive[/:year]',
                    'defaults' => array(
                        'controller' => 'ArchiveController',
                        'action'     => 'byYear',
                        'year'       => date('Y')
                    ),
                    'constraints' => array(
                        'year' => '\d{4}'
                    )
                ),
            )
        )
    )

Notice that now we have a part in our route that is optional. Not only the parameter ``year`` is optional. The slash
that is separating the ``year`` parameter from the URL string ``archive`` is optional, too, and may only be there
whenever the ``year`` parameter is present.


Different routing concepts
==========================

When thinking about the whole application it becomes clear that there are a lot of routes to be matched. When
writing these routes you have two options to decide from. One option to spent less time writing routes but in turn
are a little bit slow in matching. And another option to write very explicit routes that match a little bit faster
but require more work to define them. Let's take a loot at both of them.

Generic routes
--------------

A generic route is one that matches many URLs. You may remember this concept from Zend Framework 1 where basically
you didn't even bother about routes because we had one "god route" that was used for everything. You define the
controller, the action, and all parameters within just one single route.

The big advantage of this approach is the immense time you save when developing your application. The downside
however is that matching such a route can take a little bit longer due to the fact that so many variables need to
be checked. However, as long as you not overdo it, this is a viable concept. For this reason the
ZendSkeletonApplication uses a very generic route, too. Let's take a look at a generic route:

.. code-block:: php
   :linenos:
   :emphasize-lines: 4, 6, 8-10, 13, 14

    'router' => array(
        'routes' => array(
            'default' => array(
                'type' => 'segment',
                'options' => array(
                    'route'    => '/[:controller[/:action]]',
                    'defaults' => array(
                        '__NAMESPACE__' => 'Application\Controller',
                        'controller'    => 'Index',
                        'action'        => 'index',
                    ),
                    'constraints' => [
                        'controller' => '[a-zA-Z][a-zA-Z0-9_-]*',
                        'action'     => '[a-zA-Z][a-zA-Z0-9_-]*',
                    ]
                ),
            )
        )
    )

Let's take a closer look as to what has been defined in this configuration. The ``route`` part now contains two
optional parameters ``controller`` and ``action``. The ``action`` parameter is optional only when the ``controller``
parameter is present.

Within the ``defaults``-section it looks a little bit different, too. The ``__NAMESPACE__`` will be used to concatenate
with the ``controller`` parameter at all times. So for example when the ``controller`` parameter is "news" then the
``controller`` to be called from the ``Router`` will be ``Application\Controller\news``, if the parameter is "archive"
the ``Router`` will call the controller ``Application\Controller\archive``.

The ``defaults``-section then is pretty straight forward again. Both parameters, ``controller`` and ``action``, only
have to follow the conventions given by PHP-Standards. They have to start with a letter from ``a-z``, upper- or
lowercase and after that first letter there can be an (almost) infinite amount of letters, digits, underscores or
dashes.

**The big downside** to this approach not only is that matching this route is a little slower, it is that there
is no error-checking going on. For example, when you were to call an URL like ``domain.com/weird/doesntExist`` then
the ``controller`` would be "Application\Controller\weird" and the ``action`` would be "doesntExistAction". As you can
guess by the names let's assume neither ``controller`` nor ``action`` does exist. The route will still match but an
``Exception`` will be thrown because the ``Router`` will be unable to find the requested resources and we'll receive
a ``404``-Response.


Explicit routes using child_routes
----------------------------------

Explicit routing is done by defining all possible routes yourself. For this method you actually have two options
available, too.

**Without config structure**

The probably most easy to understand way to write explicit routes would be to write many top level routes like
in the following configuration:

.. code-block:: php
   :linenos:
   :emphasize-lines:

    'router' => array(
        'routes' => array(
            'news' => array(
                'type' => 'literal',
                'options' => array(
                    'route'    => '/news',
                    'defaults' => array(
                        'controller' => 'NewsController',
                        'action'     => 'showAll',
                    ),
                ),
            ),
            'news-archive' => array(
                'type' => 'segment',
                'options' => array(
                    'route'    => '/news/archive[/:year]',
                    'defaults' => array(
                        'controller' => 'NewsController',
                        'action'     => 'archive',
                    ),
                    'constraints' => array(
                        'year' => '\d{4}'
                    )
                ),
            ),
            'news-single' => array(
                'type' => 'segment',
                'options' => array(
                    'route'    => '/news/:id',
                    'defaults' => array(
                        'controller' => 'NewsController',
                        'action'     => 'detail',
                    ),
                    'constraints' => array(
                        'id' => '\d+'
                    )
                ),
            ),
        )
    )

As you can see with this little example, all routes have an explicit name and there's lot's of repetition going on.
We have to redefine the default ``controller`` to be used every single time and we don't really have any structure
within the configuration. Let's take a look at how we could bring more structure into a configuration like this.

**Using child_routes for more structure**

Another option to define explicit routes is to be using ``child_routes``. Child routes inherit all ``options`` from
their respective parents. Meaning: when the ``controller`` doesn't change, you do not need to redefine it. Let's take
a look at a ``child_route`` configuration using the same example as above:

.. code-block:: php
   :linenos:
   :emphasize-lines: 13, 14

    'router' => array(
        'routes' => array(
            'news' => array(
                'type' => 'literal',
                'options' => array(
                    'route'    => '/news',
                    'defaults' => array(
                        'controller' => 'NewsController',
                        'action'     => 'showAll',
                    ),
                ),
                // Defines that "/news" can be matched on its own without a child_route being matched
                'may_terminate' => true,
                'child_routes' => array(
                    'archive' => array(
                        'type' => 'segment',
                        'options' => array(
                            'route'    => '/archive[/:year]',
                            'defaults' => array(
                                'action'     => 'archive',
                            ),
                            'constraints' => array(
                                'year' => '\d{4}'
                            )
                        ),
                    ),
                    'single' => array(
                        'type' => 'segment',
                        'options' => array(
                            'route'    => '/:id',
                            'defaults' => array(
                                'action'     => 'detail',
                            ),
                            'constraints' => array(
                                'id' => '\d+'
                            )
                        ),
                    ),
                )
            ),
        )
    )

This routing configuration requires a little more explanation. First of all we have a new configuration entry which
is called ``may_terminate``. This property defines that the parent route can be matched alone, without child_routes
needing to be matched, too. In other words all of the following routes are valid:

- /news
- /news/archive
- /news/archive/2014
- /news/42

If however you were to set ``may_terminate => false``, then the parent route would only be used for global defaults
that all ``child_routes`` were to inherit. In other words: only ``child_routes`` can be matched, so the only valid
routes would be:

- /news/archive
- /news/archive/2014
- /news/42

The parent route would not be able to be matched on its own.

Next to that we have a new entry called ``child_routes``. In here we define new routes that will be appended to the
parent route. There's no real difference in configuration from routes you define as a child_route to routes that
are on the top level of the configuration. The only thing that may fall away is the re-definition of shared
default values.

The big advantage you have with this kind of configuration is the fact that you explicitly define the routes and
therefore you will never run into problems of non-existing controllers like you would with generic routes like
described above. The second advantage would be that this kind of routing is a little bit faster than generic routes
and the last advantage would be that you can easily see all possible URLs that start with ``/news``.

While ultimately this falls into the category of personal preference bare in mind that debugging of explicit routes
is significantly easier than debugging generic routes.


A practical example for our Album Module
========================================

Now that we know how to configure new routes, let's first create a route to display only a single ``Album`` from our
Database. We want to be able to identify albums by their internal ID. Given that ID is a variable parameter we need
a route of type ``Segment``. Furthermore we want to put this route as a ``child_route`` to the route of name ``album``.

.. code-block:: php
   :linenos:
   :emphasize-lines: 8-36

    <?php
    // FileName: /module/Album/config/module.config.php
    return array(
        'db'              => array( /** DB Config */ ),
        'service_manager' => array( /* ServiceManager Config */ ),
        'view_manager'    => array( /* ViewManager Config */ ),
        'controllers'     => array( /* ControllerManager Config */ ),
        'router' => array(
            'routes' => array(
                'album' => array(
                    'type' => 'literal',
                    'options' => array(
                        'route'    => '/album',
                        'defaults' => array(
                            'controller' => 'Album\Controller\List',
                            'action'     => 'index',
                        ),
                    ),
                    'may_terminate' => true,
                    'child_routes'  => array(
                        'detail' => array(
                            'type' => 'segment',
                            'options' => array(
                                'route'    => '/:id',
                                'defaults' => array(
                                    'action' => 'detail'
                                ),
                                'constraints' => array(
                                    'id' => '[1-9]\d*'
                                )
                            )
                        )
                    )
                )
            )
        )
    );

With this we have set up a new route that we use to display a single album entry. We have assigned a parameter
called ``id`` that needs to be a positive digit excluding 0. Database entries usually start with a 0 when it comes
to primary ID keys and therefore our regular expression ``constraints`` for the ``id`` fields looks a little more
complicated. Basically we tell the router that the parameter ``id`` has to start with an integer between 1 and 9,
that's the ``[1-9]`` part, and after that any digit can follow, but doesn't have to (that's the ``\d*`` part).

The route will call the same ``controller`` like the parent route but it will call the ``detailAction()`` instead. Go
to your browser and request the URL ``http://domain.loc/album/2``. You'll see the following error message:

.. code-block:: text
   :linenos:

    A 404 error occurred

    Page not found.
    The requested controller was unable to dispatch the request.

    Controller:
    Album\Controller\List

    No Exception available

This is due to the fact that the controller tries to access the ``detailAction()`` which does not yet exist. Let's go
ahead and create this action now. Go to your ``ListController`` and add the action. Return an empty ``ViewModel`` and
then refresh the page.

.. code-block:: php
   :linenos:
   :emphasize-lines: 28-31

    <?php
    // FileName: /module/Album/src/Album/Controller/ListController.php
    namespace Album\Controller;

    use Album\Service\AlbumServiceInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class ListController extends AbstractActionController
    {
        /**
         * @var \Album\Service\AlbumServiceInterface
         */
        protected $albumService;

        public function __construct(AlbumServiceInterface $albumService)
        {
            $this->albumService = $albumService;
        }

        public function indexAction()
        {
            return new ViewModel(array(
                'albums' => $this->albumService->findAllAlbums()
            ));
        }

        public function detailAction()
        {
            return new ViewModel();
        }
    }

Now you'll see the all familiar message that a template was unable to be rendered. Let's create this template now
and assume that we will get one ``Album`` passed to the template to see the details of our album. Create a new view
file under ``/view/album/list/detail.phtml``:

.. code-block:: html
   :linenos:

    <!-- FileName: /module/Album/view/album/list/detail.phtml -->
    <h1>Album Details</h1>

    <dl>
        <dt>Album Title</dt>
        <dd><?php echo $this->escapeHtml($this->album->getTitle());?></dd>
        <dt>Album Artist</dt>
        <dd><?php echo $this->escapeHtml($this->album->getArtist());?></dd>
    </dl>

Looking at this template we're expecting the variable ``$this->album`` to be an instance of our ``Album``-Model. Let's
now modify our ``ListController`` so that an ``Album`` will be passed.

.. code-block:: php
   :linenos:
   :emphasize-lines: 30-34

    <?php
    // FileName: /module/Album/src/Album/Controller/ListController.php
    namespace Album\Controller;

    use Album\Service\AlbumServiceInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class ListController extends AbstractActionController
    {
        /**
         * @var \Album\Service\AlbumServiceInterface
         */
        protected $albumService;

        public function __construct(AlbumServiceInterface $albumService)
        {
            $this->albumService = $albumService;
        }

        public function indexAction()
        {
            return new ViewModel(array(
                'albums' => $this->albumService->findAllAlbums()
            ));
        }

        public function detailAction()
        {
            $id = $this->params()->fromRoute('id');

            return new ViewModel(array(
                'album' => $this->albumService->findAlbum($id)
            ));
        }
    }

If you refresh your application now you'll see the details for our Album to be displayed. However there is one
little Problem with what we have done. While we do have our Service set up to throw an ``\InvalidArgumentException``
whenever no ``Album`` matching a given ``id`` is found, we don't make use of this just yet. Go to your browser and
open the URL ``http://domain.loc/album/99``. You will see the following error message:

.. code-block:: text
   :linenos:

    An error occurred
    An error occurred during execution; please try again later.

    Additional information:
    InvalidArgumentException

    File:
    {rootPath}/module/Album/src/Album/Service/AlbumService.php:40

    Message:
    Could not find row 99

This is kind of ugly, so our ``ListController`` should be prepared to do something whenever an
``InvalidArgumentException`` is thrown by the ``AlbumService``. Whenever an invalid ``Album`` is requested we want the
User to be redirected to the Album-Overview. Let's do this by putting the call against the ``AlbumService`` in a
try-catch statement.

.. code-block:: php
   :linenos:
   :emphasize-lines: 30-40

    <?php
    // FileName: /module/Album/src/Album/Controller/ListController.php
    namespace Album\Controller;

    use Album\Service\AlbumServiceInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class ListController extends AbstractActionController
    {
        /**
         * @var \Album\Service\AlbumServiceInterface
         */
        protected $albumService;

        public function __construct(AlbumServiceInterface $albumService)
        {
            $this->albumService = $albumService;
        }

        public function indexAction()
        {
            return new ViewModel(array(
                'albums' => $this->albumService->findAllAlbums()
            ));
        }

        public function detailAction()
        {
            $id = $this->params()->fromRoute('id');

            try {
                $album = $this->albumService->findAlbum($id);
            } catch (\InvalidArgumentException $ex) {
                return $this->redirect()->toRoute('album');
            }

            return new ViewModel(array(
                'album' => $album
            ));
        }
    }

Now whenever you access an invalid ``id`` you'll be redirected to the route ``album`` which is our list of albums,
perfect!