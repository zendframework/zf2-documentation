.. EN-Revision: none
.. _zend.navigation.pages.mvc:

Zend\Navigation\Page\Mvc
========================

Les pages de type *MVC* utilisent des paramètres *MVC* issus du composant ``Zend_Controller``. Une page *MVC*
utilisera en interne ``Zend\Controller\Action\Helper\Url`` dans la méthode ``getHref()`` pour générer des cibles
(hrefs), et la méthode ``isActive()`` utilisera les paramètres issus de ``Zend\Controller\Request\Abstract`` et
les comparera aux paramètres internes à la page.

.. _zend.navigation.pages.mvc.options:

.. table:: Options des pages de type MV

   +------------+------+-----------------+----------------------------------------------------------------+
   |Clé         |Type  |Valeur par défaut|Description                                                     |
   +============+======+=================+================================================================+
   |action      |chaîne|NULL             |Nom de l'action pour générer des cibles vers la page.           |
   +------------+------+-----------------+----------------------------------------------------------------+
   |controller  |chaîne|NULL             |Nom du contrôleur pour générer des cibles vers la page.         |
   +------------+------+-----------------+----------------------------------------------------------------+
   |module      |chaîne|NULL             |Nom du module pour générer des cibles vers la page.             |
   +------------+------+-----------------+----------------------------------------------------------------+
   |params      |Array |array()          |Paramètres utilisateurs pour générer des cibles vers la page.   |
   +------------+------+-----------------+----------------------------------------------------------------+
   |route       |chaîne|NULL             |Nom de la route à utiliser pour générer des cibles vers la page.|
   +------------+------+-----------------+----------------------------------------------------------------+
   |reset_params|bool  |TRUE             |Remettre à zéro les paramètres de la route ou non.              |
   +------------+------+-----------------+----------------------------------------------------------------+

.. note::

   Les trois exemples qui suivent supposent une configuration *MVC* par défaut, avec une route *default*.

   L'*URI* retournée est relative au *baseUrl* de ``Zend\Controller\Front``. Dans nos exemples, le baseUrl vaut
   '/' pour simplifier.

.. _zend.navigation.pages.mvc.example.getHref:

.. rubric:: getHref() génères les URI de la page

Cet exemple montre que les pages de type *MVC* utilisent ``Zend\Controller\Action\Helper\Url`` en interne pour
générer les *URI*\ s suite à l'appel à *$page->getHref()*.

.. code-block:: php
   :linenos:

   // getHref() retourne /
   $page = new Zend\Navigation\Page\Mvc(array(
       'action'     => 'index',
       'controller' => 'index'
   ));

   // getHref() retourne /blog/post/view
   $page = new Zend\Navigation\Page\Mvc(array(
       'action'     => 'view',
       'controller' => 'post',
       'module'     => 'blog'
   ));

   // getHref() retourne /blog/post/view/id/1337
   $page = new Zend\Navigation\Page\Mvc(array(
       'action'     => 'view',
       'controller' => 'post',
       'module'     => 'blog',
       'params'     => array('id' => 1337)
   ));

.. _zend.navigation.pages.mvc.example.isActive:

.. rubric:: isActive() détermine si la page est active

Cet exemple montre que les pages de type *MVC* utilisent l'objet de requête afin de déterminer si elles sont
actives ou non.

.. code-block:: php
   :linenos:

   /*
    * Requête dispatchée:
    * - module:     default
    * - controller: index
    * - action:     index
    */
   $page1 = new Zend\Navigation\Page\Mvc(array(
       'action'     => 'index',
       'controller' => 'index'
   ));

   $page2 = new Zend\Navigation\Page\Mvc(array(
       'action'     => 'bar',
       'controller' => 'index'
   ));

   $page1->isActive(); // retourne true
   $page2->isActive(); // retourne false

   /*
    * Requête dispatchée:
    * - module:     blog
    * - controller: post
    * - action:     view
    * - id:         1337
    */
   $page = new Zend\Navigation\Page\Mvc(array(
       'action'     => 'view',
       'controller' => 'post',
       'module'     => 'blog'
   ));

   // retourne true, car la requpete a le même trio module/controller/action
   $page->isActive();

   /*
    * Requête dispatchée:
    * - module:     blog
    * - controller: post
    * - action:     view
    */
   $page = new Zend\Navigation\Page\Mvc(array(
       'action'     => 'view',
       'controller' => 'post',
       'module'     => 'blog',
       'params'     => array('id' => null)
   ));

   // retourne false, car page a besoin du paramètre id dans la requête
   $page->isActive(); // retourne false

.. _zend.navigation.pages.mvc.example.routes:

.. rubric:: Utiliser les routes

Les routes sont utilisables dans les pages de type *MVC*. Si une page a une route, elle sera utilisée par
``getHref()`` pour générer l'*URL* de la page.

.. note::

   Notez que si vous utilisez le paramètre *route*, vous devrez préciser les paramètres par défaut de la route
   (module, controller, action, etc.), autremant ``isActive()`` ne pourra déterminer si la page est active ou pas.
   La raison est qu'il n'existe actuellement aucune méthode permettant de récupérer les paramètres par défaut
   d'une route un objet ``Zend\Controller\Router\Route\Interface``, ni même de récupérer la route courante
   depuis un objet ``Zend\Controller\Router\Interface``.

.. code-block:: php
   :linenos:

   // La route suivante est ajoutée au routeur de ZF
   Zend\Controller\Front::getInstance()->getRouter()->addRoute(
       'article_view', // nom de la route
       new Zend\Controller\Router\Route(
           'a/:id',
           array(
               'module'     => 'news',
               'controller' => 'article',
               'action'     => 'view',
               'id'         => null
           )
       )
   );

   // Une page est créee avec un paramètre 'route'
   $page = new Zend\Navigation\Page\Mvc(array(
       'label'      => 'A news article',
       'route'      => 'article_view',
       'module'     => 'news',    // requis pour isActive(), voyez les notes ci-dessus
       'controller' => 'article', // requis pour isActive(), voyez les notes ci-dessus
       'action'     => 'view',    // requis pour isActive(), voyez les notes ci-dessus
       'params'     => array('id' => 42)
   ));

   // retourne: /a/42
   $page->getHref();


