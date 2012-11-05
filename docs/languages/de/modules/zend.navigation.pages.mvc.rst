.. EN-Revision: none
.. _zend.navigation.pages.mvc:

Zend\Navigation_Page\Mvc
========================

*MVC* Seiten werden definiert indem *MVC* Parameter verwendet werden wie von der ``Zend_Controller`` Komponent
bekannt. Eine *MVC* Seite wird intern in der ``getHref()`` Methode ``Zend\Controller\Action\Helper\Url`` verwenden
um hrefs zu erstellen, und die ``isActive()`` Methode wird die Parameter von ``Zend\Controller_Request\Abstract``
mit den Seiten Parametern verknüpfen um zu erkennen ob die Seite aktiv ist.

.. _zend.navigation.pages.mvc.options:

.. table:: MVC Seiten Optionen

   +------------+------+------------+-----------------------------------------------------------------------------------------+
   |Schlüssel   |Typ   |Standardwert|Beschreibung                                                                             |
   +============+======+============+=========================================================================================+
   |action      |String|NULL        |Name der Aktion die verwendet wird wenn eine href zur Seite erstellt wird.               |
   +------------+------+------------+-----------------------------------------------------------------------------------------+
   |controller  |String|NULL        |Name des Controllers der verwendet wird wenn eine href zur Seite erstellt wird.          |
   +------------+------+------------+-----------------------------------------------------------------------------------------+
   |module      |String|NULL        |Name des Moduls das verwendet wird wenn eine href zur Seite erstellt wird.               |
   +------------+------+------------+-----------------------------------------------------------------------------------------+
   |params      |Array |array()     |Benutzer Parameter die verwendet werden wenn eine href zur Seite erstellt wird.          |
   +------------+------+------------+-----------------------------------------------------------------------------------------+
   |route       |String|NULL        |Name der Route die verwendet wird wenn eine href zur Seite erstellt wird.                |
   +------------+------+------------+-----------------------------------------------------------------------------------------+
   |reset_params|bool  |TRUE        |Ob Benutzer Parameter zurückgesetzt werden sollen wenn eine href zur Seite erstellt wird.|
   +------------+------+------------+-----------------------------------------------------------------------------------------+

.. note::

   Die drei Beispiele anbei nehmen ein Standard *MVC* Setup an mit der *default* Route an.

   Die zurückgegebene *URI* ist relativ zur *baseUrl* in ``Zend\Controller\Front``. Im Beispiel ist die baseUrl
   der Einfachheit halber '/'.

.. _zend.navigation.pages.mvc.example.getHref:

.. rubric:: getHref() erstellt die Seiten URI

Dieses Beispiel zeigt das *MVC* Seiten intern ``Zend\Controller\Action\Helper\Url`` verwenden um *URI*\ s zu
erstellen wenn *$page->getHref()* aufgerufen wird.

.. code-block:: php
   :linenos:

   // getHref() gibt / zurück
   $page = new Zend\Navigation_Page\Mvc(array(
       'action'     => 'index',
       'controller' => 'index'
   ));

   // getHref() gibt /blog/post/view zurück
   $page = new Zend\Navigation_Page\Mvc(array(
       'action'     => 'view',
       'controller' => 'post',
       'module'     => 'blog'
   ));

   // getHref() gibt /blog/post/view/id/1337 zurück
   $page = new Zend\Navigation_Page\Mvc(array(
       'action'     => 'view',
       'controller' => 'post',
       'module'     => 'blog',
       'params'     => array('id' => 1337)
   ));

.. _zend.navigation.pages.mvc.example.isActive:

.. rubric:: isActive() erkennt ob eine Seite aktiv ist

Dieses Beispiel zeigt das *MVC* Seiten erkennen ob sie aktiv sind indem die Parameter verwendet werden die im
Anfrage Objekt gefunden werden.

.. code-block:: php
   :linenos:

   /*
    * Ausgeführte Anfrage:
    * - module:     default
    * - controller: index
    * - action:     index
    */
   $page1 = new Zend\Navigation_Page\Mvc(array(
       'action'     => 'index',
       'controller' => 'index'
   ));

   $page2 = new Zend\Navigation_Page\Mvc(array(
       'action'     => 'bar',
       'controller' => 'index'
   ));

   $page1->isActive(); // returns true
   $page2->isActive(); // returns false

   /*
    * Ausgeführte Anfrage:
    * - module:     blog
    * - controller: post
    * - action:     view
    * - id:         1337
    */
   $page = new Zend\Navigation_Page\Mvc(array(
       'action'     => 'view',
       'controller' => 'post',
       'module'     => 'blog'
   ));

   // Gibt true zurück, weil die Anfrage die gleichen Module, Controller
   // und Aktion hat
   $page->isActive();

   /*
    * Ausgefürte Anfrage:
    * - module:     blog
    * - controller: post
    * - action:     view
    */
   $page = new Zend\Navigation_Page\Mvc(array(
       'action'     => 'view',
       'controller' => 'post',
       'module'     => 'blog',
       'params'     => array('id' => null)
   ));

   // Gibt false zurück weil die Seite den id Parameter in der
   // Anfrage gesetzt haben muß
   $page->isActive(); // gibt false zurück

.. _zend.navigation.pages.mvc.example.routes:

.. rubric:: Routen verwenden

Routen können mit *MVC* Seite verwendet werden. Wenn eine Seite eine Route hat, wird diese Route in ``getHref()``
verwendet um die *URL* für die Seite zu erstellen.

.. note::

   Beachte, das wenn die *route* Eigenschaft in einer Seite verwendet wird, man auch die Standard Parameter
   spezifizieren sollte die diese Route definieren (module, controller, action, usw.), andernfalls ist die
   ``isActive()`` Methode nicht dazu in der Lage zu erkennen ob die Seite aktiv ist oder nicht. Der Grund hierfür
   ist, das es aktuell keinen Weg gibt die Standardparameter von einem ``Zend\Controller\Router\Route\Interface``
   Objekt zu erhalten, oder die aktuelle Route von einem ``Zend\Controller_Router\Interface`` Objekt.

.. code-block:: php
   :linenos:

   // Die folgende Route wird den ZF Router hinzugefügt
   Zend\Controller\Front::getInstance()->getRouter()->addRoute(
       'article_view', // route name
       new Zend\Controller_Router\Route(
           'a/:id',
           array(
               'module'     => 'news',
               'controller' => 'article',
               'action'     => 'view',
               'id'         => null
           )
       )
   );

   // Eine Seite wird mit der 'route' Option erstellt
   $page = new Zend\Navigation_Page\Mvc(array(
       'label'      => 'A news article',
       'route'      => 'article_view',
       'module'     => 'news',    // wird für isActive() benötigt, siehe oben
       'controller' => 'article', // wird für isActive() benötigt, siehe oben
       'action'     => 'view',    // wird für isActive() benötigt, siehe oben
       'params'     => array('id' => 42)
   ));

   // Gibt /a/42 zurück
   $page->getHref();


